DROP TABLE IF EXISTS import_file_paths;

CREATE TEMPORARY TABLE IF NOT EXISTS import_file_paths (
    id serial PRIMARY KEY,
    file_path TEXT NOT NULL
);

INSERT INTO import_file_paths (file_path) VALUES
    ('D:/github/GR-Cup/transformed_dataset/barber-motorsports-park/Race 1/R1_barber_sector_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/barber-motorsports-park/Race 2/R2_barber_sector_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/circuit-of-the-americas/Race 1/R1_cota_sector_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/circuit-of-the-americas/Race 2/R2_cota_sector_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/indianapolis/Race 1/R1_indianapolis_sector_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/indianapolis/Race 2/R2_indianapolis_sector_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/road-america/Race 1/R1_road_america_sector_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/road-america/Race 2/R2_road_america_sector_data.csv'),
    -- ('D:/github/GR-Cup/transformed_dataset/sebring/Race 1/R1_sebring_sector_data.csv'), <not present in the Dataset>
    ('D:/github/GR-Cup/transformed_dataset/sebring/Race 2/R2_sebring_sector_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/sonoma/Race 1/R1_sonoma_sector_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/sonoma/Race 2/R2_sonoma_sector_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/virginia-international-raceway/Race 1/R1_vir_sector_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/virginia-international-raceway/Race 2/R2_vir_sector_data.csv');

SELECT *
FROM import_file_paths;

------------------------------------------
------------------------------------------
------------------------------------------
DROP TABLE IF EXISTS t_sector_data;

CREATE TABLE IF NOT EXISTS t_sector_data (
    meta_event VARCHAR(50),
    meta_session VARCHAR(20),
    number TEXT,
    lap_number INTEGER,
    lap_time FLOAT,
    lap_improvement INTEGER,
    crossing_finish_line_in_pit TEXT,
    s1 INTERVAL,
    s1_improvement INTEGER,
    s2 INTERVAL,
    s2_improvement INTEGER,
    s3 INTERVAL,
    s3_improvement INTEGER,
    kph FLOAT,
    elapsed FLOAT,
    hour INTERVAL,
    s1_large FLOAT,
    s2_large FLOAT,
    s3_large FLOAT,
    top_speed FLOAT,
    pit_time TEXT,
    s1_seconds FLOAT,
    s2_seconds FLOAT,
    s3_seconds FLOAT,
    im1a_time INTERVAL,
    im1a_elapsed INTERVAL,
    im2a_time INTERVAL,
    im2a_elapsed INTERVAL,
    im3a_time INTERVAL,
    im3a_elapsed INTERVAL,
    fl_time INTERVAL,
    fl_elapsed INTERVAL
);


DO $$
DECLARE
    -- A variable to hold the record for each row from the file paths table.
    file_record RECORD;

    -- A variable to construct and execute the dynamic COPY command.
    copy_sql TEXT;
BEGIN
    -- Loop through each row in the table containing your file paths.
    FOR file_record IN SELECT file_path FROM import_file_paths ORDER BY id LOOP
        RAISE NOTICE 'Importing file: %', file_record.file_path;

        copy_sql := '
            COPY t_sector_data(
				meta_event,
				meta_session,
			    number,
			    lap_number,
			    lap_time,
			    lap_improvement,
			    crossing_finish_line_in_pit,
			    s1,
			    s1_improvement,
			    s2,
			    s2_improvement,
			    s3,
			    s3_improvement,
			    kph,
			    elapsed,
			    hour,
			    s1_large,
			    s2_large,
			    s3_large,
			    top_speed,
			    pit_time,
			    s1_seconds,
			    s2_seconds,
			    s3_seconds,
			    im1a_time,
			    im1a_elapsed,
			    im2a_time,
			    im2a_elapsed,
			    im3a_time,
			    im3a_elapsed,
			    fl_time,
			    fl_elapsed
			)
			FROM ' || quote_literal(file_record.file_path) || '
            DELIMITER '',''
            CSV HEADER;
        ';

        EXECUTE copy_sql;
    END LOOP;

    RAISE NOTICE 'All files imported successfully.';
END $$;

select * from t_sector_data limit 100;


------------------------------------------
------------------------------------------
------------------------------------------


-- Check Duplicates
WITH DuplicateRows AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY meta_event, meta_session, number, lap_number ORDER BY (SELECT NULL)) as rn
    FROM
        t_sector_data
)
SELECT
    *
FROM
    DuplicateRows
WHERE
    rn > 1
ORDER BY meta_event, meta_session, number, lap_number;

-- No Duplicates

select * from t_sector_data;