--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: tmp; Type: SCHEMA; Schema: -; Owner: reingart
--

CREATE SCHEMA tmp;


ALTER SCHEMA tmp OWNER TO reingart;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: carg_list_ubic; Type: TABLE; Schema: public; Owner: reingart; Tablespace: 
--

CREATE TABLE carg_list_ubic (
    id integer NOT NULL,
    id_ubicacion integer,
    id_cargo integer,
    id_lista integer
);


ALTER TABLE public.carg_list_ubic OWNER TO reingart;

--
-- Name: carg_list_ubic_id_seq; Type: SEQUENCE; Schema: public; Owner: reingart
--

CREATE SEQUENCE carg_list_ubic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.carg_list_ubic_id_seq OWNER TO reingart;

--
-- Name: carg_list_ubic_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reingart
--

ALTER SEQUENCE carg_list_ubic_id_seq OWNED BY carg_list_ubic.id;


--
-- Name: cargos; Type: TABLE; Schema: public; Owner: reingart; Tablespace: 
--

CREATE TABLE cargos (
    id_cargo integer NOT NULL,
    descripcion character varying(50),
    idx_col integer,
    descripcion_corta character varying(16)
);


ALTER TABLE public.cargos OWNER TO reingart;

--
-- Name: cargos_id_cargo_seq; Type: SEQUENCE; Schema: public; Owner: reingart
--

CREATE SEQUENCE cargos_id_cargo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cargos_id_cargo_seq OWNER TO reingart;

--
-- Name: cargos_id_cargo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reingart
--

ALTER SEQUENCE cargos_id_cargo_seq OWNED BY cargos.id_cargo;


--
-- Name: dhont; Type: TABLE; Schema: public; Owner: reingart; Tablespace: 
--

CREATE TABLE dhont (
    id integer NOT NULL,
    id_ubicacion integer,
    id_cargo integer,
    piso double precision,
    bancas integer,
    listas_excluidas character varying(30),
    listas_sin_banca character varying(30)
);


ALTER TABLE public.dhont OWNER TO reingart;

--
-- Name: dhont_id_seq; Type: SEQUENCE; Schema: public; Owner: reingart
--

CREATE SEQUENCE dhont_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dhont_id_seq OWNER TO reingart;

--
-- Name: dhont_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reingart
--

ALTER SEQUENCE dhont_id_seq OWNED BY dhont.id;


--
-- Name: faxes; Type: TABLE; Schema: public; Owner: reingart; Tablespace: 
--

CREATE TABLE faxes (
    path character varying(256),
    codigo_provincia integer,
    codigo_departamento integer,
    codigo_circuito character varying,
    codigo_mesa integer,
    id_ubicacion integer
);


ALTER TABLE public.faxes OWNER TO reingart;

--
-- Name: listas; Type: TABLE; Schema: public; Owner: reingart; Tablespace: 
--

CREATE TABLE listas (
    id_lista integer NOT NULL,
    descripcion character varying(80),
    idx_fila integer,
    positivo character(1),
    color character varying(19),
    descripcion_corta character varying(25),
    descripcion_grafico character varying(16),
    nro_lista character varying(10),
    id_partido integer
);


ALTER TABLE public.listas OWNER TO reingart;

--
-- Name: listas_id_lista_seq; Type: SEQUENCE; Schema: public; Owner: reingart
--

CREATE SEQUENCE listas_id_lista_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.listas_id_lista_seq OWNER TO reingart;

--
-- Name: listas_id_lista_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reingart
--

ALTER SEQUENCE listas_id_lista_seq OWNED BY listas.id_lista;


--
-- Name: no_cargo_ubicacion; Type: TABLE; Schema: public; Owner: reingart; Tablespace: 
--

CREATE TABLE no_cargo_ubicacion (
    id integer NOT NULL,
    id_ubicacion character varying(12),
    id_cargo character varying(3)
);


ALTER TABLE public.no_cargo_ubicacion OWNER TO reingart;

--
-- Name: no_cargo_ubicacion_id_seq; Type: SEQUENCE; Schema: public; Owner: reingart
--

