from sqlmodel import SQLModel, Field, Relationship
from datetime import datetime



class ItemPeople(SQLModel, table=True):
    __tablename__ = "item_people"
    
    id: int = Field(default=None, primary_key=True)
    item_id: int = Field(default=None, foreign_key="items.id", nullable=False)
    people_id: int = Field(default=None, foreign_key="peoples.id")
    

    # Relationships
    item: "DBItem" = Relationship(back_populates="items_people")
    people: "DBPeople" = Relationship(back_populates="items_people")
