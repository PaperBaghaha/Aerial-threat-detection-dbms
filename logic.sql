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
WHERE object_id = ?;