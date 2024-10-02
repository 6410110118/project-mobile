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
    if  current_user.role != current_user.id:
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

