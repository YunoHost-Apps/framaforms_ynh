INSERT INTO yakforms_expired (SELECT * FROM framaforms_expired_bak );
INSERT INTO variable
SELECT
  REGEXP_REPLACE(variables_bak.name, 'framaforms', 'yakforms'),
  variables_bak.value
  FROM variables_bak
ON CONFLICT (name)
DO UPDATE
  SET value = excluded.value;

DROP TABLE framaforms_expired_bak;
DROP TABLE variables_bak;
