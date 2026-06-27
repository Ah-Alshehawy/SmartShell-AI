from fastapi import FastAPI, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from ai_logic import analyze_packet

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

logs = []
rules = []

@app.get("/logs")
async def get_logs():
    return logs

@app.get("/rules")
async def get_rules():
    return rules

@app.post("/ai/analyze")
async def analyze_packet_endpoint(request: Request):
    data = await request.json()
    packet_data = data.get("packet_data", None)
    if not packet_data:
        raise HTTPException(status_code=400, detail="Missing packet_data")

    result = analyze_packet(packet_data)
    logs.append({"data": packet_data, "action": result})
    return {"action": result}