CREATE SEQUENCE no_cargo_ubicacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.no_cargo_ubicacion_id_seq OWNER TO reingart;

--
-- Name: no_cargo_ubicacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reingart
--

ALTER SEQUENCE no_cargo_ubicacion_id_seq OWNED BY no_cargo_ubicacion.id;


--
-- Name: partidos; Type: TABLE; Schema: public; Owner: reingart; Tablespace: 
--

CREATE TABLE partidos (
    id_partido integer NOT NULL,
    nro_partido character varying(10),
    descripcion character varying(80)
);


ALTER TABLE public.partidos OWNER TO reingart;

--
-- Name: partidos_id_partido_seq; Type: SEQUENCE; Schema: public; Owner: reingart
--

CREATE SEQUENCE partidos_id_partido_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partidos_id_partido_seq OWNER TO reingart;

--
-- Name: partidos_id_partido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reingart
--

ALTER SEQUENCE partidos_id_partido_seq OWNED BY partidos.id_partido;


--
-- Name: planillas; Type: TABLE; Schema: public; Owner: reingart; Tablespace: 
--

CREATE TABLE planillas (
    id_ubicacion integer,
    id_planilla integer NOT NULL,
    id_estado character varying(512),
    definitivo character(1),
    ciudadanos_sufragaron integer
);


ALTER TABLE public.planillas OWNER TO reingart;

--
-- Name: planillas_det; Type: TABLE; Schema: public; Owner: reingart; Tablespace: 
--

CREATE TABLE planillas_det (
    id integer NOT NULL,
    id_planilla integer,
    id_cargo integer,
    id_lista integer,
    votos1 integer,
    votos2 integer,
    votos_definitivos integer
);


ALTER TABLE public.planillas_det OWNER TO reingart;

--
-- Name: planillas_det_id_seq; Type: SEQUENCE; Schema: public; Owner: reingart
--

CREATE SEQUENCE planillas_det_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.planillas_det_id_seq OWNER TO reingart;

--
-- Name: planillas_det_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reingart
--

ALTER SEQUENCE planillas_det_id_seq OWNED BY planillas_det.id;


--
-- Name: planillas_id_planilla_seq; Type: SEQUENCE; Schema: public; Owner: reingart
--

CREATE SEQUENCE planillas_id_planilla_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.planillas_id_planilla_seq OWNER TO reingart;

--
-- Name: planillas_id_planilla_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reingart
--

ALTER SEQUENCE planillas_id_planilla_seq OWNED BY planillas.id_planilla;


--
-- Name: telegramas; Type: TABLE; Schema: public; Owner: reingart; Tablespace: 
--

CREATE TABLE telegramas (
    id integer NOT NULL,
    id_planilla integer,
    estado character varying(512),
    id_reconocido character varying(5),
    observaciones text,
    imagen bytea,
    ts timestamp without time zone,
    path character varying(256)
);


ALTER TABLE public.telegramas OWNER TO reingart;

--
-- Name: telegramas_id_seq; Type: SEQUENCE; Schema: public; Owner: reingart
--

CREATE SEQUENCE telegramas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.telegramas_id_seq OWNER TO reingart;

--
-- Name: telegramas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reingart
--

ALTER SEQUENCE telegramas_id_seq OWNED BY telegramas.id;


--
-- Name: tmp_datos_publicos; Type: TABLE; Schema: public; Owner: reingart; Tablespace: 
--

CREATE TABLE tmp_datos_publicos (
    id integer NOT NULL,
    anio integer,
    eleccion text,
    provinciaid integer,
    provincia text,
    departamentoid integer,
    departamento text,
    partidoid integer,
    partido text,
    votos integer,
    nro_lista text
);


ALTER TABLE public.tmp_datos_publicos OWNER TO reingart;

--
-- Name: tmp_datos_publicos_id_seq; Type: SEQUENCE; Schema: public; Owner: reingart
--

CREATE SEQUENCE tmp_datos_publicos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmp_datos_publicos_id_seq OWNER TO reingart;

--
-- Name: tmp_datos_publicos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reingart
--

ALTER SEQUENCE tmp_datos_publicos_id_seq OWNED BY tmp_datos_publicos.id;


