--------------------------
-- GR Driver Info --------
--------------------------
DROP TABLE IF EXISTS t_driver_summary;

CREATE TABLE IF NOT EXISTS t_driver_summary (
	position INT,
	participant VARCHAR(50),
	total_points INT,
	number TEXT,
	name VARCHAR(50),
	surname VARCHAR(50),
	country VARCHAR(50),
	team VARCHAR(50),
	manufacturer VARCHAR(50),
	class VARCHAR(10),
	driver_image_url TEXT
);


COPY t_driver_summary(
	position,
	participant,
	total_points,
	number,
	name,
	surname,
	country,
	team,
	manufacturer,
	class,
	driver_image_url
)
FROM 'D:/github/GR-Cup/transformed_dataset/GR_Cup_driver_info_data.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM t_driver_summary;


-- SETTING UP KEYS
ALTER TABLE t_driver_summary
ADD PRIMARY KEY (surname, number);

--------------------------
-- GR Point Info --------
--------------------------
DROP TABLE IF EXISTS t_points_table;

CREATE TABLE IF NOT EXISTS t_points_table (
	number TEXT,
	name VARCHAR(50),
	race_track_name VARCHAR(50),
	race_session VARCHAR(50),
	extra_1 INT,
	extra_2 INT,
	extra_not_classified_points INT,
	extra_not_classified_points_are_invalid INT,
	extra_not_started_points INT,
	extra_not_started_points_are_invalid INT,
	extra_participation_points INT,
	extra_participation_points_are_invalid INT,
	fastest_lap_points INT,
	points VARCHAR(10),
	pole_points INT,
	status VARCHAR(10),
	total_extra_points INT
);


COPY t_points_table(
	number,
	name,
	race_track_name,
	race_session,
	extra_1,
	extra_2,
	extra_not_classified_points,
	extra_not_classified_points_are_invalid,
	extra_not_started_points,
	extra_not_started_points_are_invalid,
	extra_participation_points,
	extra_participation_points_are_invalid,
	fastest_lap_points,
	points,
	pole_points,
	status,
	total_extra_points
)
FROM 'D:/github/GR-Cup/transformed_dataset/GR_Cup_race_points_data.csv'
DELIMITER ','
CSV HEADER;

-- UPDATE t_points_table
-- SET race_session = UPPER(LEFT(SPLIT_PART(race_session, ' ', 1), 1)) || SPLIT_PART(race_session, ' ', 2)
-- WHERE race_session LIKE 'Race %';

SELECT * FROM t_points_table;


-- SELECT
-- 	table_schema,
-- 	table_name,
-- 	column_name,
-- 	data_type,
-- 	character_maximum_length,
-- 	is_nullable
-- FROM
-- 	information_schema.columns
-- WHERE
-- 	table_schema NOT IN ('pg_catalog', 'information_schema') -- Exclude system schemas
-- ORDER BY
-- 	table_schema, table_name, ordinal_position;


--------------------------
-- GR Team Info ----------
--------------------------
DROP TABLE IF EXISTS t_team_info;

CREATE TABLE IF NOT EXISTS t_team_info (
	team_name TEXT,
	team_image_url TEXT
);


COPY t_team_info(
	team_name,
	team_image_url
)
FROM 'D:/github/GR-Cup/transformed_dataset/GR_Cup_team_data.csv'
DELIMITER ','
CSV HEADER;


SELECT * FROM t_team_info;