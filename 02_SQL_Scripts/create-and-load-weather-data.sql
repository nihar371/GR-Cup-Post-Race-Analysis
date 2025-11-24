DROP TABLE IF EXISTS import_file_paths;

CREATE TEMPORARY TABLE IF NOT EXISTS import_file_paths (
    id serial PRIMARY KEY,
    file_path TEXT NOT NULL
);


INSERT INTO import_file_paths (file_path) VALUES
    ('D:/github/GR-Cup/transformed_dataset/barber-motorsports-park/Race 1/R1_barber_weather_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/barber-motorsports-park/Race 2/R2_barber_weather_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/circuit-of-the-americas/Race 1/R1_cota_weather_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/circuit-of-the-americas/Race 2/R2_cota_weather_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/indianapolis/Race 1/R1_indianapolis_weather_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/indianapolis/Race 2/R2_indianapolis_weather_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/road-america/Race 1/R1_road_america_weather_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/road-america/Race 2/R2_road_america_weather_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/sebring/Race 1/R1_sebring_weather_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/sebring/Race 2/R2_sebring_weather_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/sonoma/Race 1/R1_sonoma_weather_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/sonoma/Race 2/R2_sonoma_weather_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/virginia-international-raceway/Race 1/R1_vir_weather_data.csv'),
    ('D:/github/GR-Cup/transformed_dataset/virginia-international-raceway/Race 2/R2_vir_weather_data.csv');


SELECT *
FROM import_file_paths;

------------------------------------------
------------------------------------------
------------------------------------------
DROP TABLE IF EXISTS t_weather_data;


CREATE TABLE IF NOT EXISTS t_weather_data (
    meta_event VARCHAR(50),
    meta_session VARCHAR(20),
    timestamp TIMESTAMPTZ NOT NULL,
    air_temp FLOAT,
    track_temp FLOAT,
    humidity FLOAT,
    pressure FLOAT,
    wind_speed FLOAT,
    wind_direction INTEGER,
    rain FLOAT
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
            COPY t_weather_data(
			    meta_event,
			    meta_session,
			    timestamp,
			    air_temp,
			    track_temp,
			    humidity,
			    pressure,
			    wind_speed,
			    wind_direction,
			    rain
			)
            FROM ' || quote_literal(file_record.file_path) || '
            DELIMITER '',''
            CSV HEADER;
        ';

        EXECUTE copy_sql;
    END LOOP;

    RAISE NOTICE 'All files imported successfully.';
END $$;

select * from t_weather_data limit 100;
