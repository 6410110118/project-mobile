import json
from fastapi import APIRouter, Depends, HTTPException, Request, WebSocketDisconnect, status , WebSocket
from sqlalchemy import func
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from typing import Annotated
from .. import deps
from .. import models
from broadcaster import Broadcast

router = APIRouter(prefix="/groups", tags=["message"])

broadcast = Broadcast("memory://")

@router.websocket("/ws/groups/{group_id}/messages/")
async def websocket_endpoint(websocket: WebSocket, group_id: int,session: AsyncSession = Depends(models.get_session),):
    await websocket.accept()

    async def receive_messages():
        # Subscribe ไปที่ channel ของกลุ่มตาม group_id
        async with broadcast.subscribe(channel=f"group_{group_id}_messages") as subscriber:
            async for event in subscriber:
                await websocket.send_text(event.message)

    try:
        # เรียกใช้ฟังก์ชันที่รอรับข้อความจาก broadcast
        await receive_messages()
    except WebSocketDisconnect:
        print(f"WebSocket disconnected")
    except Exception as e:
        await websocket.send_text(f"Error: {str(e)}")

# POST Endpoint เพื่อส่งข้อความ
@router.post("/messages/{group_id}/")
async def send_message(
    message: models.CreatedMessage,
    group_id: int,  # เพิ่มพารามิเตอร์ group_id
    session: AsyncSession = Depends(models.get_session),
    current_user: models.User = Depends(deps.get_current_user),
) -> models.Message:

    # ตรวจสอบว่า user เป็น leader หรือ member ในกลุ่มที่กำหนด group_id
    result = await session.exec(
        select(models.DBGroup)
        .join(models.PeopleGroupLink, models.DBGroup.id == models.PeopleGroupLink.group_id)
        .where(
            (models.DBGroup.id == group_id)  # ใช้ group_id ที่ส่งเข้ามา
            & (
                (models.DBGroup.leader_id == current_user.id)  # ตรวจสอบว่า user เป็น leader หรือไม่
                | (models.PeopleGroupLink.people_id == select(models.DBPeople.id).where(models.DBPeople.user_id == current_user.id))  # ตรวจสอบว่า user เป็น member หรือไม่
            )
        )
    )
    db_group = result.first()

    if not db_group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="You are not part of this group or the group does not exist",
        )

    # ตรวจสอบว่า user เป็น leader หรือ member ในกลุ่มนี้
    result = await session.exec(
        select(models.DBPeople)
        .join(models.PeopleGroupLink, models.DBPeople.id == models.PeopleGroupLink.people_id)
        .where(
            (models.DBPeople.user_id == current_user.id)
            & (models.PeopleGroupLink.group_id == group_id)
        )
    )
    db_people = result.one_or_none()

    if db_people:
        people_id = db_people.id
    elif db_group.leader_id == current_user.id:
        people_id = None  # ถ้าเป็น leader ก็ให้ people_id เป็น None
    else:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You are not authorized to send messages in this group",
        )

    # สร้างและบันทึกข้อความลงฐานข้อมูล
    db_message = models.DBMessage(
        **message.dict(), group_id=group_id, people_id=people_id
    )
    session.add(db_message)
    await session.commit()
    await session.refresh(db_message)

    # ส่งข้อความไปที่ WebSocket ผ่าน broadcast
    await broadcast.publish(channel=f"group_{group_id}_messages", message=db_message.content)

    return models.Message.from_orm(db_message)


# เปิดการเชื่อมต่อกับ Broadcast
@router.on_event("startup")
async def startup():
    await broadcast.connect()

@router.on_event("shutdown")
async def shutdown():
    await broadcast.disconnect()
@router.get("/user/{people_id}")
async def get_group_id(
    people_id: int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
):
    result = await session.exec(
        select(models.DBGroup)
        .join(models.PeopleGroupLink, models.DBGroup.id == models.PeopleGroupLink.group_id)
        .where(models.PeopleGroupLink.people_id == people_id) # ใช้ current_user แทน
    )
    db_group = result.first()

    if db_group:
        return {"group_id": db_group.id}
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Group not found for this user"
        )



@router.get("/messages/")
async def get_messages(
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> list[models.Message]:
    # Fetch the group where the user is either the creator (leader) or a member
    result = await session.exec(
        select(models.DBGroup).where(
            (models.DBGroup.leader_id == current_user.id)  # Check if the user is the leader
            | (models.DBGroup.id == select(models.PeopleGroupLink.group_id).where(models.DBPeople.user_id == current_user.id))  # Or a member of the group
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




