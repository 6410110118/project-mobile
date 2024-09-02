from fastapi import APIRouter, HTTPException, Depends

from typing import Optional, Annotated
from sqlmodel import Field, SQLModel, create_engine, Session, select
from sqlmodel.ext.asyncio.session import AsyncSession

router = APIRouter(prefix="/peoples", tags=["peopls"])

from .. import models
from .. import deps
@router.put("/{people_id}")
async def update_people(
    people_id: int,
    people: models.UpdatedPeople,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> models.People:
    if current_user.role != "People":
        raise HTTPException(status_code=403, detail="Only one person can update")
    result = await session.exec(
        select(models.DBPeople).where(models.DBPeople.id == people_id)
    )
    db_people = result.one_or_none()
    
    if db_people:
        db_people.sqlmodel_update(people)
        await session.commit()
        await session.refresh(db_people)
        return models.People.from_orm(db_people)
    raise HTTPException(status_code=404, detail="People not found")







