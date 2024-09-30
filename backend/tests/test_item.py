import pytest

@pytest.mark.asyncio
async def test_create_item(client, create_user):
    user = await create_user  # รอให้ coroutine ของ create_user เสร็จสมบูรณ์
    response = client.post("/items", json={
        "name": "Test Item",
        "description": "This is a test item",
        "start_date": "2023-09-22",
        "end_date": "2023-09-27",
        "role": user.role,
        "user_id": user.id,
        "google_map_id": 1
    })
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "Test Item"


@pytest.mark.asyncio
async def test_get_item(client, create_user):
    user = await create_user  # รอให้ coroutine ของ create_user เสร็จสมบูรณ์
    response = client.get("/items/1")  # สมมติว่าไอเท็มมี ID เป็น 1
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == 1
    assert data["name"] == "Test Item"


@pytest.mark.asyncio
async def test_update_item(client, create_user):
    user = await create_user  # รอให้ coroutine ของ create_user เสร็จสมบูรณ์
    response = client.put("/items/1", json={
        "name": "Updated Item",
        "description": "Updated description",
        "start_date": "2023-09-22",
        "end_date": "2023-09-29"
    })
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "Updated Item"
    assert data["description"] == "Updated description"


@pytest.mark.asyncio
async def test_delete_item(client, create_user):
    user = await create_user  # รอให้ coroutine ของ create_user เสร็จสมบูรณ์
    response = client.delete("/items/1")  # ลบไอเท็มที่มี ID 1
    assert response.status_code == 200
    data = response.json()
    assert data["message"] == "delete success"
