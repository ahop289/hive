set hive.mapred.mode=nonstrict;
set hive.explain.user=false;
SET hive.vectorized.execution.enabled=true;
set hive.fetch.task.conversion=minimal;

DROP TABLE IF EXISTS DECIMAL_UDF_txt;
DROP TABLE IF EXISTS DECIMAL_UDF;

CREATE TABLE DECIMAL_UDF_txt (key decimal(20,10), value int)
ROW FORMAT DELIMITED
   FIELDS TERMINATED BY ' '
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '../../data/files/kv7.txt' INTO TABLE DECIMAL_UDF_txt;

CREATE TABLE DECIMAL_UDF (key decimal(20,10), value int)
STORED AS ORC;

INSERT OVERWRITE TABLE DECIMAL_UDF SELECT * FROM DECIMAL_UDF_txt;

-- addition
EXPLAIN VECTORIZATION DETAIL
SELECT key + key FROM DECIMAL_UDF;
SELECT key + key FROM DECIMAL_UDF;

EXPLAIN VECTORIZATION DETAIL
SELECT key + value FROM DECIMAL_UDF;
SELECT key + value FROM DECIMAL_UDF;

EXPLAIN VECTORIZATION DETAIL
SELECT key + (value/2) FROM DECIMAL_UDF;
SELECT key + (value/2) FROM DECIMAL_UDF;

EXPLAIN VECTORIZATION DETAIL
SELECT key + '1.0' FROM DECIMAL_UDF;
SELECT key + '1.0' FROM DECIMAL_UDF;

-- substraction
EXPLAIN VECTORIZATION DETAIL
SELECT key - key FROM DECIMAL_UDF;
SELECT key - key FROM DECIMAL_UDF;

EXPLAIN VECTORIZATION DETAIL
SELECT key - value FROM DECIMAL_UDF;
SELECT key - value FROM DECIMAL_UDF;

EXPLAIN VECTORIZATION DETAIL
SELECT key - (value/2) FROM DECIMAL_UDF;
SELECT key - (value/2) FROM DECIMAL_UDF;

EXPLAIN VECTORIZATION DETAIL
SELECT key - '1.0' FROM DECIMAL_UDF;
SELECT key - '1.0' FROM DECIMAL_UDF;

-- multiplication
EXPLAIN VECTORIZATION DETAIL
SELECT key * key FROM DECIMAL_UDF;
SELECT key * key FROM DECIMAL_UDF;

EXPLAIN VECTORIZATION DETAIL
SELECT key, value FROM DECIMAL_UDF where key * value > 0;
SELECT key, value FROM DECIMAL_UDF where key * value > 0;

EXPLAIN VECTORIZATION DETAIL
SELECT key * value FROM DECIMAL_UDF;
SELECT key * value FROM DECIMAL_UDF;

EXPLAIN VECTORIZATION DETAIL
SELECT key * (value/2) FROM DECIMAL_UDF;
SELECT key * (value/2) FROM DECIMAL_UDF;

EXPLAIN VECTORIZATION DETAIL
SELECT key * '2.0' FROM DECIMAL_UDF;
SELECT key * '2.0' FROM DECIMAL_UDF;

-- division
EXPLAIN VECTORIZATION DETAIL
SELECT key / 0 FROM DECIMAL_UDF limit 1;
SELECT key / 0 FROM DECIMAL_UDF limit 1;

-- Output not stable.
-- EXPLAIN VECTORIZATION DETAIL
-- SELECT key / NULL FROM DECIMAL_UDF limit 1;
-- SELECT key / NULL FROM DECIMAL_UDF limit 1;

EXPLAIN VECTORIZATION DETAIL
SELECT key / key FROM DECIMAL_UDF WHERE key is not null and key <> 0;
SELECT key / key FROM DECIMAL_UDF WHERE key is not null and key <> 0;

EXPLAIN VECTORIZATION DETAIL
SELECT key / value FROM DECIMAL_UDF WHERE value is not null and value <> 0;
SELECT key / value FROM DECIMAL_UDF WHERE value is not null and value <> 0;

