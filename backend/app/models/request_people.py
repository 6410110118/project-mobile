from datetime import datetime
from typing import Optional
from sqlmodel import Field, Relationship, SQLModel



class JoinRequest(SQLModel, table=True):
    __tablename__ = "join_requests"
    id: Optional[int] = Field(default=None, primary_key=True)
    people_id: int
    item_id: int = Field(foreign_key="items.id")
    status: str = Field(default="pending")  # "pending", "approved", "rejected"
    request_message: Optional[str] = None
    updated_at: Optional[datetime] = Field(default_factory=datetime.utcnow)

    # Relationship ไม่ต้องใช้ Optional หรือ None
    item: "DBItem" = Relationship(back_populates="join_requests")
