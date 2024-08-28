from typing import Optional, List
from pydantic import BaseModel, ConfigDict
from sqlmodel import Relationship, SQLModel, Field


from .users import *

class BaseItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    name: str
    description: Optional[str] = None

    #datetime: datetime.datetime


class CreatedItem(BaseItem):
    pass

class UpdatedItem(BaseItem):
    pass

class Item(BaseItem):
    id: int
    
    user_id: int

class DBItem(SQLModel, Item, table=True):

    __tablename__ =  'items'
    id: int = Field(default=None, primary_key=True)

    user_id: int = Field( default=None, foreign_key="users.id")
    user: DBUser | None = Relationship(back_populates="item")

class ItemList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    items: List[Item]
    page: int
    page_count: int
    
    size_per_page: int
    