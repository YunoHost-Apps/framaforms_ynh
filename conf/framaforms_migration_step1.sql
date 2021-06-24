UPDATE CREATE TABLE framaforms_expired_bak AS TABLE framaforms_expired;
CREATE TABLE variables_bak AS (SELECT * FROM variable WHERE name LIKE 'framaforms_%');