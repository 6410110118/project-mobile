import math
from fastapi import APIRouter, HTTPException, Depends , status
from typing import Optional, List, Annotated
from pydantic import BaseModel
from sqlalchemy import func
from sqlmodel import Field, SQLModel, select

from app.models.request_people import JoinRequestDecision

from ..router import google_maps

from .. import models
from .. import deps
from sqlmodel.ext.asyncio.session import AsyncSession
from datetime import datetime, timedelta


router = APIRouter(prefix="/items")


    
@router.post("")
async def create_item(
    item: models.CreatedItem,
    
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> models.Item | None:
    # ตรวจสอบสิทธิ์ของ current_user
    if  current_user.role != 'Leader':
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You is not Leader."
        )
    
    # ตรวจสอบและตั้งค่า end_date หากไม่ได้กำหนด
    if not item.end_date:
        item.end_date = item.start_date + timedelta(days=5)
    elif item.end_date < item.start_date:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="End date cannot be earlier than start date"
        )
    if item.address:
        try:
            geocoded_data = await google_maps.geocode_address(item.address, session, current_user)
            # เพิ่มข้อมูลจาก geocoded_data ลงใน item
            item.latitude = geocoded_data.latitude
            item.longitude = geocoded_data.longitude
            item.formatted_address = geocoded_data.formatted_address
            item.place_id = geocoded_data.place_id
            item.photo_reference = geocoded_data.photo_reference
        except HTTPException as e:
            raise HTTPException(status_code=e.status_code, detail=e.detail)
    
    
    
    # สร้างไอเท็ม
    dbitem = models.DBItem.from_orm(item)
    dbitem.user_id = current_user.id
    dbitem.role = current_user.role
    
    session.add(dbitem)
    await session.commit()
    await session.refresh(dbitem)

    return models.Item.from_orm(dbitem)


@router.get("/join_requests")
async def get_all_join_requests(
    session: AsyncSession = Depends(models.get_session),
    current_user: models.User = Depends(deps.get_current_user)
):
    # ดึงรายการไอเท็มทั้งหมดที่ current_user เป็น leader
    result = await session.execute(
        select(models.DBItem).filter(models.DBItem.user_id == current_user.id)
    )
    items = result.scalars().all()

    if not items:
        raise HTTPException(status_code=404, detail="No items found for the current user")

    # ดึงรายการคำขอเข้าร่วมทั้งหมดที่เกี่ยวข้องกับไอเท็มที่ current_user เป็น leader
    join_requests = await session.execute(
        select(models.JoinRequest).filter(models.JoinRequest.item_id.in_([item.id for item in items]))
    )
    return join_requests.scalars().all()


@router.post("/{item_id}/join")
async def request_to_join(
    item_id: int, 
    session: AsyncSession = Depends(models.get_session),
    current_user: models.User = Depends(deps.get_current_user)
):
    # ตรวจสอบว่าไอเท็ม (ทริป) นั้นมีอยู่หรือไม่
    result = await session.execute(select(models.DBItem).filter(models.DBItem.id == item_id))
    item = result.scalars().first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")

    # สร้างคำขอเข้าร่วมใหม่ โดยใช้ people_id จาก current_user
    join_request = models.JoinRequest(
        people_id=current_user.id,  # ใช้ current_user.id แทน people_id
        item_id=item_id,
    )
    
    session.add(join_request)
    await session.commit()
    await session.refresh(join_request)
    
    return {"message": "Join request sent successfully", "request": join_request}



@router.put("/{item_id}/join/{join_request_id}")
async def respond_to_join_request(
    item_id: int, 
    join_request_id: int, 
    decision: JoinRequestDecision,
    session: AsyncSession = Depends(models.get_session),
    current_user: models.User = Depends(deps.get_current_user)
):
    # ตรวจสอบว่า item มีอยู่จริงและ current_user เป็น leader ของ item นั้นหรือไม่
    result = await session.execute(
        select(models.DBItem).where(models.DBItem.id == item_id, models.DBItem.user_id == current_user.id)
    )
    item = result.scalar_one_or_none()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found or you are not the leader of this item")

    # ตรวจสอบ join request
    result = await session.execute(
        select(models.JoinRequest).where(models.JoinRequest.id == join_request_id, models.JoinRequest.item_id == item_id)
    )
    join_request = result.scalar_one_or_none()
    if not join_request:
        raise HTTPException(status_code=404, detail="Join request not found")
    
    # ตรวจสอบสถานะของ join request
    if join_request.status != "pending":
        raise HTTPException(status_code=400, detail="Join request has already been processed")

    if decision.is_approved:
        join_request.status = "approved"  # เปลี่ยนสถานะเป็น approved

        # เพิ่ม user_id และ item_id ลงใน item_people
        new_item_people = models.ItemPeople(
            people_id=current_user.id,
            item_id=item_id,
        )
        session.add(new_item_people)
    else:
        join_request.status = "rejected"  # เปลี่ยนสถานะเป็น rejected
    
    join_request.updated_at = datetime.now()
    await session.commit()
    await session.refresh(join_request)
    
    message = "Join request approved successfully" if decision.is_approved else "Join request rejected successfully"
    
    return {"message": message, "request": join_request}