EXPLAIN VECTORIZATION DETAIL
SELECT key / (value/2) FROM DECIMAL_UDF  WHERE value is not null and value <> 0;
SELECT key / (value/2) FROM DECIMAL_UDF  WHERE value is not null and value <> 0;

EXPLAIN VECTORIZATION DETAIL
SELECT 1 + (key / '2.0') FROM DECIMAL_UDF;
SELECT 1 + (key / '2.0') FROM DECIMAL_UDF;

-- abs
EXPLAIN VECTORIZATION DETAIL
SELECT abs(key) FROM DECIMAL_UDF;
SELECT abs(key) FROM DECIMAL_UDF;

-- avg
EXPLAIN VECTORIZATION DETAIL
SELECT value, sum(key) / count(key), avg(key), sum(key) FROM DECIMAL_UDF GROUP BY value ORDER BY value;
SELECT value, sum(key) / count(key), avg(key), sum(key) FROM DECIMAL_UDF GROUP BY value ORDER BY value;

-- negative
EXPLAIN VECTORIZATION DETAIL
SELECT -key FROM DECIMAL_UDF;
SELECT -key FROM DECIMAL_UDF;

-- positive
EXPLAIN VECTORIZATION DETAIL
SELECT +key FROM DECIMAL_UDF;
SELECT +key FROM DECIMAL_UDF;

-- ceiling
EXPlAIN SELECT CEIL(key) FROM DECIMAL_UDF;
SELECT CEIL(key) FROM DECIMAL_UDF;

-- floor
EXPLAIN VECTORIZATION DETAIL
SELECT FLOOR(key) FROM DECIMAL_UDF;
SELECT FLOOR(key) FROM DECIMAL_UDF;

-- round
EXPLAIN VECTORIZATION DETAIL
SELECT ROUND(key, 2) FROM DECIMAL_UDF;
SELECT ROUND(key, 2) FROM DECIMAL_UDF;

-- power
EXPLAIN VECTORIZATION DETAIL
SELECT POWER(key, 2) FROM DECIMAL_UDF;
SELECT POWER(key, 2) FROM DECIMAL_UDF;

-- modulo
EXPLAIN VECTORIZATION DETAIL
SELECT (key + 1) % (key / 2) FROM DECIMAL_UDF;
SELECT (key + 1) % (key / 2) FROM DECIMAL_UDF;

-- stddev, var
EXPLAIN VECTORIZATION DETAIL
SELECT value, stddev(key), variance(key) FROM DECIMAL_UDF GROUP BY value;
SELECT value, stddev(key), variance(key) FROM DECIMAL_UDF GROUP BY value;

-- stddev_samp, var_samp
EXPLAIN VECTORIZATION DETAIL
SELECT value, stddev_samp(key), var_samp(key) FROM DECIMAL_UDF GROUP BY value;
SELECT value, stddev_samp(key), var_samp(key) FROM DECIMAL_UDF GROUP BY value;

-- histogram
EXPLAIN VECTORIZATION DETAIL
SELECT histogram_numeric(key, 3) FROM DECIMAL_UDF;
SELECT histogram_numeric(key, 3) FROM DECIMAL_UDF;

-- min
EXPLAIN VECTORIZATION DETAIL
SELECT MIN(key) FROM DECIMAL_UDF;
SELECT MIN(key) FROM DECIMAL_UDF;

-- max
EXPLAIN VECTORIZATION DETAIL
SELECT MAX(key) FROM DECIMAL_UDF;
SELECT MAX(key) FROM DECIMAL_UDF;

-- count
EXPLAIN VECTORIZATION DETAIL
SELECT COUNT(key) FROM DECIMAL_UDF;
SELECT COUNT(key) FROM DECIMAL_UDF;

-- DECIMAL_64

CREATE TABLE DECIMAL_UDF_txt_small (key decimal(15,3), value int)
ROW FORMAT DELIMITED
   FIELDS TERMINATED BY ' '
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '../../data/files/kv7.txt' INTO TABLE DECIMAL_UDF_txt_small;

