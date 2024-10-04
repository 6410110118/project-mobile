from fastapi import APIRouter, Depends, HTTPException, Request, status
from sqlalchemy import func
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select
import httpx
from typing import Annotated
from .. import deps
from .. import models
from .. import security
import random
import math

router = APIRouter(prefix="/groups", tags=["groups"])

SIZE_PER_PAGE = 50
@router.get("")
async def read_group(
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
    page: int = 1,
    
) -> models.GroupList:
    dbleader = (await session.exec(
        select(models.DBLeader).where(models.DBLeader.user_id == current_user.id)
    )).one_or_none()

    query = select(models.DBGroup).where(models.DBGroup.leader_id == dbleader.id)
    result = await session.exec(
        query.offset((page - 1) * SIZE_PER_PAGE).limit(SIZE_PER_PAGE)
    )
    groups = result.all() 
    
    
    

    page_count = int(
        math.ceil(
            (await session.exec(select(func.count(models.DBGroup.id)))).first()
            / SIZE_PER_PAGE
        )
    )

    print("page_count", page_count)
    print("groups", groups)
    return models.GroupList.from_orm(
        dict(groups=groups, page_count=page_count, page=page, size_per_page=SIZE_PER_PAGE)
    )


@router.post("")
async def create(
    group_info: models.CreatedGroup,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> models.Group:

    # ตรวจสอบว่าเป็น leader หรือไม่
    result = await session.exec(
        select(models.DBLeader).where(models.DBLeader.id == current_user.id)
    )
    db_leader = result.one_or_none()

    if not db_leader:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only leader can create groups.",
        )

    # สุ่ม URL รูปภาพสำหรับกลุ่ม
    random_sticker_url = await get_random_sticker()  # เรียกฟังก์ชันเพื่อดึง URL

    # สร้างกลุ่มใหม่และเพิ่มค่า image_url
    new_group = models.DBGroup.from_orm(group_info)
    new_group.leader = db_leader
    new_group.image_url = random_sticker_url  # เพิ่ม image_url

    session.add(new_group)
    await session.commit()
    await session.refresh(new_group)

    return new_group


async def get_random_sticker():
    url = "https://api.giphy.com/v1/stickers/random"
    image = security.image_key
    params = {
        "api_key": image,
        "tag": "lazy corgi"
    }
    
    async with httpx.AsyncClient() as client:
        response = await client.get(url, params=params)
        
        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code, detail="Failed to fetch sticker")
        
        data = response.json()
        
        # ดึง URL ของสติกเกอร์จากผลลัพธ์
        sticker_url = data['data']['url']
        return sticker_url


@router.put("/add_people_to_group")

async def add_person_to_group(
    # request: Request,
    group_id: int,
    people_id: int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> models.Group:
    result = await session.exec(
        select(models.DBGroup).where(models.DBGroup.id == group_id)
    )
    db_group = result.one_or_none()
    if not db_group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Not found this group",
        )
    if not db_group.id == current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only group owner can add people",
        )
    
    result = await session.exec(
        select(models.DBPeople).where(models.DBPeople.id == people_id)
    )
    db_people = result.one_or_none()
    
    if db_people:
        # db_people.group_id = db_group.id
        # db_group.people.append(db_people)
        db_people.group = db_group
        session.add(db_people)
        await session.commit()
        await session.refresh(db_group)
        raise HTTPException(status.HTTP_200_OK, detail="New person successfully added")
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="Not found this people",
    )
    

@router.delete("/delete_group/{group_id}")
async def delete_group(
    group_id: int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> dict:
    result = await session.exec(
        select(models.DBGroup).where(models.DBGroup.id == group_id)
    )
    db_group = result.one_or_none()
    if not db_group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Group not found",
        )
    if db_group.id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only group owner can delete the group",
        )
    result = await session.exec(
        select(models.DBPeople).where(models.DBPeople.group_id == group_id)
    )

    db_people = result.all()
    
    await session.delete(db_group)
    
    for people in db_people:
        people.group_id = None

    await session.commit()
    
    return {"message": "Group deleted successfully"}

@router.delete("/delete_person/{group_id}/{people_id}")
async def delete_person_from_group(
    group_id: int,
    people_id: int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> dict:
    # ตรวจสอบว่ากลุ่มนี้มีอยู่หรือไม่
    result = await session.exec(
        select(models.DBGroup).where(models.DBGroup.id == group_id)
    )
    db_group = result.one_or_none()
    
    if not db_group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Group not found",
        )

    # ตรวจสอบว่าผู้ใช้ที่ลบเป็นเจ้าของกลุ่มหรือไม่
    if db_group.leader_id != current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only the group leader can delete people from the group",
        )
    
    # ค้นหาว่าสมาชิกที่ต้องการลบอยู่ในกลุ่มนี้หรือไม่
    result = await session.exec(
        select(models.DBPeople).where(
            (models.DBPeople.id == people_id) &
            (models.DBPeople.group_id == group_id)
        )
    )
    db_people = result.one_or_none()

    if not db_people:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Person not found in this group",
        )
    
    # ลบสมาชิกออกจากกลุ่ม
    db_people.group_id = None
    session.add(db_people)
    await session.commit()
    await session.refresh(db_people)

    return {"message": "Person removed from group successfully"}

