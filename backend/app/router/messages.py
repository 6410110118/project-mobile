from fastapi import APIRouter, Depends, HTTPException, Request, status , WebSocket
from sqlalchemy import func
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated
from .. import deps
from .. import models


router = APIRouter(prefix="/groups", tags=["message"])

@router.post("/groups/messages/")
async def send_message(
    message: models.CreatedMessage,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> models.Message:
    
    # Fetch the group where the user is either the creator (leader) or a member
    result = await session.exec(
        select(models.DBGroup).where(
            (models.DBGroup.leader_id == current_user.id)  # Check if the user is the leader
            | (models.DBGroup.id == select(models.DBPeople.group_id).where(models.DBPeople.user_id == current_user.id))  # Or a member of the group
        )
    )
    db_group = result.one_or_none()

    if not db_group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="You are not part of this group or the group does not exist",
        )

    group_id = db_group.id

    # If the user is a member (People), get their people_id
    result = await session.exec(
        select(models.DBPeople).where(
            (models.DBPeople.user_id == current_user.id)
            & (models.DBPeople.group_id == group_id)
        )
    )
    db_people = result.one_or_none()

    # Determine if the user is the leader or a member
    if db_people:
        people_id = db_people.id
    elif db_group.leader_id == current_user.id:
        # If the user is the leader, they can still send messages
        people_id = None
    else:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not authorized to send messages in this group",
        )

    # Create and save the message
    db_message = models.DBMessage(
        **message.dict(), group_id=group_id, people_id=people_id
    )
    session.add(db_message)
    await session.commit()
    await session.refresh(db_message)
    
    return models.Message.from_orm(db_message)



@router.get("/groups/messages/")
async def get_messages(
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> list[models.Message]:
    # Fetch the group where the user is either the creator (leader) or a member
    result = await session.exec(
        select(models.DBGroup).where(
            (models.DBGroup.leader_id == current_user.id)  # Check if the user is the leader
            | (models.DBGroup.id == select(models.DBPeople.group_id).where(models.DBPeople.user_id == current_user.id))  # Or a member of the group
        )
    )
    db_group = result.one_or_none()

    if not db_group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="You are not part of any group or the group does not exist",
        )

    group_id = db_group.id

    # Fetch messages for the group of the current user
    result = await session.exec(
        select(models.DBMessage).where(models.DBMessage.group_id == group_id)
    )
    db_messages = result.all()

    # Transform each DBMessage into Message object
    return [models.Message.from_orm(message) for message in db_messages]




# @router.websocket("/ws/groups/{group_id}/messages/")
# async def websocket_endpoint(
#     websocket: WebSocket, 
#     group_id: int,
#     session: Annotated[AsyncSession, Depends(models.get_session)],
#     current_user: models.User = Depends(deps.get_current_user),
#     ):
#     await websocket.accept()
#     while True:
#         data = await websocket.receive_text()
#         # บันทึกข้อความใหม่ลงฐานข้อมูล
#         db_message = models.DBMessage(group_id=group_id , people_id=current_user.id ,content=data)
#         session.add(db_message)
#         await session.commit()
#         await session.refresh(db_message)
#         await websocket.send_text(f"Message received: {data}")



@router.delete("/delete_message/{message_id}")
async def delete_message_from_group(
    message_id: int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> dict:
    # Fetch the user's group (either leader or member)
    result = await session.exec(
        select(models.DBGroup).where(
            (models.DBGroup.leader_id == current_user.id) |
            (models.DBGroup.id == select(models.DBPeople.group_id).where(models.DBPeople.user_id == current_user.id))
        )
    )
    db_group = result.one_or_none()

    if not db_group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User is not part of any group"
        )

    group_id = db_group.id

    # Find the message in the group
    result = await session.exec(
        select(models.DBMessage).where(
            (models.DBMessage.id == message_id) &
            (models.DBMessage.group_id == group_id)
        )
    )
    db_message = result.one_or_none()

    if not db_message:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Message not found in this group"
        )

    # Check if the current user is allowed to delete the message
    # Allow deletion if the user is the message creator or the group leader
    if db_message.people_id != current_user.id and db_group.leader_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You do not have permission to delete this message"
        )

    # Delete the message
    await session.delete(db_message)
    await session.commit()

    return {"message": "Message deleted from group successfully"}




