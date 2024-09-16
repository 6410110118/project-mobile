from fastapi import APIRouter, Depends, HTTPException, Request, status , WebSocket
from sqlalchemy import func
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated
from .. import deps
from .. import models


router = APIRouter(prefix="/groups", tags=["message"])

@router.post("/groups/{group_id}/messages/")

async def send_message(
    group_id:int ,
    people_id:int,
    message:models.CreatedMessage,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
    ) -> models.Message:
    

    result = await session.exec(
        select(models.DBGroup).where(models.DBGroup.id == group_id)
    )

    db_group = result.one_or_none()

    if not db_group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Group not found",
        )
    
    result = await session.exec(
        select(models.DBPeople).where(
            (models.DBPeople.id == people_id) &
            (models.DBPeople.group_id == group_id)
        )
    )
    db_message = result.one_or_none()
    
    db_message = models.DBMessage(**message.dict(), group_id=group_id , people_id=people_id)
    session.add(db_message)
    await session.commit()
    await session.refresh(db_message)
    return models.Message.from_orm(db_message)

@router.get("/groups/{group_id}/messages/")
async def get_messages(
    group_id: int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> list[models.Message]:
    result = await session.exec(
        select(models.DBMessage).where(models.DBMessage.group_id == group_id)
    )
    db_messages = result.all()

    # แปลง db_messages แต่ละตัวเป็น Message object
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


@router.delete("/delete_message/{group_id}/{message_id}")
async def delete_message_from_group(
    group_id: int,
    message_id: int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> dict:
    # Check if the group exists
    result = await session.exec(
        select(models.DBGroup).where(models.DBGroup.id == group_id)
    )
    db_group = result.one_or_none()
    
    if not db_group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Group not found",
        )

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
            detail="Message not found in this group",
        )
    
    # Delete the message
    await session.delete(db_message)
    await session.commit()

    return {"message": "Message deleted from group successfully"}






