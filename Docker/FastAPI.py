from enum import Enum
from typing import Optional
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class ModelName(str, Enum):
    alexnet = "alexnet"
    resnet = "resnet"
    letnet = "letnet"

class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None

DESCS = {"alexnet": "you selected alexnet model.",
        "resnet": "you selected resnet server model.",
        "letnet": "you selected letnet server model. Sweat!"}

fake_items_db = [{"item_name": "Foo"}, {"item_name": "Bar"}, {"item_name": "Baz"}]

@app.get("/")
async def root():
    return {"message": "Hello World! From UFM 2022"}

@app.get("/items/{item_id}")
async def read_item(item_id: int):
    return item_id

#El orden SI es importante. Las fijas van primero antes que las variables
@app.get("/users/me")
async def read_item():
    return {"user_id": "the current user"}

@app.get("/users/{user_id}")
async def read_item(user_id: str):
    return {"user_id": user_id}

@app.get("/models/{model_name}")
async def get_model_data(model_name: ModelName):
    return {"model": model_name, "description": DESCS[model_name]}

#@app.get("/items/")
#async def read_item(skip: int = 0, limit: int = 10):
#   return fake_items_db[skip : skip + limit]

@app.get("/items/{item_id}")
async def read_item(item_id: str, q: Optional[str] = None):
    if q:
        return {"item_id": item_id, "q": q}
    return {"item_id": item_id}

@app.get("/users/{user_id}/items/{item_id}")
async def read_user_item(
    user_id: int, item_id: str, q: Optional[str] = None, short: bool = False
):
    item = {"item_id": item_id, "owner_id": user_id}
    if q:
        item.update({"q": q})
    if not short:
        item.update(
            {"description": "This is an amazing item that has a long description"}
        )
    return item

@app.post("/items/")
async def create_item(item: Item):
    if not item.tax:
        item.tax = item.price * 0.12
    
    return item