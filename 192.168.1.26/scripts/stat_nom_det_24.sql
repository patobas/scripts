--Estadisticas .24
drop table if exists stats_determinativa_his;
--drop table if exists stats_nominativa_his;
begin;
SELECT nroorden,COUNT(nroorden) as total into stats_determinativa_his FROM determinativafin  GROUP BY nroorden ORDER BY nroorden;
--SELECT nroorden,COUNT(nroorden) as total into stats_nominativa_his     FROM nominativa        GROUP BY nroorden ORDER BY nroorden;
commit;
