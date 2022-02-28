drop table if exists staging_caers_events;
create table staging_caers_events (
    caers_event_id serial primary key,
    report_id varchar(255),
    created_date date,
    event_date date,
    product_type text,
    product text,
    product_code text,
    description text,
    patient_age integer,
    age_units varchar(255),
    sex varchar(255),
    terms text,
    outcomes text);