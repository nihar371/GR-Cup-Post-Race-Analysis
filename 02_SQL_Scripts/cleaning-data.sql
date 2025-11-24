
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------Creating UUID ----------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------
-- t_event_id ---------------------------------------
-----------------------------------------------------

DROP TABLE IF EXISTS t_event_info; 

CREATE TABLE IF NOT EXISTS t_event_info (
    event_uuid SERIAL PRIMARY KEY,
    meta_event VARCHAR(50),
	meta_session VARCHAR(10),
	meta_event_name VARCHAR(50),
	meta_session_name VARCHAR(50)
);

-- Add meta_event, meta_session from weather
INSERT INTO t_event_info (meta_event, meta_session)
SELECT DISTINCT 
    meta_event, 
    meta_session
FROM 
    t_weather_data
ORDER BY 
    meta_event, 
    meta_session;

-- Add meta_event_name (hardcoded)
WITH mapping_dict (key_col, value_col) AS (
    VALUES
    ('I_R06_2025-09-07', 'Barber'),
    ('I_R02_2025-04-27', 'COTA'),
    ('I_R07_2025-10-19', 'Indy'),
    ('I_R05_2025-08-17', 'Road America'),
    ('I_R03_2025-05-18', 'Sebring'),
    ('I_R01_2025-03-30', 'Sonoma Raceway'),
    ('I_R04_2025-07-20', 'VIR')
)
UPDATE t_event_info AS tei
SET meta_event_name = md.value_col
FROM mapping_dict AS md
WHERE tei.meta_event = md.key_col;

-- Add meta_session_name (hardcoded)
WITH mapping_dict (key_col, value_col) AS (
    VALUES
    ('R1', 'Race 1'),
    ('R2', 'Race 2')
)
UPDATE t_event_info AS tei
SET meta_session_name = md.value_col
FROM mapping_dict AS md
WHERE tei.meta_session = md.key_col;

select * from t_event_info;

------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------Replacing UUID ---------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------
-- t_best_lap_data ----------------------------------
-----------------------------------------------------

-- add uuid column
ALTER TABLE t_best_lap_data
ADD COLUMN event_uuid INT NULL;

-- fill uuid values
UPDATE t_best_lap_data AS tbld
SET event_uuid = tei.event_uuid
FROM t_event_info AS tei
WHERE tbld.meta_event = tei.meta_event
  AND tbld.meta_session = tei.meta_session;

-- drop meta_event, meta_session columns
ALTER TABLE t_best_lap_data
DROP COLUMN meta_event,
DROP COLUMN meta_session;

-- display
select * from t_best_lap_data;

-----------------------------------------------------
-- t_lap_time_data ----------------------------------
-----------------------------------------------------

-- add uuid column
ALTER TABLE t_lap_time_data
ADD COLUMN event_uuid INT NULL;

-- fill uuid values
UPDATE t_lap_time_data AS tlt
SET event_uuid = tei.event_uuid
FROM t_event_info AS tei
WHERE tlt.meta_event = tei.meta_event
  AND tlt.meta_session = tei.meta_session;

-- drop meta_event, meta_session columns
ALTER TABLE t_lap_time_data
DROP COLUMN meta_event,
DROP COLUMN meta_session;

-- display
select * from t_lap_time_data;

-- -----------------------------------------------------
-- -- t_race_results -----------------------------------
-- -----------------------------------------------------

-- -- add uuid column
-- ALTER TABLE t_race_results
-- ADD COLUMN event_uuid INT NULL;

-- -- fill uuid values
-- UPDATE t_race_results AS tlt
-- SET event_uuid = tei.event_uuid
-- FROM t_event_info AS tei
-- WHERE tlt.meta_event = tei.meta_event
--   AND tlt.meta_session = tei.meta_session;

-- -- drop meta_event, meta_session columns
-- ALTER TABLE t_race_results
-- DROP COLUMN meta_event,
-- DROP COLUMN meta_session;

-- -- display
-- select * from t_race_results;

-----------------------------------------------------
-- t_sector_data -----------------------------------
-----------------------------------------------------

-- add uuid column
ALTER TABLE t_sector_data
ADD COLUMN event_uuid INT NULL;

-- fill uuid values
UPDATE t_sector_data AS tlt
SET event_uuid = tei.event_uuid
FROM t_event_info AS tei
WHERE tlt.meta_event = tei.meta_event
  AND tlt.meta_session = tei.meta_session;

-- drop meta_event, meta_session columns
ALTER TABLE t_sector_data
DROP COLUMN meta_event,
DROP COLUMN meta_session;

-- display
select * from t_sector_data;


