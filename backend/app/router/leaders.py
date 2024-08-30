from fastapi import APIRouter, HTTPException, Depends

from typing import Optional, Annotated
from sqlmodel import Field, SQLModel, create_engine, Session, select
from sqlmodel.ext.asyncio.session import AsyncSession

from ..models.users import User

from ..models import (
    Leader,
    CreatedLeader,
    UpdatedLeader,
    LeaderList,
    DBLeader,
    engine,
    get_session,
)

router = APIRouter(prefix="/leaders" , tags=["leaders"])


from .. import deps

# @router.post("")
# async def create_merchant(
#     merchant: CreatedMerchant,
#     session: Annotated[AsyncSession, Depends(get_session)],
#     current_user: User = Depends(deps.get_current_user)
# ) -> Merchant:
#     print("create_merchant", merchant)
#     data = merchant.dict()
#     dbmerchant = DBMerchant(**data)
#     dbmerchant.user = current_user
#     session.add(dbmerchant)
#     await session.commit()
#     await session.refresh(dbmerchant)
#     return Merchant.from_orm(dbmerchant)







@router.put("/{leader_id}")
async def update_leader(
    leader_id: int,
    leader: UpdatedLeader,
    session: Annotated[AsyncSession, Depends(get_session)],
    current_user: User = Depends(deps.get_current_user),
) -> Leader:
    if current_user.role != "Leader":
        raise HTTPException(status_code=403, detail="Only leader can update leader")
    result = await session.exec(
        select(DBLeader).where(DBLeader.id == leader_id)
    )
    db_leader = result.one_or_none()
    
    if  db_leader :
        db_leader.sqlmodel_update(leader)
        await session.commit()
        session.add(db_leader)
        await session.commit()
        await session.refresh(db_leader)

        return Leader.from_orm(db_leader)
    raise HTTPException(status_code=404, detail="Leader not found")

# @router.delete("/{leader_id}")

# async def delete_leader(
#     leader_id: int,
#     session: Annotated[AsyncSession, Depends(get_session)],
#     current_user: User = Depends(deps.get_current_user),
#     ) -> dict:
#     if  current_user.role  != "Leader":
#         raise HTTPException(status_code=403, detail="Only leader can delete leader")
#     result = await session.exec(
#         select(DBLeader).where(DBLeader.id == leader_id)

#     )
#     db_leader = result.one_or_none()
    
#     if db_leader :
#         await session.delete(db_leader)
#         await session.commit()
#         return {"message": "Leader deleted successfully"}
#     raise HTTPException(status_code=404, detail="Leader not found")

