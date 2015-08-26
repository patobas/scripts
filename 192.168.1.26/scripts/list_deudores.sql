set default_tablespace='tmp';

SELECT
	cuit,
	sum(case when gestion is null then deuda else 0 end) as deuda,
	sum(fn_calc_interes(cuit, periodo, (case when gestion is null then deuda else 0 end), now()::date)) as interes,
	min(periodo) as desde,
	max(periodo) as hasta,
	sum(case when gestion is not null then deuda else 0 end) as en_gestion
INTO
	tmp_list_deudores
FROM
	view_cc
WHERE
	deuda > 0
	and
	periodo > 200204
GROUP BY
	cuit;

--Agregado por DC
truncate table list_deudores_apo;
insert into list_deudores_apo
select
	cuit,
	sum(deuda_apo),
	sum(case when gestion is null then fn_calc_interes(cuit,periodo,deuda_apo,current_date) else 0.00 end)
from view_cc
group by cuit;

TRUNCATE table list_deudores;
INSERT into list_deudores select * from tmp_list_deudores order by deuda desc;
DROP TABLE tmp_list_deudores;

--create index inx_ld_c    on list_deudores using btree (cuit);
--create index inx_ld_deuda on list_deudores using btree (deuda);
--create index inx_ld_dhci on list_deudores using btree (desde, hasta, (deuda + interes));