-----------------------------------------------------
-- t_telemetry_data ---------------------------------
-----------------------------------------------------

-- add uuid column
ALTER TABLE t_telemetry_data
ADD COLUMN event_uuid INT NULL;

-- fill uuid values
UPDATE t_telemetry_data AS tlt
SET event_uuid = tei.event_uuid
FROM t_event_info AS tei
WHERE tlt.meta_event = tei.meta_event
  AND tlt.meta_session = tei.meta_session;

-- drop meta_event, meta_session columns
ALTER TABLE t_telemetry_data
DROP COLUMN meta_event,
DROP COLUMN meta_session;

-- display
select * from t_telemetry_data LIMIT 100;


---------------------------------------------------
-- t_weather_data ---------------------------------
---------------------------------------------------

-- add uuid column
ALTER TABLE t_weather_data
ADD COLUMN event_uuid INT NULL;

-- fill uuid values
UPDATE t_weather_data AS tlt
SET event_uuid = tei.event_uuid
FROM t_event_info AS tei
WHERE tlt.meta_event = tei.meta_event
  AND tlt.meta_session = tei.meta_session;

-- drop meta_event, meta_session columns
ALTER TABLE t_weather_data
DROP COLUMN meta_event,
DROP COLUMN meta_session;

-- display
select * from t_weather_data;

---------------------------------------------------
-- t_points_table ---------------------------------
---------------------------------------------------

-- add uuid column
ALTER TABLE t_points_table
ADD COLUMN event_uuid INT NULL;

-- fill uuid values
UPDATE t_points_table AS tlt
SET event_uuid = tei.event_uuid
FROM t_event_info AS tei
WHERE tlt.race_track_name = tei.meta_event_name
  AND tlt.race_session = tei.meta_session_name;

-- drop meta_event, meta_session columns
ALTER TABLE t_points_table
DROP COLUMN race_track_name,
DROP COLUMN race_session;

-- display
select * from t_points_table;
select * from t_event_info;
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------Creating another column ---------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
select * from t_telemetry_data Limit 100;
-----------------------------------------------------
-- t_telemetry_data ---------------------------------
-----------------------------------------------------
-- clean values
UPDATE t_telemetry_data
SET vehicle_id = 'GR86-002-2'
WHERE vehicle_id = 'GR86-002-000' or vehicle_id = 'GR86-002-002';

-- add another column
ALTER TABLE t_telemetry_data
ADD COLUMN driver_number VARCHAR(10) NULL;

-- fill driver_number values
UPDATE t_telemetry_data
SET driver_number = SPLIT_PART(vehicle_id, '-', 3);

-- add another column
ALTER TABLE t_telemetry_data
ADD COLUMN event_participant_uuid VARCHAR(20) NULL;

-- fill driver_number values
UPDATE t_telemetry_data
SET event_participant_uuid = (event_uuid || '-' || driver_number);


-- add another column
ALTER TABLE t_telemetry_data
ADD COLUMN event_participant_lap_uuid VARCHAR(20) NULL;

-- fill driver_number values
UPDATE t_telemetry_data
SET event_participant_lap_uuid = (event_uuid || '-' || driver_number || '-' || lap);


ALTER TABLE t_telemetry_data
DROP COLUMN driver_number CASCADE;
ALTER TABLE t_telemetry_data
DROP COLUMN vehicle_id CASCADE;

select * from t_telemetry_data limit 100;
select * from v_pos_telemetry limit 100;
------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------Indexing Tables --------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------
-- INDEXING TELEMETRY -------------------------------
-----------------------------------------------------
DROP INDEX IF EXISTS vehicle_telemetry_idx;
CREATE INDEX vehicle_telemetry_idx ON t_telemetry_data (event_participant_lap_uuid);

