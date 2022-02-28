\copy staging_caers_events(report_id,created_date,event_date,product_type,product,product_code,description ,patient_age ,age_units ,sex ,terms ,outcomes ) from 'CAERS_ASCII_11_14_to_12_17.csv' CSV HEADER DELIMITER as E',';

