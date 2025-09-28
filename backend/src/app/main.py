from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from app.core.config import settings

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Message(BaseModel):
    text: str

@app.get("/")
async def main():
    return {"message": "Hello World"}

@app.post("/echo")
async def echo_message(msg: Message):
    # Simply returns what the user sent
    return {"text": f"You said: {msg.text}"}
