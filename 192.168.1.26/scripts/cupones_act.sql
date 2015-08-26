set default_tablespace='tmp';

drop table cupones_final;
--truncate table cupones_final;
--insert into cupones_final
select 
	case when trim(cuit)='' or cuit ilike '%L%' or cuit ilike '%-%' then 99999999995::int8 else trim(cuit)::bigint end as cuit, 
	case when trim(cuil)='' or cuil ilike '%L%' or cuil ilike '%-%' then 99999999995::int8 else trim(cuil)::bigint end as cuil,
	nro_cupon,
	to_date(fec_pres,'dd/mm/yyyy') as fec_pres,
	upper(substring(tipo,1,1)) as tipo,
	case when trim(periodo)='' 
	then 
	    0::int
	else 
	    to_char(to_date(periodo,'dd/mm/yyyy'),'yyyymm')::int
	end as periodo,
	remuneracion::numeric(10,2),
	case when trim(del)='' or del ilike '%/%' or del ilike '%-%' or del ilike '%.%' or del ilike '%C%' or del ilike '%N%' 
	then 
	    0::int
	else
	    case when char_length(del)=6 	
		then  (del::int/10000)*1000+del::int%1000
		else del::int 
	    end
	end as del,
	condicion,
	upper(imagen) as imagen,
	nro_cd 
into
	cupones_final
from 
	cupones_per cp left join cupones_head ch 
	on ch.id=cp.idcupon 
where 
	not cuit like '%.%'
	and not cuit like '%C%' 
	and not cuit like '%N%';

create index inx_cupf_ccp on cupones_final using btree (cuit, cuil, periodo);
create index inx_cupf_cp on cupones_final using btree  (cuil, periodo);
create index inx_cupf_fd on cupones_final using btree  (fec_pres,del);
create index inx_cupf_pd on cupones_final using btree  (periodo,del);
