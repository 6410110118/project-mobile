from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlmodel import select
from typing import List
from .. import models  # นำเข้า deps เพื่อใช้งาน get_session
from .. import deps
router = APIRouter()

@router.get("/item_people/")
async def get_item_people(
    session: AsyncSession = Depends(models.get_session),
    current_user: models.User = Depends(deps.get_current_user),
):

    result = await session.execute(
        select(models.DBPeople).where(models.DBPeople.user_id == current_user.id)
    )
    db_people = result.scalar_one_or_none()
    if not db_people:
        raise HTTPException(status_code=404, detail="User not found")
    
    


    result = await session.execute(
        select(models.ItemPeople).where(models.ItemPeople.people_id == db_people.id)
    )
    item_people = result.scalars().all()

    if not item_people:
        raise HTTPException(status_code=404, detail="No items found for this user")

    return item_people
