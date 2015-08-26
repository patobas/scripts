--set default_tablespace='tmp';

drop table cupones_head;
drop table cupones_per;

--insert into cupones_per
select * into cupones_per from 
    dblink('user=postgres host=192.168.1.19 dbname=cupones',
  'select seq,periodo,remuneracion from periodos; --where not seq ilike ''%t%'' and not seq ilike ''%s%'';') as d (idcupon bigint,periodo varchar(15),remuneracion numeric(10,2));

--insert into cupones_head 
select * into cupones_head from
    dblink('user=postgres host=192.168.1.19 dbname=cupones',
'select seq::int as id, nro_cupon,tipo,cuit,cuil,fecha_presentacion,delegacion,condicion,tarea,nro_cd,upper(imagen) from cupones;'
    ) as d (id bigint, nro_cupon varchar(25), tipo varchar(25), cuit varchar(15), cuil varchar(15), fec_pres varchar(15), del varchar(15), condicion varchar(50), tarea varchar(50), nro_cd varchar(15), imagen varchar(50));


create index inx_cup_h_id on cupones_head using btree (id);
create index inx_cup_p_id on cupones_per using btree (idcupon);
