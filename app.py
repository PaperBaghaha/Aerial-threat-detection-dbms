def assess_threat(conn, obj_id):
    conn.execute("""
    INSERT INTO Threat_Assessment(object_id, threat_level, priority_score)
    SELECT object_id,
        CASE
            WHEN type = 'Missile' AND speed > 900 THEN 'CRITICAL'
            WHEN speed > 800 AND altitude < 2000 THEN 'HIGH'
            WHEN speed > 400 THEN 'MEDIUM'
            ELSE 'LOW'
        END,
        CASE
            WHEN type = 'Missile' THEN 100
            WHEN speed > 800 THEN 80
            WHEN speed > 400 THEN 50
            ELSE 20
        END
    FROM Aerial_Objects
    WHERE object_id = ?
    """, (obj_id,))
    conn.commit()
def setup_db():
    conn = sqlite3.connect("database.db")
    cur = conn.cursor()

    cur.execute("""
    CREATE TABLE IF NOT EXISTS Aerial_Objects (
        object_id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        speed INTEGER,
        altitude INTEGER,
        detected_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
    """)

    cur.execute("""
    CREATE TABLE IF NOT EXISTS Threat_Assessment (
        assessment_id INTEGER PRIMARY KEY AUTOINCREMENT,
        object_id INTEGER,
        threat_level TEXT,
        priority_score INTEGER,
        assessed_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
    """)

    cur.execute("""
    CREATE TABLE IF NOT EXISTS Alerts (
        alert_id INTEGER PRIMARY KEY AUTOINCREMENT,
        object_id INTEGER,
        message TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
    """)

    # Trigger
    cur.execute("""
    CREATE TRIGGER IF NOT EXISTS threat_alert_trigger
    AFTER INSERT ON Threat_Assessment
    BEGIN
        INSERT INTO Alerts(object_id, message)
        SELECT NEW.object_id,
            CASE
                WHEN NEW.threat_level = 'CRITICAL' THEN '🚨 CRITICAL THREAT 🚨'
                WHEN NEW.threat_level = 'HIGH' THEN '⚠️ High threat detected'
                ELSE 'Monitor'
            END;
    END;
    """)

    conn.commit()
    conn.close()