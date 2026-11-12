-- =====================================================
-- AI CRIME SCENE INVESTIGATION SYSTEM - DATABASE SCHEMA
-- File: schema.sql
-- Database Engine: PostgreSQL / Supabase
-- =====================================================

-- 1. USERS TABLE (Officer Login Details & Access Control)
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    officer_id VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    officer_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) DEFAULT 'Inspector',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Default Inspector Account (Demo Data)
INSERT INTO users (officer_id, password_hash, officer_name) 
VALUES ('PCB-20417', 'hashed_pass_123', 'Inspector R. Patil');


-- 2. CASES TABLE (Cases Dashboard & Location Screen)
CREATE TABLE cases (
    case_id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    incident_type VARCHAR(50) DEFAULT 'Crime',
    severity VARCHAR(20) DEFAULT 'High',
    status VARCHAR(50) DEFAULT 'Verify',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Demo Case Data
INSERT INTO cases (case_id, title, location, incident_type, severity, status, notes) 
VALUES (
    'SL-2026-0417', 
    'Break-in with assault, Flat 4B', 
    'Flat 4B, Shivaji Nagar', 
    'Crime', 
    'High', 
    'Verify', 
    'Forced entry at main door. Occupant shifted to hospital.'
);


-- 3. EVIDENCE_FILES TABLE (New Case & AI Analysis Uploads)
CREATE TABLE evidence_files (
    id SERIAL PRIMARY KEY,
    case_id VARCHAR(50) REFERENCES cases(case_id) ON DELETE CASCADE,
    file_name VARCHAR(255) NOT NULL,
    file_type VARCHAR(20),
    file_hash VARCHAR(255),
    authenticity_score VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Secure',
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Demo Evidence Files Data
INSERT INTO evidence_files (case_id, file_name, file_type, file_hash, authenticity_score, status)
VALUES 
('SL-2026-0417', 'scene_livingroom.jpg', 'IMG', 'SHA-256 9f2c...a41e', 'Likely real (94%)', 'Secure'),
('SL-2026-0417', 'witness_photo.jpg', 'IMG', 'SHA-256 3a1f...8b2c', 'Likely AI (88%)', 'Flagged');


-- 4. CLUES_LOG TABLE (AI Analysis Tabular Log Screen)
CREATE TABLE clues_log (
    id SERIAL PRIMARY KEY,
    case_id VARCHAR(50) REFERENCES cases(case_id) ON DELETE CASCADE,
    item_name VARCHAR(100) NOT NULL,
    location_in_scene VARCHAR(255) NOT NULL,
    confidence_score VARCHAR(10) NOT NULL,
    status VARCHAR(50) DEFAULT 'Verified'
);

-- Demo Clues Log Data
INSERT INTO clues_log (case_id, item_name, location_in_scene, confidence_score, status)
VALUES 
('SL-2026-0417', 'Knife (Weapon)', 'Near dining table', '96%', 'Verified'),
('SL-2026-0417', 'Mobile Phone', 'On floor near sofa', '97%', 'Verified'),
('SL-2026-0417', 'Blood Stain', 'Pooled (~40 cm area)', '93%', 'Critical'),
('SL-2026-0417', 'Broken Glass', 'Below main window', '91%', 'Review'),
('SL-2026-0417', 'Footprints', '3 prints leading to entry', '88%', 'Review');


-- 5. SPATIAL_3D_NODES TABLE (3D Scene Screen Markers)
CREATE TABLE spatial_3d_nodes (
    id SERIAL PRIMARY KEY,
    case_id VARCHAR(50) REFERENCES cases(case_id) ON DELETE CASCADE,
    item_name VARCHAR(100) NOT NULL,
    pos_x FLOAT NOT NULL,
    pos_y FLOAT NOT NULL,
    pos_z FLOAT NOT NULL,
    tag_number INT NOT NULL
);

-- Demo 3D Object Coordinates Data
INSERT INTO spatial_3d_nodes (case_id, item_name, pos_x, pos_y, pos_z, tag_number)
VALUES 
('SL-2026-0417', 'Knife (Weapon)', 2.5, 0.8, -1.2, 1),
('SL-2026-0417', 'Mobile Phone', -1.2, 0.0, 0.5, 2),
('SL-2026-0417', 'Blood Stain', 0.4, 0.0, 1.8, 3),
('SL-2026-0417', 'Broken Glass', -3.0, 0.2, -2.1, 4);


-- 6. AUDIT_TRAIL TABLE (Report Screen & Security Audit Logs)
CREATE TABLE audit_trail (
    id SERIAL PRIMARY KEY,
    case_id VARCHAR(50) REFERENCES cases(case_id) ON DELETE CASCADE,
    action_time VARCHAR(20) NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    action_recorded VARCHAR(255) NOT NULL
);

-- Demo Audit Logs Data
INSERT INTO audit_trail (case_id, action_time, user_name, action_recorded)
VALUES 
('SL-2026-0417', '09:12 UTC', 'Inspector R. Patil', 'Signed in (2FA)'),
('SL-2026-0417', '09:15 UTC', 'Inspector R. Patil', 'Uploaded 3 files'),
('SL-2026-0417', '09:40 UTC', 'Inspector R. Patil', 'Verified findings');