import os
import pytest
from fastapi.testclient import TestClient
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from app.main import create_app
from app.models import init_db, create_all, get_session, DBUser, UserRole
from app.config import get_settings
from dotenv import load_dotenv
import bcrypt

# โหลดไฟล์ .testing.env
load_dotenv(dotenv_path=".testing.env")

# สร้าง engine สำหรับทดสอบ
engine = create_async_engine(os.getenv("SQLDB_URL"), echo=True, future=True)

# สร้าง session สำหรับทดสอบ
TestingSessionLocal = sessionmaker(
    engine, class_=AsyncSession, expire_on_commit=False
)

@pytest.fixture(scope="module")
def client():
    settings = get_settings()

    # สร้างแอปพลิเคชัน FastAPI
    app = create_app(settings)

    # สร้างฐานข้อมูลก่อนเริ่มทดสอบ
    with TestClient(app) as client:
        # สร้าง schema ในฐานข้อมูล
        init_db(settings)
        create_all()

        yield client

@pytest.fixture(scope="function")
async def session():
    async with TestingSessionLocal() as session:
        yield session

@pytest.fixture(scope="function")
async def create_user(session: AsyncSession):
    # ฟังก์ชันในการสร้างผู้ใช้งานทดสอบในฐานข้อมูล
    password_hash = bcrypt.hashpw("password".encode("utf-8"), bcrypt.gensalt()).decode("utf-8")
    test_user = DBUser(
        email="test_user@example.com",
        username="testuser",
        password=password_hash,
        role=UserRole.leader,  # หรือคุณจะเปลี่ยนเป็น 'people'
        first_name="Test",
        last_name="User",
    )
    session.add(test_user)
    await session.commit()  # รอให้การ commit เสร็จสมบูรณ์
    await session.refresh(test_user)

    return test_user
