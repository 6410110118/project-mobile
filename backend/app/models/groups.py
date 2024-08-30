from pydantic import BaseModel, ConfigDict
from sqlmodel import Field, SQLModel , Relationship
from typing import List
from .users import *
from .leaders import *
from .add_user_to_groups import *

class BaseGroup(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    name: str


class CreatedGroup(BaseGroup):
    pass

class UpdatedGroup(BaseGroup):
    pass

class Group(BaseGroup):
    id: int
    leader_id: int
    user_id: int
    

class DBGroup(SQLModel, Group ,table=True):
    __tablename__ =  'groups'
    id: int = Field(default=None, primary_key=True)

    user_id: int = Field( default=None, foreign_key="users.id")
    user: DBUser | None = Relationship(back_populates="group")
    leader: Optional["DBLeader"] | None = Relationship(back_populates="groups")
    leader_id: int= Field(default=None, foreign_key="leaders.id")

    
    # add_user_to_group: list["DBAddUserToGroup"] =  Relationship(back_populates="group", cascade_delete=True)
    