-- addition
EXPLAIN VECTORIZATION DETAIL
SELECT key + key FROM DECIMAL_UDF_txt_small;
SELECT key + key FROM DECIMAL_UDF_txt_small;

EXPLAIN VECTORIZATION DETAIL
SELECT key + value FROM DECIMAL_UDF_txt_small;
SELECT key + value FROM DECIMAL_UDF_txt_small;

EXPLAIN VECTORIZATION DETAIL
SELECT key + (value/2) FROM DECIMAL_UDF_txt_small;
SELECT key + (value/2) FROM DECIMAL_UDF_txt_small;

EXPLAIN VECTORIZATION DETAIL
SELECT key + '1.0' FROM DECIMAL_UDF_txt_small;
SELECT key + '1.0' FROM DECIMAL_UDF_txt_small;

-- substraction
EXPLAIN VECTORIZATION DETAIL
SELECT key - key FROM DECIMAL_UDF_txt_small;
SELECT key - key FROM DECIMAL_UDF_txt_small;

EXPLAIN VECTORIZATION DETAIL
SELECT key - value FROM DECIMAL_UDF_txt_small;
SELECT key - value FROM DECIMAL_UDF_txt_small;

EXPLAIN VECTORIZATION DETAIL
SELECT key - (value/2) FROM DECIMAL_UDF_txt_small;
SELECT key - (value/2) FROM DECIMAL_UDF_txt_small;

EXPLAIN VECTORIZATION DETAIL
SELECT key - '1.0' FROM DECIMAL_UDF_txt_small;
SELECT key - '1.0' FROM DECIMAL_UDF_txt_small;

-- multiplication
EXPLAIN VECTORIZATION DETAIL
SELECT key * key FROM DECIMAL_UDF_txt_small;
SELECT key * key FROM DECIMAL_UDF_txt_small;

EXPLAIN VECTORIZATION DETAIL
SELECT key, value FROM DECIMAL_UDF_txt_small where key * value > 0;
SELECT key, value FROM DECIMAL_UDF_txt_small where key * value > 0;

EXPLAIN VECTORIZATION DETAIL
SELECT key * value FROM DECIMAL_UDF_txt_small;
SELECT key * value FROM DECIMAL_UDF_txt_small;

EXPLAIN VECTORIZATION DETAIL
SELECT key * (value/2) FROM DECIMAL_UDF_txt_small;
SELECT key * (value/2) FROM DECIMAL_UDF_txt_small;

EXPLAIN VECTORIZATION DETAIL
SELECT key * '2.0' FROM DECIMAL_UDF_txt_small;
SELECT key * '2.0' FROM DECIMAL_UDF_txt_small;

-- division
EXPLAIN VECTORIZATION DETAIL
SELECT key / 0 FROM DECIMAL_UDF_txt_small limit 1;
SELECT key / 0 FROM DECIMAL_UDF_txt_small limit 1;

-- Output not stable.
-- EXPLAIN VECTORIZATION DETAIL
-- SELECT key / NULL FROM DECIMAL_UDF_txt_small limit 1;
-- SELECT key / NULL FROM DECIMAL_UDF_txt_small limit 1;

EXPLAIN VECTORIZATION DETAIL
SELECT key / key FROM DECIMAL_UDF_txt_small WHERE key is not null and key <> 0;
SELECT key / key FROM DECIMAL_UDF_txt_small WHERE key is not null and key <> 0;

EXPLAIN VECTORIZATION DETAIL
SELECT key / value FROM DECIMAL_UDF_txt_small WHERE value is not null and value <> 0;
SELECT key / value FROM DECIMAL_UDF_txt_small WHERE value is not null and value <> 0;

EXPLAIN VECTORIZATION DETAIL
SELECT key / (value/2) FROM DECIMAL_UDF_txt_small  WHERE value is not null and value <> 0;
SELECT key / (value/2) FROM DECIMAL_UDF_txt_small  WHERE value is not null and value <> 0;

