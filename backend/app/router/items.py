import math
from fastapi import APIRouter, HTTPException, Depends , status
from typing import Optional, List, Annotated
from sqlalchemy import func
from sqlmodel import Field, SQLModel, select

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


@router.get("/{item_id}/join_requests")
async def get_join_requests(
    item_id: int, 
    session: AsyncSession = Depends(models.get_session),
    current_user: models.User = Depends(deps.get_current_user)
):
    # ตรวจสอบว่าไอเท็ม (ทริป) นั้นมีอยู่หรือไม่ และตรวจสอบว่า current_user เป็น leader หรือไม่
    result = await session.execute(
        select(models.DBItem)
        .filter(models.DBItem.id == item_id, models.DBItem.user_id == current_user.id)
    )
    item = result.scalars().first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found or you are not the leader of this item")

    # ดึงรายการคำขอเข้าร่วมทั้งหมดที่เกี่ยวข้องกับไอเท็ม
    join_requests = await session.execute(
        select(models.JoinRequest).filter(models.JoinRequest.item_id == item_id)
    )
    return join_requests.scalars().all()


# ส่งคำขอเข้าร่วมทริป
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
    session: AsyncSession = Depends(models.get_session),
    current_user: models.User = Depends(deps.get_current_user)  # ใช้ current_user เพื่อตรวจสอบว่าเป็น leader
):
    # ตรวจสอบว่าไอเท็ม (ทริป) นั้นมีอยู่หรือไม่ และตรวจสอบว่า current_user เป็น leader หรือไม่
    result = await session.execute(select(models.DBItem).filter(models.DBItem.id == item_id, models.DBItem.user_id == current_user.id))
    item = result.scalars().first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found or you are not the leader of this item")
    
    # ตรวจสอบคำขอเข้าร่วม
    result = await session.execute(select(models.JoinRequest).filter(models.JoinRequest.id == join_request_id, models.JoinRequest.item_id == item_id))
    join_request = result.scalars().first()
    if not join_request:
        raise HTTPException(status_code=404, detail="Join request not found")

    # อัปเดตสถานะของคำขอเข้าร่วมเป็น approved หรือ rejected ตามเงื่อนไข
    # คุณสามารถเพิ่มเงื่อนไขการอนุมัติที่นี่ เช่น ตรวจสอบว่า join_request.status เป็น "pending"
    if join_request.status != "pending":
        raise HTTPException(status_code=400, detail="Join request has already been processed")

    join_request.status = "approved"  # ตั้งสถานะให้เป็น approved
    join_request.updated_at = datetime.utcnow()
    
    await session.commit()
    await session.refresh(join_request)
    
    return {"message": "Join request approved successfully", "request": join_request}

