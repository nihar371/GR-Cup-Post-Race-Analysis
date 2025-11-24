DROP TABLE IF EXISTS import_file_paths;

CREATE TEMPORARY TABLE IF NOT EXISTS import_file_paths (
    id serial PRIMARY KEY,
    file_path TEXT NOT NULL
);

INSERT INTO import_file_paths (file_path) VALUES
    -- ('D:/github/GR-Cup/transformed_dataset/barber-motorsports-park/Race 1/R1_barber_lap_time_df.csv'), <need to create data properly>
    -- ('D:/github/GR-Cup/transformed_dataset/barber-motorsports-park/Race 2/R2_barber_lap_time_df.csv'), <need to create data properly>
    ('D:/github/GR-Cup/transformed_dataset/circuit-of-the-americas/Race 1/R1_cota_lap_time.csv'),
    ('D:/github/GR-Cup/transformed_dataset/circuit-of-the-americas/Race 2/R2_cota_lap_time.csv'),
    -- ('D:/github/GR-Cup/transformed_dataset/indianapolis/Race 1/R1_indianapolis_lap_time.csv'), <need to create data properly>
    -- ('D:/github/GR-Cup/transformed_dataset/indianapolis/Race 2/R2_indianapolis_lap_time.csv'), <need to create data properly>
    ('D:/github/GR-Cup/transformed_dataset/road-america/Race 1/R1_road_america_lap_time.csv'),
    ('D:/github/GR-Cup/transformed_dataset/road-america/Race 2/R2_road_america_lap_time.csv'),
    -- ('D:/github/GR-Cup/transformed_dataset/sebring/Race 1/R1_sebring_lap_time.csv'), <not present in the Dataset>
    ('D:/github/GR-Cup/transformed_dataset/sebring/Race 2/R2_sebring_lap_time.csv'),
    ('D:/github/GR-Cup/transformed_dataset/sonoma/Race 1/R1_sonoma_lap_time.csv'),
    ('D:/github/GR-Cup/transformed_dataset/sonoma/Race 2/R2_sonoma_lap_time.csv'),
    ('D:/github/GR-Cup/transformed_dataset/virginia-international-raceway/Race 1/R1_vir_lap_time.csv');
    -- ('D:/github/GR-Cup/transformed_dataset/virginia-international-raceway/Race 2/R2_vir_lap_time.csv'); <need to create data properly>


SELECT *
FROM import_file_paths;

------------------------------------------
------------------------------------------
------------------------------------------
DROP TABLE IF EXISTS t_lap_time_data;

CREATE TABLE IF NOT EXISTS t_lap_time_data (
    meta_event TEXT NOT NULL,
    meta_session TEXT NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL,
    vehicle_id VARCHAR(50) NOT NULL,
    lap INTEGER NOT NULL,
    value BIGINT
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
            COPY t_lap_time_data (meta_event,
								  meta_session,
								  timestamp,
								  vehicle_id,
								  lap,
								  value)
            FROM ' || quote_literal(file_record.file_path) || '
            DELIMITER '',''
            CSV HEADER;
        ';

        EXECUTE copy_sql;
    END LOOP;

    RAISE NOTICE 'All files imported successfully.';
END $$;

select * from t_lap_time_data limit 100;

------------------------------------------
------------------------------------------
------------------------------------------

-- Check Duplicates
-- WITH DuplicateRows AS (
--     SELECT
--         *,
--         ROW_NUMBER() OVER (PARTITION BY meta_event, meta_session, vehicle_id, lap ORDER BY (SELECT NULL)) as rn
--     FROM
--         t_lap_time_data
-- )
-- SELECT
--     *
-- FROM
--     DuplicateRows
-- WHERE
--     rn > 1
-- ORDER BY meta_event, meta_session, vehicle_id, lap;
