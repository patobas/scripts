/* Crea tabla AFIP reducida por codigo de actividad 9798 */
drop index idx_nominativa_9798; 
drop table nominativa_9798;

CREATE TABLE nominativa_9798 AS SELECT * FROM nominativa
WHERE (actividades = 97 OR actividades = 98)
AND periodo >= 201;

create index idx_nominativa_9798 on nominativa_9798 using btree(cuitcont); 

