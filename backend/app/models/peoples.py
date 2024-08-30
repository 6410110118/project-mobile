from typing import Optional

from pydantic import BaseModel, ConfigDict
from sqlmodel import Field, SQLModel,Relationship

from .users import *


class BasePeople(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    name: str
    description: str | None = None
    
    
class CreatedPeople(BasePeople):
    pass

class UpdatedPeople(BasePeople):
    pass

class People(BasePeople):
    id: int
    user_id: int
    
class DBPeople(BasePeople, SQLModel, table=True):
    __tablename__ = "peoples"
    
    id: Optional[int] = Field(default=None, primary_key=True)
    
    user_id: int = Field(default=None, foreign_key="users.id")
    user: DBUser | None = Relationship(back_populates="people")

 
    

class PeopleList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    peoples: list[People]
    page: int
    page_size: int
    size_per_page: int