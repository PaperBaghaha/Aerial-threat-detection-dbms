-- Tables
CREATE TABLE IF NOT EXISTS Aerial_Objects (
    object_id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT,
    speed INTEGER,
    altitude INTEGER,
    detected_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Threat_Assessment (
    assessment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    object_id INTEGER,
    threat_level TEXT,
    priority_score INTEGER,
    assessed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Alerts (
    alert_id INTEGER PRIMARY KEY AUTOINCREMENT,
    object_id INTEGER,
    message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Trigger: auto threat assessment
CREATE TRIGGER IF NOT EXISTS auto_assess_threat
AFTER INSERT ON Aerial_Objects
BEGIN
    INSERT INTO Threat_Assessment(object_id, threat_level, priority_score)
    VALUES (
        NEW.object_id,
        CASE
            WHEN NEW.type = 'Missile' AND NEW.speed > 900 THEN 'CRITICAL'
            WHEN NEW.speed > 800 AND NEW.altitude < 2000 THEN 'HIGH'
            WHEN NEW.speed > 400 THEN 'MEDIUM'
            ELSE 'LOW'
        END,
        CASE
            WHEN NEW.type = 'Missile' THEN 100
            WHEN NEW.speed > 800 THEN 80
            WHEN NEW.speed > 400 THEN 50
            ELSE 20
        END
    );
END;

-- Trigger: auto alert
CREATE TRIGGER IF NOT EXISTS threat_alert_trigger
AFTER INSERT ON Threat_Assessment
BEGIN
    INSERT INTO Alerts(object_id, message)
    VALUES (
        NEW.object_id,
        CASE
            WHEN NEW.threat_level = 'CRITICAL' THEN 'CRITICAL THREAT'
            WHEN NEW.threat_level = 'HIGH' THEN 'High threat detected'
            ELSE 'Monitor'
        END
    );
END;

-- Audit Logging Table
CREATE TABLE IF NOT EXISTS Audit_Log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    object_id INTEGER,
    action TEXT,
    details TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Trigger: Audit Updates
CREATE TRIGGER IF NOT EXISTS audit_update_aerial_objects
AFTER UPDATE ON Aerial_Objects
BEGIN
    INSERT INTO Audit_Log (object_id, action, details)
    VALUES (NEW.object_id, 'UPDATE', 'Object updated. Speed: ' || OLD.speed || ' -> ' || NEW.speed || ', Altitude: ' || OLD.altitude || ' -> ' || NEW.altitude);
END;

-- Trigger: Audit Deletes
CREATE TRIGGER IF NOT EXISTS audit_delete_aerial_objects
AFTER DELETE ON Aerial_Objects
BEGIN
    INSERT INTO Audit_Log (object_id, action, details)
    VALUES (OLD.object_id, 'DELETE', 'Object deleted: Type: ' || OLD.type || ', Speed: ' || OLD.speed);
END;

-- Users Table
CREATE TABLE IF NOT EXISTS Users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    role TEXT NOT NULL
);

-- Insert dummy users if they don't exist
INSERT OR IGNORE INTO Users (username, password, role) VALUES ('admin', 'admin123', 'general');
INSERT OR IGNORE INTO Users (username, password, role) VALUES ('commander_1', 'cmd123', 'commander');
INSERT OR IGNORE INTO Users (username, password, role) VALUES ('analyst_1', 'ana123', 'analyst');