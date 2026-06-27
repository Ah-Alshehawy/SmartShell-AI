from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import json

app = FastAPI()

# Mock data
mock_logs = [
    {"timestamp": "2023-10-01T12:00:00Z", "level": "INFO", "message": "System started"},
    {"timestamp": "2023-10-01T12:05:00Z", "level": "WARNING", "message": "Disk space low"}
]

mock_rules = [
    {"id": 1, "description": "Check disk space"},
    {"id": 2, "description": "Verify system start"}
]

# Models
class Log(BaseModel):
    timestamp: str
    level: str
    message: str

class Rule(BaseModel):
    id: int
    description: str

# Endpoints
@app.get("/logs")
def get_logs():
    return mock_logs

@app.get("/rules")
def get_rules():
    return mock_rules

@app.post("/rules", response_model=Rule)
async def create_rule(rule: Rule):
    # Simulate rule creation by appending to the list
    mock_rules.append(rule.dict())
    return rule

@app.post("/ai/analyze", response_model=dict)
async def ai_analyze():
    # Dummy JSON response for AI analysis
    return {"status": "success", "message": "Analysis complete"}


