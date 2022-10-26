from enum import Enum
from fastapi import FastAPI

app = FastAPI()

class ModelName(str, Enum):
    alexnet = "alexnet"
    resnet = "resnet"
    letnet = "letnet"

DESCS = {"alexnet": "you selected alexnet model.",
        "resnet": "you selected resnet server model.",
        "letnet": "you selected letnet server model. Sweat!"}

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