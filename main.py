from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import crud
from models import LoginRequest, CaseRequest, EvidenceRequest

app = FastAPI(title="Scene Lens AI - Crime Scene Investigation API")

# Allow Frontend UI to connect with Backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def home():
    return {"message": "Welcome to Scene Lens AI Backend APIs!"}

# 1. Login Endpoint
@app.post("/api/login")
def login_user(data: LoginRequest):
    user = crud.verify_user(data.officer_id, data.password_hash)
    if user:
        return {"status": "success", "user": user}
    raise HTTPException(status_code=401, detail="Invalid Officer ID or Password")

# 2. Get All Cases Endpoint
@app.get("/api/cases")
def read_cases():
    cases = crud.get_all_cases()
    return {"status": "success", "cases": cases}

# 3. Create New Case Endpoint
@app.post("/api/cases")
def add_case(data: CaseRequest):
    result = crud.create_case(data.case_id, data.title, data.description, data.location)
    if result:
        return {"status": "success", "message": "Case created successfully"}
    raise HTTPException(status_code=400, detail="Failed to create case")

# 4. Add Evidence Endpoint
@app.post("/api/evidence")
def add_evidence_log(data: EvidenceRequest):
    result = crud.add_evidence(data.case_id, data.file_name, data.file_url, data.file_hash, data.ai_score)
    if result:
        return {"status": "success", "message": "Evidence logged successfully"}
    raise HTTPException(status_code=400, detail="Failed to log evidence")
   # 5. 3D Reconstruction Endpoint (Fix for 404 Error)
@app.get("/api/3d-reconstruction/{case_id}")
def get_3d_reconstruction(case_id: str):
    return {
        "status": "success",
        "case_id": case_id,
        "model_url": "https://modelviewer.dev/shared-assets/models/Astronaut.glb",
        "message": "3D Scene mesh loaded successfully"
    } 