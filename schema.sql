-- Aerial Objects
CREATE TABLE Aerial_Objects (
    object_id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT,
    speed INTEGER,
    altitude INTEGER,
    latitude REAL,
    longitude REAL,
    detected_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Sensor Data (NEW 🔥)
CREATE TABLE Sensor_Data (
    sensor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    object_id INTEGER,
    temperature REAL,
    radar_cross_section REAL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Threat Assessment
CREATE TABLE Threat_Assessment (
    assessment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    object_id INTEGER,
    threat_level TEXT,
    priority_score INTEGER,
    assessed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Alerts
CREATE TABLE Alerts (
    alert_id INTEGER PRIMARY KEY AUTOINCREMENT,
    object_id INTEGER,
    message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);