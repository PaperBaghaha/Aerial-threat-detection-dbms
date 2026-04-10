-- Insert object
INSERT INTO Aerial_Objects(type, speed, altitude, latitude, longitude)
VALUES ('Missile', 1000, 1500, 11.01, 76.96);

-- Run logic
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
WHERE object_id = 1;

-- View data
SELECT * FROM Aerial_Objects;
SELECT * FROM Threat_Assessment;
SELECT * FROM Alerts;

-- Dashboard query 🔥
SELECT threat_level, COUNT(*) as count
FROM Threat_Assessment
GROUP BY threat_level;

-- Priority ranking 🔥
SELECT * FROM Threat_Assessment ORDER BY priority_score DESC;