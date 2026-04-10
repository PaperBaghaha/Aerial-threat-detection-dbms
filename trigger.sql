CREATE TRIGGER threat_alert_trigger
AFTER INSERT ON Threat_Assessment
BEGIN
    INSERT INTO Alerts(object_id, message)
    SELECT NEW.object_id,
        CASE
            WHEN NEW.threat_level = 'CRITICAL' THEN '🚨 CRITICAL THREAT 🚨'
            WHEN NEW.threat_level = 'HIGH' THEN '⚠️ High threat detected'
            ELSE 'Monitor situation'
        END;
END;