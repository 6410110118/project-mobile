from fastapi import FastAPI, APIRouter, Depends, HTTPException
from fastapi.testclient import TestClient
from pydantic import BaseModel, Field, EmailStr
from typing import List, Optional
from app.models import BaseUser  

mock_user_data = {
    "email": "admin@email.local",
    "username": "admin",
    "first_name": "Firstname",
    "last_name": "Lastname",
}

app = FastAPI()
router = APIRouter(prefix="/users", tags=["users"])

def get_current_user():
    return BaseUser(**mock_user_data)

@router.get("/me", response_model=BaseUser)
def get_me(current_user: BaseUser = Depends(get_current_user)) -> BaseUser:
    return current_user 

@app.get("/users")
async def read_user(username: str, current_user: BaseUser = Depends(get_current_user)):
    if username == current_user.username:
        raise HTTPException(status_code=400, detail="You cannot view your own profile")

    if username != "admin":  
        raise HTTPException(status_code=404, detail="User not found")

    return {"username": username}  

app.include_router(router)

# Testing--------------------------------------------------------------------------------------------------------------------------

client = TestClient(app)

def test_get_me():
    response = client.get("/users/me")
    assert response.status_code == 200
    assert response.json() == mock_user_data

def test_read_user_not_found():
    response = client.get("/users?username=nonexistentuser")
    assert response.status_code == 404
    assert response.json() == {"detail": "User not found"}

def test_read_user_own_profile():
    response = client.get("/users?username=admin")
    assert response.status_code == 400
    assert response.json() == {"detail": "You cannot view your own profile"}

if __name__ == "__main__":
    test_get_me()
    test_read_user_not_found()
    test_read_user_own_profile()
