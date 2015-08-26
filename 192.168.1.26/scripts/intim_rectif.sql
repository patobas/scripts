                                                                     
                                                                     
                                                                     
                                             
/*
	Script que consolida las intimaciones de Rectificacion, usadas por el sector de recaudación.
	Creado por DC 11/10/2013
*/

--Vaciar tablas
truncate table intimacion_rectificacion_total_trabajadores;
truncate table intimacion_rectificacion_aportes_intereses;
truncate table intimacion_rectificacion_contribucion_intereses;

--Cargar total de trabajadores BIEN declarados.
insert into intimacion_rectificacion_total_trabajadores
select  A.periodo,
		A.cuitcont,
		'B' as tipo,
		count(distinct A.cuitapo) as trabajadores,
		count(A.cuitapo) 	      as relaciones
from    nominativa  as A
where a.periodo >='1201'
and   a.periodo <='1306'
and   a.actividades in('97','98')
and   a.modcont not in (989,110,111,112,113,990,991,992,993,994,995,996,997,998,999)
group by A.periodo,A.cuitcont;

--Cargar total de trabajadores MAL declarados.
insert into intimacion_rectificacion_total_trabajadores
select  A.periodo,
	A.cuitcont,
	'M' as tipo,
	count(distinct A.cuitapo) as trabajadores,
	count(A.cuitapo) 	     as relaciones
from   nominativa  as A
where A.periodo >='1201'
and   A.codosoc = '119302'
and   A.actividades not in ('97','98')
group by A.periodo,A.cuitcont;

--Cargar total de APORTES BIEN declarados.
insert into intimacion_rectificacion_aportes_intereses
select A.periodo,
       A.cuitcont,
       'B' as tipo,
       round(sum(A.remimpo)*0.015,2) as aporte,
       (round(sum(A.remimpo)*0.015,2)*calc_numdias_afip(A.cuitcont,A.periodo))*0.001 as interes
from  nominativa as A
where A.Periodo >= '1201'
and   A.periodo <='1306'
and   A.actividades in ('97','98')			
and   A.modcont not in (989,110,111,112,113,990,991,992,993,994,995,996,997,998,999)
group by A.periodo,A.cuitcont;

--Cargar total de APORTES MAL declarados
insert into intimacion_rectificacion_aportes_intereses
select A.periodo,
       A.cuitcont,
       'M' as tipo,
       round(sum(A.remimpo)*0.015,2) as aporte,
      (round(sum(A.remimpo)*0.015,2)*calc_numdias_afip(A.cuitcont,A.periodo))*0.001 as interes
from  nominativa as A
where A.Periodo >= '1201'
and   A.actividades not in ('97','98')		
and   A.codosoc  = '119302'
group by A.periodo,A.cuitcont;

--Cargar total de CONTRIBUCIONES BIEN declaradas
insert into intimacion_rectificacion_contribucion_intereses
select  A.periodo,
		A.cuitcont,
        'B' as tipo,
		round(sum(A.remimpo)*0.015,2) as contribucion,
       (round(sum(A.remimpo)*0.015,2)*calc_numdias_afip(A.cuitcont,A.periodo))*0.001 as interes
from  nominativa as A
where A.Periodo >= '1204'
and   A.periodo <= '1306'
and   A.actividades in ('97','98')			
and   A.modcont not in (989,110,111,112,113,990,991,992,993,994,995,996,997,998,999)
group by A.periodo,A.cuitcont;

--Cargar total de CONTRIBUCIONES MAL declaradas
insert into intimacion_rectificacion_contribucion_intereses
select  A.periodo,
		A.cuitcont,
       'M' as tipo,
		round(sum(A.remimpo)*0.015,2) as contribucion,
		(round(sum(A.remimpo)*0.015,2)*calc_numdias_afip(A.cuitcont,A.periodo))*0.001 as interes
from  nominativa as A
where A.Periodo >= '1201'
and   A.codosoc  = '119302'
and   A.actividades not in ('97','98')
group by A.periodo,A.cuitcont;

--Grabar nueva version de la corrida
insert into intimacion_version(fecha,tipo) values(now(),'rectificativa');
