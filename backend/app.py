 ```python
from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel
import database as db

app = FastAPI()

class Log(BaseModel):
    id: int
    message: str

class Rule(BaseModel):
    id: int
    pattern: str
    action: str

@app.get("/logs")
async def get_logs():
    logs = db.get_all_logs()
    return {"logs": [Log(id=log.id, message=log.message) for log in logs]}

@app.get("/rules")
async def get_rules():
    rules = db.get_all_rules()
    return {"rules": [Rule(id=rule.id, pattern=rule.pattern, action=rule.action) for rule in rules]}

@app.post("/rules")
async def create_rule(rule: Rule):
    new_rule_id = db.create_new_rule(rule.pattern, rule.action)
    return {"id": new_rule_id}

@app.post("/ai/analyze")
async def analyze_network_data(request: Request):
    network_data = await request.json()
    response = requests.post("http://localhost:11434/api/generate", json=network_data)
    if response.status_code != 200:
        raise HTTPException(status_code=500, detail="Failed to analyze data")
    result = response.json()
    if result["malicious"]:
        return {"action": "DROP"}
    else:
        return {"action": "ALLOW"}
```
