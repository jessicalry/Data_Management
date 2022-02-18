DROP TABLE IF EXISTS staging_caers_events;
DROP TABLE IF EXISTS report;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS product_description;

create table product_description (
    product_code varchar(255) primary key,
    description varchar(255)
);

create table report (
    report_id varchar(255) primary key,
    created_date date,
    event_date date,
    sex varchar(255),
    patient_age integer,
    terms varchar(255),
    outcomes varchar(255),
    age_units varchar(255)
);

create table product (
    product_id serial primary key,
    product varchar(255),
    product_code varchar(255) references product_description
);

create table staging_caers_events (
    caers_event_id serial primary key,
    report_id varchar(255) references report,
    product_id int references product,
    product_type varchar(255)
);