--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3 (Debian 16.3-1.pgdg120+1)
-- Dumped by pg_dump version 16.3 (Debian 16.3-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO mlflow_user;

--
-- Name: datasets; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.datasets (
    dataset_uuid character varying(36) NOT NULL,
    experiment_id integer NOT NULL,
    name character varying(500) NOT NULL,
    digest character varying(36) NOT NULL,
    dataset_source_type character varying(36) NOT NULL,
    dataset_source text NOT NULL,
    dataset_schema text,
    dataset_profile text
);


ALTER TABLE public.datasets OWNER TO mlflow_user;

--
-- Name: experiment_tags; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.experiment_tags (
    key character varying(250) NOT NULL,
    value character varying(5000),
    experiment_id integer NOT NULL
);


ALTER TABLE public.experiment_tags OWNER TO mlflow_user;

--
-- Name: experiments; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.experiments (
    experiment_id integer NOT NULL,
    name character varying(256) NOT NULL,
    artifact_location character varying(256),
    lifecycle_stage character varying(32),
    creation_time bigint,
    last_update_time bigint,
    CONSTRAINT experiments_lifecycle_stage CHECK (((lifecycle_stage)::text = ANY ((ARRAY['active'::character varying, 'deleted'::character varying])::text[])))
);


ALTER TABLE public.experiments OWNER TO mlflow_user;

--
-- Name: experiments_experiment_id_seq; Type: SEQUENCE; Schema: public; Owner: mlflow_user
--

CREATE SEQUENCE public.experiments_experiment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.experiments_experiment_id_seq OWNER TO mlflow_user;

--
-- Name: experiments_experiment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mlflow_user
--

ALTER SEQUENCE public.experiments_experiment_id_seq OWNED BY public.experiments.experiment_id;


--
-- Name: input_tags; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.input_tags (
    input_uuid character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(500) NOT NULL
);


ALTER TABLE public.input_tags OWNER TO mlflow_user;

--
-- Name: inputs; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.inputs (
    input_uuid character varying(36) NOT NULL,
    source_type character varying(36) NOT NULL,
    source_id character varying(36) NOT NULL,
    destination_type character varying(36) NOT NULL,
    destination_id character varying(36) NOT NULL
);


ALTER TABLE public.inputs OWNER TO mlflow_user;

--
-- Name: latest_metrics; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.latest_metrics (
    key character varying(250) NOT NULL,
    value double precision NOT NULL,
    "timestamp" bigint,
    step bigint NOT NULL,
    is_nan boolean NOT NULL,
    run_uuid character varying(32) NOT NULL
);


ALTER TABLE public.latest_metrics OWNER TO mlflow_user;

--
-- Name: metrics; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.metrics (
    key character varying(250) NOT NULL,
    value double precision NOT NULL,
    "timestamp" bigint NOT NULL,
    run_uuid character varying(32) NOT NULL,
    step bigint DEFAULT '0'::bigint NOT NULL,
    is_nan boolean DEFAULT false NOT NULL
);


ALTER TABLE public.metrics OWNER TO mlflow_user;

--
-- Name: model_version_tags; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.model_version_tags (
    key character varying(250) NOT NULL,
    value character varying(5000),
    name character varying(256) NOT NULL,
    version integer NOT NULL
);


ALTER TABLE public.model_version_tags OWNER TO mlflow_user;

--
-- Name: model_versions; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.model_versions (
    name character varying(256) NOT NULL,
    version integer NOT NULL,
    creation_time bigint,
    last_updated_time bigint,
    description character varying(5000),
    user_id character varying(256),
    current_stage character varying(20),
    source character varying(500),
    run_id character varying(32),
    status character varying(20),
    status_message character varying(500),
    run_link character varying(500),
    storage_location character varying(500)
);


ALTER TABLE public.model_versions OWNER TO mlflow_user;

--
-- Name: params; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.params (
    key character varying(250) NOT NULL,
    value character varying(8000) NOT NULL,
    run_uuid character varying(32) NOT NULL
);


ALTER TABLE public.params OWNER TO mlflow_user;

--
-- Name: registered_model_aliases; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.registered_model_aliases (
    alias character varying(256) NOT NULL,
    version integer NOT NULL,
    name character varying(256) NOT NULL
);


ALTER TABLE public.registered_model_aliases OWNER TO mlflow_user;

--
-- Name: registered_model_tags; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.registered_model_tags (
    key character varying(250) NOT NULL,
    value character varying(5000),
    name character varying(256) NOT NULL
);


ALTER TABLE public.registered_model_tags OWNER TO mlflow_user;

--
-- Name: registered_models; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.registered_models (
    name character varying(256) NOT NULL,
    creation_time bigint,
    last_updated_time bigint,
    description character varying(5000)
);


ALTER TABLE public.registered_models OWNER TO mlflow_user;

--
-- Name: runs; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.runs (
    run_uuid character varying(32) NOT NULL,
    name character varying(250),
    source_type character varying(20),
    source_name character varying(500),
    entry_point_name character varying(50),
    user_id character varying(256),
    status character varying(9),
    start_time bigint,
    end_time bigint,
    source_version character varying(50),
    lifecycle_stage character varying(20),
    artifact_uri character varying(200),
    experiment_id integer,
    deleted_time bigint,
    CONSTRAINT runs_lifecycle_stage CHECK (((lifecycle_stage)::text = ANY ((ARRAY['active'::character varying, 'deleted'::character varying])::text[]))),
    CONSTRAINT runs_status_check CHECK (((status)::text = ANY ((ARRAY['SCHEDULED'::character varying, 'FAILED'::character varying, 'FINISHED'::character varying, 'RUNNING'::character varying, 'KILLED'::character varying])::text[]))),
    CONSTRAINT source_type CHECK (((source_type)::text = ANY ((ARRAY['NOTEBOOK'::character varying, 'JOB'::character varying, 'LOCAL'::character varying, 'UNKNOWN'::character varying, 'PROJECT'::character varying])::text[])))
);


ALTER TABLE public.runs OWNER TO mlflow_user;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: mlflow_user
--

CREATE TABLE public.tags (
    key character varying(250) NOT NULL,
    value character varying(5000),
    run_uuid character varying(32) NOT NULL
);


ALTER TABLE public.tags OWNER TO mlflow_user;

--
-- Name: experiments experiment_id; Type: DEFAULT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.experiments ALTER COLUMN experiment_id SET DEFAULT nextval('public.experiments_experiment_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.alembic_version (version_num) FROM stdin;
acf3f17fdcc7
\.


--
-- Data for Name: datasets; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.datasets (dataset_uuid, experiment_id, name, digest, dataset_source_type, dataset_source, dataset_schema, dataset_profile) FROM stdin;
\.


--
-- Data for Name: experiment_tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.experiment_tags (key, value, experiment_id) FROM stdin;
\.


--
-- Data for Name: experiments; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.experiments (experiment_id, name, artifact_location, lifecycle_stage, creation_time, last_update_time) FROM stdin;
0	Default	s3://mlflow-storage/0	active	1716223687091	1716223687091
\.


--
-- Data for Name: input_tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.input_tags (input_uuid, name, value) FROM stdin;
\.


--
-- Data for Name: inputs; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.inputs (input_uuid, source_type, source_id, destination_type, destination_id) FROM stdin;
\.


--
-- Data for Name: latest_metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.latest_metrics (key, value, "timestamp", step, is_nan, run_uuid) FROM stdin;
SMI - Power Draw	15.11	1716223904014	0	f	de35cf1dcafb466d83a5fec08b4700d5
SMI - Timestamp	1716223904	1716223904014	0	f	de35cf1dcafb466d83a5fec08b4700d5
SMI - GPU Util	0	1716223904014	0	f	de35cf1dcafb466d83a5fec08b4700d5
SMI - Mem Util	0	1716223904014	0	f	de35cf1dcafb466d83a5fec08b4700d5
SMI - Mem Used	0	1716223904014	0	f	de35cf1dcafb466d83a5fec08b4700d5
SMI - Performance State	0	1716223904014	0	f	de35cf1dcafb466d83a5fec08b4700d5
TOP - Memory Usage GB	2.1182	1716226590257	0	f	de35cf1dcafb466d83a5fec08b4700d5
TOP - Memory Utilization	9.6	1716226590257	0	f	de35cf1dcafb466d83a5fec08b4700d5
TOP - Swap Memory GB	0.0008	1716226590277	0	f	de35cf1dcafb466d83a5fec08b4700d5
TOP - CPU Utilization	102	1716226590257	0	f	de35cf1dcafb466d83a5fec08b4700d5
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	15.11	1716223904014	de35cf1dcafb466d83a5fec08b4700d5	0	f
SMI - Timestamp	1716223904	1716223904014	de35cf1dcafb466d83a5fec08b4700d5	0	f
SMI - GPU Util	0	1716223904014	de35cf1dcafb466d83a5fec08b4700d5	0	f
SMI - Mem Util	0	1716223904014	de35cf1dcafb466d83a5fec08b4700d5	0	f
SMI - Mem Used	0	1716223904014	de35cf1dcafb466d83a5fec08b4700d5	0	f
SMI - Performance State	0	1716223904014	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	0	1716223904077	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	0	1716223904077	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.2550999999999999	1716223904077	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223904091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	146.7	1716223905079	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.2	1716223905079	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.2550999999999999	1716223905079	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223905095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223906082	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223906082	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.2550999999999999	1716223906082	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223906095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223907084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223907084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4852	1716223907084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223907104	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223908086	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223908086	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4852	1716223908086	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223908107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716223909088	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223909088	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4852	1716223909088	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223909101	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223910090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223910090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4858	1716223910090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223910111	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	105	1716223911091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223911091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4858	1716223911091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223911112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223912093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223912093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4858	1716223912093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223912114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	105	1716223913095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223913095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4841	1716223913095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223913117	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716223914097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223914097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4841	1716223914097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223914110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	105	1716223915099	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223915099	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4841	1716223915099	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223915120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223916101	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	4.4	1716223916101	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4848	1716223916101	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223916122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716223917103	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223917103	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4848	1716223917103	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223917125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716223918105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223918105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4848	1716223918105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223918125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223919121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223920122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223921131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223922134	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223923137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223924139	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223925132	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223926141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0005	1716223927144	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223928140	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223929149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223930153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223931154	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223932154	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223933150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223934159	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223935153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223936162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223937164	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223938166	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223939167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223940170	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223941171	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223942175	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223943168	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223944178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223945179	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223946180	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223947184	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223948185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223949188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223950190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223951192	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223952195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223953188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223954200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223955200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223956204	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223957204	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223958199	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223959207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223960209	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223961211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223962214	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223963217	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223964219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223965219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223966221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223967223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223968218	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223969228	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223970230	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223971230	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223972232	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223973225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223974235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223975237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223976241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223977239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224218677	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224218677	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9228	1716224218677	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224219679	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224219679	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223919107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223919107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4858	1716223919107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	106	1716223920108	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223920108	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4858	1716223920108	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716223921110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223921110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4858	1716223921110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223922113	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223922113	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4874	1716223922113	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223923115	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223923115	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4874	1716223923115	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223924118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223924118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.4874	1716223924118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223925119	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223925119	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.6729	1716223925119	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223926121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223926121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.6729	1716223926121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223927123	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223927123	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.6729	1716223927123	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223928125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223928125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8959000000000001	1716223928125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223929127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223929127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8959000000000001	1716223929127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716223930130	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223930130	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8959000000000001	1716223930130	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223931132	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223931132	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.897	1716223931132	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223932134	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223932134	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.897	1716223932134	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223933136	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223933136	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.897	1716223933136	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223934138	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223934138	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8971	1716223934138	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223935139	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223935139	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8971	1716223935139	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716223936141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223936141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8971	1716223936141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716223937143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223937143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9002000000000001	1716223937143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223938145	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223938145	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9002000000000001	1716223938145	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223939147	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223939147	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9002000000000001	1716223939147	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223940149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223940149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9045999999999998	1716223940149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223941150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223941150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9045999999999998	1716223941150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	105	1716223942152	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223942152	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9045999999999998	1716223942152	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	99	1716223943155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223943155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9055	1716223943155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223944156	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223944156	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9055	1716223944156	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223945159	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223945159	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9055	1716223945159	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	105	1716223946160	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223946160	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8934000000000002	1716223946160	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223947162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223947162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8934000000000002	1716223947162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223948164	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223948164	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8934000000000002	1716223948164	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223949166	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223949166	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8973	1716223949166	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223950169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223950169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8973	1716223950169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223951171	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223951171	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8973	1716223951171	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223952173	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223952173	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8969	1716223952173	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223953175	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223953175	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8969	1716223953175	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223954177	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223954177	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8969	1716223954177	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223955179	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223955179	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8981	1716223955179	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223956181	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223956181	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8981	1716223956181	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223957183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223957183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8981	1716223957183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223958185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223958185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8999000000000001	1716223958185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223959186	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223959186	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8999000000000001	1716223959186	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223960188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223960188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8999000000000001	1716223960188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223961190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223961190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8995	1716223961190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716223962192	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223962192	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8995	1716223962192	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716223963194	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223963194	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8995	1716223963194	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223964195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223964195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8993	1716223964195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223965197	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223965197	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8993	1716223965197	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223966199	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223966199	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8993	1716223966199	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223967201	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223967201	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8991	1716223967201	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223968204	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223968204	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8991	1716223968204	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223969206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223969206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.8991	1716223969206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223970207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223970207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9007	1716223970207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223971209	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223971209	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9007	1716223971209	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223972210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223972210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9007	1716223972210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223973211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716223973211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9028	1716223973211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223974213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223974213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9028	1716223974213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223975215	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223975215	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9028	1716223975215	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223976217	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223976217	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9032	1716223976217	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223977219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223977219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9032	1716223977219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223978221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223978221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9032	1716223978221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223978235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223979223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223979223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9025	1716223979223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223979240	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223980225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223980225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9025	1716223980225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223980245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223981226	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223981226	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9025	1716223981226	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223981247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223982249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223983244	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223984253	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223985255	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223986258	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223987258	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223988254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223989266	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223990264	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223991267	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223992261	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223993270	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223994273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223995274	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223996275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223997278	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223998272	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716223999283	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224000284	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224001287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224002286	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224003281	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224004291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224005292	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224006294	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224007288	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224008298	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224009299	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224010303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224011303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224012306	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224013300	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224014308	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224015311	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224016316	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224017315	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224018311	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224019318	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224020320	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224021322	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224022323	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224023325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224024400	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224025331	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224026331	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224027329	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224028329	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224029337	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224030338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224031342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224032342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224033338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224034348	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224035340	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224036348	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224037344	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224218691	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224219699	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224220703	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224221704	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224222709	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224223703	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224224711	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224225710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223982228	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223982228	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9033	1716223982228	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223983230	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223983230	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9033	1716223983230	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223984232	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223984232	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9033	1716223984232	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223985234	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223985234	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9049	1716223985234	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223986235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223986235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9049	1716223986235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223987237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223987237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9049	1716223987237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223988239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223988239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9059000000000001	1716223988239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716223989241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223989241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9059000000000001	1716223989241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716223990243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223990243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9059000000000001	1716223990243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223991245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223991245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9022999999999999	1716223991245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223992247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223992247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9022999999999999	1716223992247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223993249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223993249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9022999999999999	1716223993249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223994250	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223994250	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9029	1716223994250	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223995252	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223995252	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9029	1716223995252	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223996254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223996254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9029	1716223996254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716223997256	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223997256	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.908	1716223997256	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716223998258	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716223998258	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.908	1716223998258	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716223999260	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716223999260	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.908	1716223999260	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	105	1716224000262	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224000262	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9062999999999999	1716224000262	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224001263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224001263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9062999999999999	1716224001263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224002265	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224002265	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9062999999999999	1716224002265	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224003267	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224003267	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9053	1716224003267	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224004269	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224004269	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9053	1716224004269	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224005271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224005271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9053	1716224005271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224006273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224006273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9062000000000001	1716224006273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224007275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224007275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9062000000000001	1716224007275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224008277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224008277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9062000000000001	1716224008277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224009278	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224009278	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9107	1716224009278	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224010280	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224010280	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9107	1716224010280	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224011282	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224011282	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9107	1716224011282	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224012284	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224012284	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9062999999999999	1716224012284	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224013286	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224013286	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9062999999999999	1716224013286	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224014287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224014287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9062999999999999	1716224014287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224015289	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224015289	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9093	1716224015289	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224016291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224016291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9093	1716224016291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224017293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224017293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9093	1716224017293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224018295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224018295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9109	1716224018295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224019297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224019297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9109	1716224019297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224020299	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224020299	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9109	1716224020299	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224021301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224021301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9107	1716224021301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224022303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224022303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9107	1716224022303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224023304	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224023304	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9107	1716224023304	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224024306	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224024306	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9136	1716224024306	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224025308	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224025308	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9136	1716224025308	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	110	1716224026310	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224026310	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9136	1716224026310	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224027312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224027312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9137	1716224027312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224028313	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224028313	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9137	1716224028313	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224029315	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224029315	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9137	1716224029315	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224030317	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224030317	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9142000000000001	1716224030317	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224031319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224031319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9142000000000001	1716224031319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224032321	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224032321	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9142000000000001	1716224032321	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224033323	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224033323	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9133	1716224033323	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224034325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224034325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9133	1716224034325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224035326	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.7	1716224035326	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9133	1716224035326	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224036328	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716224036328	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9101	1716224036328	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224037330	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	2.6	1716224037330	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9101	1716224037330	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	105	1716224038332	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6000000000000005	1716224038332	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9101	1716224038332	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224038355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224039334	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224039334	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9105	1716224039334	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224039355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224040336	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6000000000000005	1716224040336	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9105	1716224040336	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224040360	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224041338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224041338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9105	1716224041338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224041351	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224042339	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6000000000000005	1716224042339	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9099000000000002	1716224042339	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224042362	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224043341	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224043341	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9099000000000002	1716224043341	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224043356	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224044343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6000000000000005	1716224044343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9099000000000002	1716224044343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224045345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224045345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9098	1716224045345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224046347	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224046347	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9098	1716224046347	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224047349	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6000000000000005	1716224047349	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9098	1716224047349	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224048351	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224048351	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9093	1716224048351	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224049353	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6000000000000005	1716224049353	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9093	1716224049353	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224050355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224050355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9093	1716224050355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224051357	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6000000000000005	1716224051357	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9112	1716224051357	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224052359	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224052359	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9112	1716224052359	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224053361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224053361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9112	1716224053361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224054363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716224054363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9148	1716224054363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224055365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224055365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9148	1716224055365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	109	1716224056366	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716224056366	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9148	1716224056366	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224057368	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224057368	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9142000000000001	1716224057368	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224058370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224058370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9142000000000001	1716224058370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224059371	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224059371	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9142000000000001	1716224059371	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224060373	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224060373	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9167	1716224060373	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224061375	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224061375	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9167	1716224061375	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224062377	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224062377	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9167	1716224062377	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224063379	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224063379	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9138	1716224063379	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	105	1716224064381	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224064381	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9138	1716224064381	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224065383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224044368	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224045361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224046362	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224047372	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224048365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224049374	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224050379	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224051379	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224052372	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224053382	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224054386	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224055386	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224056387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224057390	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224058386	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224059395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224060395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224061399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224062403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224063393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224064402	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224065406	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224066406	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224067400	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224068411	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224069412	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224070414	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224071409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224072418	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224073415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224074428	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224075417	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224076427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224077430	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224078422	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224079431	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224080434	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224081435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224082438	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224083439	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224084444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224085444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224086449	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224087447	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224088444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224089455	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224090453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224091453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224092456	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224093453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224094459	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224095461	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224096462	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224097465	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9225999999999999	1716224219679	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224220680	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224220680	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9225999999999999	1716224220680	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224221682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224221682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9225999999999999	1716224221682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224222684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224222684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9241	1716224222684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224223686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224065383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9138	1716224065383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224066385	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224066385	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9147	1716224066385	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224067387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224067387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9147	1716224067387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224068390	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224068390	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9147	1716224068390	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224069391	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224069391	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9181	1716224069391	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224070393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224070393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9181	1716224070393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224071395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224071395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9181	1716224071395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224072397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	4.6	1716224072397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9172	1716224072397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224073399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224073399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9172	1716224073399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224074401	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224074401	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9172	1716224074401	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224075403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224075403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9189	1716224075403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224076405	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224076405	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9189	1716224076405	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224077406	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224077406	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9189	1716224077406	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224078408	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224078408	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9145	1716224078408	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224079410	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224079410	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9145	1716224079410	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224080411	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224080411	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9145	1716224080411	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224081413	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224081413	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9150999999999998	1716224081413	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224082415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224082415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9150999999999998	1716224082415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224083417	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224083417	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9150999999999998	1716224083417	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224084419	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224084419	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9150999999999998	1716224084419	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224085421	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224085421	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9150999999999998	1716224085421	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224086423	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224086423	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9150999999999998	1716224086423	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224087425	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224087425	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9141	1716224087425	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224088427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224088427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9141	1716224088427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224089429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224089429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9141	1716224089429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224090430	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224090430	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9163	1716224090430	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224091432	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224091432	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9163	1716224091432	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224092434	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224092434	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9163	1716224092434	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224093435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224093435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9185999999999999	1716224093435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224094437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224094437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9185999999999999	1716224094437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224095439	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224095439	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9185999999999999	1716224095439	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224096441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224096441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9182000000000001	1716224096441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224097443	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224097443	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9182000000000001	1716224097443	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224098445	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224098445	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9182000000000001	1716224098445	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224098470	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224099447	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224099447	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9176	1716224099447	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224099468	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224100449	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224100449	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9176	1716224100449	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224100470	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224101451	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224101451	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9176	1716224101451	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224101465	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224102453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224102453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9147	1716224102453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224102475	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224103455	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224103455	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9147	1716224103455	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224103469	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224104457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224104457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9147	1716224104457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224104477	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224105458	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224105458	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9161	1716224105458	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224106460	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224106460	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9161	1716224106460	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224107462	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224107462	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9161	1716224107462	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224108464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224108464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9185999999999999	1716224108464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224109466	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224109466	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9185999999999999	1716224109466	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224110468	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224110468	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9185999999999999	1716224110468	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224111470	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224111470	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9193	1716224111470	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	105	1716224112472	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224112472	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9193	1716224112472	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224113474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224113474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9193	1716224113474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224114475	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224114475	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9199000000000002	1716224114475	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224115478	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224115478	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9199000000000002	1716224115478	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224116480	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224116480	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9199000000000002	1716224116480	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224117482	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224117482	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9203	1716224117482	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224118484	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224118484	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9203	1716224118484	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224119486	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224119486	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9203	1716224119486	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224120488	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224120488	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9007	1716224120488	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224121490	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224121490	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9007	1716224121490	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224122492	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224122492	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9007	1716224122492	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224123493	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224123493	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9192	1716224123493	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224124495	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224124495	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9192	1716224124495	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224125497	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224125497	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9192	1716224125497	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224126499	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224126499	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9189	1716224126499	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224105472	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224106485	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224107484	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224108481	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224109483	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224110491	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224111490	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224112493	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224113493	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224114497	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224115502	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224116501	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224117507	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224118498	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224119510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224120504	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224121511	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224122515	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224123508	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224124516	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224125520	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224126520	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224127517	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224128524	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224129526	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224130527	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224131531	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224132531	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224133529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224134527	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224135530	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224136539	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224137546	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224138542	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224139537	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224140540	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224141544	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224142546	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224143547	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224144548	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224145560	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224146562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224147564	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224148560	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224149568	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224150561	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224151567	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224152565	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224153567	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224154575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224155576	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224156578	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224157572	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224223686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9241	1716224223686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224224688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224224688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9241	1716224224688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224225690	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224225690	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.925	1716224225690	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224226691	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224226691	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.925	1716224226691	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	99	1716224227693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224127501	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224127501	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9189	1716224127501	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224128503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224128503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9189	1716224128503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224129505	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224129505	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9179000000000002	1716224129505	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224130506	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224130506	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9179000000000002	1716224130506	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224131508	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224131508	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9179000000000002	1716224131508	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224132510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224132510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9185	1716224132510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224133512	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224133512	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9185	1716224133512	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224134514	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224134514	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9185	1716224134514	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224135516	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224135516	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9214	1716224135516	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224136518	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224136518	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9214	1716224136518	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224137520	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224137520	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9214	1716224137520	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224138522	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224138522	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9212	1716224138522	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224139524	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224139524	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9212	1716224139524	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224140525	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224140525	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9212	1716224140525	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224141528	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224141528	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9165999999999999	1716224141528	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224142529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224142529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9165999999999999	1716224142529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224143531	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224143531	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9165999999999999	1716224143531	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224144534	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224144534	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9177	1716224144534	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224145536	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224145536	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9177	1716224145536	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224146538	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224146538	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9177	1716224146538	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224147540	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224147540	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9182000000000001	1716224147540	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224148542	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224148542	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9182000000000001	1716224148542	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224149544	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224149544	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9182000000000001	1716224149544	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224150546	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224150546	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9197	1716224150546	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224151548	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224151548	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9197	1716224151548	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224152549	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224152549	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9197	1716224152549	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224153551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224153551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9208	1716224153551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224154553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224154553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9208	1716224154553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224155555	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224155555	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9208	1716224155555	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224156557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224156557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9192	1716224156557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224157559	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224157559	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9192	1716224157559	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224158561	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224158561	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9192	1716224158561	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224158577	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224159562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224159562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.92	1716224159562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224159584	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224160564	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224160564	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.92	1716224160564	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224160587	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224161566	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224161566	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.92	1716224161566	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224161589	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224162568	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224162568	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9190999999999998	1716224162568	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224162582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224163570	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224163570	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9190999999999998	1716224163570	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224163592	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224164572	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224164572	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9190999999999998	1716224164572	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224164589	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224165574	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224165574	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9197	1716224165574	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224165596	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224166576	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224166576	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9197	1716224166576	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224166597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224167595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224168602	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224169597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224170607	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224171606	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224172601	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224173603	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224174611	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224175616	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224176618	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224177617	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224178612	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224179621	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224180626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224181625	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224182628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224183623	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224184631	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224185633	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224186634	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224187629	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224188631	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224189640	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224190645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224191646	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224192648	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224193645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224194644	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224195656	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224196654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224197648	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224198651	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224199660	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224200662	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224201664	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224202665	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224203668	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224204676	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224205673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224206675	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224207677	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224208672	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224209682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224210683	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224211687	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224212686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224213681	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224214690	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224215692	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224216695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224226707	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224227715	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224228710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224229719	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224230721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224231722	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224232725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224233719	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224234728	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224235732	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224236734	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224237738	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224238731	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224239741	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224167578	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224167578	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9197	1716224167578	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224168579	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224168579	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9201	1716224168579	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224169581	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224169581	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9201	1716224169581	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224170583	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716224170583	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9201	1716224170583	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224171585	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.800000000000001	1716224171585	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9215	1716224171585	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224172587	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224172587	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9215	1716224172587	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224173589	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224173589	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9215	1716224173589	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224174590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224174590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9225	1716224174590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224175593	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224175593	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9225	1716224175593	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224176595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224176595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9225	1716224176595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224177597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224177597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9209	1716224177597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224178599	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224178599	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9209	1716224178599	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224179601	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224179601	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9209	1716224179601	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224180603	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224180603	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9196	1716224180603	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224181604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224181604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9196	1716224181604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224182606	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224182606	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9196	1716224182606	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224183608	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224183608	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9213	1716224183608	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224184610	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224184610	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9213	1716224184610	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224185612	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224185612	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9213	1716224185612	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224186614	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224186614	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9065	1716224186614	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224187616	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224187616	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9065	1716224187616	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	99	1716224188618	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224188618	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9065	1716224188618	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224189619	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224189619	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9164	1716224189619	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224190622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224190622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9164	1716224190622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224191624	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224191624	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9164	1716224191624	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224192626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224192626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9203	1716224192626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224193628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224193628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9203	1716224193628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224194630	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224194630	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9203	1716224194630	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224195632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.799999999999999	1716224195632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9201	1716224195632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224196633	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224196633	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9201	1716224196633	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224197635	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224197635	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9201	1716224197635	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224198637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224198637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9198	1716224198637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224199639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224199639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9198	1716224199639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224200641	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224200641	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9198	1716224200641	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224201643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224201643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9201	1716224201643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224202645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224202645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9201	1716224202645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224203648	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224203648	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9201	1716224203648	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224204650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224204650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9229	1716224204650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224205652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224205652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9229	1716224205652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224206654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224206654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9229	1716224206654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224207656	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224207656	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9230999999999998	1716224207656	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224208658	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224208658	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9230999999999998	1716224208658	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224209660	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224209660	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9230999999999998	1716224209660	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224210662	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224210662	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9175	1716224210662	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	98	1716224211663	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224211663	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9175	1716224211663	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224212665	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224212665	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9175	1716224212665	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224213667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224213667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9210999999999998	1716224213667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224214669	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224214669	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9210999999999998	1716224214669	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224215671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224215671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9210999999999998	1716224215671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224216673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224216673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9228	1716224216673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224217675	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224217675	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9228	1716224217675	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224217698	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	2.8	1716224227693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.925	1716224227693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224228695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224228695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9272	1716224228695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224229697	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224229697	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9272	1716224229697	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224230699	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224230699	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9272	1716224230699	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224231701	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224231701	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9209	1716224231701	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224232703	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224232703	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9209	1716224232703	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224233705	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224233705	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9209	1716224233705	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224234707	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224234707	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9222000000000001	1716224234707	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224235710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224235710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9222000000000001	1716224235710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224236712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224236712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9222000000000001	1716224236712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224237715	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224237715	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9233	1716224237715	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224238717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224238717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9233	1716224238717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224239719	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224239719	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9233	1716224239719	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224240721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224240721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9253	1716224240721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224241723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224241723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9253	1716224241723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224242725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224242725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9253	1716224242725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224243727	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224243727	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9232	1716224243727	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224244729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224244729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9232	1716224244729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224245731	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224245731	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9232	1716224245731	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224246732	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224246732	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9263	1716224246732	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224247734	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224247734	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9263	1716224247734	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224248736	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224248736	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9263	1716224248736	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224249738	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224249738	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9283	1716224249738	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224250740	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224250740	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9283	1716224250740	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224251742	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224251742	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9283	1716224251742	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224252744	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224252744	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9277	1716224252744	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224253746	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224253746	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9277	1716224253746	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224254748	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224254748	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9277	1716224254748	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224255750	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224255750	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9244	1716224255750	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224256751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224256751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9244	1716224256751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224257753	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224257753	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9244	1716224257753	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224258756	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224258756	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9265999999999999	1716224258756	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224259757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224259757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9265999999999999	1716224259757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224260759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224260759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9265999999999999	1716224260759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224261761	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224240744	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224241745	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224242746	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224243741	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224244750	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224245751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224246747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224247755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224248761	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224249762	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224250762	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224251763	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224252767	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224253759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224254769	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224255770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224256774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224257768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224258774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224259780	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224260781	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224261785	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224262778	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224263779	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224264782	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224265791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224266793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224267788	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224268797	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224269798	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224270798	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224271801	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224272798	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224273805	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224274808	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224275803	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224276812	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224638487	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224638487	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9527999999999999	1716224638487	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224639489	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224639489	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9507	1716224639489	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224640491	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224640491	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9507	1716224640491	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224641493	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224641493	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9507	1716224641493	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224642495	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224642495	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9515	1716224642495	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224643496	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224643496	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9515	1716224643496	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224644498	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224644498	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9515	1716224644498	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224645500	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224645500	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9503	1716224645500	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224646502	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224646502	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9503	1716224646502	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224647504	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224261761	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9245	1716224261761	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	105	1716224262763	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224262763	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9245	1716224262763	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224263764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224263764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9245	1716224263764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224264767	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224264767	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9253	1716224264767	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224265769	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224265769	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9253	1716224265769	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224266770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224266770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9253	1716224266770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224267773	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224267773	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9263	1716224267773	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224268774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224268774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9263	1716224268774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224269776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224269776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9263	1716224269776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224270778	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224270778	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9269	1716224270778	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224271780	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224271780	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9269	1716224271780	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224272782	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224272782	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9269	1716224272782	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224273784	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224273784	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.928	1716224273784	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224274786	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224274786	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.928	1716224274786	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224275788	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224275788	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.928	1716224275788	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224276790	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224276790	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9205	1716224276790	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224277792	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224277792	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9205	1716224277792	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224277806	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224278793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224278793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9205	1716224278793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224278816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224279795	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224279795	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9245999999999999	1716224279795	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224279816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224280797	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224280797	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9245999999999999	1716224280797	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224280821	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224281799	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224281799	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9245999999999999	1716224281799	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224282801	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224282801	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9247	1716224282801	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224283803	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224283803	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9247	1716224283803	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224284805	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224284805	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9247	1716224284805	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224285807	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224285807	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9264000000000001	1716224285807	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224286809	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224286809	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9264000000000001	1716224286809	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224287810	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224287810	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9264000000000001	1716224287810	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224288812	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224288812	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9281	1716224288812	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224289814	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224289814	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9281	1716224289814	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224290816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224290816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9281	1716224290816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224291818	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224291818	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9264000000000001	1716224291818	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224292819	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224292819	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9264000000000001	1716224292819	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224293821	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224293821	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9264000000000001	1716224293821	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224294823	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224294823	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9285	1716224294823	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224295825	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224295825	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9285	1716224295825	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224296828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224296828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9285	1716224296828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224297830	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224297830	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.925	1716224297830	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224298832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224298832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.925	1716224298832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224299834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224299834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.925	1716224299834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224300836	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224300836	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9292	1716224300836	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224301839	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224301839	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9292	1716224301839	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224302841	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224302841	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224281822	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224282822	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224283817	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224284828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224285829	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224286831	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224287831	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224288825	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224289838	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224290836	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224291841	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224292840	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224293844	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224294845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224295849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224296849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224297852	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224298846	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224299858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224300860	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224301857	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224302859	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224303861	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224304866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224305860	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224306863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224307872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224308876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224309868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224310870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224311881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224312881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224313876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224314886	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224315881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224316889	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224317891	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224318886	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224319895	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224320899	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224321898	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224322894	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224323906	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224324897	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224325911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224326910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224327911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224328918	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224329915	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224330911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224331911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224332913	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224333924	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224334926	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224335927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224336930	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224638501	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224639506	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224640512	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224641513	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224642508	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224643512	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224644514	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224645523	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224646524	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9292	1716224302841	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224303843	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224303843	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9301	1716224303843	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224304845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224304845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9301	1716224304845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224305847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224305847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9301	1716224305847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224306849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224306849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9296	1716224306849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224307850	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224307850	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9296	1716224307850	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224308853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224308853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9296	1716224308853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224309855	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224309855	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9323	1716224309855	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224310856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224310856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9323	1716224310856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224311858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224311858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9323	1716224311858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224312860	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224312860	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9305999999999999	1716224312860	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224313862	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224313862	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9305999999999999	1716224313862	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224314864	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224314864	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9305999999999999	1716224314864	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224315866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224315866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9310999999999998	1716224315866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224316868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224316868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9310999999999998	1716224316868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224317870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224317870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9310999999999998	1716224317870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224318872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.800000000000001	1716224318872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9307	1716224318872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224319874	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	5.9	1716224319874	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9307	1716224319874	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224320875	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224320875	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9307	1716224320875	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224321877	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224321877	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9252	1716224321877	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224322879	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224322879	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9252	1716224322879	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224323881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224323881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9252	1716224323881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224324883	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224324883	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9244	1716224324883	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224325885	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224325885	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9244	1716224325885	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224326888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224326888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9244	1716224326888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224327890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224327890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9233	1716224327890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224328892	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224328892	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9233	1716224328892	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224329893	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224329893	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9233	1716224329893	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224330895	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224330895	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9242000000000001	1716224330895	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224331897	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224331897	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9242000000000001	1716224331897	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224332899	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224332899	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9242000000000001	1716224332899	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224333901	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224333901	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9249	1716224333901	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224334903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224334903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9249	1716224334903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224335905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224335905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9249	1716224335905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224336907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224336907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9265	1716224336907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224337909	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224337909	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9265	1716224337909	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224337923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224338911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224338911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9265	1716224338911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224338931	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224339912	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224339912	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.928	1716224339912	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224339934	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224340914	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224340914	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.928	1716224340914	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224340938	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224341916	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224341916	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.928	1716224341916	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224341940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224342918	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224342918	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9257	1716224342918	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224342934	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224343920	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224343920	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9257	1716224343920	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224344921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224344921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9257	1716224344921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224345923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224345923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9261	1716224345923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224346925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224346925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9261	1716224346925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224347927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224347927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9261	1716224347927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224348929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224348929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9282000000000001	1716224348929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224349931	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224349931	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9282000000000001	1716224349931	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224350933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224350933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9282000000000001	1716224350933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224351935	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224351935	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9289	1716224351935	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224352938	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224352938	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9289	1716224352938	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224353940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224353940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9289	1716224353940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224354942	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224354942	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9287	1716224354942	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224355944	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224355944	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9287	1716224355944	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224356946	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224356946	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9287	1716224356946	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224357948	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224357948	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9314	1716224357948	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224358949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224358949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9314	1716224358949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224359951	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224359951	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9314	1716224359951	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224360953	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224360953	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9285999999999999	1716224360953	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224361955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224361955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9285999999999999	1716224361955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224362957	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224362957	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9285999999999999	1716224362957	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224363959	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224363959	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9263	1716224363959	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224364961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224364961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224343936	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224344944	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224345949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224346940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224347942	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224348951	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224349955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224350955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224351958	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224352961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224353961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224354961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224355969	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224356971	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224357963	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224358971	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224359974	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224360976	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224361977	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224362973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224363980	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224364983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224365984	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224366986	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224367989	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224368991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224369985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224370995	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224371996	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224372989	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224374003	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224375001	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224376003	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224377004	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224377999	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224379009	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224380012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224381012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224382015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224383008	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224384017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224385012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224386021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224387024	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224388017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224389027	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224390031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224391032	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224392031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224393028	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224394035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224395037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224396040	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224397041	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224647504	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9503	1716224647504	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224648506	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224648506	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9498	1716224648506	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224649508	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224649508	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9498	1716224649508	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224650510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224650510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9498	1716224650510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9263	1716224364961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224365962	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224365962	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9263	1716224365962	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224366964	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224366964	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9290999999999998	1716224366964	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224367966	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224367966	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9290999999999998	1716224367966	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224368969	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224368969	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9290999999999998	1716224368969	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224369971	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224369971	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9292	1716224369971	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224370973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224370973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9292	1716224370973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224371975	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224371975	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9292	1716224371975	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224372976	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224372976	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9305	1716224372976	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224373978	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224373978	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9305	1716224373978	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224374980	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224374980	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9305	1716224374980	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224375982	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224375982	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9301	1716224375982	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224376983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224376983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9301	1716224376983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224377985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224377985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9301	1716224377985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224378987	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224378987	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.932	1716224378987	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224379989	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224379989	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.932	1716224379989	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224380991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224380991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.932	1716224380991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224381993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224381993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9321	1716224381993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224382995	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224382995	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9321	1716224382995	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224383996	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224383996	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9321	1716224383996	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224384999	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224384999	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9257	1716224384999	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224386000	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224386000	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9257	1716224386000	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224387002	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224387002	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9257	1716224387002	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224388004	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224388004	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9297	1716224388004	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224389005	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224389005	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9297	1716224389005	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224390007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224390007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9297	1716224390007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224391009	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224391009	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9325	1716224391009	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224392011	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224392011	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9325	1716224392011	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224393013	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224393013	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.933	1716224393013	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224394015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224394015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.933	1716224394015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224395017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224395017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.933	1716224395017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224396018	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224396018	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9303	1716224396018	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224397020	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224397020	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9303	1716224397020	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224398022	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224398022	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9303	1716224398022	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224398041	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224399024	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224399024	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9301	1716224399024	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224399050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224400026	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224400026	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9301	1716224400026	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224400048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224401028	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224401028	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9301	1716224401028	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224401052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224402030	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224402030	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9310999999999998	1716224402030	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224402052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224403031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224403031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9310999999999998	1716224403031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224403048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224404033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224404033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9310999999999998	1716224404033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224404048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224405035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224405035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9343	1716224405035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224405058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224406061	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224407060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224408056	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224409066	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224410066	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224411073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224412069	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224413063	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224414075	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224415074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224416077	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224417079	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224418074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224419081	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224420085	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224421087	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224422088	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224423081	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224424090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224425093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224426094	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224427090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224428091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224429102	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224430103	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224431106	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224432107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224433102	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224434110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224435113	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224436108	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224437118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224438117	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224439122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224440125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224441120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224442129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224443131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224444132	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224445136	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224446137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224447141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224448141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224449136	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224450146	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224451148	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224452148	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224453142	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224454145	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224455153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224456156	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224457150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224458161	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224459160	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224460164	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224461163	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224462166	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224463168	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224464163	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224465176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224466175	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224467176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224468179	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224469174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224406037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224406037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9343	1716224406037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224407039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224407039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9343	1716224407039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224408041	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224408041	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9307999999999998	1716224408041	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224409043	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224409043	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9307999999999998	1716224409043	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224410045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224410045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9307999999999998	1716224410045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224411046	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224411046	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9325999999999999	1716224411046	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224412048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224412048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9325999999999999	1716224412048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224413050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224413050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9325999999999999	1716224413050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224414052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224414052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9329	1716224414052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224415053	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224415053	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9329	1716224415053	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224416055	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224416055	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9329	1716224416055	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224417057	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224417057	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9337	1716224417057	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224418058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224418058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9337	1716224418058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224419060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224419060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9337	1716224419060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224420062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224420062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9361	1716224420062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224421063	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224421063	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9361	1716224421063	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224422065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224422065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9361	1716224422065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224423067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224423067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9347	1716224423067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224424070	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224424070	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9347	1716224424070	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224425072	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224425072	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9347	1716224425072	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224426074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224426074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.935	1716224426074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224427076	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224427076	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.935	1716224427076	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224428078	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224428078	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.935	1716224428078	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224429080	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224429080	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9293	1716224429080	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	105	1716224430081	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224430081	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9293	1716224430081	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224431083	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224431083	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9293	1716224431083	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224432085	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224432085	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9343	1716224432085	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224433087	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224433087	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9343	1716224433087	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224434089	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224434089	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9343	1716224434089	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224435091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224435091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9352	1716224435091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224436093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224436093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9352	1716224436093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224437095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224437095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9352	1716224437095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224438097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224438097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9353	1716224438097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224439100	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6	1716224439100	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9353	1716224439100	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224440102	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224440102	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9353	1716224440102	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224441105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.9	1716224441105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9336	1716224441105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224442108	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224442108	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9336	1716224442108	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224443110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716224443110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9336	1716224443110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224444112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224444112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9356	1716224444112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224445114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224445114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9356	1716224445114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224446116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224446116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9356	1716224446116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224447119	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224447119	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9354	1716224447119	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224448120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224448120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9354	1716224448120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224449122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224449122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9354	1716224449122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224450123	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224450123	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9345	1716224450123	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224451126	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224451126	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9345	1716224451126	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224452127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224452127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9345	1716224452127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224453129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224453129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716224453129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224454131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224454131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716224454131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224455133	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224455133	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716224455133	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224456135	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224456135	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9347	1716224456135	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224457137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224457137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9347	1716224457137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224458138	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224458138	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9347	1716224458138	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224459140	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224459140	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716224459140	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224460142	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224460142	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716224460142	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224461143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224461143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716224461143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224462145	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224462145	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9338	1716224462145	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224463147	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224463147	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9338	1716224463147	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224464149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224464149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9338	1716224464149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224465151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224465151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9338	1716224465151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224466153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224466153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9338	1716224466153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224467155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224467155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9338	1716224467155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224468157	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224468157	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9338	1716224468157	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224469161	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224469161	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9338	1716224469161	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224470162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224470162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9338	1716224470162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224471165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224471165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9382000000000001	1716224471165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224472166	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224472166	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9382000000000001	1716224472166	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224473168	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224473168	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9382000000000001	1716224473168	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224474170	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224474170	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716224474170	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224475172	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224475172	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716224475172	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224476174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224476174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9339000000000002	1716224476174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224477176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224477176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9359000000000002	1716224477176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224478178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224478178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9359000000000002	1716224478178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224479180	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224479180	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9359000000000002	1716224479180	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224480181	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224480181	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9373	1716224480181	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224481183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224481183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9373	1716224481183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224482185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224482185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9373	1716224482185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224483187	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224483187	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9361	1716224483187	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224484189	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224484189	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9361	1716224484189	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224485191	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224485191	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9361	1716224485191	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224486193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224486193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9379000000000002	1716224486193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224487196	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224487196	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9379000000000002	1716224487196	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224488198	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224488198	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9379000000000002	1716224488198	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224489200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224489200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9364000000000001	1716224489200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224490202	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224490202	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9364000000000001	1716224490202	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224491203	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224470185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224471188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224472188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224473190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224474193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224475193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224476195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224477199	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224478195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224479205	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224480204	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224481206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224482207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224483201	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224484210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224485213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224486217	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224487210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224488212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224489213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224490224	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224491217	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224492230	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224493223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224494228	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224495228	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224496237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224497237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224498234	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224499238	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224500244	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224501246	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224502245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224503243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224504244	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224505255	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224506258	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224507259	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224508254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224509255	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224510265	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224511267	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224512270	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224513262	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224514266	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224515275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224516275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224517278	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224647526	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224648521	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224649522	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224650531	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224651532	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224652535	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224653532	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224654539	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224655541	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224656545	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224657544	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224658541	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224659546	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224660554	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224661553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224662557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224663549	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224491203	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9364000000000001	1716224491203	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224492206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224492206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9384000000000001	1716224492206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224493207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224493207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9384000000000001	1716224493207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224494211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224494211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9384000000000001	1716224494211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224495212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224495212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9390999999999998	1716224495212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224496214	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224496214	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9390999999999998	1716224496214	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224497216	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224497216	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9390999999999998	1716224497216	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224498218	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224498218	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407999999999999	1716224498218	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224499222	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224499222	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407999999999999	1716224499222	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224500224	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224500224	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407999999999999	1716224500224	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224501225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224501225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9417	1716224501225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224502227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224502227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9417	1716224502227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224503229	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224503229	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9417	1716224503229	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224504231	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224504231	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9403	1716224504231	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224505233	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224505233	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9403	1716224505233	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224506236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224506236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9403	1716224506236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224507238	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224507238	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407	1716224507238	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224508240	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224508240	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407	1716224508240	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224509241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224509241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407	1716224509241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224510243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	4.9	1716224510243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9409	1716224510243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224511245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224511245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9409	1716224511245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224512247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224512247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9409	1716224512247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224513249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224513249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9425	1716224513249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224514251	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224514251	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9425	1716224514251	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224515253	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224515253	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9425	1716224515253	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224516255	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224516255	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9358	1716224516255	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224517256	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224517256	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9358	1716224517256	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224518258	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224518258	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9358	1716224518258	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224518272	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224519260	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224519260	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9397	1716224519260	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224519275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224520262	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224520262	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9397	1716224520262	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224520283	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224521264	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224521264	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9397	1716224521264	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224521277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224522266	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224522266	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9403	1716224522266	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224522288	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224523268	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224523268	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9403	1716224523268	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224523291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224524270	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224524270	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9403	1716224524270	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224524283	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224525272	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224525272	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9418	1716224525272	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224525293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224526274	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224526274	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9418	1716224526274	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224526295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224527275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224527275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9418	1716224527275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224527299	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224528277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224528277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.943	1716224528277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224528302	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224529279	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224529279	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.943	1716224529279	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224529292	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224530281	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224530281	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.943	1716224530281	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224531283	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	4.9	1716224531283	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407999999999999	1716224531283	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224532285	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224532285	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407999999999999	1716224532285	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224533287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224533287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407999999999999	1716224533287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224534288	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224534288	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9416	1716224534288	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224535290	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224535290	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9416	1716224535290	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224536293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224536293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9416	1716224536293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224537296	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224537296	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9396	1716224537296	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224538297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224538297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9396	1716224538297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224539299	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224539299	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9396	1716224539299	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224540301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224540301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9367	1716224540301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224541303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224541303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9367	1716224541303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224542305	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224542305	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9367	1716224542305	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224543307	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224543307	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9405999999999999	1716224543307	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224544309	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224544309	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9405999999999999	1716224544309	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224545311	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224545311	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9405999999999999	1716224545311	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224546312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224546312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407999999999999	1716224546312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224547314	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224547314	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407999999999999	1716224547314	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224548316	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224548316	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407999999999999	1716224548316	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224549318	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224549318	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407	1716224549318	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224550320	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224550320	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407	1716224550320	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224551322	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224530303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224531307	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224532306	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224533311	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224534301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224535311	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224536314	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224537318	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224538317	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224539312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224540324	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224541326	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224542321	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224543328	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224544325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224545336	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224546336	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224547329	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224548338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224549333	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224550341	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224551335	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224552344	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224553339	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224554341	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224555343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224556352	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224557355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224558349	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224559352	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224560361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224561362	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224562369	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224563368	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224564360	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224565369	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224566371	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224567376	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224568370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224569370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224570382	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224571385	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224572384	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224573379	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224574382	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224575390	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224576391	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224577393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224578388	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224579388	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224580399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224581402	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224582402	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224583397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224584400	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224585407	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224586408	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224587411	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224588406	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224589407	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224590416	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224591417	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224592421	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224593416	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224594417	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224551322	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9407	1716224551322	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224552324	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224552324	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9413	1716224552324	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224553325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224553325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9413	1716224553325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224554328	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224554328	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9413	1716224554328	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224555330	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224555330	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9430999999999998	1716224555330	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224556332	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224556332	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9430999999999998	1716224556332	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224557334	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224557334	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9430999999999998	1716224557334	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224558335	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716224558335	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9442000000000002	1716224558335	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224559337	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224559337	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9442000000000002	1716224559337	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224560339	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224560339	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9442000000000002	1716224560339	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224561341	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224561341	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9410999999999998	1716224561341	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224562343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224562343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9410999999999998	1716224562343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224563345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224563345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9410999999999998	1716224563345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224564347	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224564347	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9456	1716224564347	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224565349	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224565349	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9456	1716224565349	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224566351	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224566351	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9456	1716224566351	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224567352	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224567352	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9445999999999999	1716224567352	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224568355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224568355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9445999999999999	1716224568355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224569356	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224569356	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9445999999999999	1716224569356	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224570358	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716224570358	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9437	1716224570358	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224571360	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.1	1716224571360	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9437	1716224571360	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224572362	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224572362	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9437	1716224572362	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224573363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224573363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9442000000000002	1716224573363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224574365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224574365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9442000000000002	1716224574365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224575367	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224575367	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9442000000000002	1716224575367	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224576369	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224576369	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.945	1716224576369	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224577370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224577370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.945	1716224577370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224578373	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224578373	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.945	1716224578373	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224579375	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224579375	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.946	1716224579375	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224580377	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224580377	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.946	1716224580377	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224581379	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224581379	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.946	1716224581379	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224582380	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224582380	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9427999999999999	1716224582380	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224583382	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224583382	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9427999999999999	1716224583382	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224584383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224584383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9427999999999999	1716224584383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224585385	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224585385	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9450999999999998	1716224585385	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224586387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224586387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9450999999999998	1716224586387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224587389	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224587389	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9450999999999998	1716224587389	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224588391	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224588391	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9442000000000002	1716224588391	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224589393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224589393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9442000000000002	1716224589393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224590394	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224590394	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9442000000000002	1716224590394	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224591396	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224591396	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9465999999999999	1716224591396	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224592398	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224592398	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9465999999999999	1716224592398	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224593400	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224593400	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9465999999999999	1716224593400	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224594402	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224594402	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9469	1716224594402	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224595404	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224595404	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9469	1716224595404	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224596406	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224596406	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9469	1716224596406	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224597408	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224597408	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9475	1716224597408	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224598409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224598409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9475	1716224598409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224599413	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224599413	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9475	1716224599413	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224600415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224600415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.948	1716224600415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224601416	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224601416	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.948	1716224601416	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224602418	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224602418	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.948	1716224602418	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224603420	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224603420	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.948	1716224603420	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224604422	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224604422	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.948	1716224604422	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224605424	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224605424	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.948	1716224605424	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224606426	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224606426	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9463	1716224606426	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224607427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224607427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9463	1716224607427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224608429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224608429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9463	1716224608429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224609432	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224609432	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9482000000000002	1716224609432	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224610434	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224610434	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9482000000000002	1716224610434	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224611436	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224611436	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9482000000000002	1716224611436	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224612438	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224612438	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9496	1716224612438	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224613440	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224613440	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9496	1716224613440	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224614441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224614441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9496	1716224614441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224615443	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224595425	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224596426	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224597429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224598423	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224599427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224600436	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224601438	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224602439	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224603434	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224604435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224605446	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224606446	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224607449	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224608446	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224609450	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224610464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224611461	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224612460	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224613453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224614457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224615465	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224616466	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224617469	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224618465	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224619472	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224620478	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224621476	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224622479	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224623471	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224624483	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224625483	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224626484	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224627487	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224628481	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224629490	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224630495	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224631497	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224632502	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224633494	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224634503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224635502	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224636505	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224637498	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224651512	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716224651512	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9507999999999999	1716224651512	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224652514	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224652514	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9507999999999999	1716224652514	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224653516	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224653516	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9507999999999999	1716224653516	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224654517	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224654517	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9501	1716224654517	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224655519	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224655519	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9501	1716224655519	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224656521	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224656521	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9501	1716224656521	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224657523	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224657523	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224657523	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224658525	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224615443	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9504000000000001	1716224615443	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224616445	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224616445	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9504000000000001	1716224616445	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224617447	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224617447	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9504000000000001	1716224617447	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224618449	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224618449	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9499000000000002	1716224618449	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224619451	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224619451	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9499000000000002	1716224619451	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224620453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224620453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9499000000000002	1716224620453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224621454	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224621454	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.952	1716224621454	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224622457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224622457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.952	1716224622457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224623458	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224623458	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.952	1716224623458	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224624460	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224624460	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9505	1716224624460	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224625462	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224625462	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9505	1716224625462	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	99	1716224626464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224626464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9505	1716224626464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224627466	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224627466	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9485	1716224627466	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224628468	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224628468	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9485	1716224628468	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224629469	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224629469	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9485	1716224629469	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224630473	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224630473	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9505	1716224630473	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224631475	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224631475	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9505	1716224631475	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224632477	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224632477	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9505	1716224632477	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224633479	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224633479	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9515	1716224633479	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224634480	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224634480	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9515	1716224634480	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224635481	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224635481	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9515	1716224635481	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224636483	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224636483	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9527999999999999	1716224636483	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224637485	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224637485	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9527999999999999	1716224637485	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224658525	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224658525	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224659528	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224659528	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224659528	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224660530	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224660530	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.951	1716224660530	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224661532	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224661532	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.951	1716224661532	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224662533	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224662533	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.951	1716224662533	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224663535	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224663535	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9513	1716224663535	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224664537	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224664537	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9513	1716224664537	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224664551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224665538	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224665538	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9513	1716224665538	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224665561	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224666541	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224666541	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224666541	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224666563	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224667542	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224667542	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224667542	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224667559	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224668544	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224668544	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224668544	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224668560	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224669546	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224669546	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.953	1716224669546	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224669559	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224670548	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224670548	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.953	1716224670548	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224670572	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224671550	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224671550	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.953	1716224671550	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224671572	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224672552	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224672552	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9505	1716224672552	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224672577	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224673554	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224673554	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9505	1716224673554	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224673569	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224674556	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224674556	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9505	1716224674556	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224674569	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224675580	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224676582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224677582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224678578	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224679580	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224680589	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224681589	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224682592	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224683595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224684589	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224685598	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224686599	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224687604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224688599	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224689597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224690608	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224691603	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224692614	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224693612	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224694607	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224695618	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224696619	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224697622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224698623	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224699617	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224700627	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224701627	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224702632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224703625	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224704628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224705636	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224706632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224707639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224708633	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224709638	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224710653	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224711650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224712648	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224713650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224714644	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224715654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224716657	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224717652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224718654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224719666	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224720665	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224721667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224722668	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224723667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224724672	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224725675	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224726674	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224727670	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224728682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224729684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224730685	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224731687	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224732687	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224733689	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224734696	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224735693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224736696	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224737689	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224738698	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224675557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224675557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9514	1716224675557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224676559	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224676559	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9514	1716224676559	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224677561	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224677561	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9514	1716224677561	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224678563	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224678563	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9518	1716224678563	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224679565	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224679565	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9518	1716224679565	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224680567	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224680567	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9518	1716224680567	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224681569	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224681569	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9510999999999998	1716224681569	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224682571	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224682571	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9510999999999998	1716224682571	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224683573	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224683573	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9510999999999998	1716224683573	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224684575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224684575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9513	1716224684575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224685577	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224685577	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9513	1716224685577	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224686579	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224686579	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9513	1716224686579	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224687580	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224687580	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9526	1716224687580	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224688582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224688582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9526	1716224688582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224689584	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224689584	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9526	1716224689584	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224690586	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224690586	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716224690586	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224691588	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224691588	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716224691588	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224692590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716224692590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716224692590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224693592	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.2	1716224693592	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.948	1716224693592	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224694594	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224694594	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.948	1716224694594	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224695595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224695595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.948	1716224695595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224696597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224696597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9529	1716224696597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224697599	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224697599	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9529	1716224697599	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224698601	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224698601	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9529	1716224698601	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224699603	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224699603	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224699603	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224700605	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224700605	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224700605	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224701607	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224701607	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224701607	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224702609	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224702609	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9539000000000002	1716224702609	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224703610	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224703610	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9539000000000002	1716224703610	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224704611	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224704611	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9539000000000002	1716224704611	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224705613	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224705613	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9544000000000001	1716224705613	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224706615	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224706615	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9544000000000001	1716224706615	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224707618	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224707618	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9544000000000001	1716224707618	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224708620	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224708620	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.956	1716224708620	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224709622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224709622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.956	1716224709622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224710624	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224710624	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.956	1716224710624	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224711626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224711626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9559000000000002	1716224711626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224712628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224712628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9559000000000002	1716224712628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224713629	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224713629	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9559000000000002	1716224713629	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224714630	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224714630	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9541	1716224714630	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224715632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224715632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9541	1716224715632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224716634	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224716634	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9541	1716224716634	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224717637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224717637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224717637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224718639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224718639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224718639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224719641	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224719641	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224719641	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224720643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224720643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.952	1716224720643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224721645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224721645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.952	1716224721645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224722646	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224722646	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.952	1716224722646	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224723648	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224723648	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9516	1716224723648	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224724650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224724650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9516	1716224724650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224725652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224725652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9516	1716224725652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224726654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224726654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224726654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224727656	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224727656	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224727656	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224728658	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224728658	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9512	1716224728658	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224729660	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224729660	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9513	1716224729660	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224730662	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224730662	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9513	1716224730662	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224731663	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716224731663	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9513	1716224731663	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224732665	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224732665	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9526	1716224732665	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224733667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224733667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9526	1716224733667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224734669	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224734669	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9526	1716224734669	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224735671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224735671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9392	1716224735671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224736673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224736673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9392	1716224736673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224737675	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224737675	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9392	1716224737675	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224738677	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224738677	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9503	1716224738677	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224739679	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224739679	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9503	1716224739679	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224740681	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224740681	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9503	1716224740681	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224741682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224741682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.952	1716224741682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224742684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224742684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.952	1716224742684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224743686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224743686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.952	1716224743686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224744688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224744688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9530999999999998	1716224744688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224745689	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224745689	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9530999999999998	1716224745689	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224746691	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224746691	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9530999999999998	1716224746691	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224747693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224747693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9532	1716224747693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224748695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224748695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9532	1716224748695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224749698	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224749698	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9532	1716224749698	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224750700	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224750700	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9537	1716224750700	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224751702	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224751702	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9537	1716224751702	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224752704	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224752704	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9537	1716224752704	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224753706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224753706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9525	1716224753706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224754708	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224754708	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9525	1716224754708	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224755710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224755710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9525	1716224755710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224756712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224756712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9378	1716224756712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224757714	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224757714	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9378	1716224757714	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225118412	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225118412	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9687999999999999	1716225118412	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225119414	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225119414	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9687999999999999	1716225119414	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225120416	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224739700	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224740695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224741708	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224742699	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224743706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224744706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224745710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224746712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224747708	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224748720	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224749722	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224750724	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224751727	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224752718	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224753732	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224754728	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224755731	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224756733	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224757728	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224758716	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224758716	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9378	1716224758716	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224758737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224759718	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224759718	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9498	1716224759718	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224759738	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224760720	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224760720	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9498	1716224760720	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224760741	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224761721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224761721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9498	1716224761721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224761743	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224762723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224762723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9487999999999999	1716224762723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224762744	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224763725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224763725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9487999999999999	1716224763725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224763739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224764727	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224764727	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9487999999999999	1716224764727	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224764747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224765729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224765729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9517	1716224765729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224765750	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224766731	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224766731	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9517	1716224766731	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224766752	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224767733	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224767733	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9517	1716224767733	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224767754	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224768735	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224768735	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9518	1716224768735	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224768752	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224769737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224769737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9518	1716224769737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224770739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224770739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9518	1716224770739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224771741	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224771741	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716224771741	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224772742	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224772742	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716224772742	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224773744	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224773744	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716224773744	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224774746	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224774746	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9542	1716224774746	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224775748	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224775748	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9542	1716224775748	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224776750	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224776750	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9542	1716224776750	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224777752	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224777752	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9532	1716224777752	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224778754	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224778754	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9532	1716224778754	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224779755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224779755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9532	1716224779755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224780757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224780757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9485999999999999	1716224780757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224781760	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224781760	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9485999999999999	1716224781760	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224782762	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224782762	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9485999999999999	1716224782762	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224783764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224783764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.952	1716224783764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224784766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224784766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.952	1716224784766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224785768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224785768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.952	1716224785768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224786770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224786770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9496	1716224786770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224787772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224787772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9496	1716224787772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224788774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224788774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9496	1716224788774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224789776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224789776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9521	1716224789776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224790777	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224790777	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9521	1716224790777	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224769760	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224770764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224771765	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224772767	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224773768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224774762	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224775770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224776771	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224777772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224778773	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224779776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224780782	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224781783	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224782783	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224783781	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224784790	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224785782	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224786792	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224787793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224788795	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224789788	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224790799	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224791800	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224792805	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224793797	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224794811	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224795809	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224796813	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224797814	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224798807	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224799816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224800818	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224801824	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224802822	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224803823	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224804825	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224805831	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224806829	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224807823	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224808834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224809835	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224810836	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224811838	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224812834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224813843	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224814846	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224815848	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224816852	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224817843	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224818853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224819847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224820861	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224821861	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224822853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224823862	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224824865	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224825860	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224826870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224827863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224828872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224829876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224830879	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224831879	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224832876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224833881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224791779	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224791779	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9521	1716224791779	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224792781	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224792781	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716224792781	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224793783	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224793783	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716224793783	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224794785	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224794785	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716224794785	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224795787	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224795787	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9505	1716224795787	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224796789	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224796789	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9505	1716224796789	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224797791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224797791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9505	1716224797791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224798793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224798793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9516	1716224798793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224799794	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224799794	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9516	1716224799794	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224800796	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224800796	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9516	1716224800796	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224801798	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224801798	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9509	1716224801798	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224802800	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224802800	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9509	1716224802800	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224803802	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224803802	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9509	1716224803802	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224804804	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224804804	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716224804804	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224805806	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224805806	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716224805806	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224806807	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224806807	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716224806807	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224807809	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224807809	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9558	1716224807809	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224808811	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224808811	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9558	1716224808811	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224809813	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224809813	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9558	1716224809813	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224810815	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224810815	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9557	1716224810815	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224811817	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224811817	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9557	1716224811817	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224812819	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224812819	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9557	1716224812819	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224813822	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224813822	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9550999999999998	1716224813822	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224814824	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224814824	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9550999999999998	1716224814824	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224815826	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224815826	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9550999999999998	1716224815826	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224816828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224816828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9547999999999999	1716224816828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224817830	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224817830	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9547999999999999	1716224817830	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224818831	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224818831	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9547999999999999	1716224818831	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224819833	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716224819833	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.955	1716224819833	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224820835	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.200000000000001	1716224820835	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.955	1716224820835	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224821838	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224821838	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.955	1716224821838	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224822840	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224822840	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9581	1716224822840	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224823842	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224823842	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9581	1716224823842	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224824844	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224824844	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9581	1716224824844	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224825845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224825845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9550999999999998	1716224825845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224826847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224826847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9550999999999998	1716224826847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224827849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224827849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9550999999999998	1716224827849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224828851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224828851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9575	1716224828851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224829853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224829853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9575	1716224829853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224830855	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224830855	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9575	1716224830855	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224831857	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224831857	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9574	1716224831857	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224832859	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716224832859	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9574	1716224832859	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224833861	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224833861	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9574	1716224833861	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224834863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224834863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9572	1716224834863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224835864	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224835864	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9572	1716224835864	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224836866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224836866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9572	1716224836866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224837868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224837868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9582	1716224837868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224838870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224838870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9582	1716224838870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224839872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224839872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9582	1716224839872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224840873	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224840873	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9570999999999998	1716224840873	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224841875	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224841875	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9570999999999998	1716224841875	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224842877	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224842877	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9570999999999998	1716224842877	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224843879	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224843879	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9558	1716224843879	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224844881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224844881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9558	1716224844881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224845883	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224845883	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9558	1716224845883	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224846885	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224846885	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9536	1716224846885	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224847887	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224847887	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9536	1716224847887	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224848888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224848888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9536	1716224848888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224849890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224849890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9556	1716224849890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224850891	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224850891	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9556	1716224850891	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224851894	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224851894	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9556	1716224851894	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224852895	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224852895	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.955	1716224852895	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224853897	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224853897	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.955	1716224853897	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224854899	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224854899	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.955	1716224854899	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224834885	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224835887	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224836890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224837883	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224838886	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224839892	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224840888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224841896	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224842891	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224843900	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224844907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224845905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224846906	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224847908	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224848913	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224849914	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224850913	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224851914	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224852916	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224853914	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224854922	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224855916	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224856919	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224857928	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224858922	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224859932	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224860934	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224861927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224862936	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224863939	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224864932	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224865945	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224866948	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224867947	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224868941	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224869952	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224870944	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224871947	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224872955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224873950	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224874960	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224875961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224876956	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225118436	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225119437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225120442	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225121442	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225122437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225123440	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225124439	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225125448	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225126442	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225127450	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225128445	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225129455	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225130458	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225131458	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225132460	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225133464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225134462	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225135466	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225136468	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225137470	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225138465	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225139473	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224855901	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224855901	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.954	1716224855901	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224856903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224856903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.954	1716224856903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224857905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224857905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.954	1716224857905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224858907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224858907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9561	1716224858907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224859910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224859910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9561	1716224859910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224860911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224860911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9561	1716224860911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224861913	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224861913	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9567999999999999	1716224861913	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224862915	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224862915	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9567999999999999	1716224862915	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224863917	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224863917	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9567999999999999	1716224863917	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224864919	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224864919	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9564000000000001	1716224864919	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224865921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224865921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9564000000000001	1716224865921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224866923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224866923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9564000000000001	1716224866923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224867925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224867925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9447	1716224867925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224868927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224868927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9447	1716224868927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224869929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224869929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9447	1716224869929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224870931	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224870931	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9598	1716224870931	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224871933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224871933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9598	1716224871933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224872934	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224872934	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9598	1716224872934	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224873936	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224873936	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9597	1716224873936	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224874938	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224874938	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9597	1716224874938	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224875940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224875940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9597	1716224875940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224876943	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224876943	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9592	1716224876943	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224877945	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224877945	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9592	1716224877945	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224877959	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224878947	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224878947	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9592	1716224878947	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224878970	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224879949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224879949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9596	1716224879949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224879972	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224880951	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224880951	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9596	1716224880951	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224880972	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224881953	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224881953	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9596	1716224881953	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224881973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224882954	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224882954	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9594	1716224882954	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224882969	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224883956	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224883956	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9594	1716224883956	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224883979	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224884958	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224884958	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9594	1716224884958	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224884979	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224885960	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224885960	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9581	1716224885960	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224885975	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224886962	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224886962	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9581	1716224886962	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224886977	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224887964	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224887964	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9581	1716224887964	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224887977	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224888966	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224888966	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9589	1716224888966	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224888990	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224889968	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224889968	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9589	1716224889968	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224889993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224890970	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224890970	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9589	1716224890970	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224890991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224891972	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224891972	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9561	1716224891972	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224891996	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224892973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224892973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9561	1716224892973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224893975	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224893975	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9561	1716224893975	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224894977	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224894977	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9587999999999999	1716224894977	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224895979	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224895979	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9587999999999999	1716224895979	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224896981	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224896981	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9587999999999999	1716224896981	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224897983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224897983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9599000000000002	1716224897983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224898985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224898985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9599000000000002	1716224898985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224899987	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224899987	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9599000000000002	1716224899987	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224900988	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224900988	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9589	1716224900988	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224901990	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224901990	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9589	1716224901990	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224902992	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224902992	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9589	1716224902992	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224903994	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224903994	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9574	1716224903994	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224904996	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224904996	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9574	1716224904996	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224905998	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224905998	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9574	1716224905998	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224907000	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224907000	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9575	1716224907000	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224908002	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224908002	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9575	1716224908002	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224909004	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224909004	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9575	1716224909004	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224910006	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224910006	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9584000000000001	1716224910006	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224911007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224911007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9584000000000001	1716224911007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224912009	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224912009	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9584000000000001	1716224912009	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224913011	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224913011	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9582	1716224913011	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224914013	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224914013	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9582	1716224914013	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224892990	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224893997	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224895000	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224896001	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224897002	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224898006	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224899001	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224900007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224901007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224902006	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224903014	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224904007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224905017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224906018	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224907016	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224908023	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224909024	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224910028	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224911020	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224912032	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224913036	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224914029	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224915039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224916031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224917033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224918042	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224919038	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224920049	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224921048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224922050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224923045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224924046	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224925057	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224926050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224927060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224928057	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224929065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224930065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224931067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224932073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224933066	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224934074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224935082	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224936081	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224937075	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224938085	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224939087	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224940091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224941084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224942093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224943087	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224944104	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224945095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224946105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224947107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224948100	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224949110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224950111	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224951112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224952115	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224953110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224954123	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224955127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224956118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224957125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224915015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224915015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9582	1716224915015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224916017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224916017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9541	1716224916017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224917019	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224917019	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9541	1716224917019	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224918021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224918021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9541	1716224918021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224919024	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224919024	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9584000000000001	1716224919024	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224920026	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224920026	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9584000000000001	1716224920026	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224921027	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224921027	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9584000000000001	1716224921027	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224922029	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224922029	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9579000000000002	1716224922029	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224923031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224923031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9579000000000002	1716224923031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224924033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224924033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9579000000000002	1716224924033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224925035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224925035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9598	1716224925035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224926037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224926037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9598	1716224926037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224927039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224927039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9598	1716224927039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224928041	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224928041	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9613	1716224928041	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224929043	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224929043	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9613	1716224929043	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224930045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716224930045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9613	1716224930045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224931047	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224931047	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9606	1716224931047	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224932049	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224932049	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9606	1716224932049	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224933052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224933052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9606	1716224933052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224934054	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224934054	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9627000000000001	1716224934054	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224935058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224935058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9627000000000001	1716224935058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224936060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224936060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9627000000000001	1716224936060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224937062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224937062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9587999999999999	1716224937062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	99	1716224938063	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224938063	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9587999999999999	1716224938063	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224939065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224939065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9587999999999999	1716224939065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224940067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224940067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9594	1716224940067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224941069	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224941069	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9594	1716224941069	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224942071	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224942071	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9594	1716224942071	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224943073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224943073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9596	1716224943073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224944075	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224944075	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9596	1716224944075	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224945079	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224945079	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9596	1716224945079	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224946082	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224946082	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9593	1716224946082	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224947084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224947084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9593	1716224947084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224948086	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224948086	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9593	1716224948086	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224949088	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224949088	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9614	1716224949088	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224950090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224950090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9614	1716224950090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224951092	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224951092	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9614	1716224951092	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224952093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224952093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9610999999999998	1716224952093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224953095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224953095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9610999999999998	1716224953095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224954099	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224954099	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9610999999999998	1716224954099	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224955101	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224955101	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9629	1716224955101	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224956103	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224956103	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9629	1716224956103	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224957105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224957105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9629	1716224957105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224958107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224958107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9574	1716224958107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224959109	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224959109	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9574	1716224959109	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224960110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224960110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9574	1716224960110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224961111	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224961111	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9607999999999999	1716224961111	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224962113	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224962113	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9607999999999999	1716224962113	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224963115	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224963115	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9607999999999999	1716224963115	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224964117	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224964117	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9605	1716224964117	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224965119	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224965119	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9605	1716224965119	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224966121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224966121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9605	1716224966121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224967123	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224967123	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9619000000000002	1716224967123	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224968125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224968125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9619000000000002	1716224968125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224969127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224969127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9619000000000002	1716224969127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224970129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224970129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9601	1716224970129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224971130	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224971130	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9601	1716224971130	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224972132	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224972132	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9601	1716224972132	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224973134	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224973134	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9626	1716224973134	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224974135	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224974135	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9626	1716224974135	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224975137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224975137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9626	1716224975137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224976140	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224976140	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9629	1716224976140	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224977141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224977141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9629	1716224977141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224978143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.3	1716224978143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9629	1716224978143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224958121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224959131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224960131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224961133	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224962135	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224963128	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224964140	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224965136	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224966142	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224967143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224968139	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224969146	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224970151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224971144	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224972154	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224973149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224974158	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224975151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224976160	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224977156	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224978160	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224979170	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224980170	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224981172	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224982174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224983173	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224984178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224985176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224986174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224987186	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224988187	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224989179	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224990187	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224991192	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224992195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224993195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224994192	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224995200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224996202	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224997203	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225120416	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9722	1716225120416	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	106	1716225121418	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225121418	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9722	1716225121418	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225122420	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225122420	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9722	1716225122420	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225123422	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225123422	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225123422	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225124424	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225124424	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225124424	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225125426	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225125426	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225125426	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225126428	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225126428	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9741	1716225126428	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225127430	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225127430	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9741	1716225127430	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225128431	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225128431	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224979146	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716224979146	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9647000000000001	1716224979146	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224980148	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716224980148	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9647000000000001	1716224980148	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224981150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716224981150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9647000000000001	1716224981150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224982152	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716224982152	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.961	1716224982152	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	99	1716224983154	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716224983154	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.961	1716224983154	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224984156	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716224984156	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.961	1716224984156	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224985158	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716224985158	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9618	1716224985158	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224986159	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716224986159	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9618	1716224986159	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224987162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716224987162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9618	1716224987162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224988163	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716224988163	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9627000000000001	1716224988163	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224989165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716224989165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9627000000000001	1716224989165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224990167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716224990167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9627000000000001	1716224990167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224991169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716224991169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9638	1716224991169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224992172	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716224992172	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9638	1716224992172	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716224993174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716224993174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9638	1716224993174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716224994176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716224994176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9629	1716224994176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224995178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716224995178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9629	1716224995178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716224996180	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716224996180	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9629	1716224996180	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224997182	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716224997182	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9656	1716224997182	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716224998184	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716224998184	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9656	1716224998184	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224998197	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716224999186	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716224999186	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9656	1716224999186	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716224999207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225000211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225001212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225002214	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225003210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225004218	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225005222	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225006221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225007214	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225008216	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225009225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225010229	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225011233	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225012231	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225013233	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225014236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225015238	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225016240	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225017241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225018238	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225019245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225020247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225021251	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225022247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225023247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225024254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225025257	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225026257	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225027259	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225028254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225029264	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225030267	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225031268	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225032272	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225033273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225034275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225035277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225036278	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225037275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225038281	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225039282	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225040284	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225041289	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225042281	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225043285	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225044293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225045294	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225046298	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225047297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225048294	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225049301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225050302	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225051306	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225052303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225053307	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225054311	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225055313	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225056319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225057319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225058313	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225059324	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225060324	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225061326	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225062321	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225063322	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225000188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225000188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9653	1716225000188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225001190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225001190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9653	1716225001190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225002192	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225002192	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9653	1716225002192	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225003193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225003193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9594	1716225003193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225004195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225004195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9594	1716225004195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225005197	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225005197	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9594	1716225005197	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225006199	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225006199	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9653	1716225006199	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225007201	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225007201	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9653	1716225007201	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225008203	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225008203	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9653	1716225008203	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225009205	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225009205	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.967	1716225009205	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225010207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225010207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.967	1716225010207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225011208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225011208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.967	1716225011208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225012210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225012210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9630999999999998	1716225012210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225013212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225013212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9630999999999998	1716225013212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225014214	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225014214	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9630999999999998	1716225014214	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225015216	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225015216	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9639000000000002	1716225015216	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225016218	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225016218	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9639000000000002	1716225016218	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225017220	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225017220	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9639000000000002	1716225017220	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225018222	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225018222	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9654	1716225018222	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225019224	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225019224	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9654	1716225019224	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225020225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225020225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9654	1716225020225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225021227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225021227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9664000000000001	1716225021227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225022229	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225022229	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9664000000000001	1716225022229	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225023231	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225023231	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9664000000000001	1716225023231	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225024233	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225024233	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9642	1716225024233	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225025235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225025235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9642	1716225025235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225026237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225026237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9642	1716225026237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225027239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225027239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9647999999999999	1716225027239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225028241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225028241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9647999999999999	1716225028241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225029243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225029243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9647999999999999	1716225029243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225030245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225030245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9674	1716225030245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225031246	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225031246	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9674	1716225031246	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225032248	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225032248	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9674	1716225032248	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225033250	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225033250	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716225033250	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225034252	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225034252	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716225034252	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225035254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225035254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9667999999999999	1716225035254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225036256	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225036256	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9674	1716225036256	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225037258	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225037258	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9674	1716225037258	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225038260	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225038260	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9674	1716225038260	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225039261	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225039261	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9681	1716225039261	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225040263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225040263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9681	1716225040263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225041265	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225041265	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9681	1716225041265	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225042267	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225042267	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9669	1716225042267	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225043269	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225043269	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9669	1716225043269	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225044271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225044271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9669	1716225044271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225045273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225045273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225045273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225046275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225046275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225046275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225047276	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225047276	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225047276	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225048278	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225048278	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9646	1716225048278	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225049280	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225049280	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9646	1716225049280	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225050282	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225050282	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9646	1716225050282	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225051284	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225051284	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9653	1716225051284	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225052286	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225052286	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9653	1716225052286	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225053288	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225053288	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9653	1716225053288	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225054290	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225054290	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9659	1716225054290	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225055293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225055293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9659	1716225055293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225056295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225056295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9659	1716225056295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225057297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225057297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9679	1716225057297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225058299	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225058299	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9679	1716225058299	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225059301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225059301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9679	1716225059301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225060302	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225060302	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225060302	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225061304	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225061304	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225061304	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225062306	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225062306	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225062306	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225063308	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225063308	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225063308	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225064310	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225064310	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225064310	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225065312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225065312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225065312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225066313	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225066313	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.968	1716225066313	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225067316	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225067316	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.968	1716225067316	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225068317	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225068317	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.968	1716225068317	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225069319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225069319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9441	1716225069319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225070321	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225070321	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9441	1716225070321	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225071323	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225071323	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9441	1716225071323	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225072325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225072325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9693	1716225072325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225073327	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225073327	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9693	1716225073327	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225074329	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225074329	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9693	1716225074329	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225075331	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225075331	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9675	1716225075331	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225076332	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225076332	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9675	1716225076332	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225077334	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225077334	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9675	1716225077334	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225078336	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225078336	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9707000000000001	1716225078336	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225079338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225079338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9707000000000001	1716225079338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225080340	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225080340	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9707000000000001	1716225080340	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225081342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225081342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9703	1716225081342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225082344	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225082344	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9703	1716225082344	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225083346	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225083346	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9703	1716225083346	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225084348	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225084348	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9727999999999999	1716225084348	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225085350	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225064331	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225065333	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225066334	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225067338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225068330	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225069340	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225070345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225071345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225072347	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225073342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225074350	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225075354	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225076354	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225077356	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225078350	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225079354	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225080364	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225081363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225082366	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225083361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225084370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225085371	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225086376	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225087376	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225088370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225089380	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225090383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225091384	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225092378	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225093387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225094382	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225095393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225096393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225097397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225098390	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225099398	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225100400	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225101404	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225102404	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225103410	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225104409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225105409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225106411	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225107417	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225108407	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225109418	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225110419	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225111420	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225112426	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225113417	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225114427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225115429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225116430	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225117432	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9741	1716225128431	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225129433	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225129433	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9730999999999999	1716225129433	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225130435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225130435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9730999999999999	1716225130435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225131437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225131437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9730999999999999	1716225131437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225132439	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225085350	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9727999999999999	1716225085350	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225086352	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225086352	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9727999999999999	1716225086352	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225087354	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225087354	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9719	1716225087354	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225088355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225088355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9719	1716225088355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225089357	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225089357	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9719	1716225089357	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225090359	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225090359	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9718	1716225090359	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225091361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.4	1716225091361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9718	1716225091361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225092363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.5	1716225092363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9718	1716225092363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225093365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225093365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.956	1716225093365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225094367	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225094367	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.956	1716225094367	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225095369	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225095369	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.956	1716225095369	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225096371	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225096371	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9682	1716225096371	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225097373	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225097373	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9682	1716225097373	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225098375	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225098375	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9682	1716225098375	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225099377	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225099377	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9683	1716225099377	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225100379	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225100379	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9683	1716225100379	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225101381	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225101381	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9683	1716225101381	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225102383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225102383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9673	1716225102383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225103384	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225103384	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9673	1716225103384	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225104386	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225104386	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9673	1716225104386	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225105388	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225105388	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9713	1716225105388	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225106390	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225106390	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9713	1716225106390	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225107392	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225107392	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9713	1716225107392	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225108394	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225108394	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9723	1716225108394	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225109395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225109395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9723	1716225109395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225110397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225110397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9723	1716225110397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225111399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225111399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.973	1716225111399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225112401	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225112401	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.973	1716225112401	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225113403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225113403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.973	1716225113403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225114405	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225114405	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9744000000000002	1716225114405	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225115407	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225115407	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9744000000000002	1716225115407	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225116409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225116409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9744000000000002	1716225116409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225117411	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225117411	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9687999999999999	1716225117411	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225132439	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9741	1716225132439	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225133441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225133441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9741	1716225133441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225134442	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225134442	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9741	1716225134442	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225135444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225135444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9735999999999998	1716225135444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225136446	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225136446	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9735999999999998	1716225136446	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225137448	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225137448	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9735999999999998	1716225137448	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225138450	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225138450	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9746	1716225138450	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225139452	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225139452	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9746	1716225139452	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	99	1716225140454	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225140454	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9746	1716225140454	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225140477	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225141456	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225141456	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9727999999999999	1716225141456	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225141478	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225142482	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225143473	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225144482	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225145489	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225146488	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225147488	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225148490	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225149486	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225150495	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225151497	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225152500	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225153494	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225154504	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225155504	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225156506	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225157511	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225158504	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225159516	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225160519	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225161517	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225162518	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225163523	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225164522	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225165527	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225166529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225167531	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225168524	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225169538	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225170538	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225171541	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225172541	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225173537	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225174545	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225175549	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225176551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225177550	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225718573	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716225718573	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0486	1716225718573	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225719575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225719575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0486	1716225719575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225720577	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225720577	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0486	1716225720577	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225721579	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225721579	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0570999999999997	1716225721579	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225722581	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225722581	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0570999999999997	1716225722581	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225723582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225723582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0570999999999997	1716225723582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225724584	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225724584	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0578000000000003	1716225724584	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225725586	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225725586	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0578000000000003	1716225725586	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225726588	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225726588	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0578000000000003	1716225726588	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225727590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225142458	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225142458	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9727999999999999	1716225142458	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225143459	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225143459	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9727999999999999	1716225143459	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225144461	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225144461	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9741	1716225144461	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225145463	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225145463	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9741	1716225145463	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225146465	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225146465	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9741	1716225146465	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225147467	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225147467	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9746	1716225147467	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225148469	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225148469	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9746	1716225148469	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225149472	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225149472	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9746	1716225149472	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225150474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225150474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9758	1716225150474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225151476	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225151476	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9758	1716225151476	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225152478	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225152478	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9758	1716225152478	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225153480	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225153480	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9737	1716225153480	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225154482	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225154482	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9737	1716225154482	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225155484	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225155484	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9737	1716225155484	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225156486	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225156486	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9744000000000002	1716225156486	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225157488	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225157488	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9744000000000002	1716225157488	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225158490	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225158490	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9744000000000002	1716225158490	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225159492	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225159492	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9729	1716225159492	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225160494	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225160494	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9729	1716225160494	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225161496	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225161496	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9729	1716225161496	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225162498	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225162498	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9734	1716225162498	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225163500	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225163500	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9734	1716225163500	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225164502	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225164502	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9734	1716225164502	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225165504	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225165504	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9757	1716225165504	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225166507	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225166507	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9757	1716225166507	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225167509	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225167509	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9757	1716225167509	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225168511	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225168511	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9765	1716225168511	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225169512	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225169512	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9765	1716225169512	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225170514	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225170514	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9765	1716225170514	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225171516	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225171516	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9754	1716225171516	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225172518	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225172518	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9754	1716225172518	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225173520	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225173520	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9754	1716225173520	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225174522	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225174522	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9755999999999998	1716225174522	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225175524	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225175524	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9755999999999998	1716225175524	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225176526	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225176526	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9755999999999998	1716225176526	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225177527	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225177527	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9766	1716225177527	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225178529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225178529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9766	1716225178529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225178552	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225179531	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225179531	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9766	1716225179531	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225179553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225180533	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225180533	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.977	1716225180533	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225180554	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225181535	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225181535	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.977	1716225181535	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225181557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225182537	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225182537	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.977	1716225182537	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225182559	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225183539	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225183539	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9737	1716225183539	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	99	1716225184541	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225184541	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9737	1716225184541	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225185543	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225185543	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9737	1716225185543	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225186545	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225186545	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9744000000000002	1716225186545	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225187546	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225187546	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9744000000000002	1716225187546	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225188548	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225188548	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9744000000000002	1716225188548	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225189550	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225189550	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9743	1716225189550	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225190553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225190553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9743	1716225190553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225191555	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225191555	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9743	1716225191555	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225192557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225192557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9755999999999998	1716225192557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225193558	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225193558	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9755999999999998	1716225193558	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225194560	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225194560	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9755999999999998	1716225194560	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225195562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225195562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9775	1716225195562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225196564	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225196564	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9775	1716225196564	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225197566	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225197566	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9775	1716225197566	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225198568	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225198568	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9766	1716225198568	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225199570	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225199570	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9766	1716225199570	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225200571	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225200571	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9766	1716225200571	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225201573	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225201573	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.978	1716225201573	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225202575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225202575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.978	1716225202575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225203577	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225203577	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.978	1716225203577	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225204579	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225183553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225184555	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225185563	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225186558	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225187567	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225188568	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225189571	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225190574	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225191575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225192578	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225193580	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225194575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225195585	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225196589	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225197590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225198582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225199583	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225200592	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225201597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225202597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225203591	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225204600	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225205603	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225206605	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225207601	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225208602	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225209613	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225210614	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225211617	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225212619	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225213617	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225214621	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225215616	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225216625	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225217627	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225218621	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225219632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225220635	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225221637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225222640	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225223639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225224632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225225645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225226650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225227648	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225228644	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225229652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225230659	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225231654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225232656	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225233652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225234663	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225235664	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225236665	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225237667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225238671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225239662	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225240673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225241674	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225242670	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225243672	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225244675	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225245685	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225246688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225247686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225204579	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9789	1716225204579	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225205581	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225205581	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9789	1716225205581	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225206583	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225206583	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9789	1716225206583	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225207586	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225207586	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9761	1716225207586	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225208588	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225208588	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9761	1716225208588	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225209590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225209590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9761	1716225209590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225210592	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225210592	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9768	1716225210592	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225211594	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225211594	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9768	1716225211594	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225212596	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225212596	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9768	1716225212596	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225213598	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225213598	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.977	1716225213598	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225214600	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225214600	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.977	1716225214600	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	105	1716225215602	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225215602	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.977	1716225215602	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225216604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225216604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9788	1716225216604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225217606	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225217606	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9788	1716225217606	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225218608	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225218608	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9788	1716225218608	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225219610	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225219610	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9786	1716225219610	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225220612	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225220612	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9786	1716225220612	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225221613	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225221613	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9786	1716225221613	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225222615	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225222615	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.979	1716225222615	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225223617	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225223617	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.979	1716225223617	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225224619	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225224619	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.979	1716225224619	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225225622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225225622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9777	1716225225622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225226624	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225226624	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9777	1716225226624	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225227625	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225227625	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9777	1716225227625	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225228628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225228628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9750999999999999	1716225228628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225229630	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225229630	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9750999999999999	1716225229630	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225230632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225230632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9750999999999999	1716225230632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225231633	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225231633	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9784000000000002	1716225231633	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225232635	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225232635	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9784000000000002	1716225232635	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225233637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225233637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9784000000000002	1716225233637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225234639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225234639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9794	1716225234639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225235641	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225235641	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9794	1716225235641	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225236643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225236643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9794	1716225236643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225237645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225237645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9794	1716225237645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225238647	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225238647	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9794	1716225238647	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225239649	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225239649	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9794	1716225239649	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225240651	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225240651	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9790999999999999	1716225240651	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225241653	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225241653	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9790999999999999	1716225241653	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225242655	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225242655	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9790999999999999	1716225242655	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225243657	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225243657	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9781	1716225243657	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225244659	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225244659	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9781	1716225244659	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225245661	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225245661	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9781	1716225245661	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225246663	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225246663	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9784000000000002	1716225246663	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225247665	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225247665	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9784000000000002	1716225247665	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225248667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.6	1716225248667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9784000000000002	1716225248667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225249669	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.5	1716225249669	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9766	1716225249669	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225250671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225250671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9766	1716225250671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225251672	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225251672	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9766	1716225251672	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225252674	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225252674	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9795999999999998	1716225252674	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225253676	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225253676	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9795999999999998	1716225253676	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225254678	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225254678	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9795999999999998	1716225254678	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225255680	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225255680	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.979	1716225255680	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225256682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225256682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.979	1716225256682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225257684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225257684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.979	1716225257684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225258686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225258686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9813	1716225258686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225259688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225259688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9813	1716225259688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225260690	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225260690	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9813	1716225260690	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225261691	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225261691	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9812	1716225261691	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225262693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225262693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9812	1716225262693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225263695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225263695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9812	1716225263695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225264697	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225264697	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9809	1716225264697	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225265700	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225265700	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9809	1716225265700	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225266702	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225266702	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9809	1716225266702	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225267704	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225267704	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9807000000000001	1716225267704	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225268706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225248683	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225249685	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225250692	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225251693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225252688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225253698	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225254692	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225255702	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225256707	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225257698	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225258709	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225259701	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225260715	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225261712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225262707	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225263715	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225264711	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225265722	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225266723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225267726	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225268732	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225269721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225270733	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225271735	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225272728	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225273729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225274738	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225275740	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225276742	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225277744	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225278742	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225279747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225280751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225281755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225282753	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225283756	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225284757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225285759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225286763	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225287765	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225288758	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225289769	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225290767	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225291776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225292774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225293768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225294775	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225295780	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225296779	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225297772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225298782	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225299784	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225300786	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225301788	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225302782	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225303793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225304792	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225305798	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225306800	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225307792	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225308803	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225309804	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225310804	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225311808	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225312801	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225268706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9807000000000001	1716225268706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225269708	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225269708	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9807000000000001	1716225269708	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225270710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225270710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9789	1716225270710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225271712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225271712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9789	1716225271712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225272713	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225272713	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9789	1716225272713	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225273715	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225273715	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9802	1716225273715	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225274717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225274717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9802	1716225274717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225275719	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225275719	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9802	1716225275719	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225276721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225276721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9815999999999998	1716225276721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225277723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225277723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9815999999999998	1716225277723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225278725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225278725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9815999999999998	1716225278725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225279727	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225279727	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9815	1716225279727	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225280729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225280729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9815	1716225280729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225281730	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225281730	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9815	1716225281730	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225282732	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225282732	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9821	1716225282732	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225283733	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225283733	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9821	1716225283733	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225284735	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225284735	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9821	1716225284735	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225285737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225285737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9835	1716225285737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225286739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225286739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9835	1716225286739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225287741	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225287741	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9835	1716225287741	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225288743	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225288743	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.984	1716225288743	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225289745	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225289745	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.984	1716225289745	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225290747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225290747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.984	1716225290747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225291749	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225291749	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.985	1716225291749	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225292750	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225292750	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.985	1716225292750	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225293752	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225293752	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.985	1716225293752	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225294754	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225294754	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9810999999999999	1716225294754	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225295755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225295755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9810999999999999	1716225295755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225296757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225296757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9810999999999999	1716225296757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225297759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225297759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9798	1716225297759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225298761	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225298761	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9798	1716225298761	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225299763	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225299763	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9798	1716225299763	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225300765	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225300765	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9814	1716225300765	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225301766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225301766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9814	1716225301766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225302768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225302768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9814	1716225302768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225303770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225303770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9828	1716225303770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225304772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225304772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9828	1716225304772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225305774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225305774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9828	1716225305774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225306776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225306776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9826	1716225306776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225307778	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225307778	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9826	1716225307778	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225308780	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225308780	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9826	1716225308780	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225309782	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225309782	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9818	1716225309782	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225310784	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225310784	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9818	1716225310784	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225311785	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225311785	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9818	1716225311785	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225312787	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225312787	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9801	1716225312787	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225313789	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225313789	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9801	1716225313789	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225314791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225314791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9801	1716225314791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225315793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225315793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9747000000000001	1716225315793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225316797	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225316797	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9747000000000001	1716225316797	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225317799	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225317799	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9747000000000001	1716225317799	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225318802	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225318802	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9813	1716225318802	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225319805	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225319805	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9813	1716225319805	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225320807	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225320807	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9813	1716225320807	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225321810	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225321810	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9837	1716225321810	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225322812	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225322812	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9837	1716225322812	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225323814	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225323814	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9837	1716225323814	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225324816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225324816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9848	1716225324816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225325818	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225325818	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9848	1716225325818	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225326820	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225326820	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9848	1716225326820	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225327821	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225327821	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9857	1716225327821	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225328823	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225328823	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9857	1716225328823	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225329825	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225329825	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9857	1716225329825	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225330827	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225330827	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.983	1716225330827	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225331829	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225331829	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.983	1716225331829	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225332831	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225313810	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225314804	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225315814	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225316819	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225317819	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225318816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225319827	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225320833	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225321832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225322834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225323829	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225324839	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225325839	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225326841	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225327843	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225328846	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225329847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225330847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225331851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225332852	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225333855	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225334851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225335859	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225336859	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225337863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225338862	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225339865	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225340867	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225341869	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225342872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225343873	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225344871	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225345870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225346881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225347881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225348878	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225349887	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225350888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225351891	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225352891	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225353886	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225354894	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225355897	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225356899	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225357903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225718596	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225719598	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225720601	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225721600	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225722597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225723595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225724598	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225725603	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225726612	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225727604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225728613	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225729618	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225730622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225731620	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225732615	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225733623	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225734625	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225735629	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225736631	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225737632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225332831	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.983	1716225332831	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225333832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225333832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9834	1716225333832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225334834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225334834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9834	1716225334834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225335836	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225335836	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9834	1716225335836	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225336838	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225336838	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.984	1716225336838	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225337840	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225337840	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.984	1716225337840	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225338842	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225338842	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.984	1716225338842	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225339843	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225339843	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9801	1716225339843	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225340845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225340845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9801	1716225340845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225341847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225341847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9801	1716225341847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225342849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225342849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9810999999999999	1716225342849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225343851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225343851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9810999999999999	1716225343851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225344853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225344853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9810999999999999	1716225344853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225345856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225345856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9835999999999998	1716225345856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225346858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225346858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9835999999999998	1716225346858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225347860	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225347860	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9835999999999998	1716225347860	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225348863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225348863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9825	1716225348863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225349865	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225349865	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9825	1716225349865	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225350866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225350866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9825	1716225350866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225351868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225351868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9866	1716225351868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225352870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225352870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9866	1716225352870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225353872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225353872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9866	1716225353872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225354874	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225354874	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9849	1716225354874	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225355876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225355876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9849	1716225355876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225356878	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225356878	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9849	1716225356878	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225357880	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225357880	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9859	1716225357880	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225358881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225358881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9859	1716225358881	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225358904	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225359883	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.7	1716225359883	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9859	1716225359883	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225359905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225360885	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.6	1716225360885	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9858	1716225360885	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225360910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225361887	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225361887	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9858	1716225361887	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225361911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225362889	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225362889	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9858	1716225362889	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225362911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225363891	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225363891	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9859	1716225363891	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225363905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225364893	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225364893	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9859	1716225364893	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225364915	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225365895	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225365895	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9859	1716225365895	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225365918	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225366896	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225366896	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9855	1716225366896	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225366918	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225367898	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225367898	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9855	1716225367898	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225367922	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225368900	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225368900	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9855	1716225368900	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225368916	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225369902	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225369902	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9838	1716225369902	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225369924	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225370904	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225370904	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9838	1716225370904	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225370925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225371928	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225372933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225373934	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225374934	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225375930	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225376938	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225377938	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225378934	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225379941	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225380944	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225381952	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225382948	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225383942	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225384951	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225385955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225386956	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225387958	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225388961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225389963	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225390965	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225391964	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225392969	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225393962	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225394967	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225395973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225396975	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225397978	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225398979	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225399980	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225400982	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225401983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225402984	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225403981	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225404990	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225405983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225406993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225407996	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225408990	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225410000	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225411000	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225412002	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225413004	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225413998	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225415009	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225416013	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225417012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225418007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225419009	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225420023	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225421012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225422024	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225423016	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225424026	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225425031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225426023	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225427033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225428030	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225429039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225430039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225431035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225432041	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225433038	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225434049	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225435046	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225371906	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225371906	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9838	1716225371906	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225372908	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225372908	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9849	1716225372908	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225373910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225373910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9849	1716225373910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225374911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225374911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9849	1716225374911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225375913	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225375913	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9872	1716225375913	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225376915	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225376915	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9872	1716225376915	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225377917	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225377917	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9872	1716225377917	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225378919	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225378919	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9895	1716225378919	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225379921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225379921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9895	1716225379921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225380922	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225380922	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9895	1716225380922	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225381925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225381925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9879	1716225381925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225382926	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225382926	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9879	1716225382926	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225383928	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225383928	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9879	1716225383928	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225384930	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225384930	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9882	1716225384930	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225385932	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225385932	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9882	1716225385932	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225386934	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225386934	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9882	1716225386934	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225387936	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225387936	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9895	1716225387936	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225388938	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225388938	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9895	1716225388938	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225389940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225389940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9895	1716225389940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225390942	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225390942	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9892999999999998	1716225390942	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225391943	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225391943	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9892999999999998	1716225391943	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225392945	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225392945	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9892999999999998	1716225392945	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225393947	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225393947	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9914	1716225393947	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225394949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225394949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9914	1716225394949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225395951	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225395951	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9914	1716225395951	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225396953	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225396953	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9938	1716225396953	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225397955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225397955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9938	1716225397955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225398956	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225398956	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9938	1716225398956	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225399958	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225399958	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9914	1716225399958	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225400960	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225400960	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9914	1716225400960	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225401962	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225401962	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9914	1716225401962	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225402964	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225402964	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9906	1716225402964	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225403966	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225403966	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9906	1716225403966	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225404968	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225404968	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9906	1716225404968	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225405970	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225405970	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9895	1716225405970	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225406971	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225406971	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9895	1716225406971	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225407973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225407973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9895	1716225407973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225408975	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225408975	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9906	1716225408975	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225409977	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225409977	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9906	1716225409977	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225410979	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225410979	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9906	1716225410979	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225411981	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225411981	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9892999999999998	1716225411981	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225412983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225412983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9892999999999998	1716225412983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225413985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225413985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9892999999999998	1716225413985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225414986	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225414986	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9894	1716225414986	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225415990	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.200000000000001	1716225415990	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9894	1716225415990	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225416991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225416991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9894	1716225416991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225417993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225417993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9906	1716225417993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225418995	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225418995	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9906	1716225418995	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225419997	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225419997	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9906	1716225419997	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225420999	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225420999	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.992	1716225420999	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225422001	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225422001	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.992	1716225422001	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225423003	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225423003	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.992	1716225423003	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225424005	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225424005	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9915	1716225424005	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225425007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225425007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9915	1716225425007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225426008	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225426008	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9915	1716225426008	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225427010	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225427010	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9886	1716225427010	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225428012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225428012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9886	1716225428012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225429014	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225429014	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9886	1716225429014	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225430016	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225430016	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9899	1716225430016	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225431018	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225431018	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9899	1716225431018	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225432020	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225432020	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9899	1716225432020	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225433021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225433021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9890999999999999	1716225433021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225434023	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225434023	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9890999999999999	1716225434023	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225435025	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225435025	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9890999999999999	1716225435025	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225436027	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225436027	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9887000000000001	1716225436027	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225437029	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225437029	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9887000000000001	1716225437029	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225438031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225438031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9887000000000001	1716225438031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225439033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225439033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9892999999999998	1716225439033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225440035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225440035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9892999999999998	1716225440035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225441037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225441037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9892999999999998	1716225441037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225442039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225442039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9901	1716225442039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225443040	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225443040	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9901	1716225443040	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225444044	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225444044	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9901	1716225444044	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225445046	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225445046	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9888	1716225445046	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225446048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225446048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9888	1716225446048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225447050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225447050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9888	1716225447050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225448051	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225448051	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.987	1716225448051	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225449053	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225449053	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.987	1716225449053	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225450055	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225450055	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.987	1716225450055	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225451058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225451058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9835	1716225451058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225452060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225452060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9835	1716225452060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225453062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225453062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9835	1716225453062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225454065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225454065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9862	1716225454065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225455067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225455067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9862	1716225455067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225456068	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225456068	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9862	1716225456068	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225457070	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225436043	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225437050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225438046	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225439054	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225440060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225441050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225442060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225443054	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225444060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225445066	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225446062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225447070	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225448074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225449074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225450080	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225451073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225452087	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225453077	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225454087	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225455092	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225456083	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225457091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225458090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225459097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225460100	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225461096	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225462102	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225463096	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225464105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225465099	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225466110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225467113	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225468116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225469111	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225470121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225471122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225472124	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225473124	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225474119	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225475124	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225476129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225477133	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225478126	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225479137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225480138	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225481141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225482141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225483144	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225484145	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225485147	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225486151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225487151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225488155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225489155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225490156	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225491158	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225492161	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225493156	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225494165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225495167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225496169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225497174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225498172	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225499166	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225500178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225457070	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9879	1716225457070	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225458072	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225458072	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9879	1716225458072	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225459074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225459074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9879	1716225459074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225460076	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225460076	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9908	1716225460076	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225461078	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225461078	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9908	1716225461078	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225462080	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.7	1716225462080	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9908	1716225462080	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225463082	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225463082	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9915	1716225463082	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225464083	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225464083	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9915	1716225464083	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225465085	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225465085	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9915	1716225465085	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225466087	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225466087	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9908	1716225466087	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225467090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225467090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9908	1716225467090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225468092	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225468092	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9908	1716225468092	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225469094	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225469094	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9932	1716225469094	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225470097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225470097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9932	1716225470097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225471099	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225471099	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9932	1716225471099	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225472101	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225472101	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9930999999999999	1716225472101	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225473103	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225473103	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9930999999999999	1716225473103	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225474105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225474105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9930999999999999	1716225474105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225475107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225475107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9908	1716225475107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225476109	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225476109	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9908	1716225476109	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225477111	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225477111	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9908	1716225477111	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225478112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225478112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.994	1716225478112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225479114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225479114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.994	1716225479114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225480116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225480116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.994	1716225480116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225481118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225481118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225481118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225482120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225482120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225482120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225483121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225483121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9702	1716225483121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225484124	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225484124	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9755	1716225484124	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225485125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225485125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9755	1716225485125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225486127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225486127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9755	1716225486127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225487129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225487129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9784000000000002	1716225487129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225488131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.700000000000001	1716225488131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9784000000000002	1716225488131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225489133	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.800000000000001	1716225489133	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9784000000000002	1716225489133	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225490135	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225490135	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9779	1716225490135	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225491137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225491137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9779	1716225491137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225492139	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225492139	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9779	1716225492139	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225493141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225493141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9815	1716225493141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225494143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225494143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9815	1716225494143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225495145	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225495145	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9815	1716225495145	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225496147	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225496147	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9839	1716225496147	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225497149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225497149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9839	1716225497149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225498151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225498151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9839	1716225498151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225499153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225499153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9926	1716225499153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225500155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225500155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9926	1716225500155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225501157	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225501157	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9926	1716225501157	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225502158	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225502158	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9775999999999998	1716225502158	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225503160	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225503160	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9775999999999998	1716225503160	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225504162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225504162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9775999999999998	1716225504162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225505165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225505165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9823	1716225505165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225506167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225506167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9823	1716225506167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225507169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225507169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9823	1716225507169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225508171	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225508171	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9959	1716225508171	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225509173	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225509173	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9959	1716225509173	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225510174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225510174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9959	1716225510174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225511176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225511176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9965	1716225511176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225512178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225512178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9965	1716225512178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225513181	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225513181	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9965	1716225513181	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225514183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225514183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9987000000000001	1716225514183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225515185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225515185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9987000000000001	1716225515185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225516187	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225516187	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9987000000000001	1716225516187	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225517189	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225517189	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9998	1716225517189	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225518191	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225518191	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9998	1716225518191	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225519193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225519193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9998	1716225519193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225520194	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716225520194	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9959	1716225520194	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225521196	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225501178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225502180	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225503186	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225504176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225505189	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225506188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225507192	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225508184	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225509195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225510198	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225511196	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225512191	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225513196	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225514207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225515198	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225516213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225517210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225518208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225519219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225520218	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225521219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225522220	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225523213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225524229	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225525225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225526227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225527230	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225528225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225529236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225530235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225531237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225532240	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225533237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225534243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225535245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225536246	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225537250	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225727590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0601	1716225727590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225728593	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225728593	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0601	1716225728593	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225729595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225729595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0601	1716225729595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225730597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225730597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0609	1716225730597	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225731598	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225731598	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0609	1716225731598	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225732600	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225732600	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0609	1716225732600	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225733602	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225733602	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0594	1716225733602	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225734604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225734604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0594	1716225734604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225735606	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225735606	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0594	1716225735606	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225736608	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225736608	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225521196	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9959	1716225521196	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225522198	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225522198	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9959	1716225522198	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225523200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225523200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9977	1716225523200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225524201	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225524201	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9977	1716225524201	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225525203	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225525203	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9977	1716225525203	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225526205	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225526205	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9974	1716225526205	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225527208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225527208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9974	1716225527208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225528209	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225528209	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9974	1716225528209	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225529211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225529211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9990999999999999	1716225529211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225530213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225530213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9990999999999999	1716225530213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225531215	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225531215	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9990999999999999	1716225531215	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225532217	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225532217	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9990999999999999	1716225532217	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225533219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225533219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9990999999999999	1716225533219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225534221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225534221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9990999999999999	1716225534221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225535223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225535223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9992999999999999	1716225535223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225536224	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225536224	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9992999999999999	1716225536224	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225537226	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225537226	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9992999999999999	1716225537226	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225538228	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225538228	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9975	1716225538228	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225538247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225539230	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225539230	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9975	1716225539230	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225539256	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225540232	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225540232	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9975	1716225540232	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225540253	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225541234	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225541234	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9970999999999999	1716225541234	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225542236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225542236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9970999999999999	1716225542236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225543237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225543237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9970999999999999	1716225543237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225544239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225544239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9978	1716225544239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225545243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225545243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9978	1716225545243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225546245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225546245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9978	1716225546245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225547247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225547247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9990999999999999	1716225547247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225548249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225548249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9990999999999999	1716225548249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225549250	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225549250	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9990999999999999	1716225549250	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225550252	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225550252	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0032	1716225550252	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225551254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225551254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0032	1716225551254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225552256	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225552256	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0032	1716225552256	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225553257	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225553257	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0036	1716225553257	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225554260	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225554260	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0036	1716225554260	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225555262	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225555262	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0036	1716225555262	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225556264	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225556264	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0037000000000003	1716225556264	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225557266	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225557266	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0037000000000003	1716225557266	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225558268	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225558268	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0037000000000003	1716225558268	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225559270	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225559270	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0028	1716225559270	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225560271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225560271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0028	1716225560271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225561273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225561273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0028	1716225561273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225562275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225562275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0013	1716225562275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225541258	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225542254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225543251	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225544267	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225545263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225546262	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225547268	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225548263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225549273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225550274	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225551276	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225552271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225553279	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225554281	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225555285	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225556287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225557287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225558281	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225559291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225560297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225561296	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225562296	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225563291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225564301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225565303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225566310	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225567308	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225568306	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225569311	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225570312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225571312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225572307	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225573309	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225574318	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225575322	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225576313	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225577322	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225578319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225579330	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225580330	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225581331	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225582333	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225583336	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225584342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225585339	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225586341	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225587343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225588340	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225589348	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225590346	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225591345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225592354	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225593346	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225594356	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225595358	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225596363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225597361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225598363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225599365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225600367	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225601368	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225602370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225603366	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225604375	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225605377	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225563277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225563277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0013	1716225563277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225564278	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225564278	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0013	1716225564278	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225565280	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225565280	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0032	1716225565280	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225566281	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225566281	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0032	1716225566281	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225567283	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225567283	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0032	1716225567283	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225568285	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225568285	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.003	1716225568285	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225569287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225569287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.003	1716225569287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225570289	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225570289	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.003	1716225570289	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225571291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225571291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0011	1716225571291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225572293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225572293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0011	1716225572293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225573295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225573295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0011	1716225573295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225574297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225574297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0054000000000003	1716225574297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225575298	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225575298	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0054000000000003	1716225575298	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225576300	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225576300	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0054000000000003	1716225576300	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225577301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225577301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.004	1716225577301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225578303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225578303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.004	1716225578303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225579306	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225579306	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.004	1716225579306	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225580308	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225580308	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0054000000000003	1716225580308	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225581310	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225581310	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0054000000000003	1716225581310	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225582312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225582312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0054000000000003	1716225582312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225583314	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225583314	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9972999999999999	1716225583314	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225584316	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225584316	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9972999999999999	1716225584316	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225585317	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225585317	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	1.9972999999999999	1716225585317	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225586319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225586319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0040999999999998	1716225586319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225587321	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225587321	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0040999999999998	1716225587321	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225588323	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225588323	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0040999999999998	1716225588323	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225589325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225589325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0054000000000003	1716225589325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225590327	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225590327	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0054000000000003	1716225590327	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225591329	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225591329	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0054000000000003	1716225591329	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225592331	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225592331	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0059	1716225592331	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225593333	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225593333	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0059	1716225593333	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225594334	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225594334	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0059	1716225594334	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225595336	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225595336	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0138	1716225595336	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225596338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225596338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0138	1716225596338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225597340	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225597340	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0138	1716225597340	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225598342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225598342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0174000000000003	1716225598342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225599343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225599343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0174000000000003	1716225599343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225600345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225600345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0174000000000003	1716225600345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225601347	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225601347	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0161	1716225601347	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225602349	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225602349	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0161	1716225602349	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225603351	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225603351	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0161	1716225603351	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225604353	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225604353	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0072	1716225604353	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225605355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225605355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0072	1716225605355	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225606357	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225606357	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0072	1716225606357	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225607359	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225607359	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0165	1716225607359	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225608361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225608361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0165	1716225608361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225609363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225609363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0165	1716225609363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225610365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225610365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0213	1716225610365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225611367	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225611367	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0213	1716225611367	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225612368	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716225612368	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0213	1716225612368	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225613370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225613370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0189	1716225613370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225614372	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225614372	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0189	1716225614372	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225615374	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225615374	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0189	1716225615374	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225616376	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225616376	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0329	1716225616376	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225617378	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225617378	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0329	1716225617378	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225618380	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225618380	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0329	1716225618380	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225619382	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225619382	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0322999999999998	1716225619382	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225620383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225620383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0322999999999998	1716225620383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225621385	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225621385	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0322999999999998	1716225621385	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225622387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225622387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0357	1716225622387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225623389	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225623389	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0357	1716225623389	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225624391	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225624391	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0357	1716225624391	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225625393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225625393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0375	1716225625393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225626395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225626395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0375	1716225626395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225606371	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225607380	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225608376	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225609384	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225610387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225611390	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225612390	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225613394	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225614394	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225615397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225616397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225617399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225618395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225619404	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225620406	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225621400	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225622410	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225623403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225624409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225625407	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225626412	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225627419	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225628425	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225629415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225630427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225631424	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225632428	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225633427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225634433	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225635433	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225636435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225637438	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225638441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225639441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225640435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225641446	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225642446	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225643446	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225644450	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225645451	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225646444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225647455	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225648449	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225649457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225650459	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225651461	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225652463	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225653458	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225654468	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225655470	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225656473	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225657474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225658477	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225659481	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225660482	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225661490	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225662487	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225663491	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225664488	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225665491	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225666493	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225667494	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225668491	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225669498	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225670501	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225627397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225627397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0375	1716225627397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225628399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225628399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0407	1716225628399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225629400	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225629400	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0407	1716225629400	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225630402	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225630402	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0407	1716225630402	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225631403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225631403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0519000000000003	1716225631403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225632405	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225632405	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0519000000000003	1716225632405	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225633407	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225633407	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0519000000000003	1716225633407	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225634409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225634409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0587	1716225634409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225635411	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225635411	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0587	1716225635411	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225636413	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225636413	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0587	1716225636413	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225637415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225637415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0599000000000003	1716225637415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225638417	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225638417	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0599000000000003	1716225638417	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225639419	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225639419	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0599000000000003	1716225639419	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225640420	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225640420	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0584000000000002	1716225640420	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225641422	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.9	1716225641422	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0584000000000002	1716225641422	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225642423	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225642423	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0584000000000002	1716225642423	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225643425	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.8	1716225643425	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0609	1716225643425	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225644427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225644427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0609	1716225644427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225645429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225645429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0609	1716225645429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225646431	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225646431	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0605	1716225646431	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225647433	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225647433	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0605	1716225647433	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225648435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225648435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0605	1716225648435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225649437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225649437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0599000000000003	1716225649437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225650439	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225650439	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0599000000000003	1716225650439	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225651441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225651441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0599000000000003	1716225651441	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225652442	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225652442	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0618000000000003	1716225652442	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225653444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225653444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0618000000000003	1716225653444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225654448	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225654448	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0618000000000003	1716225654448	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225655450	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225655450	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0619	1716225655450	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225656451	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225656451	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0619	1716225656451	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225657453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225657453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0619	1716225657453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225658455	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225658455	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.063	1716225658455	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225659457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225659457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.063	1716225659457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225660459	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225660459	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.063	1716225660459	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225661461	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225661461	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0650999999999997	1716225661461	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225662464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225662464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0650999999999997	1716225662464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225663466	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225663466	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0650999999999997	1716225663466	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225664468	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225664468	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0659	1716225664468	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225665470	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225665470	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0659	1716225665470	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225666472	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225666472	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0659	1716225666472	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225667474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225667474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0659	1716225667474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225668475	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225668475	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0659	1716225668475	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225669477	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225669477	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0659	1716225669477	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225670479	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225670479	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225670479	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225671481	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225671481	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225671481	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225672483	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225672483	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225672483	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225673485	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225673485	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0656	1716225673485	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225674487	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225674487	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0656	1716225674487	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225675489	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225675489	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0656	1716225675489	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225676491	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225676491	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0602	1716225676491	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225677492	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225677492	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0602	1716225677492	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225678494	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225678494	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0602	1716225678494	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225679496	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225679496	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.061	1716225679496	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225680498	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225680498	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.061	1716225680498	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225681501	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225681501	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.061	1716225681501	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225682503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225682503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0631	1716225682503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225683505	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225683505	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0631	1716225683505	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225684507	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225684507	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0631	1716225684507	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225685509	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225685509	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0636	1716225685509	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225686510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225686510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0636	1716225686510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225687511	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225687511	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0636	1716225687511	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225688513	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225688513	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0668	1716225688513	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225689515	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225689515	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0668	1716225689515	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225690517	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225690517	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0668	1716225690517	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225671503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225672503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225673505	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225674502	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225675509	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225676511	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225677514	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225678508	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225679519	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225680526	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225681526	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225682528	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225683521	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225684531	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225685533	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225686533	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225687525	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225688534	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225689530	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225690539	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225691544	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225692545	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225693537	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225694547	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225695551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225696553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225697554	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225698551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225699559	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225700562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225701562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225702565	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225703566	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225704572	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225705572	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225706575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225707567	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225708568	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225709577	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225710580	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225711580	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225712585	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225713582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225714593	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225715589	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225716591	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225717585	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.06	1716225736608	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225737610	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225737610	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.06	1716225737610	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225738612	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225738612	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.06	1716225738612	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225739614	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225739614	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0598	1716225739614	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225740617	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225740617	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0598	1716225740617	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225741620	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225741620	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0598	1716225741620	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225742622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225742622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225691519	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225691519	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0676	1716225691519	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225692522	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225692522	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0676	1716225692522	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225693524	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225693524	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0676	1716225693524	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225694526	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225694526	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0678	1716225694526	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225695529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225695529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0678	1716225695529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225696532	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225696532	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0678	1716225696532	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225697534	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225697534	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0653	1716225697534	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225698535	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225698535	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0653	1716225698535	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225699537	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225699537	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0653	1716225699537	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225700539	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225700539	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.051	1716225700539	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225701541	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225701541	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.051	1716225701541	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225702543	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225702543	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.051	1716225702543	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225703545	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225703545	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0522	1716225703545	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225704547	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225704547	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0522	1716225704547	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225705549	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225705549	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0522	1716225705549	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225706551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225706551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0545999999999998	1716225706551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225707553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225707553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0545999999999998	1716225707553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225708554	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225708554	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0545999999999998	1716225708554	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225709556	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225709556	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0572	1716225709556	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225710558	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225710558	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0572	1716225710558	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225711560	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225711560	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0572	1716225711560	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225712562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225712562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0559000000000003	1716225712562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225713563	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225713563	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0559000000000003	1716225713563	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225714565	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225714565	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0559000000000003	1716225714565	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225715567	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225715567	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0562	1716225715567	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225716569	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225716569	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0562	1716225716569	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225717571	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225717571	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0562	1716225717571	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225738629	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225739631	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225740640	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225741646	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0585999999999998	1716225742622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225742644	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225743626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225743626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0585999999999998	1716225743626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225743641	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225744628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225744628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0585999999999998	1716225744628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225744649	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225745630	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225745630	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0601	1716225745630	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225745653	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225746632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225746632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0601	1716225746632	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225746654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225747634	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225747634	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0601	1716225747634	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225747649	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225748636	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225748636	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0612	1716225748636	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225748657	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225749637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225749637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0612	1716225749637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225749661	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225750639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225750639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0612	1716225750639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225750662	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225751641	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225751641	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0616	1716225751641	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225751664	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225752643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225752643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0616	1716225752643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225752666	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225753645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225753645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0616	1716225753645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225754647	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225754647	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0634	1716225754647	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225755649	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225755649	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0634	1716225755649	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225756650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225756650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0634	1716225756650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225757652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225757652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0627	1716225757652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225758653	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225758653	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0627	1716225758653	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225759655	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225759655	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0627	1716225759655	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225760657	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225760657	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0635	1716225760657	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225761659	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225761659	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0635	1716225761659	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225762660	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225762660	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0635	1716225762660	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225763662	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225763662	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0385	1716225763662	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225764664	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225764664	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0385	1716225764664	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225765667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225765667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0385	1716225765667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225766669	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225766669	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0625999999999998	1716225766669	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225767671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225767671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0625999999999998	1716225767671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225768673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225768673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0625999999999998	1716225768673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225769674	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225769674	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0644	1716225769674	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225770676	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225770676	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0644	1716225770676	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225771678	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225771678	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0644	1716225771678	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225772680	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225772680	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0646999999999998	1716225772680	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225773682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225773682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0646999999999998	1716225773682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225774684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225774684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225753660	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225754671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225755673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225756671	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225757674	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225758667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225759677	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225760679	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225761685	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225762682	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225763684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225764678	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225765689	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225766690	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225767692	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225768692	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225769696	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225770698	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225771700	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225772702	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225773698	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225774706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225775706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225776709	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225777710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225778713	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225779717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225780719	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225781724	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225782726	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225783719	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225784722	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225785730	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225786724	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225787736	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225788730	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225789729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225790740	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225791748	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225792748	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225793751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225794739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225795741	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225796751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225797753	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225798747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225799749	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225800754	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225801760	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225802762	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225803758	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225804759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225805767	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225806771	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225807772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225808773	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225809779	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225810770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225811779	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225812783	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225813777	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225814788	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225815785	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225816783	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225817790	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0646999999999998	1716225774684	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225775686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225775686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0671	1716225775686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225776688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225776688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0671	1716225776688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225777689	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225777689	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0671	1716225777689	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225778691	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225778691	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225778691	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225779693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225779693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225779693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225780697	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225780697	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225780697	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225781700	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225781700	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0563000000000002	1716225781700	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225782702	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225782702	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0563000000000002	1716225782702	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225783704	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225783704	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0563000000000002	1716225783704	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225784706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225784706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0595	1716225784706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225785707	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225785707	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0595	1716225785707	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225786709	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225786709	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0595	1716225786709	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225787711	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225787711	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.059	1716225787711	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225788713	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225788713	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.059	1716225788713	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225789715	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225789715	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.059	1716225789715	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225790717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225790717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0522	1716225790717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225791720	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7	1716225791720	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0522	1716225791720	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225792723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.9	1716225792723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0522	1716225792723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225793724	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225793724	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0561	1716225793724	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225794726	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225794726	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0561	1716225794726	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225795728	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225795728	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0561	1716225795728	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225796730	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225796730	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0585	1716225796730	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225797732	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225797732	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0585	1716225797732	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225798734	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225798734	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0585	1716225798734	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225799736	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225799736	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0565	1716225799736	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225800737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225800737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0565	1716225800737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225801739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225801739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0565	1716225801739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225802741	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225802741	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.06	1716225802741	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225803743	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225803743	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.06	1716225803743	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225804745	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225804745	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.06	1716225804745	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225805747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225805747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0636	1716225805747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225806749	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225806749	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0636	1716225806749	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225807751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225807751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0636	1716225807751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225808753	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225808753	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0612	1716225808753	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225809755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225809755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0612	1716225809755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225810757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225810757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0612	1716225810757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225811759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225811759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0622	1716225811759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225812760	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225812760	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0622	1716225812760	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225813762	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225813762	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0622	1716225813762	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225814764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225814764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0628	1716225814764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225815766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225815766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0628	1716225815766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225816768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225816768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0628	1716225816768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225817770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225817770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0631999999999997	1716225817770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225818772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225818772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0631999999999997	1716225818772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225819774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225819774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0631999999999997	1716225819774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225820776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225820776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225820776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225821778	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225821778	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225821778	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225822780	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225822780	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225822780	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225823781	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225823781	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0656999999999996	1716225823781	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225824783	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225824783	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0656999999999996	1716225824783	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225825786	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225825786	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0656999999999996	1716225825786	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225826789	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225826789	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0665	1716225826789	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225827791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225827791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0665	1716225827791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225828793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225828793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0665	1716225828793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	99	1716225829795	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225829795	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0605	1716225829795	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225830796	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225830796	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0605	1716225830796	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225831798	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225831798	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0605	1716225831798	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225832800	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225832800	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0629	1716225832800	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225833801	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225833801	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0629	1716225833801	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225834803	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225834803	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0629	1716225834803	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225835805	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225835805	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0641	1716225835805	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225836807	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225836807	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0641	1716225836807	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225837809	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225837809	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0641	1716225837809	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225838811	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225838811	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225818787	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225819797	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225820800	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225821794	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225822801	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225823804	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225824808	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225825800	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225826810	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225827815	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225828808	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225829817	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225830817	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225831820	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225832824	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225833818	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225834826	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225835828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225836828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225837823	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225838832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225839834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225840836	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225841838	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225842835	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225843842	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225844837	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225845846	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225846841	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225847842	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225848851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225849853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225850857	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225851856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225852858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225853860	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225854863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225855856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225856866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225857861	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225858870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225859871	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225860876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225861873	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225862869	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225863879	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225864883	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225865882	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225866885	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225867887	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225868889	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225869890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225870893	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225871893	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225872897	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225873891	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225874900	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225875903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225876896	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225877907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225878900	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225879909	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225880914	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225881911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225882915	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225838811	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225839813	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225839813	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225839813	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225840815	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225840815	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225840815	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225841816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225841816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0675	1716225841816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225842818	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225842818	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0675	1716225842818	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225843820	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225843820	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0675	1716225843820	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225844822	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225844822	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.065	1716225844822	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225845824	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225845824	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.065	1716225845824	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225846826	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225846826	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.065	1716225846826	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225847828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225847828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0642	1716225847828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225848830	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225848830	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0642	1716225848830	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225849832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225849832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0642	1716225849832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225850834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225850834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0645	1716225850834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225851835	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225851835	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0645	1716225851835	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225852837	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225852837	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0645	1716225852837	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225853839	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225853839	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0612	1716225853839	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225854841	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225854841	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0612	1716225854841	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225855843	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225855843	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0612	1716225855843	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225856845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225856845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0622	1716225856845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225857847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225857847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0622	1716225857847	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225858849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225858849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0622	1716225858849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225859851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225859851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0636	1716225859851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225860853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225860853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0636	1716225860853	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225861855	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225861855	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0636	1716225861855	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225862856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225862856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.065	1716225862856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225863858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225863858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.065	1716225863858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225864860	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225864860	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.065	1716225864860	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225865861	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225865861	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225865861	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225866863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225866863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225866863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225867865	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225867865	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0655	1716225867865	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225868867	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225868867	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0676	1716225868867	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225869869	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225869869	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0676	1716225869869	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225870871	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225870871	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0676	1716225870871	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225871873	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225871873	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0658000000000003	1716225871873	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225872875	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225872875	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0658000000000003	1716225872875	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225873876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225873876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0658000000000003	1716225873876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225874878	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225874878	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0641	1716225874878	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225875880	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225875880	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0641	1716225875880	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225876882	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225876882	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0641	1716225876882	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225877884	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225877884	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0639000000000003	1716225877884	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225878886	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225878886	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0639000000000003	1716225878886	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225879888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225879888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0639000000000003	1716225879888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225880890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225880890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0664000000000002	1716225880890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225881892	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225881892	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0664000000000002	1716225881892	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225882894	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225882894	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0664000000000002	1716225882894	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225883897	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225883897	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0676	1716225883897	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225884899	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225884899	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0676	1716225884899	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225885901	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225885901	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0676	1716225885901	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225886903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716225886903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0684	1716225886903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225887905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225887905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0684	1716225887905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225888907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225888907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0684	1716225888907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225889909	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225889909	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.068	1716225889909	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225890910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225890910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.068	1716225890910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225891911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225891911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.068	1716225891911	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225892913	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225892913	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0696999999999997	1716225892913	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225893916	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225893916	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0696999999999997	1716225893916	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225894917	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225894917	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0696999999999997	1716225894917	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225895919	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225895919	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0705	1716225895919	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225896921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225896921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0705	1716225896921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225897923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225897923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0705	1716225897923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225898925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225898925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0681	1716225898925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225899927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225899927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0681	1716225899927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225900929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225900929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0681	1716225900929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225901930	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225901930	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0683000000000002	1716225901930	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225902932	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225902932	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225883918	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225884921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225885923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225886924	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225887921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225888929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225889930	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225890930	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225891933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225892927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225893940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225894939	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225895943	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225896945	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225897941	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225898950	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225899950	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225900950	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225901942	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225902954	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225903947	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225904957	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225905960	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225906959	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225907962	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225908957	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225909966	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225910967	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225911969	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225912963	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225913973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225914979	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225915977	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225916979	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225917980	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225918975	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225919984	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225920985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225921981	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225922984	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225923986	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225924993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225925998	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225926998	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225927992	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225929003	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225930003	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225931004	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225932006	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225933009	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225934018	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225935005	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225936015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225937020	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225938020	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225939021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225940022	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225941022	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225942029	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225943032	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225944033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225945034	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225946034	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225947037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225948038	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0683000000000002	1716225902932	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225903933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225903933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0683000000000002	1716225903933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225904935	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225904935	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0683000000000002	1716225904935	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225905937	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225905937	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0683000000000002	1716225905937	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225906939	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225906939	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0683000000000002	1716225906939	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225907941	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225907941	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0692	1716225907941	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225908943	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225908943	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0692	1716225908943	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225909945	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225909945	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0692	1716225909945	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225910947	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225910947	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0681	1716225910947	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225911949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225911949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0681	1716225911949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225912950	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225912950	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0681	1716225912950	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225913952	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225913952	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0686999999999998	1716225913952	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225914954	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225914954	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0686999999999998	1716225914954	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225915955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225915955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0686999999999998	1716225915955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225916957	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225916957	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.069	1716225916957	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225917959	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225917959	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.069	1716225917959	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225918961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225918961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.069	1716225918961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225919963	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225919963	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0708	1716225919963	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225920965	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225920965	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0708	1716225920965	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225921966	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225921966	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0708	1716225921966	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225922968	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225922968	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0683000000000002	1716225922968	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225923970	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225923970	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0683000000000002	1716225923970	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225924973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225924973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0683000000000002	1716225924973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225925974	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225925974	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0696999999999997	1716225925974	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225926976	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225926976	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0696999999999997	1716225926976	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225927978	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225927978	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0696999999999997	1716225927978	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225928980	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225928980	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0717	1716225928980	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225929982	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225929982	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0717	1716225929982	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225930983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225930983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0717	1716225930983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225931985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225931985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0708	1716225931985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225932987	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225932987	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0708	1716225932987	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225933991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225933991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0708	1716225933991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225934993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225934993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0713000000000004	1716225934993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225935994	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225935994	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0713000000000004	1716225935994	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225936996	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225936996	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0713000000000004	1716225936996	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225937998	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225937998	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0711	1716225937998	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225939000	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225939000	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0711	1716225939000	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225940002	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225940002	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0711	1716225940002	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225941003	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225941003	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0705999999999998	1716225941003	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225942005	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225942005	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0705999999999998	1716225942005	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225943007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225943007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0705999999999998	1716225943007	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225944009	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225944009	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0688	1716225944009	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225945011	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225945011	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0688	1716225945011	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225946013	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225946013	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0709	1716225946013	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225947015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225947015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0709	1716225947015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225948017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.1	1716225948017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0709	1716225948017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225949019	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9	1716225949019	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.071	1716225949019	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225950021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225950021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.071	1716225950021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225951023	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225951023	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.071	1716225951023	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225952025	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225952025	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0772	1716225952025	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225953027	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225953027	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0772	1716225953027	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225954029	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225954029	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0772	1716225954029	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225955032	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225955032	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0769	1716225955032	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225956034	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225956034	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0769	1716225956034	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225957036	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225957036	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0769	1716225957036	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225958038	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225958038	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0785	1716225958038	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226438965	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226438965	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.111	1716226438965	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226439967	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226439967	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.111	1716226439967	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226440969	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226440969	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.111	1716226440969	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226441971	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226441971	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1108000000000002	1716226441971	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226442973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226442973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1108000000000002	1716226442973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226443974	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226443974	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1108000000000002	1716226443974	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226444976	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226444976	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.111	1716226444976	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226445978	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226445978	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.111	1716226445978	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226446980	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226446980	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225949034	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225950043	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225951044	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225952047	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225953048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225954044	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225955055	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225956055	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225957057	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225958053	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225959039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225959039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0785	1716225959039	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225959062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225960041	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225960041	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0785	1716225960041	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225960064	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225961045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225961045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0799000000000003	1716225961045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225961066	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225962047	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225962047	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0799000000000003	1716225962047	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225962060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225963048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225963048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0799000000000003	1716225963048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225963073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225964050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225964050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0828	1716225964050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225964068	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225965052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225965052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0828	1716225965052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225965073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225966054	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225966054	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0828	1716225966054	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225966075	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225967056	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225967056	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0813	1716225967056	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225967077	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225968058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225968058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0813	1716225968058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225968084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225969060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225969060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0813	1716225969060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225969077	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225970062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225970062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0783	1716225970062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225970084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716225971064	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225971064	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0783	1716225971064	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225971087	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225972067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225972067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0783	1716225972067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225973069	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225973069	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0770999999999997	1716225973069	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225974071	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716225974071	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0770999999999997	1716225974071	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225975073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225975073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0770999999999997	1716225975073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225976075	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225976075	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0773	1716225976075	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225977077	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225977077	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0773	1716225977077	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225978079	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225978079	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0773	1716225978079	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225979081	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225979081	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0784000000000002	1716225979081	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225980083	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225980083	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0784000000000002	1716225980083	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225981084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225981084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0784000000000002	1716225981084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225982086	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225982086	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0786	1716225982086	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225983088	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225983088	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0786	1716225983088	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225984090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225984090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0786	1716225984090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225985092	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225985092	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0806	1716225985092	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225986094	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225986094	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0806	1716225986094	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225987096	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225987096	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0806	1716225987096	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225988098	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225988098	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0794	1716225988098	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225989100	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225989100	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0794	1716225989100	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225990102	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225990102	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0794	1716225990102	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225991104	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225991104	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0806	1716225991104	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716225992106	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225992106	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0806	1716225992106	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225993107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225993107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0806	1716225993107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225972092	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225973083	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225974096	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225975094	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225976096	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225977100	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225978092	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225979105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225980105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225981105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225982107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225983102	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225984113	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225985113	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225986116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225987117	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225988111	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225989121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225990127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225991125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225992121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225993122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225994131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225995131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225996126	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225997137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225998137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716225999141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226000140	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226001143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226002144	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226003148	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226004151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226005153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226006152	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226007158	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226008158	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226009152	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226010162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226011163	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226012166	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226013167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226014164	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226015173	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226016173	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226017175	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226018169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226019178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226020181	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226021186	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226022177	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226023183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226024188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226025190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226026185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226027193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226028197	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226029200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226030199	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226031200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226032206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226033197	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226034208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226035208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226036213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225994109	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225994109	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0806	1716225994109	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225995110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225995110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0806	1716225995110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716225996112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225996112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0806	1716225996112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716225997114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225997114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0809	1716225997114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225998116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716225998116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0809	1716225998116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716225999118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716225999118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0809	1716225999118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226000120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226000120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0812	1716226000120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226001122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226001122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0812	1716226001122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226002124	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226002124	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0812	1716226002124	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226003126	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226003126	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0816999999999997	1716226003126	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226004128	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226004128	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0816999999999997	1716226004128	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226005130	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226005130	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0816999999999997	1716226005130	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226006132	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226006132	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0876	1716226006132	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226007134	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226007134	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0876	1716226007134	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226008136	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226008136	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0876	1716226008136	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226009138	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226009138	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0884	1716226009138	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226010139	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226010139	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0884	1716226010139	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226011141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226011141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0884	1716226011141	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226012143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226012143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0827	1716226012143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226013147	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226013147	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0827	1716226013147	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226014149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226014149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0827	1716226014149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226015150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226015150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0844	1716226015150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226016152	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226016152	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0844	1716226016152	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226017154	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226017154	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0844	1716226017154	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226018156	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226018156	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0886	1716226018156	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226019157	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226019157	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0886	1716226019157	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226020159	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226020159	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0886	1716226020159	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226021161	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226021161	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0896999999999997	1716226021161	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226022163	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226022163	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0896999999999997	1716226022163	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226023165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226023165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0896999999999997	1716226023165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226024167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226024167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0906	1716226024167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226025169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226025169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0906	1716226025169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226026171	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226026171	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0906	1716226026171	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226027173	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226027173	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0887	1716226027173	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226028174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226028174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0887	1716226028174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226029176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226029176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0887	1716226029176	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226030178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226030178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0906	1716226030178	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226031180	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226031180	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0906	1716226031180	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226032181	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226032181	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0906	1716226032181	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226033183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226033183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0928	1716226033183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226034185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226034185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0928	1716226034185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226035187	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226035187	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0928	1716226035187	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226036189	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226036189	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0885	1716226036189	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226037191	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226037191	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0885	1716226037191	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226038193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226038193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0885	1716226038193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226039195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226039195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0881999999999996	1716226039195	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226040197	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226040197	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0881999999999996	1716226040197	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226041199	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226041199	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0881999999999996	1716226041199	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226042200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226042200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0861	1716226042200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226043202	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226043202	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0861	1716226043202	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226044204	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226044204	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0861	1716226044204	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226045206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226045206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0862	1716226045206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226046208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226046208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0862	1716226046208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226047210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226047210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0862	1716226047210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226048212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226048212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0901	1716226048212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226049214	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226049214	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0901	1716226049214	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226050216	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226050216	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0901	1716226050216	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226051218	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226051218	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.089	1716226051218	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226052220	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226052220	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.089	1716226052220	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226053221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226053221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.089	1716226053221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226054223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226054223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0938000000000003	1716226054223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226055225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226055225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0938000000000003	1716226055225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226056227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226056227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0938000000000003	1716226056227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226057229	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226057229	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0941	1716226057229	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226037211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226038207	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226039211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226040218	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226041221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226042221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226043217	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226044219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226045227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226046227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226047232	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226048235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226049235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226050240	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226051240	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226052248	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226053241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226054244	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226055247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226056240	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226057252	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226058245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226059254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226060254	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226061257	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226062263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226063263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226064269	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226065270	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226066271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226067273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226068264	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226069277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226070277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226071278	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226072282	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226073277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226074286	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226075290	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226076291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226077296	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226078283	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226079285	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226080295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226081297	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226082298	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226083293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226084300	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226085303	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226086305	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226087307	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226088301	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226089310	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226090312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226091314	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226092320	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226093311	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226094312	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226095321	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226096324	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226097325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226098319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226099326	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226100330	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226101333	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226058231	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226058231	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0941	1716226058231	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226059233	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226059233	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0941	1716226059233	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226060235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226060235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0877	1716226060235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226061236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226061236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0877	1716226061236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226062238	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226062238	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0877	1716226062238	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226063240	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226063240	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0890999999999997	1716226063240	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226064243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226064243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0890999999999997	1716226064243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226065245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226065245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0890999999999997	1716226065245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226066247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226066247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.089	1716226066247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226067249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226067249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.089	1716226067249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226068251	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226068251	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.089	1716226068251	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226069253	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226069253	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.091	1716226069253	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226070255	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226070255	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.091	1716226070255	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226071257	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226071257	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.091	1716226071257	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226072259	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226072259	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0917	1716226072259	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226073261	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226073261	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0917	1716226073261	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226074263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226074263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0917	1716226074263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226075264	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226075264	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0942	1716226075264	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226076266	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226076266	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0942	1716226076266	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226077268	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226077268	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0942	1716226077268	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226078270	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226078270	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0938000000000003	1716226078270	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226079271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226079271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0938000000000003	1716226079271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226080273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226080273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0938000000000003	1716226080273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226081275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226081275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0887	1716226081275	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226082277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226082277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0887	1716226082277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226083279	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226083279	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0887	1716226083279	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226084280	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226084280	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0906	1716226084280	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226085282	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226085282	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0906	1716226085282	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226086283	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226086283	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0906	1716226086283	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226087285	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226087285	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0914	1716226087285	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226088287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226088287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0914	1716226088287	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226089289	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226089289	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0914	1716226089289	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226090291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226090291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0939	1716226090291	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226091293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226091293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0939	1716226091293	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226092295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226092295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0939	1716226092295	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226093296	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226093296	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0945	1716226093296	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226094298	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226094298	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0945	1716226094298	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226095300	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226095300	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0945	1716226095300	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226096302	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226096302	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0951999999999997	1716226096302	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226097304	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226097304	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0951999999999997	1716226097304	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226098305	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226098305	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0951999999999997	1716226098305	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226099307	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.1	1716226099307	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0968	1716226099307	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226100309	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.199999999999999	1716226100309	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0968	1716226100309	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226101311	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226101311	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0968	1716226101311	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226102313	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226102313	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0846999999999998	1716226102313	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226103315	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226103315	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0846999999999998	1716226103315	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226104317	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226104317	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0846999999999998	1716226104317	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226105319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226105319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0929	1716226105319	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226106320	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226106320	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0929	1716226106320	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226107322	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226107322	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0929	1716226107322	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226108323	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226108323	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0943	1716226108323	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226109325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226109325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0943	1716226109325	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226110327	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226110327	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0943	1716226110327	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226111329	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226111329	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0918	1716226111329	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226112331	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226112331	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0918	1716226112331	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226113333	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226113333	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0918	1716226113333	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226114335	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226114335	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0943	1716226114335	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226115337	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226115337	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0943	1716226115337	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226116338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226116338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0943	1716226116338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226117340	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226117340	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0963000000000003	1716226117340	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226118342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226118342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0963000000000003	1716226118342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226119343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226119343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0963000000000003	1716226119343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226120345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226120345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0959	1716226120345	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226121347	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226121347	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0959	1716226121347	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226102337	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226103338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226104330	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226105339	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226106342	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226107343	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226108344	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226109338	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226110353	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226111348	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226112352	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226113348	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226114348	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226115358	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226116360	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226117361	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226118356	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226119357	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226120366	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226121368	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226122370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226123370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226124365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226125377	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226126377	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226127380	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226128374	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226129379	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226130388	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226131386	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226132388	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226133384	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226134384	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226135393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226136395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226137397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226138392	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226139396	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226140402	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226141404	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226142407	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226143402	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226144403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226145415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226146415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226147409	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226148412	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226149421	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226150423	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226151424	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226152427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226153423	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226154431	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226155434	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226156436	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226157438	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226158433	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226159442	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226160443	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226161444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226162447	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226163446	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226164456	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226165453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226166454	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226122349	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226122349	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0959	1716226122349	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226123350	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226123350	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0967	1716226123350	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226124352	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226124352	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0967	1716226124352	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226125354	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226125354	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0967	1716226125354	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226126356	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226126356	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0948	1716226126356	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226127358	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226127358	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0948	1716226127358	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226128360	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226128360	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0948	1716226128360	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226129362	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226129362	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0957	1716226129362	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226130363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226130363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0957	1716226130363	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226131365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226131365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0957	1716226131365	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226132367	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226132367	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0955	1716226132367	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226133369	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226133369	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0955	1716226133369	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226134370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226134370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0955	1716226134370	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226135372	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226135372	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.095	1716226135372	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226136374	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226136374	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.095	1716226136374	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226137376	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226137376	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.095	1716226137376	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226138378	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226138378	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0954	1716226138378	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226139380	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226139380	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0954	1716226139380	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226140382	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226140382	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0954	1716226140382	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226141383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226141383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0961999999999996	1716226141383	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226142385	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226142385	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0961999999999996	1716226142385	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226143387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226143387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0961999999999996	1716226143387	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226144389	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226144389	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0939	1716226144389	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226145391	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226145391	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0939	1716226145391	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226146393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226146393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0939	1716226146393	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226147395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226147395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0936	1716226147395	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226148397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226148397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0936	1716226148397	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226149399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226149399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0936	1716226149399	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226150401	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226150401	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0965	1716226150401	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226151403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226151403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0965	1716226151403	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226152405	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226152405	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0965	1716226152405	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226153408	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226153408	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0967	1716226153408	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226154410	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226154410	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0967	1716226154410	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226155412	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226155412	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0967	1716226155412	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226156414	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226156414	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0972	1716226156414	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226157415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226157415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0972	1716226157415	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226158418	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226158418	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0972	1716226158418	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226159420	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226159420	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0965	1716226159420	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226160421	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226160421	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0965	1716226160421	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226161423	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226161423	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0965	1716226161423	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226162425	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226162425	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0967	1716226162425	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226163427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226163427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0967	1716226163427	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226164429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226164429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0967	1716226164429	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226165431	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226165431	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0970999999999997	1716226165431	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226166433	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226166433	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0970999999999997	1716226166433	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226167435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226167435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0970999999999997	1716226167435	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226168437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226168437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991999999999997	1716226168437	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226169438	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226169438	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991999999999997	1716226169438	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226170440	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226170440	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991999999999997	1716226170440	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226171442	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.700000000000001	1716226171442	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0959	1716226171442	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226172444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226172444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0959	1716226172444	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226173445	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226173445	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0959	1716226173445	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226174447	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226174447	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0964	1716226174447	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226175449	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226175449	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0964	1716226175449	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226176451	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226176451	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0964	1716226176451	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226177453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226177453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1014	1716226177453	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226178455	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226178455	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1014	1716226178455	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226179457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226179457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1014	1716226179457	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226180460	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226180460	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991999999999997	1716226180460	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226181462	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226181462	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991999999999997	1716226181462	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226182464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226182464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991999999999997	1716226182464	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226183465	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226183465	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0995999999999997	1716226183465	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226184467	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226184467	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0995999999999997	1716226184467	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226185469	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226185469	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0995999999999997	1716226185469	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226167458	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226168461	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226169461	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226170462	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226171468	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226172471	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226173461	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226174470	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226175473	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226176472	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226177474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226178469	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226179479	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226180482	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226181484	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226182490	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226183478	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226184488	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226185492	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226186492	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226187498	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226188490	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226189499	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226190503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226191502	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226192503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226193501	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226194510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226195513	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226196505	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226197515	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226438987	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226439989	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226440993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226441984	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226442994	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226443990	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226444997	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226445992	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226447001	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226447995	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226448997	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226449998	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226451011	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226452011	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226453012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226454012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226455018	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226456021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226457012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226458001	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0921	1716226458001	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226458016	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226459004	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226459004	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0921	1716226459004	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226459017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226460006	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226460006	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1016	1716226460006	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226460027	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226461008	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226461008	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1016	1716226461008	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226461029	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226186471	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226186471	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0999	1716226186471	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226187473	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226187473	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0999	1716226187473	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226188474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226188474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0999	1716226188474	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226189476	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226189476	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1008	1716226189476	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226190478	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226190478	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1008	1716226190478	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226191480	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226191480	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1008	1716226191480	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226192482	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226192482	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0929	1716226192482	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226193484	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226193484	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0929	1716226193484	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226194487	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226194487	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0929	1716226194487	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226195489	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226195489	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0975	1716226195489	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226196491	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226196491	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0975	1716226196491	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226197494	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226197494	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0975	1716226197494	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226198496	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226198496	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0995	1716226198496	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226198521	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226199497	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226199497	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0995	1716226199497	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226199523	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226200499	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226200499	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0995	1716226200499	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226200525	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226201501	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226201501	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0736999999999997	1716226201501	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226201522	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226202503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226202503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0736999999999997	1716226202503	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226202523	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226203505	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226203505	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0736999999999997	1716226203505	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226203518	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226204506	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226204506	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0781	1716226204506	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226204528	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226205508	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226205508	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0781	1716226205508	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226206510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226206510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0781	1716226206510	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226207511	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226207511	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0791999999999997	1716226207511	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226208513	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226208513	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0791999999999997	1716226208513	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226209515	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226209515	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0791999999999997	1716226209515	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226210517	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226210517	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0789	1716226210517	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226211519	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226211519	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0789	1716226211519	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226212521	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226212521	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0789	1716226212521	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226213523	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226213523	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0791	1716226213523	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226214525	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226214525	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0791	1716226214525	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226215527	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226215527	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0791	1716226215527	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226216529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226216529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0814	1716226216529	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226217530	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226217530	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0814	1716226217530	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226218532	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226218532	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0814	1716226218532	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226219534	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226219534	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0876	1716226219534	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226220536	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226220536	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0876	1716226220536	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226221538	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226221538	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0876	1716226221538	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226222540	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226222540	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0961999999999996	1716226222540	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226223542	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226223542	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0961999999999996	1716226223542	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226224543	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226224543	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0961999999999996	1716226224543	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226225545	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226225545	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0953000000000004	1716226225545	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226226547	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226205532	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226206531	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226207532	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226208527	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226209536	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226210540	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226211543	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226212543	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226213545	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226214546	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226215547	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226216549	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226217551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226218550	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226219557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226220557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226221560	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226222565	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226223561	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226224565	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226225569	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226226562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226227563	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226228566	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226229574	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226230574	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226231579	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226232583	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226233585	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226234584	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226235590	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226236583	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226237584	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226238592	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226239594	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226240598	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226241600	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226242594	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226243603	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226244600	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226245599	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226246609	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226247610	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226248605	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226249616	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226250618	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226251621	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226252621	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226253617	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226254626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226255628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226256628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226257624	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226258635	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226259635	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226260630	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226261639	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226262634	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226263646	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226264645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226265649	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226266649	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226267645	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226268655	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226269656	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226226547	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0953000000000004	1716226226547	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226227549	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226227549	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0953000000000004	1716226227549	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226228551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226228551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0932	1716226228551	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226229553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226229553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0932	1716226229553	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226230555	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226230555	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0932	1716226230555	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226231557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226231557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991	1716226231557	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226232559	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226232559	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991	1716226232559	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226233562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226233562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991	1716226233562	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226234564	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226234564	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0982	1716226234564	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226235566	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226235566	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0982	1716226235566	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226236568	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226236568	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0982	1716226236568	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226237570	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226237570	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.093	1716226237570	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226238571	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226238571	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.093	1716226238571	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226239573	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226239573	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.093	1716226239573	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226240575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226240575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991	1716226240575	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226241578	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226241578	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991	1716226241578	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226242580	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226242580	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991	1716226242580	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226243582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226243582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991	1716226243582	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226244583	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226244583	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991	1716226244583	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226245585	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226245585	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0991	1716226245585	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226246587	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.200000000000001	1716226246587	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0995999999999997	1716226246587	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226247589	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.300000000000001	1716226247589	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0995999999999997	1716226247589	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226248591	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226248591	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0995999999999997	1716226248591	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226249595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226249595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1009	1716226249595	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226250596	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226250596	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1009	1716226250596	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226251598	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226251598	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1009	1716226251598	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226252600	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226252600	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1071	1716226252600	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226253602	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226253602	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1071	1716226253602	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226254604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226254604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1071	1716226254604	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226255606	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226255606	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1048	1716226255606	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226256609	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226256609	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1048	1716226256609	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226257611	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226257611	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1048	1716226257611	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226258613	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226258613	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1054	1716226258613	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226259615	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226259615	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1054	1716226259615	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226260616	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226260616	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1054	1716226260616	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226261618	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226261618	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0778000000000003	1716226261618	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226262620	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226262620	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0778000000000003	1716226262620	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226263622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226263622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0778000000000003	1716226263622	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226264624	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226264624	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.083	1716226264624	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226265626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226265626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.083	1716226265626	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226266628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226266628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.083	1716226266628	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226267631	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226267631	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.086	1716226267631	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226268633	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226268633	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.086	1716226268633	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226269635	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226269635	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.086	1716226269635	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226270637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226270637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0881	1716226270637	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226271638	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.700000000000001	1716226271638	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0881	1716226271638	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226272640	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226272640	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0881	1716226272640	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226273643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226273643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0923000000000003	1716226273643	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226274644	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226274644	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0923000000000003	1716226274644	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226275646	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226275646	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0923000000000003	1716226275646	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226276648	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226276648	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0945	1716226276648	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226277650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226277650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0945	1716226277650	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226278652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226278652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0945	1716226278652	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226279654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.3	1716226279654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0943	1716226279654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226280656	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226280656	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0943	1716226280656	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226281657	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.199999999999999	1716226281657	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0943	1716226281657	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226282659	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.4	1716226282659	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0853	1716226282659	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226283661	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226283661	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0853	1716226283661	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226284664	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226284664	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0853	1716226284664	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226285666	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226285666	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.096	1716226285666	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226286668	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226286668	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.096	1716226286668	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226287670	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226287670	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.096	1716226287670	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226288672	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226288672	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.103	1716226288672	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226289673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226289673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.103	1716226289673	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226290675	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226270657	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226271661	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226272654	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226273668	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226274665	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226275670	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226276672	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226277672	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226278667	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226279676	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226280680	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226281680	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226282680	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226283675	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226284685	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226285689	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226286695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226287686	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226288693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226289699	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226290701	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226291701	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226292696	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226293700	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226294703	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226295712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226296711	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226297713	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226298710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226299717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226300717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226301720	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226302714	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226303723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226304725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226305722	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226306729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226307724	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226308734	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226309737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226310737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226311739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226312736	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226313743	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226314747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226315749	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226316751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226317745	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226318752	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226319754	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226320757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226321759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226322760	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226323754	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226324764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226325766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226326766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226327770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226328764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226329772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226330774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226331776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226332774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226333780	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226334781	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226290675	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.103	1716226290675	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226291679	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226291679	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1029	1716226291679	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226292681	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226292681	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1029	1716226292681	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226293683	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226293683	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1029	1716226293683	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226294685	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226294685	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0841999999999996	1716226294685	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226295688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226295688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0841999999999996	1716226295688	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226296690	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226296690	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0841999999999996	1716226296690	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226297692	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226297692	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0874	1716226297692	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226298693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226298693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0874	1716226298693	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226299695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226299695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0874	1716226299695	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226300697	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226300697	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0886	1716226300697	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226301699	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226301699	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0886	1716226301699	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226302701	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226302701	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0886	1716226302701	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226303703	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226303703	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0827	1716226303703	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226304704	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226304704	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0827	1716226304704	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226305706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226305706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0827	1716226305706	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226306708	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226306708	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0876	1716226306708	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226307710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226307710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0876	1716226307710	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226308712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226308712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0876	1716226308712	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226309714	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226309714	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0904000000000003	1716226309714	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226310716	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226310716	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0904000000000003	1716226310716	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226311717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226311717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0904000000000003	1716226311717	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226312720	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226312720	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0816	1716226312720	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226313721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226313721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0816	1716226313721	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226314723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226314723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0816	1716226314723	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226315725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226315725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0876	1716226315725	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226316727	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226316727	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0876	1716226316727	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226317729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226317729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0876	1716226317729	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226318731	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226318731	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0917	1716226318731	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226319733	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226319733	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0917	1716226319733	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226320735	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226320735	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0917	1716226320735	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226321737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226321737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0916	1716226321737	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226322739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226322739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0916	1716226322739	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226323740	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226323740	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0916	1716226323740	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226324742	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226324742	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0995	1716226324742	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226325744	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226325744	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0995	1716226325744	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226326745	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226326745	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0995	1716226326745	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226327747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226327747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1018000000000003	1716226327747	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226328749	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226328749	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1018000000000003	1716226328749	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226329751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226329751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1018000000000003	1716226329751	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226330753	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226330753	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1049	1716226330753	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226331755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226331755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1049	1716226331755	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226332757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226332757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1049	1716226332757	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226333759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226333759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1047	1716226333759	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226334761	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226334761	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1047	1716226334761	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226335762	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226335762	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1047	1716226335762	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226336764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226336764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.103	1716226336764	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226337766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226337766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.103	1716226337766	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226338768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226338768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.103	1716226338768	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226339770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226339770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1035999999999997	1716226339770	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226340772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226340772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1035999999999997	1716226340772	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226341774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226341774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1035999999999997	1716226341774	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226342775	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226342775	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1062	1716226342775	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226343777	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226343777	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1062	1716226343777	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226344779	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226344779	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1062	1716226344779	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226345781	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226345781	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1056	1716226345781	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226346783	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226346783	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1056	1716226346783	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226347785	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226347785	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1056	1716226347785	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226348787	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226348787	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1065	1716226348787	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226349789	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226349789	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1065	1716226349789	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226350791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226350791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1065	1716226350791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226351793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226351793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1084	1716226351793	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226352795	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226352795	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1084	1716226352795	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226353796	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226353796	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1084	1716226353796	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226354799	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226335776	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226336787	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226337789	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226338784	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226339794	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226340792	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226341797	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226342798	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226343791	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226344801	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226345802	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226346803	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226347801	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226348813	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226349811	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226350815	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226351816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226352816	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226353810	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226354814	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226355821	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226356823	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226357824	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226358822	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226359830	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226360832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226361833	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226362839	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226363839	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226364838	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226365842	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226366843	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226367845	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226368840	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226369849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226370851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226371849	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226372855	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226373851	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226374863	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226375862	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226376868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226377858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226378869	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226379872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226380871	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226381865	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226382872	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226383883	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226384882	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226385880	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226386885	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226387882	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226388889	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226389891	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226390892	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226391898	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226392891	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226393902	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226394903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226395903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226396898	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226397908	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226398901	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226399910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226354799	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1096	1716226354799	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226355800	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226355800	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1096	1716226355800	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226356802	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226356802	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1096	1716226356802	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226357804	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226357804	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.112	1716226357804	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226358806	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226358806	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.112	1716226358806	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226359808	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226359808	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.112	1716226359808	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226360810	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226360810	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1104000000000003	1716226360810	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226361812	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226361812	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1104000000000003	1716226361812	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226362814	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.300000000000001	1716226362814	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1104000000000003	1716226362814	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226363815	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226363815	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.111	1716226363815	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226364817	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226364817	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.111	1716226364817	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226365819	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226365819	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.111	1716226365819	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226366822	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226366822	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1123000000000003	1716226366822	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226367824	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226367824	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1123000000000003	1716226367824	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226368825	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.8	1716226368825	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1123000000000003	1716226368825	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226369828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226369828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.099	1716226369828	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226370830	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226370830	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.099	1716226370830	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226371832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226371832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.099	1716226371832	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226372834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226372834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1114	1716226372834	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226373835	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226373835	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1114	1716226373835	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226374837	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226374837	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1114	1716226374837	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226375839	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226375839	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0890999999999997	1716226375839	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226376842	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226376842	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0890999999999997	1716226376842	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226377844	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226377844	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0890999999999997	1716226377844	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226378846	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226378846	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0982	1716226378846	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226379848	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226379848	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0982	1716226379848	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226380850	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226380850	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0982	1716226380850	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226381852	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226381852	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.103	1716226381852	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226382854	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226382854	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.103	1716226382854	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226383856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226383856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.103	1716226383856	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226384858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226384858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0866	1716226384858	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226385859	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226385859	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0866	1716226385859	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226386862	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226386862	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0866	1716226386862	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226387864	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226387864	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.091	1716226387864	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226388866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226388866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.091	1716226388866	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226389868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226389868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.091	1716226389868	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226390870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226390870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0936	1716226390870	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226391873	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226391873	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0936	1716226391873	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226392876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226392876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0936	1716226392876	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226393878	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226393878	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1073000000000004	1716226393878	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226394880	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226394880	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1073000000000004	1716226394880	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226395882	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226395882	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1073000000000004	1716226395882	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226396884	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226396884	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1069	1716226396884	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226397886	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226397886	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1069	1716226397886	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226398888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226398888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1069	1716226398888	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226399890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226399890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1108000000000002	1716226399890	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226400892	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226400892	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1108000000000002	1716226400892	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226401894	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226401894	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1108000000000002	1716226401894	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226402896	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226402896	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1113000000000004	1716226402896	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226403898	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226403898	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1113000000000004	1716226403898	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226404900	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226404900	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1113000000000004	1716226404900	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226405903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226405903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1102	1716226405903	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226406905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226406905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1102	1716226406905	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226407907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226407907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1102	1716226407907	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226408909	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226408909	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1098000000000003	1716226408909	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226409910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226409910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1098000000000003	1716226409910	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226410912	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226410912	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1098000000000003	1716226410912	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226411914	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226411914	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0972	1716226411914	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226412916	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.4	1716226412916	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0972	1716226412916	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226413919	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.5	1716226413919	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0972	1716226413919	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226414920	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226414920	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1089	1716226414920	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226415921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226415921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1089	1716226415921	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226416923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226416923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1089	1716226416923	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226417925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226417925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.109	1716226417925	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226418927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226400914	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226401915	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226402917	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226403912	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226404922	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226405924	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226406929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226407920	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226408929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226409931	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226410934	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226411932	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226412931	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226413940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226414940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226415935	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226416937	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226417943	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226418949	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226419951	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226420952	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226421953	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226422952	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226423958	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226424961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226425956	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226426957	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226427958	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226428967	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226429969	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226430971	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226431973	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226432967	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226433977	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226434978	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226435981	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226436982	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226437977	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.111	1716226446980	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226447982	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226447982	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0911999999999997	1716226447982	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226448983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226448983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0911999999999997	1716226448983	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226449985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226449985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0911999999999997	1716226449985	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226450987	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226450987	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0930999999999997	1716226450987	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226451989	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226451989	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0930999999999997	1716226451989	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226452991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226452991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0930999999999997	1716226452991	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226453993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226453993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0925	1716226453993	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226454995	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226454995	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0925	1716226454995	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226455997	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226455997	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226418927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.109	1716226418927	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226419929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226419929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.109	1716226419929	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226420931	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226420931	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1125	1716226420931	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226421933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226421933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1125	1716226421933	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226422935	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226422935	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1125	1716226422935	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226423937	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226423937	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.112	1716226423937	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226424939	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226424939	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.112	1716226424939	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226425940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226425940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.112	1716226425940	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226426942	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226426942	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1138000000000003	1716226426942	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226427944	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226427944	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1138000000000003	1716226427944	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226428946	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226428946	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1138000000000003	1716226428946	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226429948	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226429948	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1141	1716226429948	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226430950	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226430950	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1141	1716226430950	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226431952	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226431952	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1141	1716226431952	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226432953	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226432953	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1130999999999998	1716226432953	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226433955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226433955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1130999999999998	1716226433955	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226434957	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226434957	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1130999999999998	1716226434957	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226435959	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226435959	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1115999999999997	1716226435959	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226436961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226436961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1115999999999997	1716226436961	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226437963	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226437963	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1115999999999997	1716226437963	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0925	1716226455997	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226456999	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226456999	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0921	1716226456999	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226458001	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226462010	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226462010	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1035	1716226462010	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226463012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226463012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1035	1716226463012	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226464013	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226464013	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1035	1716226464013	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226465015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226465015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1101	1716226465015	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226466017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226466017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1101	1716226466017	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226467019	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8	1716226467019	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1101	1716226467019	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226468021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226468021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1118	1716226468021	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226469023	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226469023	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1118	1716226469023	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226470025	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226470025	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1118	1716226470025	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226471026	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226471026	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1126	1716226471026	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226472028	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226472028	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1126	1716226472028	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226473030	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226473030	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1126	1716226473030	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226474032	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226474032	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1138000000000003	1716226474032	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226475033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226475033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1138000000000003	1716226475033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226476035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226476035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1138000000000003	1716226476035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226477037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226477037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1153000000000004	1716226477037	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226478040	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226478040	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1153000000000004	1716226478040	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226479042	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226479042	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1153000000000004	1716226479042	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226480043	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226480043	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1143	1716226480043	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226481045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226481045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1143	1716226481045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226482047	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226482047	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1143	1716226482047	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226483050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226462031	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226463035	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226464033	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226465036	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226466038	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226467042	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226468042	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226469043	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226470045	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226471048	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226472053	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226473044	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226474055	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226475052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226476052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226477060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226478053	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226479063	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226480064	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226481067	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226482070	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226483072	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226484074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226485077	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226486078	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226487080	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226488074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226489083	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226490085	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226491089	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226492091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226493085	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226494087	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226495089	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226496097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226497100	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226498105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226483050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1136999999999997	1716226483050	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226484052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226484052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1136999999999997	1716226484052	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226485054	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226485054	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1136999999999997	1716226485054	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226486056	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226486056	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1172	1716226486056	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226487058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226487058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1172	1716226487058	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226488060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226488060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1172	1716226488060	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226489062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226489062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1176	1716226489062	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226490064	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226490064	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1176	1716226490064	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226491065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226491065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1176	1716226491065	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226492069	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226492069	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1181	1716226492069	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226493071	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226493071	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1181	1716226493071	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226494073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226494073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1181	1716226494073	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226495074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226495074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1176999999999997	1716226495074	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226496076	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226496076	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1176999999999997	1716226496076	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226497078	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226497078	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1176999999999997	1716226497078	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226498080	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226498080	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.116	1716226498080	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226499082	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226499082	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.116	1716226499082	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226499097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226500084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226500084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.116	1716226500084	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226500106	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226501086	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226501086	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1185	1716226501086	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226501109	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226502088	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226502088	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1185	1716226502088	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226502110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226503090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226503090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1185	1716226503090	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226504091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226504091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.119	1716226504091	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226505093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226505093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.119	1716226505093	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	99	1716226506095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	6.4	1716226506095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.119	1716226506095	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226507097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226507097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1151999999999997	1716226507097	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226508099	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226508099	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1151999999999997	1716226508099	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226509101	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226509101	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1151999999999997	1716226509101	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226510103	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226510103	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1154	1716226510103	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226511105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226511105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1154	1716226511105	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226512107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226512107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1154	1716226512107	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226513108	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226513108	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1161	1716226513108	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226514110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226514110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1161	1716226514110	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226515112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226515112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1161	1716226515112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226516114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226516114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1155	1716226516114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226517116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226517116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1155	1716226517116	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226518118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226518118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1155	1716226518118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226519120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226519120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0951	1716226519120	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226520122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226520122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0951	1716226520122	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226521123	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226521123	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0951	1716226521123	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226522125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226522125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0972	1716226522125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226523127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226523127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0972	1716226523127	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226524129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226524129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226503104	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226504113	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226505114	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226506111	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226507118	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226508112	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226509121	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226510125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226511125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226512125	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226513124	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226514134	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226515134	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226516137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226517136	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226518143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226519132	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226520142	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226521144	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226522150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226523149	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226524143	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226525155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226526154	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226527162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226528157	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226529153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226530162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226531168	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226532165	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226533170	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226534169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226535170	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226536173	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226537180	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226538170	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226539179	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226540183	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226541185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226542184	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226543190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226544190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226545191	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226546185	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226547194	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226548191	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226549198	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226550201	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226551203	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226552206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226553199	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226554211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226555212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226556214	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226557216	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226558209	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226559211	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226560221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226561224	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226562225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226563220	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226564231	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226565231	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226566233	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226567235	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0972	1716226524129	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226525131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226525131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0999	1716226525131	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226526133	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226526133	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0999	1716226526133	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226527135	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226527135	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0999	1716226527135	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226528137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226528137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0941	1716226528137	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226529138	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226529138	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0941	1716226529138	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226530140	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226530140	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.0941	1716226530140	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226531142	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226531142	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1055	1716226531142	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226532144	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226532144	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1055	1716226532144	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226533146	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226533146	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1055	1716226533146	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226534148	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226534148	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1104000000000003	1716226534148	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226535150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226535150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1104000000000003	1716226535150	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226536151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226536151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1104000000000003	1716226536151	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226537153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226537153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1121	1716226537153	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226538155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226538155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1121	1716226538155	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226539158	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226539158	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1121	1716226539158	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226540160	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226540160	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1108000000000002	1716226540160	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226541162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226541162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1108000000000002	1716226541162	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226542163	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226542163	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1108000000000002	1716226542163	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226543167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226543167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.114	1716226543167	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226544169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226544169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.114	1716226544169	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226545170	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226545170	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.114	1716226545170	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226546172	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226546172	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1155999999999997	1716226546172	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226547174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226547174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1155999999999997	1716226547174	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226548175	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226548175	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1155999999999997	1716226548175	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226549177	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226549177	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1126	1716226549177	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226550179	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226550179	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1126	1716226550179	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226551182	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.6	1716226551182	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1126	1716226551182	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226552184	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.5	1716226552184	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1126	1716226552184	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226553186	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226553186	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1126	1716226553186	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226554188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226554188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1126	1716226554188	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226555190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226555190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.116	1716226555190	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226556192	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226556192	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.116	1716226556192	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	100	1716226557193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226557193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.116	1716226557193	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226558196	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226558196	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1139	1716226558196	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226559198	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226559198	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1139	1716226559198	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226560200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226560200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1139	1716226560200	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226561202	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226561202	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1147	1716226561202	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226562204	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226562204	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1147	1716226562204	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226563206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226563206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1147	1716226563206	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226564208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	8.1	1716226564208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1148000000000002	1716226564208	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226565210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226565210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1148000000000002	1716226565210	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226566212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226566212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1148000000000002	1716226566212	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226567213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226567213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1170999999999998	1716226567213	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226568215	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226568215	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1170999999999998	1716226568215	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226569217	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226569217	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1170999999999998	1716226569217	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226570219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226570219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1107	1716226570219	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226571221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226571221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1107	1716226571221	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226572223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226572223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1107	1716226572223	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226573225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226573225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1159	1716226573225	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226574227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226574227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1159	1716226574227	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226575228	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226575228	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1159	1716226575228	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226576230	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226576230	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1179	1716226576230	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226577232	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226577232	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1179	1716226577232	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226578234	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226578234	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1179	1716226578234	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226579236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226579236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1181	1716226579236	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226580237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226580237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1181	1716226580237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226581239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226581239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1181	1716226581239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	104	1716226582241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226582241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1187	1716226582241	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226583243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226583243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1187	1716226583243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226584245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226584245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1187	1716226584245	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226585247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226585247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1210999999999998	1716226585247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226586249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226586249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1210999999999998	1716226586249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	103	1716226587251	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226587251	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1210999999999998	1716226587251	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226588253	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226588253	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226568229	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226569237	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226570242	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226571243	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226572247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226573249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226574239	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226575249	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226576252	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226577253	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226578247	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226579261	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226580263	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226581264	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226582262	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226583257	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226584268	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226585269	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226586271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226587271	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226588273	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226589277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Swap Memory GB	0.0008	1716226590277	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1182	1716226588253	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	101	1716226589255	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	7.699999999999999	1716226589255	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1182	1716226589255	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - CPU Utilization	102	1716226590257	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Utilization	9.6	1716226590257	de35cf1dcafb466d83a5fec08b4700d5	0	f
TOP - Memory Usage GB	2.1182	1716226590257	de35cf1dcafb466d83a5fec08b4700d5	0	f
\.


--
-- Data for Name: model_version_tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.model_version_tags (key, value, name, version) FROM stdin;
\.


--
-- Data for Name: model_versions; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.model_versions (name, version, creation_time, last_updated_time, description, user_id, current_stage, source, run_id, status, status_message, run_link, storage_location) FROM stdin;
\.


--
-- Data for Name: params; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.params (key, value, run_uuid) FROM stdin;
letter	0	c40dd324dd3b41128730ef1ce57bba4c
workload	0	c40dd324dd3b41128730ef1ce57bba4c
listeners	smi+top+dcgmi	c40dd324dd3b41128730ef1ce57bba4c
params	'"-"'	c40dd324dd3b41128730ef1ce57bba4c
file	cifar10.py	c40dd324dd3b41128730ef1ce57bba4c
workload_listener	''	c40dd324dd3b41128730ef1ce57bba4c
letter	0	de35cf1dcafb466d83a5fec08b4700d5
workload	0	de35cf1dcafb466d83a5fec08b4700d5
listeners	smi+top+dcgmi	de35cf1dcafb466d83a5fec08b4700d5
params	'"-"'	de35cf1dcafb466d83a5fec08b4700d5
file	cifar10.py	de35cf1dcafb466d83a5fec08b4700d5
workload_listener	''	de35cf1dcafb466d83a5fec08b4700d5
model	cifar10.py	de35cf1dcafb466d83a5fec08b4700d5
manual	False	de35cf1dcafb466d83a5fec08b4700d5
max_epoch	5	de35cf1dcafb466d83a5fec08b4700d5
max_time	172800	de35cf1dcafb466d83a5fec08b4700d5
\.


--
-- Data for Name: registered_model_aliases; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.registered_model_aliases (alias, version, name) FROM stdin;
\.


--
-- Data for Name: registered_model_tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.registered_model_tags (key, value, name) FROM stdin;
\.


--
-- Data for Name: registered_models; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.registered_models (name, creation_time, last_updated_time, description) FROM stdin;
\.


--
-- Data for Name: runs; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.runs (run_uuid, name, source_type, source_name, entry_point_name, user_id, status, start_time, end_time, source_version, lifecycle_stage, artifact_uri, experiment_id, deleted_time) FROM stdin;
c40dd324dd3b41128730ef1ce57bba4c	respected-fish-93	UNKNOWN			daga	FAILED	1716223718710	1716223854067		active	s3://mlflow-storage/0/c40dd324dd3b41128730ef1ce57bba4c/artifacts	0	\N
de35cf1dcafb466d83a5fec08b4700d5	(0 0) efficient-rook-873	UNKNOWN			daga	FINISHED	1716223897969	1716226591328		active	s3://mlflow-storage/0/de35cf1dcafb466d83a5fec08b4700d5/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	c40dd324dd3b41128730ef1ce57bba4c
mlflow.source.name	file:///home/daga/radt#examples/pytorch	c40dd324dd3b41128730ef1ce57bba4c
mlflow.source.type	PROJECT	c40dd324dd3b41128730ef1ce57bba4c
mlflow.project.entryPoint	main	c40dd324dd3b41128730ef1ce57bba4c
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	c40dd324dd3b41128730ef1ce57bba4c
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	c40dd324dd3b41128730ef1ce57bba4c
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	c40dd324dd3b41128730ef1ce57bba4c
mlflow.runName	respected-fish-93	c40dd324dd3b41128730ef1ce57bba4c
mlflow.project.env	conda	c40dd324dd3b41128730ef1ce57bba4c
mlflow.project.backend	local	c40dd324dd3b41128730ef1ce57bba4c
mlflow.user	daga	de35cf1dcafb466d83a5fec08b4700d5
mlflow.source.name	file:///home/daga/radt#examples/pytorch	de35cf1dcafb466d83a5fec08b4700d5
mlflow.source.type	PROJECT	de35cf1dcafb466d83a5fec08b4700d5
mlflow.project.entryPoint	main	de35cf1dcafb466d83a5fec08b4700d5
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	de35cf1dcafb466d83a5fec08b4700d5
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	de35cf1dcafb466d83a5fec08b4700d5
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	de35cf1dcafb466d83a5fec08b4700d5
mlflow.project.env	conda	de35cf1dcafb466d83a5fec08b4700d5
mlflow.project.backend	local	de35cf1dcafb466d83a5fec08b4700d5
mlflow.runName	(0 0) efficient-rook-873	de35cf1dcafb466d83a5fec08b4700d5
\.


--
-- Name: experiments_experiment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mlflow_user
--

SELECT pg_catalog.setval('public.experiments_experiment_id_seq', 1, false);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: datasets dataset_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT dataset_pk PRIMARY KEY (experiment_id, name, digest);


--
-- Name: experiments experiment_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.experiments
    ADD CONSTRAINT experiment_pk PRIMARY KEY (experiment_id);


--
-- Name: experiment_tags experiment_tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.experiment_tags
    ADD CONSTRAINT experiment_tag_pk PRIMARY KEY (key, experiment_id);


--
-- Name: experiments experiments_name_key; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.experiments
    ADD CONSTRAINT experiments_name_key UNIQUE (name);


--
-- Name: input_tags input_tags_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.input_tags
    ADD CONSTRAINT input_tags_pk PRIMARY KEY (input_uuid, name);


--
-- Name: inputs inputs_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.inputs
    ADD CONSTRAINT inputs_pk PRIMARY KEY (source_type, source_id, destination_type, destination_id);


--
-- Name: latest_metrics latest_metric_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.latest_metrics
    ADD CONSTRAINT latest_metric_pk PRIMARY KEY (key, run_uuid);


--
-- Name: metrics metric_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metric_pk PRIMARY KEY (key, "timestamp", step, run_uuid, value, is_nan);


--
-- Name: model_versions model_version_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.model_versions
    ADD CONSTRAINT model_version_pk PRIMARY KEY (name, version);


--
-- Name: model_version_tags model_version_tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.model_version_tags
    ADD CONSTRAINT model_version_tag_pk PRIMARY KEY (key, name, version);


--
-- Name: params param_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.params
    ADD CONSTRAINT param_pk PRIMARY KEY (key, run_uuid);


--
-- Name: registered_model_aliases registered_model_alias_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.registered_model_aliases
    ADD CONSTRAINT registered_model_alias_pk PRIMARY KEY (name, alias);


--
-- Name: registered_models registered_model_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.registered_models
    ADD CONSTRAINT registered_model_pk PRIMARY KEY (name);


--
-- Name: registered_model_tags registered_model_tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.registered_model_tags
    ADD CONSTRAINT registered_model_tag_pk PRIMARY KEY (key, name);


--
-- Name: runs run_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.runs
    ADD CONSTRAINT run_pk PRIMARY KEY (run_uuid);


--
-- Name: tags tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tag_pk PRIMARY KEY (key, run_uuid);


--
-- Name: index_datasets_dataset_uuid; Type: INDEX; Schema: public; Owner: mlflow_user
--

CREATE INDEX index_datasets_dataset_uuid ON public.datasets USING btree (dataset_uuid);


--
-- Name: index_datasets_experiment_id_dataset_source_type; Type: INDEX; Schema: public; Owner: mlflow_user
--

CREATE INDEX index_datasets_experiment_id_dataset_source_type ON public.datasets USING btree (experiment_id, dataset_source_type);


--
-- Name: index_inputs_destination_type_destination_id_source_type; Type: INDEX; Schema: public; Owner: mlflow_user
--

CREATE INDEX index_inputs_destination_type_destination_id_source_type ON public.inputs USING btree (destination_type, destination_id, source_type);


--
-- Name: index_inputs_input_uuid; Type: INDEX; Schema: public; Owner: mlflow_user
--

CREATE INDEX index_inputs_input_uuid ON public.inputs USING btree (input_uuid);


--
-- Name: index_latest_metrics_run_uuid; Type: INDEX; Schema: public; Owner: mlflow_user
--

CREATE INDEX index_latest_metrics_run_uuid ON public.latest_metrics USING btree (run_uuid);


--
-- Name: index_metrics_run_uuid; Type: INDEX; Schema: public; Owner: mlflow_user
--

CREATE INDEX index_metrics_run_uuid ON public.metrics USING btree (run_uuid);


--
-- Name: index_params_run_uuid; Type: INDEX; Schema: public; Owner: mlflow_user
--

CREATE INDEX index_params_run_uuid ON public.params USING btree (run_uuid);


--
-- Name: index_tags_run_uuid; Type: INDEX; Schema: public; Owner: mlflow_user
--

CREATE INDEX index_tags_run_uuid ON public.tags USING btree (run_uuid);


--
-- Name: datasets datasets_experiment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT datasets_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);


--
-- Name: experiment_tags experiment_tags_experiment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.experiment_tags
    ADD CONSTRAINT experiment_tags_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);


--
-- Name: latest_metrics latest_metrics_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.latest_metrics
    ADD CONSTRAINT latest_metrics_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- Name: metrics metrics_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- Name: model_version_tags model_version_tags_name_version_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.model_version_tags
    ADD CONSTRAINT model_version_tags_name_version_fkey FOREIGN KEY (name, version) REFERENCES public.model_versions(name, version) ON UPDATE CASCADE;


--
-- Name: model_versions model_versions_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.model_versions
    ADD CONSTRAINT model_versions_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE;


--
-- Name: params params_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.params
    ADD CONSTRAINT params_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- Name: registered_model_aliases registered_model_alias_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.registered_model_aliases
    ADD CONSTRAINT registered_model_alias_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: registered_model_tags registered_model_tags_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.registered_model_tags
    ADD CONSTRAINT registered_model_tags_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE;


--
-- Name: runs runs_experiment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.runs
    ADD CONSTRAINT runs_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);


--
-- Name: tags tags_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- PostgreSQL database dump complete
--

