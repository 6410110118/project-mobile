from fastapi import FastAPI, APIRouter, HTTPException
from fastapi.testclient import TestClient
from pydantic import BaseModel, EmailStr
from app.config import Settings
from app.models.users import Login
from app.security import create_access_token, create_refresh_token

app = FastAPI()

router = APIRouter()

@router.post("/login")
def login(login_data: Login):
    # ใช้ค่าจริงในการตรวจสอบล็อกอิน
    if login_data.email == "admin@example.com" and login_data.password == "password":
        # สร้าง access token โดยไม่ต้องระบุ role
        access_token = create_access_token({"username": login_data.email})
        refresh_token = create_refresh_token({"username": login_data.email})
        return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer"}
    else:
        raise HTTPException(status_code=401, detail="Invalid credentials")

app.include_router(router)

# Testing--------------------------------------------------------------------------------------------------------------------------

client = TestClient(app)

def test_login_success():
    # ทดสอบการล็อกอินสำเร็จ
    login_data = Login(email="admin@example.com", password="password")  # เปลี่ยน email เป็นที่อยู่อีเมลที่ถูกต้อง
    response = client.post("/login", json=login_data.dict())
    assert response.status_code == 200
    json_response = response.json()
    assert "access_token" in json_response
    assert "refresh_token" in json_response
    assert json_response["token_type"] == "bearer"

def test_login_failure():
    # ทดสอบการล็อกอินล้มเหลวเมื่อใส่รหัสผ่านผิด
    login_data = Login(email="admin@example.com", password="wrongpassword")  # เปลี่ยน email เป็นที่อยู่อีเมลที่ถูกต้อง
    response = client.post("/login", json=login_data.dict())
    assert response.status_code == 401
    assert response.json() == {"detail": "Invalid credentials"}

if __name__ == "__main__":
    test_login_success()
    test_login_failure()
