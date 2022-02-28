staging_caers_events
	serial caers_event_id
	varchar report_id
	varchar product_id
	varchar product_type

product_description
	varchar product_code
	varchar description

report
	varchar report_id
	date created_date
	date event_date
	varchar sex
	int patient_age
	varchar terms
	varchar outcomes
	varchar age_units

product
	serial product_id
	varchar product
	varchar product_code

staging_caers_events {1}-have-{1..n} report
staging_caers_events {1..n}-have-{1} product_description
product {1..n}-have-{1} product_description