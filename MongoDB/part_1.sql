--1. Write a query to show the report_id and the uppercase version of product for all rows that contain a 75 year old patient sorted by the report_id ascending. Add this query to part_1.sql.
select report_id, upper(product) from staging_caers_events where patient_age=75 and age_units='year(s)'
order by report_id asc;

--2. Use EXPLAIN ANALYZE to show how much time it takes to run your query
EXPLAIN ANALYZE select report_id, upper(product) from staging_caers_events where patient_age=75 and age_units='year(s)' order by report_id asc;
--                                                          QUERY PLAN                                                          
-- -----------------------------------------------------------------------------------------------------------------------------
--  Sort  (cost=2134.28..2135.11 rows=331 width=39) (actual time=16.086..16.121 rows=561 loops=1)
--    Sort Key: report_id
--    Sort Method: quicksort  Memory: 76kB
--    ->  Seq Scan on staging_caers_events  (cost=0.00..2120.43 rows=331 width=39) (actual time=0.152..15.708 rows=561 loops=1)
--          Filter: ((patient_age = 75) AND ((age_units)::text = 'year(s)'::text))
--          Rows Removed by Filter: 49879
--  Planning Time: 0.512 ms
--  Execution Time: 16.244 ms
-- (8 rows)

--3. Write SQL to add a single column index to make your query run faster and verify that it has been created
create index age_index on staging_caers_events(patient_age);
-- Indexes:
--     "staging_caers_events_pkey" PRIMARY KEY, btree (caers_event_id)
--     "age_index" btree (patient_age)
EXPLAIN ANALYZE select report_id, upper(product) from staging_caers_events where patient_age=75 and age_units='year(s)' order by report_id asc;
--                                                              QUERY PLAN                                                             
-- ------------------------------------------------------------------------------------------------------------------------------------
--  Sort  (cost=1072.61..1073.44 rows=331 width=39) (actual time=1.798..1.835 rows=561 loops=1)
--    Sort Key: report_id
--    Sort Method: quicksort  Memory: 76kB
--    ->  Bitmap Heap Scan on staging_caers_events  (cost=8.54..1058.76 rows=331 width=39) (actual time=0.106..1.426 rows=561 loops=1)
--          Recheck Cond: (patient_age = 75)
--          Filter: ((age_units)::text = 'year(s)'::text)
--          Heap Blocks: exact=228
--          ->  Bitmap Index Scan on age_index  (cost=0.00..8.45 rows=555 width=0) (actual time=0.065..0.066 rows=561 loops=1)
--                Index Cond: (patient_age = 75)
--  Planning Time: 0.570 ms
--  Execution Time: 1.989 ms
-- (11 rows)

-- 3. Write a 3rd query, a SELECT statement that involves the column you placed in the index on in the WHERE clause, that will cause the 
-- query planner to do a sequential scan rather than use the created index (that is, try to formulate a query that will make it not use
-- the index)
EXPLAIN ANALYZE select report_id, upper(product) from staging_caers_events where patient_age+0=75 and age_units='year(s)' order by report_id asc;
--                                                          QUERY PLAN                                                          
-- -----------------------------------------------------------------------------------------------------------------------------
--  Sort  (cost=2251.50..2251.87 rows=150 width=39) (actual time=17.839..17.876 rows=561 loops=1)
--    Sort Key: report_id
--    Sort Method: quicksort  Memory: 76kB
--    ->  Seq Scan on staging_caers_events  (cost=0.00..2246.07 rows=150 width=39) (actual time=0.103..17.395 rows=561 loops=1)
--          Filter: (((age_units)::text = 'year(s)'::text) AND ((patient_age + 0) = 75))
--          Rows Removed by Filter: 49879
--  Planning Time: 0.180 ms
--  Execution Time: 17.947 ms
-- (8 rows)