EXPLAIN VECTORIZATION DETAIL
SELECT 1 + (key / '2.0') FROM DECIMAL_UDF_txt_small;
SELECT 1 + (key / '2.0') FROM DECIMAL_UDF_txt_small;

-- abs
EXPLAIN VECTORIZATION DETAIL
SELECT abs(key) FROM DECIMAL_UDF_txt_small;
SELECT abs(key) FROM DECIMAL_UDF_txt_small;

-- avg
EXPLAIN VECTORIZATION DETAIL
SELECT value, sum(key) / count(key), avg(key), sum(key) FROM DECIMAL_UDF_txt_small GROUP BY value ORDER BY value;
SELECT value, sum(key) / count(key), avg(key), sum(key) FROM DECIMAL_UDF_txt_small GROUP BY value ORDER BY value;

-- negative
EXPLAIN VECTORIZATION DETAIL
SELECT -key FROM DECIMAL_UDF_txt_small;
SELECT -key FROM DECIMAL_UDF_txt_small;

-- positive
EXPLAIN VECTORIZATION DETAIL
SELECT +key FROM DECIMAL_UDF_txt_small;
SELECT +key FROM DECIMAL_UDF_txt_small;

-- ceiling
EXPlAIN SELECT CEIL(key) FROM DECIMAL_UDF_txt_small;
SELECT CEIL(key) FROM DECIMAL_UDF_txt_small;

-- floor
EXPLAIN VECTORIZATION DETAIL
SELECT FLOOR(key) FROM DECIMAL_UDF_txt_small;
SELECT FLOOR(key) FROM DECIMAL_UDF_txt_small;

-- round
EXPLAIN VECTORIZATION DETAIL
SELECT ROUND(key, 2) FROM DECIMAL_UDF_txt_small;
SELECT ROUND(key, 2) FROM DECIMAL_UDF_txt_small;

-- power
EXPLAIN VECTORIZATION DETAIL
SELECT POWER(key, 2) FROM DECIMAL_UDF_txt_small;
SELECT POWER(key, 2) FROM DECIMAL_UDF_txt_small;

-- modulo
EXPLAIN VECTORIZATION DETAIL
SELECT (key + 1) % (key / 2) FROM DECIMAL_UDF_txt_small;
SELECT (key + 1) % (key / 2) FROM DECIMAL_UDF_txt_small;

-- stddev, var
EXPLAIN VECTORIZATION DETAIL
SELECT value, stddev(key), variance(key) FROM DECIMAL_UDF_txt_small GROUP BY value;
SELECT value, stddev(key), variance(key) FROM DECIMAL_UDF_txt_small GROUP BY value;

-- stddev_samp, var_samp
EXPLAIN VECTORIZATION DETAIL
SELECT value, stddev_samp(key), var_samp(key) FROM DECIMAL_UDF_txt_small GROUP BY value;
SELECT value, stddev_samp(key), var_samp(key) FROM DECIMAL_UDF_txt_small GROUP BY value;

-- histogram
EXPLAIN VECTORIZATION DETAIL
SELECT histogram_numeric(key, 3) FROM DECIMAL_UDF_txt_small;
SELECT histogram_numeric(key, 3) FROM DECIMAL_UDF_txt_small;

-- min
EXPLAIN VECTORIZATION DETAIL
SELECT MIN(key) FROM DECIMAL_UDF_txt_small;
SELECT MIN(key) FROM DECIMAL_UDF_txt_small;

-- max
EXPLAIN VECTORIZATION DETAIL
SELECT MAX(key) FROM DECIMAL_UDF_txt_small;
SELECT MAX(key) FROM DECIMAL_UDF_txt_small;

-- count
EXPLAIN VECTORIZATION DETAIL
SELECT COUNT(key) FROM DECIMAL_UDF_txt_small;
SELECT COUNT(key) FROM DECIMAL_UDF_txt_small;

DROP TABLE IF EXISTS DECIMAL_UDF_txt;
DROP TABLE IF EXISTS DECIMAL_UDF;

