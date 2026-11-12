from pydantic import BaseModel

# 1. User Login Request Model
class LoginRequest(BaseModel):
    officer_id: str
    password_hash: str

# 2. Case Creation Request Model
class CaseRequest(BaseModel):
    case_id: str
    title: str
    description: str
    location: str

# 3. Evidence Log Request Model
class EvidenceRequest(BaseModel):
    case_id: str
    file_name: str
    file_url: str
    file_hash: str
    ai_score: float = 0.0