------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------Creating Views ---------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------
-- v_best_lap_data_unpivot --------------------------
-----------------------------------------------------
CREATE OR REPLACE VIEW v_best_lap_data_unpivot AS
(
	SELECT 
	    event_uuid,
	    number,
	    'bestlap_1' AS lap_column,
	    bestlap_1 AS lap_time,
		bestlap_1_lapnum AS lap_num
	FROM 
	    t_best_lap_data
	UNION ALL
	SELECT 
	    event_uuid,
	    number,
	    'bestlap_2' AS lap_column,
	    bestlap_2 AS lap_time,
		bestlap_2_lapnum AS lap_num
	FROM 
	    t_best_lap_data
	UNION ALL
	SELECT 
	    event_uuid,
	    number,
	    'bestlap_3' AS lap_column,
	    bestlap_3 AS lap_time,
		bestlap_3_lapnum AS lap_num
	FROM 
	    t_best_lap_data
	UNION ALL
	SELECT 
	    event_uuid,
	    number,
	    'bestlap_4' AS lap_column,
	    bestlap_4 AS lap_time,
		bestlap_4_lapnum AS lap_num
	FROM 
	    t_best_lap_data
	UNION ALL
	SELECT 
	    event_uuid,
	    number,
	    'bestlap_5' AS lap_column,
	    bestlap_5 AS lap_time,
		bestlap_5_lapnum AS lap_num
	FROM 
	    t_best_lap_data
	UNION ALL
	SELECT 
	    event_uuid,
	    number,
	    'bestlap_6' AS lap_column,
	    bestlap_6 AS lap_time,
		bestlap_6_lapnum AS lap_num
	FROM 
	    t_best_lap_data
	UNION ALL
	SELECT 
	    event_uuid,
	    number,
	    'bestlap_7' AS lap_column,
	    bestlap_7 AS lap_time,
		bestlap_7_lapnum AS lap_num
	FROM 
	    t_best_lap_data
	UNION ALL
	SELECT 
	    event_uuid,
	    number,
	    'bestlap_8' AS lap_column,
	    bestlap_8 AS lap_time,
		bestlap_8_lapnum AS lap_num
	FROM 
	    t_best_lap_data
	UNION ALL
	SELECT 
	    event_uuid,
	    number,
	    'bestlap_9' AS lap_column,
	    bestlap_9 AS lap_time,
		bestlap_9_lapnum AS lap_num
	FROM 
	    t_best_lap_data
	UNION ALL
	SELECT 
	    event_uuid,
	    number,
	    'bestlap_10' AS lap_column,
	    bestlap_10 AS lap_time,
		bestlap_10_lapnum AS lap_num
	FROM 
	    t_best_lap_data
	ORDER BY 
	    event_uuid,
	    number,
	    lap_column
);

select * from v_best_lap_data_unpivot LIMIT 100;


-----------------------------------------------------
-- v_rel_telemetry ----------------------------------
-----------------------------------------------------

select * from t_telemetry_data limit 100;

DROP VIEW IF EXISTS v_pos_telemetry;

CREATE OR REPLACE VIEW v_pos_telemetry AS (
	SELECT
	    event_uuid,
		event_participant_uuid,
		event_participant_lap_uuid,
	    lap,
	    timestamp,
	    (EXTRACT(EPOCH FROM timestamp) - EXTRACT(EPOCH FROM MIN(timestamp) OVER (PARTITION BY event_participant_lap_uuid))) /
	    NULLIF(
            (EXTRACT(EPOCH FROM MAX(timestamp) OVER (PARTITION BY event_participant_lap_uuid)) - EXTRACT(EPOCH FROM MIN(timestamp) OVER (PARTITION BY event_participant_lap_uuid))),
            0
        ) AS track_position_value,
		steering_angle,
		accx_can,
		accy_can,
		ath,
		gear,
		nmot,
		pbrake_f,
		pbrake_r,
		speed
	FROM
	    t_telemetry_data
);

SELECT * FROM v_pos_telemetry
where event_uuid=13
LIMIT 100;


-- select distinct event_uuid || '-' || driver_number
-- from v_pos_telemetry
-- limit 100



-----------------------------------------------------
-- t_sector_data ------------------------------------
-----------------------------------------------------


select * from t_sector_data LIMIT 5;


-- add uuid column
ALTER TABLE t_sector_data
ADD COLUMN event_uuid INT NULL;

-- fill uuid values
UPDATE t_sector_data AS tbld
SET event_uuid = tei.event_uuid
FROM t_event_info AS tei
WHERE tbld.meta_event = tei.meta_event
  AND tbld.meta_session = tei.meta_session;

-- drop meta_event, meta_session columns
ALTER TABLE t_sector_data
DROP COLUMN meta_event,
DROP COLUMN meta_session;




-- check for dups
SELECT event_uuid, number, lap_number, COUNT(*)
FROM t_sector_data
GROUP BY event_uuid, number, lap_number
HAVING COUNT(*) > 1;


-- add uuid column
ALTER TABLE t_sector_data
ADD COLUMN event_participant_lap_uuid VARCHAR(15) NULL;


UPDATE t_sector_data
SET event_participant_lap_uuid = event_uuid || '-' || number || '-' || lap_number;

-- display
select * from t_sector_data LIMIT 5;











-----------------------------------------------------
-- v_lap_analysis -----------------------------------
-----------------------------------------------------
select distinct driver_number, event_uuid  from t_telemetry_data limit 100;