--
-- Name: ubicaciones; Type: TABLE; Schema: public; Owner: reingart; Tablespace: 
--

CREATE TABLE ubicaciones (
    id_ubicacion integer NOT NULL,
    id_ubicacion_padre integer,
    clase character varying(30),
    descripcion character varying(100),
    sexo character varying(512)
);


ALTER TABLE public.ubicaciones OWNER TO reingart;

--
-- Name: ubicaciones_id_ubicacion_seq; Type: SEQUENCE; Schema: public; Owner: reingart
--

CREATE SEQUENCE ubicaciones_id_ubicacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ubicaciones_id_ubicacion_seq OWNER TO reingart;

--
-- Name: ubicaciones_id_ubicacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: reingart
--

ALTER SEQUENCE ubicaciones_id_ubicacion_seq OWNED BY ubicaciones.id_ubicacion;


SET search_path = public, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY carg_list_ubic ALTER COLUMN id SET DEFAULT nextval('carg_list_ubic_id_seq'::regclass);


--
-- Name: id_cargo; Type: DEFAULT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY cargos ALTER COLUMN id_cargo SET DEFAULT nextval('cargos_id_cargo_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY dhont ALTER COLUMN id SET DEFAULT nextval('dhont_id_seq'::regclass);


--
-- Name: id_lista; Type: DEFAULT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY listas ALTER COLUMN id_lista SET DEFAULT nextval('listas_id_lista_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY no_cargo_ubicacion ALTER COLUMN id SET DEFAULT nextval('no_cargo_ubicacion_id_seq'::regclass);


--
-- Name: id_partido; Type: DEFAULT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY partidos ALTER COLUMN id_partido SET DEFAULT nextval('partidos_id_partido_seq'::regclass);


--
-- Name: id_planilla; Type: DEFAULT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY planillas ALTER COLUMN id_planilla SET DEFAULT nextval('planillas_id_planilla_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY planillas_det ALTER COLUMN id SET DEFAULT nextval('planillas_det_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY telegramas ALTER COLUMN id SET DEFAULT nextval('telegramas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY tmp_datos_publicos ALTER COLUMN id SET DEFAULT nextval('tmp_datos_publicos_id_seq'::regclass);


--
-- Name: id_ubicacion; Type: DEFAULT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY ubicaciones ALTER COLUMN id_ubicacion SET DEFAULT nextval('ubicaciones_id_ubicacion_seq'::regclass);


--
-- Name: carg_list_ubic_pkey; Type: CONSTRAINT; Schema: public; Owner: reingart; Tablespace: 
--

ALTER TABLE ONLY carg_list_ubic
    ADD CONSTRAINT carg_list_ubic_pkey PRIMARY KEY (id);


--
-- Name: cargos_pkey; Type: CONSTRAINT; Schema: public; Owner: reingart; Tablespace: 
--

ALTER TABLE ONLY cargos
    ADD CONSTRAINT cargos_pkey PRIMARY KEY (id_cargo);


--
-- Name: dhont_pkey; Type: CONSTRAINT; Schema: public; Owner: reingart; Tablespace: 
--

ALTER TABLE ONLY dhont
    ADD CONSTRAINT dhont_pkey PRIMARY KEY (id);


--
-- Name: listas_idx_fila_key; Type: CONSTRAINT; Schema: public; Owner: reingart; Tablespace: 
--

ALTER TABLE ONLY listas
    ADD CONSTRAINT listas_idx_fila_key UNIQUE (idx_fila);


--
-- Name: listas_pkey; Type: CONSTRAINT; Schema: public; Owner: reingart; Tablespace: 
--

ALTER TABLE ONLY listas
    ADD CONSTRAINT listas_pkey PRIMARY KEY (id_lista);


--
-- Name: no_cargo_ubicacion_pkey; Type: CONSTRAINT; Schema: public; Owner: reingart; Tablespace: 
--

ALTER TABLE ONLY no_cargo_ubicacion
    ADD CONSTRAINT no_cargo_ubicacion_pkey PRIMARY KEY (id);


--
-- Name: partidos_pkey; Type: CONSTRAINT; Schema: public; Owner: reingart; Tablespace: 
--

ALTER TABLE ONLY partidos
    ADD CONSTRAINT partidos_pkey PRIMARY KEY (id_partido);


--
-- Name: planillas_det_pkey; Type: CONSTRAINT; Schema: public; Owner: reingart; Tablespace: 
--

ALTER TABLE ONLY planillas_det
    ADD CONSTRAINT planillas_det_pkey PRIMARY KEY (id);


--
-- Name: planillas_pkey; Type: CONSTRAINT; Schema: public; Owner: reingart; Tablespace: 
--

ALTER TABLE ONLY planillas
    ADD CONSTRAINT planillas_pkey PRIMARY KEY (id_planilla);


--
-- Name: telegramas_pkey; Type: CONSTRAINT; Schema: public; Owner: reingart; Tablespace: 
--

ALTER TABLE ONLY telegramas
    ADD CONSTRAINT telegramas_pkey PRIMARY KEY (id);


--
-- Name: ubicaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: reingart; Tablespace: 
--

ALTER TABLE ONLY ubicaciones
    ADD CONSTRAINT ubicaciones_pkey PRIMARY KEY (id_ubicacion);


SET search_path = public, pg_catalog;

--
-- Name: planillas_det_id_cargo; Type: INDEX; Schema: public; Owner: reingart; Tablespace: 
--

CREATE INDEX planillas_det_id_cargo ON planillas_det USING btree (id_cargo);


--
-- Name: carg_list_ubic_id_cargo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY carg_list_ubic
    ADD CONSTRAINT carg_list_ubic_id_cargo_fkey FOREIGN KEY (id_cargo) REFERENCES cargos(id_cargo) ON DELETE CASCADE;


--
-- Name: carg_list_ubic_id_lista_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY carg_list_ubic
    ADD CONSTRAINT carg_list_ubic_id_lista_fkey FOREIGN KEY (id_lista) REFERENCES listas(id_lista) ON DELETE CASCADE;


--
-- Name: carg_list_ubic_id_ubicacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY carg_list_ubic
    ADD CONSTRAINT carg_list_ubic_id_ubicacion_fkey FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion) ON DELETE CASCADE;


--
-- Name: dhont_id_cargo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY dhont
    ADD CONSTRAINT dhont_id_cargo_fkey FOREIGN KEY (id_cargo) REFERENCES cargos(id_cargo) ON DELETE CASCADE;


--
-- Name: dhont_id_ubicacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY dhont
    ADD CONSTRAINT dhont_id_ubicacion_fkey FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion) ON DELETE CASCADE;


--
-- Name: listas_id_partido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY listas
    ADD CONSTRAINT listas_id_partido_fkey FOREIGN KEY (id_partido) REFERENCES partidos(id_partido) ON DELETE CASCADE;


--
-- Name: planillas_det_id_cargo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY planillas_det
    ADD CONSTRAINT planillas_det_id_cargo_fkey FOREIGN KEY (id_cargo) REFERENCES cargos(id_cargo) ON DELETE CASCADE;


--
-- Name: planillas_det_id_lista_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY planillas_det
    ADD CONSTRAINT planillas_det_id_lista_fkey FOREIGN KEY (id_lista) REFERENCES listas(id_lista) ON DELETE CASCADE;


--
-- Name: planillas_det_id_planilla_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY planillas_det
    ADD CONSTRAINT planillas_det_id_planilla_fkey FOREIGN KEY (id_planilla) REFERENCES planillas(id_planilla) ON DELETE CASCADE;


--
-- Name: planillas_id_ubicacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY planillas
    ADD CONSTRAINT planillas_id_ubicacion_fkey FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion) ON DELETE CASCADE;


--
-- Name: telegramas_id_planilla_fkey; Type: FK CONSTRAINT; Schema: public; Owner: reingart
--

ALTER TABLE ONLY telegramas
    ADD CONSTRAINT telegramas_id_planilla_fkey FOREIGN KEY (id_planilla) REFERENCES planillas(id_planilla) ON DELETE CASCADE;



--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

