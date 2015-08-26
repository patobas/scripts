/*
Determinativa --> declaraciones y rectificativas
         | 1
         V
    (d.cuit=n.cuitcont and d.periodo=n.periodo)  
         |
         V n
Nominativa    --> detalle de los pagos
*/


/*************************************************************
 ******************   REGISTROS DUPLICADOS   *****************
 *************************************************************/
--registros que no son rectificativas y estan ya insertados:
--Inserta los registros en determinativas-duplicadas-error y nominativas-duplicadas-error
\timing
set default_tablespace='tmp';

select * into determinativa_inicial_tmp_duplicadas
    from determinativa_inicial di
    where
        exists (
            select 1 from determinativa d
            where di.cuit=d.cuit and
            di.periodo=d.periodo and
            di.secoblig=d.secoblig and
            di.codrect=d.codrect
        );
--SELECT
--Time: 155682.252 ms

create index inx_determinativa_inicial_tmp_duplicadas_cp
    on determinativa_inicial_tmp_duplicadas
    using btree(cuit,periodo);

insert into determinativa_error_duplicadas ( select * from determinativa_inicial_tmp_duplicadas);

insert into nominativa_error_duplicadas (
    select * from nominativa_inicial ni
    where exists (
        select 1 from determinativa_inicial_tmp_duplicadas dd
        where dd.cuit=ni.cuitcont and
        dd.periodo=ni.periodo and
        dd.secoblig=ni.secoblig and
        dd.codrect=ni.codrect
        )
    );

--TODO: Si el numero de secoblig coincide con el de determinativa inserta en determinativa-duplicadas-error y nominativas-duplicadas-error
--TODO: checkeo de mierda "interna" al CD
--TODO: checkeo de mierda "novedosa" y "original" que a nuestros amigos les guste mandar



/*************************************************************
 ****************   DETERMINATIVAS NUEVAS   ******************
 *************************************************************/
--Para los registros que no son rectificativas y no estan ya insertados:
----inserta los registros en nominativas y determinativas
select * into determinativa_inicial_tmp_nuevas
    from determinativa_inicial di
    where
        not codrect and
        not exists (
            select 1 from determinativa d
            where di.cuit=d.cuit and
            di.periodo=d.periodo
        );
--SELECT
--Time: 33485.358 ms

create index inx_determinativa_inicial_tmp_nuevas_cp
    on determinativa_inicial_tmp_nuevas
    using btree(cuit,periodo);
--CREATE INDEX
--Time: 833.891 ms

insert into determinativa (select * from determinativa_inicial_tmp_nuevas);
--INSERT 0 101864
--Time: 1163013.865 ms

insert into nominativa (
    select * from nominativa_inicial ni
    where exists (
        select 1 from determinativa_inicial_tmp_nuevas dn
        where dn.cuit=ni.cuitcont and
        dn.periodo=ni.periodo and
        dn.secoblig=ni.secoblig and
        dn.codrect=ni.codrect
        )
    );

--INSERT 0 1399206
--Time: 1035022.040 ms

/*************************************************************
 ****************   RECTIFICATIVAS NUEVAS   ******************
 *************************************************************/

--Aparta las que se van a insertar en determinativas

--TODO: las q son iguales???

select * into determinativa_inicial_tmp_rect
    from determinativa_inicial di
    where
        codrect and
        not exists (
            select 1 from determinativa d
            where di.cuit=d.cuit and
            di.periodo=d.periodo and
            d.codrect and
            d.secoblig > di.secoblig
        )
        and di.secoblig= (
            select max(di2.secoblig)
            from determinativa_inicial di2
                where di.cuit=di2.cuit and
                di.periodo=di2.periodo
        )
    ;

/*
select * into determinativa_inicial_tmp_rect_max_secoblig
    from determinativa_inicial di
    where
        codrect and 
	secoblig=(select max(secoblig) from determinativa_inicial where cuit=di.cuit and periodo=di.periodo);
*/

-- SELECT
-- Time: 81693.501 ms


create index inx_determinativa_inicial_tmp_rect_cp
    on determinativa_inicial_tmp_rect
    using btree(cuit,periodo);

-- CREATE INDEX
-- Time: 720.397 ms

