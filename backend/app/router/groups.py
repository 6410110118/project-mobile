from fastapi import APIRouter, Depends, HTTPException, Request, status
from sqlalchemy import func
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select
import httpx
from typing import Annotated, List
from .. import deps
from .. import models
from .. import security
import random
import math

router = APIRouter(prefix="/groups", tags=["groups"])

SIZE_PER_PAGE = 10
@router.get("")
async def read_group(
    session: Annotated[AsyncSession, Depends(models.get_session)],
    page: int = 1,
    current_user: models.User = Depends(deps.get_current_user),
    ) -> models.GroupList:
        dbleader = (await session.exec(
            select(models.DBLeader).where(models.DBLeader.user_id == current_user.id)
        )).one_or_none()
        print("current_user.id", current_user.id)
        print("dbleader", dbleader)


        if not dbleader:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Leader not found",
            )

        query = select(models.DBGroup).where(models.DBGroup.leader_id== dbleader.id)
        print("query", query)
        result = await session.exec(
            query.offset((page - 1) * SIZE_PER_PAGE).limit(SIZE_PER_PAGE)
        )
        print('result', result)
        groups = result.all()
        print("groups", groups)


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
        select(models.DBLeader).where(models.DBLeader.user_id == current_user.id)
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
    

@router.put("/add_people_to_group/{group_id}/{people_id}/")
async def add_person_to_group(
    group_id: int,
    people_id: int,
    session: AsyncSession = Depends(models.get_session),
    current_user: models.User = Depends(deps.get_current_user),
) -> dict:
    result = await session.exec(
        select(models.DBGroup).where(models.DBGroup.id == group_id)
    )
    db_group = result.one_or_none()

    if not db_group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Not found this group",
        )
    
    if not db_group.leader_id == current_user.id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only group owner can add people",
        )
    
    result = await session.exec(
        select(models.DBPeople).where(models.DBPeople.id == people_id)
    )
    db_people = result.one_or_none()
    
    if db_people:
        # เช็คว่าผู้คนอยู่ในกลุ่มแล้วหรือไม่
        existing_link = await session.exec(
            select(models.PeopleGroupLink).where(
                models.PeopleGroupLink.people_id == people_id,
                models.PeopleGroupLink.group_id == group_id
            )
        )
        existing_link = existing_link.one_or_none()

        if existing_link:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Person is already in this group"
            )
        
        db_user = await session.exec(
            select(models.DBUser).where(models.DBUser.id == db_people.user_id)
            )

        # เพิ่มความสัมพันธ์ใหม่ในตารางกลาง
        new_link = models.PeopleGroupLink(people_id=people_id, group_id=group_id ,user_id = db_people.user_id)
        session.add(new_link)
        await session.commit()

        return {"detail": "New person successfully added to the group"}
    
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="Not found this person",
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

@router.delete("/delete_person/{people_id}")
async def delete_person_from_group(
    people_id: int,
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) -> dict:
    # ค้นหากลุ่มที่เจ้าของเป็น current_user
    result = await session.exec(
        select(models.DBGroup).where(models.DBGroup.leader_id == current_user.id)  # เปลี่ยนให้ตรงกับโครงสร้างของคุณ
    )
    db_group = result.one_or_none()

    if not db_group:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No group found for this user",
        )
    
    # ค้นหาสมาชิกที่ต้องการลบอยู่ในกลุ่มนี้หรือไม่
    result = await session.exec(
        select(models.DBPeople).where(
            (models.DBPeople.id == people_id) &
            (models.DBPeople.group_id == db_group.id)
        )
    )
    db_people = result.one_or_none()

    if not db_people:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Person not found in this group",
        )
    
    # ลบสมาชิกออกจากกลุ่ม
    db_people.group_id = None  # หรือวิธีการลบที่ตรงกับโครงสร้างของคุณ
    session.add(db_people)
    await session.commit()
    await session.refresh(db_people)

    return {"message": "Person removed from group successfully"}


@router.get("/{group_id}/people")
async def read_people_in_group(
    group_id: int, 
    session: AsyncSession = Depends(models.get_session),
    current_user: models.User = Depends(deps.get_current_user)
):
    # ตรวจสอบว่ากลุ่มมีอยู่ในฐานข้อมูลหรือไม่
    group_result = await session.exec(
        select(models.DBPeople).distinct().where(models.PeopleGroupLink.group_id == group_id)
    )
    group = group_result.all()

    if not group:  # เปลี่ยนจาก group is None เป็น not group
        raise HTTPException(status_code=404, detail="Group not found")
    
    # ตรวจสอบว่า current_user เป็นผู้สร้างกลุ่มหรือไม่
    return group

@router.get("/people_id/")
async def read_people(
    
    session: Annotated[AsyncSession, Depends(models.get_session)],
    current_user: models.User = Depends(deps.get_current_user),
) :
    people_result = await session.exec(
        select(models.DBGroup).distinct().where(models.PeopleGroupLink.user_id== current_user.id)


    )
    people = people_result.all()
    
    if not people:
        raise HTTPException(status_code=404, detail="People not found")

    return people
