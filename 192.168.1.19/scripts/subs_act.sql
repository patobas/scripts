begin;

drop table subs_subsidios;
drop table subs_cuotas;

create table subs_subsidios as
select * from dblink ('dbname=dbrenatre host=192.168.1.2 port=5435 user=postgres','
select
   s.cuil,
   (select documentonumero from padron where id=(select persona from
trabajadores where cuil=s.cuil)) as documentonumero,
   (select fechanacimiento from padron where id=(select persona from
trabajadores where cuil=s.cuil)) as fechanacimiento,
   s.nroexpediente,
   s.nrosubsidio,
   b.nombre as banco,
   v.filial,
   v.domicilio,
   v.localidad,
   v.cp,
   v.partido,
   (select nombre from provincias where id=v.provincia) as provincia,
   (case
       when estadosubsidio in (1,2,3,4) then ''En proceso de
aprobaci&oacute;n''
       when estadosubsidio in (6,8) then ''Aprobado''
       else (select descripcion from subs_estados where
codigo=estadosubsidio)
   end) as estado,
   s.estadosubsidio as idestado,
   (select descripcion from subs_motivos where codigo=s.motivo) as motivo,
   s.fechasolicitud
from
   subs_subsidios s
left join
   subs_bancos b on b.codigo=s.idpagador
left join
   subs_sucursales_bancos v on v.codigo=s.idsucursal')
as subs_subsidios (
   cuil bigint,
   documentonumero int,
   fechanacimiento date,
   nroexpediente bigint,
   nrosubsidio bigint,
   banco text,
   filial varchar(100),
   domicilio text,
   localidad varchar(50),
   cp int,
   partido varchar(50),
   provincia text,
   estado varchar(255),
   idestado int,
   motivo varchar(255),
   fechasolicitud date
);

create table  subs_cuotas as
select * from dblink ('dbname=dbrenatre host=192.168.1.2 port=5435 user=postgres','
select
   nroexpediente,
   nrocuota,
   max(monto) as monto,
   (case when min(monto) < 0 then min(monto)*-1 else 0 end) as descuento,
   sum(monto) as apagar,
   max(fecha) as fecha,
   (case
       when min(estadocuota) in (1,6,8) then ''A pagar''
       when min(estadocuota) in (5,7) then ''Pagada''
       when min(estadocuota) in (2) then ''Enviada al banco''
       else (select descripcion from subs_estados_cuotas where
codigo=min(estadocuota))
   end) as estado,
   min(estadocuota) as idestado
from
   subs_cuotas
group by
   nrocuota,
   nroexpediente')
as subs_cuotas(
   nroexpediente bigint,
   nrocuota int,
   monto real,
   descuento real,
   apagar real,
   fecha date,
   estado varchar(255),
   idestado int
);
commit;