--mueve las que estan a historico
insert into determinativa_his (
    select * from determinativa d
        where exists (
            select 1 from determinativa_inicial_tmp_rect dr
            where dr.cuit=d.cuit and
            dr.periodo=d.periodo
        )
    );

-- INSERT 0 18935
-- Time: 129984.823 ms

delete from determinativa
    where exists (
        select 1 from determinativa_inicial_tmp_rect dr
        where dr.cuit=determinativa.cuit and
        dr.periodo=determinativa.periodo
    );

--DELETE 18935
--Time: 97691.200 ms

insert into nominativa_his (
    select *  from nominativa n
        where exists (
            select 1 from determinativa_inicial_tmp_rect dr
            where dr.cuit=n.cuitcont and
            dr.periodo=n.periodo
        )
    );

--INSERT 0 1202072
--Time: 905084.662 ms

delete from nominativa
    where exists (
        select 1 from determinativa_inicial_tmp_rect dr
        where dr.cuit=nominativa.cuitcont and
        dr.periodo=nominativa.periodo
    );

--DELETE 1202072
--Time: 785092.958 ms

--Inserta las nuevas

insert into determinativa (select * from determinativa_inicial_tmp_rect);

-- INSERT 0 20497
-- Time: 186706.084 ms

insert into nominativa (
    select * from nominativa_inicial ni
    where exists (
        select 1 from determinativa_inicial_tmp_rect dr
        where dr.cuit=ni.cuitcont and
        dr.periodo=ni.periodo and
        dr.secoblig=ni.secoblig and
        ni.codrect
        )
    );

--INSERT 0 1435440
--Time: 231669.999 ms

/*************************************************************
 ********   DECLARATIVAS Y  RECTIFICATIVAS VIEJAS   **********
 *************************************************************/

--inserta el resto directo al historico

insert into determinativa_his (
    select * from determinativa_inicial di
    where
        (   codrect and
            not exists (
                select 1 from determinativa_inicial_tmp_rect dr
                --select 1 from determinativa_inicial_tmp_rect_max_secoblig dr
                where dr.cuit=di.cuit and
                dr.periodo=di.periodo and
                dr.secoblig=di.secoblig
            )
        ) or
        (
            not codrect and
            not exists (
                select 1 from determinativa_inicial_tmp_nuevas dn
                where dn.cuit=di.cuit and
                dn.periodo=di.periodo and
                dn.secoblig=di.secoblig
            ) and
            not exists (
                select 1 from determinativa_inicial_tmp_duplicadas dd
                where dd.cuit=di.cuit and
                dd.periodo=di.periodo and
                dd.secoblig=di.secoblig
            )
        )
    );

--INSERT 0 0
--Time: 6880.875 ms

insert into nominativa_his
   (
    select * from nominativa_inicial ni
    where
        not exists (
                select 1 from determinativa_inicial_tmp_rect dr
                where dr.cuit=ni.cuitcont and
                dr.periodo=ni.periodo and
                dr.secoblig=ni.secoblig and
                ni.codrect
        )
        and not exists (
                select 1 from determinativa_inicial_tmp_nuevas dn
                where dn.cuit=ni.cuitcont and
                dn.periodo=ni.periodo and
                dn.secoblig=ni.secoblig and
                not ni.codrect
        )
        and not exists (
                select 1 from determinativa_inicial_tmp_duplicadas dd
                where dd.cuit=ni.cuitcont and
                dd.periodo=ni.periodo and
                dd.secoblig=ni.secoblig and
                not ni.codrect
            )
      );
   
--iNSERT 0 0
--Time: 52634.695 ms

/*************************************************************
 ******************   BORRADO DE TABLAS   ********************
 *************************************************************/

--borra la tabla temporal de seleccion
drop table determinativa_inicial_tmp_nuevas;
drop table determinativa_inicial_tmp_rect;
drop table determinativa_inicial_tmp_duplicadas;

--Borra las tablas iniciales.
drop table determinativa_inicial;
drop table nominativa_inicial;
--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

--SET SESSION AUTHORIZATION 'dbmaster';

SET search_path = public, pg_catalog;

DROP INDEX public.deter_ini_index_nro;
DROP INDEX public.deter_ini_index_cuit;
DROP TABLE public.determinativa_inicial;
--
-- TOC entry 3 (OID 285512397)
-- Name: determinativa_inicial; Type: TABLE; Schema: public; Owner: dbmaster
--

