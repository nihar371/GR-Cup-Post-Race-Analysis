DROP TABLE IF EXISTS import_file_paths;

CREATE TEMPORARY TABLE IF NOT EXISTS import_file_paths (
    id serial PRIMARY KEY,
    file_path TEXT NOT NULL
);

INSERT INTO import_file_paths (file_path) VALUES
    ('D:/github/GR-Cup/transformed_dataset/barber-motorsports-park/Race 1/R1_barber_best_lap_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/barber-motorsports-park/Race 2/R2_barber_best_lap_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/circuit-of-the-americas/Race 1/R1_cota_best_lap_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/circuit-of-the-americas/Race 2/R2_cota_best_lap_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/indianapolis/Race 1/R1_indianapolis_best_lap_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/indianapolis/Race 2/R2_indianapolis_best_lap_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/road-america/Race 1/R1_road_america_best_lap_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/road-america/Race 2/R2_road_america_best_lap_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/sebring/Race 1/R1_sebring_best_lap_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/sebring/Race 2/R2_sebring_best_lap_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/sonoma/Race 1/R1_sonoma_best_lap_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/sonoma/Race 2/R2_sonoma_best_lap_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/virginia-international-raceway/Race 1/R1_vir_best_lap_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/virginia-international-raceway/Race 2/R2_vir_best_lap_data.csv');

SELECT *
FROM import_file_paths;

------------------------------------------
------------------------------------------
------------------------------------------
DROP TABLE IF EXISTS t_best_lap_data CASCADE;

CREATE TABLE IF NOT EXISTS t_best_lap_data (
    meta_event VARCHAR(50),
    meta_session VARCHAR(20),
    number TEXT,
    total_driver_laps INTEGER,
    bestlap_1 INTERVAL,
    bestlap_1_lapnum INTEGER,
    bestlap_2 INTERVAL,
    bestlap_2_lapnum INTEGER,
    bestlap_3 INTERVAL,
    bestlap_3_lapnum INTEGER,
    bestlap_4 INTERVAL,
    bestlap_4_lapnum INTEGER,
    bestlap_5 INTERVAL,
    bestlap_5_lapnum INTEGER,
    bestlap_6 INTERVAL,
    bestlap_6_lapnum INTEGER,
    bestlap_7 INTERVAL,
    bestlap_7_lapnum INTEGER,
    bestlap_8 INTERVAL,
    bestlap_8_lapnum INTEGER,
    bestlap_9 INTERVAL,
    bestlap_9_lapnum INTEGER,
    bestlap_10 INTERVAL,
    bestlap_10_lapnum INTEGER,
    average INTERVAL
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
            COPY t_best_lap_data(
			    meta_event,
			    meta_session,
			    number,
                total_driver_laps,
                bestlap_1,
                bestlap_1_lapnum,
                bestlap_2,
                bestlap_2_lapnum,
                bestlap_3,
                bestlap_3_lapnum,
                bestlap_4,
                bestlap_4_lapnum,
                bestlap_5,
                bestlap_5_lapnum,
                bestlap_6,
                bestlap_6_lapnum,
                bestlap_7,
                bestlap_7_lapnum,
                bestlap_8,
                bestlap_8_lapnum,
                bestlap_9,
                bestlap_9_lapnum,
                bestlap_10,
                bestlap_10_lapnum,
                average
            )
            FROM ' || quote_literal(file_record.file_path) || '
            DELIMITER '',''
            CSV HEADER;
        ';

        EXECUTE copy_sql;
    END LOOP;

    RAISE NOTICE 'All files imported successfully.';
END $$;


SELECT *
FROM t_best_lap_data;

------------------------------------------
------------------------------------------
------------------------------------------

-- Check Duplicates
-- WITH DuplicateRows AS (
--     SELECT
--         *,
--         ROW_NUMBER() OVER (PARTITION BY meta_event, meta_session, number ORDER BY (SELECT NULL)) as rn
--     FROM
--         t_best_lap_data
-- )
-- SELECT
--     *
-- FROM
--     DuplicateRows
-- WHERE
--     rn > 1
-- ORDER BY meta_event, meta_session, number;

-- No Duplicates found

SELECT * FROM t_best_lap_data LIMIT 100;