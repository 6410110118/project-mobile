from typing import Optional, List
from pydantic import BaseModel, ConfigDict
from sqlmodel import Relationship, SQLModel, Field
import datetime

from .item_people import ItemPeople
from .users import DBUser, UserRole
from .leaders import DBLeader
from .google_maps import DBGoogleMap


class BaseItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    name: str
    description: Optional[str] = None
    address: str
    start_date: datetime.date = datetime.date.today()
    end_date: datetime.date = datetime.date.today() + datetime.timedelta(days=5)  # กำหนดค่าเริ่มต้นเป็น 5 วันหลังจาก start_date

class CreatedItem(BaseItem):
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    formatted_address: Optional[str] = None
    place_id: Optional[str] = None
    photo_reference: Optional[str] = None

class UpdatedItem(BaseItem):
    pass

class Item(BaseItem):
    id: int
    role: UserRole
    user_id: int
    
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    formatted_address: Optional[str] = None
    
    place_id: Optional[str] = None  # เพิ่มฟิลด์ place_id เพื่อเก็บข้อมูลจาก Google Places API
    photo_reference: Optional[str] = None

class DBItem(SQLModel, Item, table=True):
    __tablename__ = 'items'
    
    id: int = Field(default=None, primary_key=True)
    user_id: int = Field(default=None, foreign_key="users.id")
    user: DBUser | None = Relationship(back_populates="item")
    role: UserRole = Field(default=None)
    join_requests: List["JoinRequest"] = Relationship(back_populates="item")
    items_people: List["ItemPeople"] = Relationship(
        back_populates="item",
        sa_relationship_kwargs={"cascade": "all, delete-orphan"}
    )
    # leader_id: int = Field(default=None, primary_key=True)
    # leader: DBLeader | None = Relationship(back_populates="items")
    # google_map_id:int = Field(default=None, foreign_key="google_maps.id")
    # google_map: Optional[DBGoogleMap] = Relationship(back_populates="items")

class ItemList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    items: List[Item]
    page: int
    page_count: int
    size_per_page: int