CREATE TABLE determinativa_inicial (
    cuit bigint NOT NULL,
    periodo integer NOT NULL,
    numoble character(12) NOT NULL,
    secoblig numeric(3,0) NOT NULL,
    banco character(3) NOT NULL,
    codsuc character(3) NOT NULL,
    fecpres date NOT NULL,
    codrect boolean NOT NULL,
    excconss numeric(15,2) NOT NULL,
    excoscon numeric(15,2) NOT NULL,
    asigfam numeric(15,2) NOT NULL,
    asigcomp numeric(15,2) NOT NULL,
    totapss numeric(15,2) NOT NULL,
    sigconss character(1) NOT NULL,
    totconss numeric(15,2) NOT NULL,
    totosap numeric(15,2) NOT NULL,
    sigoscon character(1) NOT NULL,
    totoscon numeric(15,2) NOT NULL,
    pertemp character(1) NOT NULL,
    conanses numeric(15,2) NOT NULL,
    conpami numeric(15,2) NOT NULL,
    confemp numeric(15,2) NOT NULL,
    bruconss numeric(15,2) NOT NULL,
    retconss numeric(15,2) NOT NULL,
    retoscon numeric(15,2) NOT NULL,
    versi character(2) NOT NULL,
    conrenatre numeric(15,2) NOT NULL,
    fecproc date NOT NULL,
    totaporena numeric(15,2),
    nroorden integer NOT NULL,
    nrolinea bigint NOT NULL
);


--
-- TOC entry 4 (OID 285512411)
-- Name: deter_ini_index_cuit; Type: INDEX; Schema: public; Owner: dbmaster
--

CREATE INDEX deter_ini_index_cuit ON determinativa_inicial USING btree (cuit, periodo);


--
-- TOC entry 5 (OID 285512413)
-- Name: deter_ini_index_nro; Type: INDEX; Schema: public; Owner: dbmaster
--

CREATE UNIQUE INDEX deter_ini_index_nro ON determinativa_inicial USING btree (nroorden, nrolinea);


--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

--SET SESSION AUTHORIZATION 'dbmaster';

SET search_path = public, pg_catalog;

DROP INDEX public.nomi_cuit_index;
DROP TABLE public.nominativa_inicial;
--
-- TOC entry 3 (OID 285512399)
-- Name: nominativa_inicial; Type: TABLE; Schema: public; Owner: dbmaster
--

CREATE TABLE nominativa_inicial (
    cuitcont bigint NOT NULL,
    periodo integer NOT NULL,
    numoble character(12),
    secoblig numeric(3,0) NOT NULL,
    codrect boolean NOT NULL,
    fecpres date NOT NULL,
    cuitapo bigint NOT NULL,
    codosoc numeric(6,0),
    grpfam numeric(2,0),
    nogrpfam numeric(2,0),
    modcont numeric(5,2) NOT NULL,
    zona character(2) NOT NULL,
    actividades integer NOT NULL,
    --actividades integer NOT NULL,
    remimpo numeric(8,2) NOT NULL,
    fecproc date NOT NULL,
    sitcuil numeric(2,0) NOT NULL,
    condcuil numeric(2,0) NOT NULL,
    versi character(2),
    codsini character(2),
    nroorden integer NOT NULL,
    nrolinea bigint NOT NULL,
    banco character varying(3),
    porcredu numeric(4,2),
    sac numeric(8,2),
    extras numeric(8,2),
    zonades numeric(8,2),
    vacaciones numeric(8,2),
    laborables integer,
    nrohe integer,
    aporena numeric(13,2)
) WITHOUT OIDS;

create or replace function null_a_99() returns "trigger" as '
begin
if NEW.actividades=\'  \' then NEW.actividades:=\'99\'; end if;
return NEW;
end '
language 'plpgsql' volatile;


--create trigger trg_null_a_99 before insert on nominativa_inicial for each row execute procedure null_a_99();



--
-- TOC entry 4 (OID 285512414)
-- Name: nomi_cuit_index; Type: INDEX; Schema: public; Owner: dbmaster
--

CREATE INDEX nomi_cuit_index ON nominativa_inicial USING btree (cuitcont);


