set default_tablespace = 'tmp';
drop table cuit_domicilio;
select
    (case when pd.cuit is null then p.cuit else pd.cuit end) as cuit,
    (case when pd.cuit is null then p.calle else pd.calle end) as calle,
    (case when pd.cuit is null then p.numero else pd.numero end) as numero,
    (case when pd.cuit is null then p.piso else pd.piso end) as piso,
    (case when pd.cuit is null then p.depto else pd.depto end) as depto,
    (case when pd.cuit is null then p.localid else pd.localid end) as loc,
    (case when pd.cuit is null then p.cpostal else pd.cpostal end) as cpostal,
    (case when pd.cuit is null then p.pcia else pd.pcia end) as prov,
    (select nombre from provincias where id=(case when pd.cuit is null then p.pcia else pd.pcia end)::int) as prov_str,
    (case when pd.cuit is null then 2 else 1 end) as fuente
    into cuit_domicilio  
from 
    padron_domicilios pd full outer join padron p on pd.cuit=p.cuit;
create index inx_cuit_domicilio_cuit on cuit_domicilio using btree (cuit);
