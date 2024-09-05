from typing import Optional, List
from pydantic import BaseModel, ConfigDict, root_validator
from sqlmodel import Relationship, SQLModel, Field
import datetime

from .users import *
from .leaders import *
from .google_maps import *

class BaseItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    name: str
    description: Optional[str] = None
    
    start_date: datetime.date = datetime.date.today()
    end_date: datetime.date = datetime.date.isoformat


class CreatedItem(BaseItem):
    pass

class UpdatedItem(BaseItem):
    pass

class Item(BaseItem):
    id: int
    role: UserRole
    user_id: int
    google_map_id: int

class DBItem(SQLModel, Item, table=True):

    __tablename__ =  'items'
    id: int = Field(default=None, primary_key=True)

    user_id: int = Field( default=None, foreign_key="users.id")
    user: DBUser | None = Relationship(back_populates="item")
    role: UserRole = Field(default=None)
    # leader_id: int = Field(default=None, primary_key=True)
    # leader: DBLeader | None = Relationship(back_populates="item")
    google_map_id:int = Field(default=None, foreign_key="google_maps.id")
    google_map: Optional["DBGoogleMap"] = Relationship(back_populates="items")


class ItemList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    items: List[Item]
    page: int
    page_count: int
    
    size_per_page: int
    