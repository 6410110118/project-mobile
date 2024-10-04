from pydantic import BaseModel, ConfigDict
from sqlmodel import Field, SQLModel , Relationship
from typing import List
from .messages import DBMessage
from .users import *
from .leaders import *
# from .add_user_to_groups import *

class BaseGroup(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    name: str
    start_date: datetime.date = datetime.date.today()
    end_date: datetime.date = datetime.date.today() + datetime.timedelta(days=5)


class CreatedGroup(BaseGroup):
    pass

class UpdatedGroup(BaseGroup):
    pass

class Group(BaseGroup):
    id: int
    leader_id: int
    image_url: Optional[str] = None
    
    

class DBGroup(SQLModel, Group ,table=True):
    __tablename__ =  'groups'
    id: int = Field(default=None, primary_key=True)
    
    # user_id: int | None = Field( default=None, foreign_key="users.id")
    # user: DBUser | None = Relationship(back_populates="group")
    leader: Optional["DBLeader"] | None = Relationship(back_populates="groups")
    leader_id: int= Field(default=None, foreign_key="leaders.id")
    people: list["DBPeople"] = Relationship(back_populates="group", passive_deletes=True)
    messages: List[DBMessage] = Relationship(back_populates="group", passive_deletes=True)

    
    # add_user_to_group: list["DBAddUserToGroup"] =  Relationship(back_populates="group", cascade_delete=True)
    
class GroupList(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    
    groups: list[Group]
    page: int
    # page_size: int
    size_per_page: int