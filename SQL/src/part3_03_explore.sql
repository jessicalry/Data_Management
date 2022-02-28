--1. this query shows each report id and its instances in the table, ordered by its instance count. 
select report_id,count(*)
from staging_caers_events
group by report_id
order by count(*) desc;
--     report_id    | count 
-- -----------------+-------
--  179852          |    88
--  174049          |    78
--  190041          |    70
--  210074          |    70
--  190166          |    60
--  198546          |    56
--  192894          |    54
--  2017-CFS-002608 |    54
--  2017-CFS-000086 |    50
--  194925          |    50
--  176303          |    48
--  186332          |    48
--  197516          |    46
--  189451          |    46
--  204508          |    46

--2. this query finds the most recent and least recent event date record
select report_id, event_date from staging_caers_events
where  event_date=(
    select max( event_date) from staging_caers_events
)
union 
select report_id, event_date from staging_caers_events
where  event_date=(
    select min( event_date) from staging_caers_events 
)
;
--  report_id | event_date 
-- -----------+------------
--  177760    | 1950-05-01
--  215683    | 2018-05-11
-- (2 rows)

--3. this query shows if each report id matches a patient.
select report_id, count(distinct (sex,patient_age,age_units)) from staging_caers_events
group by report_id
order by count(distinct (sex,patient_age,age_units)) desc;
--     report_id    | count 
-- -----------------+-------
--  16,213          |     1
--  172934          |     1
--  172937          |     1
--  172939          |     1
--  172940          |     1
--  172941          |     1
--  172944          |     1

--4. this query determines whether the rows with the same terms will have different outcomes
select a.terms, a.outcomes, b.terms, b.outcomes
from staging_caers_events as a
inner join staging_caers_events as b on (a.terms=b.terms)
where a.outcomes!=b.outcomes
limit 10;
--             terms            |   outcomes    |            terms            |               outcomes                
-- -----------------------------+---------------+-----------------------------+---------------------------------------
--  DYSGEUSIA, HYPERSENSITIVITY | Other Outcome | DYSGEUSIA, HYPERSENSITIVITY | Medically Important, 
--  DYSGEUSIA, HYPERSENSITIVITY | Other Outcome | DYSGEUSIA, HYPERSENSITIVITY | Patient Visited Healthcare Provider, 
--  DYSGEUSIA, HYPERSENSITIVITY | Other Outcome | DYSGEUSIA, HYPERSENSITIVITY | Medically Important, 
--  DYSGEUSIA, HYPERSENSITIVITY | Other Outcome | DYSGEUSIA, HYPERSENSITIVITY | Medically Important, 
--  DYSGEUSIA, HYPERSENSITIVITY | Other Outcome | DYSGEUSIA, HYPERSENSITIVITY | Medically Important, 
--  DYSGEUSIA, HYPERSENSITIVITY | Other Outcome | DYSGEUSIA, HYPERSENSITIVITY | Patient Visited Healthcare Provider, 
--  DYSGEUSIA, HYPERSENSITIVITY | Other Outcome | DYSGEUSIA, HYPERSENSITIVITY | Medically Important, 
--  DYSGEUSIA, HYPERSENSITIVITY | Other Outcome | DYSGEUSIA, HYPERSENSITIVITY | Medically Important, 
--  NAUSEA                      | Other Outcome | NAUSEA                      | Patient Visited ER, 
--  NAUSEA                      | Other Outcome | NAUSEA                      | Hospitalization, 
-- (10 rows)

--5. this query explores the relationship between product codes and description. 
select product_code, COUNT(distinct description) AS description_count FROM staging_caers_events
GROUP BY product_code ORDER BY description_count DESC;
--  product_code | description_count 
-- --------------+-----------
--  5            |         2
--  20           |         2
--  16           |         2
--  9            |         2
--  17           |         1
--  18           |         1
--  2            |         1
--  21           |         1
--  22           |         1
--  23           |         1
--  24           |         1
--  25           |         1
--  26           |         1

--6. these queries explore the relationship between created_date, event_date, and report_id
SELECT report_id, COUNT(DISTINCT created_date) AS create_count
FROM staging_caers_events
GROUP BY report_id ORDER BY create_count DESC;

SELECT report_id, COUNT(DISTINCT event_date) AS event_count
FROM staging_caers_events
GROUP BY report_id ORDER BY event_count DESC;
--     report_id    | event_count 
-- -----------------+-------------
--  175718          |           1
--  198733          |           1
--  175719          |           1
--  198737          |           1
--  198746          |           1
--  198747          |           1
--  198748          |           1

--7. explores relationship between report_id, terms and outcomes.
select report_id, count(distinct terms) as terms_count, count(distinct outcomes) as outcomes_count
from staging_caers_events
group by report_id
order by outcomes_count desc, terms_count desc;
--     report_id    | terms_count | outcomes_count 
-- -----------------+-------------+----------------
--  217551          |           1 |              1
--  172934          |           1 |              1
--  172937          |           1 |              1
--  172939          |           1 |              1
--  172940          |           1 |              1
--  172941          |           1 |              1
--  172944          |           1 |              1

select caers_event_id, count(distinct product_code) as report_count
from staging_caers_events
group by caers_event_id
order by report_count desc;
