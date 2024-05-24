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
0	Default	s3://mlflow-storage/0	active	1716235436008	1716235436008
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
SMI - Power Draw	14.53	1716235792330	0	f	12f7bcc1326849ebb1b120cd129bcc57
SMI - Timestamp	1716235792.319	1716235792330	0	f	12f7bcc1326849ebb1b120cd129bcc57
SMI - GPU Util	0	1716235792330	0	f	12f7bcc1326849ebb1b120cd129bcc57
SMI - Mem Util	0	1716235792330	0	f	12f7bcc1326849ebb1b120cd129bcc57
SMI - Mem Used	0	1716235792330	0	f	12f7bcc1326849ebb1b120cd129bcc57
SMI - Performance State	0	1716235792330	0	f	12f7bcc1326849ebb1b120cd129bcc57
TOP - CPU Utilization	102	1716237153988	0	f	12f7bcc1326849ebb1b120cd129bcc57
TOP - Memory Usage GB	2.013	1716237153988	0	f	12f7bcc1326849ebb1b120cd129bcc57
TOP - Memory Utilization	6.6	1716237153988	0	f	12f7bcc1326849ebb1b120cd129bcc57
TOP - Swap Memory GB	0.0005	1716237154013	0	f	12f7bcc1326849ebb1b120cd129bcc57
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.53	1716235792330	12f7bcc1326849ebb1b120cd129bcc57	0	f
SMI - Timestamp	1716235792.319	1716235792330	12f7bcc1326849ebb1b120cd129bcc57	0	f
SMI - GPU Util	0	1716235792330	12f7bcc1326849ebb1b120cd129bcc57	0	f
SMI - Mem Util	0	1716235792330	12f7bcc1326849ebb1b120cd129bcc57	0	f
SMI - Mem Used	0	1716235792330	12f7bcc1326849ebb1b120cd129bcc57	0	f
SMI - Performance State	0	1716235792330	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	0	1716235792397	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	0	1716235792397	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.2370999999999999	1716235792397	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235792412	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	131.2	1716235793399	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	9	1716235793399	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.2370999999999999	1716235793399	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235793414	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235794401	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235794401	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.2370999999999999	1716235794401	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235794422	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235795403	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235795403	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4702	1716235795403	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235795424	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235796405	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235796405	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4702	1716235796405	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235796425	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235797407	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235797407	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4702	1716235797407	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235797421	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235798409	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235798409	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4703	1716235798409	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235798427	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235799410	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235799410	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4703	1716235799410	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235799432	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235800412	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235800412	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4703	1716235800412	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235800426	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235801414	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235801414	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4703	1716235801414	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235801436	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235802416	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235802416	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4703	1716235802416	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235802438	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235803418	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235803418	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4703	1716235803418	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235803440	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235804420	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235804420	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4706	1716235804420	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235804441	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235805422	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235805422	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4706	1716235805422	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235805436	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235806424	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235806424	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4706	1716235806424	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235806445	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235807447	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235808449	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235809451	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235810444	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235811454	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235812457	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235813458	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235814460	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235815463	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236116016	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236116016	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9496	1716236116016	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236117018	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236117018	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9496	1716236117018	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236118019	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236118019	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9496	1716236118019	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236119021	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236119021	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9492	1716236119021	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236120024	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236120024	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9492	1716236120024	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236121025	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236121025	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9492	1716236121025	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236122027	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236122027	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9489	1716236122027	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236123029	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236123029	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9489	1716236123029	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236124031	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236124031	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9489	1716236124031	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236125033	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236125033	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9487	1716236125033	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236126034	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236126034	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9487	1716236126034	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236127037	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236127037	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9487	1716236127037	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236128039	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236128039	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9507999999999999	1716236128039	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236129041	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236129041	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9507999999999999	1716236129041	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236130042	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236130042	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9507999999999999	1716236130042	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236131045	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236131045	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9518	1716236131045	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236132047	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	2.7	1716236132047	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9518	1716236132047	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236133049	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236133049	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9518	1716236133049	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	105	1716235807426	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235807426	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4704000000000002	1716235807426	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235808428	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235808428	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4704000000000002	1716235808428	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235809430	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235809430	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4704000000000002	1716235809430	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235810431	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235810431	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4705	1716235810431	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235811433	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235811433	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4705	1716235811433	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235812435	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235812435	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4705	1716235812435	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235813437	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235813437	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4717	1716235813437	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235814439	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235814439	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4717	1716235814439	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235815441	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235815441	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4717	1716235815441	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235816443	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235816443	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4709	1716235816443	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235816465	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235817445	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235817445	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4709	1716235817445	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235817467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235818447	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235818447	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4709	1716235818447	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235818468	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235819449	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235819449	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4714	1716235819449	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235819471	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235820451	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235820451	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4714	1716235820451	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235820472	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235821453	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235821453	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4714	1716235821453	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235821467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235822455	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235822455	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4712	1716235822455	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235822476	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235823457	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235823457	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4712	1716235823457	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235823479	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235824459	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235824459	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4712	1716235824459	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235824482	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	105	1716235825461	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235825461	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4724000000000002	1716235825461	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235826463	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235826463	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4724000000000002	1716235826463	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235827465	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235827465	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.4724000000000002	1716235827465	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235828467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235828467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.8302	1716235828467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716235829469	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235829469	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.8302	1716235829469	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235830470	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235830470	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.8302	1716235830470	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235831472	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235831472	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9892999999999998	1716235831472	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235832474	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235832474	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9892999999999998	1716235832474	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235833476	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235833476	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9892999999999998	1716235833476	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235834478	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235834478	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9905	1716235834478	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	99	1716235835480	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235835480	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9905	1716235835480	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235836481	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235836481	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9905	1716235836481	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235837483	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235837483	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9932	1716235837483	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235838485	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235838485	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9932	1716235838485	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235839487	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235839487	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9932	1716235839487	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235840489	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235840489	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9942	1716235840489	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235841491	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235841491	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9942	1716235841491	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235842493	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235842493	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9942	1716235842493	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235843494	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235843494	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9963	1716235843494	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235844496	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716235844496	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9963	1716235844496	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235845498	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.4	1716235845498	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9963	1716235845498	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235846500	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235846500	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235825473	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235826483	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235827486	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235828480	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235829483	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235830492	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235831493	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235832495	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235833497	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235834500	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235835497	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235836502	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235837505	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235838499	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235839501	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235840503	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235841514	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235842514	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235843516	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235844517	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235845521	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235846524	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235847524	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235848525	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235849527	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235850529	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235851526	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235852533	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235853537	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235854537	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235855533	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235856535	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235857545	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235858545	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235859541	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235860550	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235861554	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235862555	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235863557	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235864561	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235865555	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235866563	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235867566	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235868567	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235869569	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235870563	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235871572	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235872573	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235873576	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235874575	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235875577	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236116030	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236117039	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236118040	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236119043	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236120038	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236121039	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236122048	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236123051	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236124054	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236125045	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236126049	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236127061	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236128053	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236129061	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0015	1716235846500	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235847502	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	4.3	1716235847502	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0015	1716235847502	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235848504	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235848504	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0015	1716235848504	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235849506	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235849506	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.928	1716235849506	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235850508	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235850508	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.928	1716235850508	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235851509	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235851509	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.928	1716235851509	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235852511	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235852511	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9325999999999999	1716235852511	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235853513	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235853513	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9325999999999999	1716235853513	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235854517	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235854517	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9325999999999999	1716235854517	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235855518	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235855518	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9347999999999999	1716235855518	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716235856520	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235856520	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9347999999999999	1716235856520	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235857522	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235857522	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9347999999999999	1716235857522	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235858524	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235858524	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9332	1716235858524	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235859526	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235859526	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9332	1716235859526	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235860528	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235860528	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9332	1716235860528	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235861530	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235861530	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9334	1716235861530	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235862531	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235862531	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9334	1716235862531	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235863534	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235863534	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9334	1716235863534	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235864536	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235864536	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.935	1716235864536	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235865538	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235865538	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.935	1716235865538	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235866540	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235866540	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.935	1716235866540	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235867542	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.6	1716235867542	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.935	1716235867542	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235868544	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235868544	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.935	1716235868544	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235869546	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.3999999999999995	1716235869546	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.935	1716235869546	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235870547	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235870547	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9305999999999999	1716235870547	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716235871549	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235871549	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9305999999999999	1716235871549	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235872551	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235872551	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9305999999999999	1716235872551	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235873553	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235873553	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9325	1716235873553	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235874554	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235874554	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9325	1716235874554	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235875556	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235875556	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9325	1716235875556	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235876558	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235876558	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9345	1716235876558	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235876581	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235877560	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235877560	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9345	1716235877560	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235877582	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235878562	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235878562	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9345	1716235878562	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235878583	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235879564	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235879564	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9336	1716235879564	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235879580	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235880566	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235880566	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9336	1716235880566	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235880580	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235881568	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235881568	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9336	1716235881568	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235881584	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235882570	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235882570	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9343	1716235882570	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235882586	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235883572	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235883572	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9343	1716235883572	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235883594	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235884574	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235884574	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9343	1716235884574	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235884587	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235885576	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235885576	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9367999999999999	1716235885576	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235885588	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235886577	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235886577	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9367999999999999	1716235886577	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716235887580	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235887580	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9367999999999999	1716235887580	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235888581	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235888581	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9381	1716235888581	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235889583	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235889583	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9381	1716235889583	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235890584	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235890584	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9381	1716235890584	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235891587	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235891587	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9382000000000001	1716235891587	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235892589	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235892589	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9382000000000001	1716235892589	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716235893591	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235893591	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9382000000000001	1716235893591	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235894593	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235894593	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9327999999999999	1716235894593	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235895595	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235895595	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9327999999999999	1716235895595	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235896596	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235896596	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9327999999999999	1716235896596	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235897598	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235897598	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9349	1716235897598	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235898600	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235898600	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9349	1716235898600	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235899603	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235899603	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9349	1716235899603	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235900604	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235900604	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9353	1716235900604	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235901608	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235901608	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9353	1716235901608	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235902610	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235902610	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9353	1716235902610	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235903612	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235903612	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9356	1716235903612	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235904613	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235904613	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9356	1716235904613	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235905615	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235905615	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9356	1716235905615	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235906617	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235906617	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9379000000000002	1716235906617	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235907619	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235886605	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235887603	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235888602	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235889597	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235890598	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235891610	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235892611	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235893615	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235894608	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235895610	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235896610	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235897613	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235898622	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235899624	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235900626	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235901622	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235902632	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235903638	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235904627	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235905637	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235906639	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235907640	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235908636	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235909646	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235910639	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235911647	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235912712	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235913655	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235914660	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235915650	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235916662	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235917663	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235918662	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235919667	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235920665	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235921668	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235922670	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235923673	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235924675	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235925668	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235926678	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235927683	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235928681	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235929683	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235930678	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235931689	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235932692	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235933692	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235934696	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235935690	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236130055	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236131068	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236132070	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236133070	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236134073	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236135065	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236136077	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236137078	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236138080	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236139077	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236140076	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236141085	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236142086	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236143081	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236144089	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235907619	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9379000000000002	1716235907619	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235908621	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235908621	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9379000000000002	1716235908621	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235909623	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235909623	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9377	1716235909623	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235910624	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235910624	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9377	1716235910624	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235911626	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235911626	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9377	1716235911626	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235912628	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235912628	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9385999999999999	1716235912628	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235913632	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235913632	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9385999999999999	1716235913632	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	108	1716235914634	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1000000000000005	1716235914634	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9385999999999999	1716235914634	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235915635	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235915635	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9344000000000001	1716235915635	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235916637	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235916637	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9344000000000001	1716235916637	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235917639	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235917639	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9344000000000001	1716235917639	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235918641	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235918641	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9376	1716235918641	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235919643	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235919643	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9376	1716235919643	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235920645	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235920645	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9376	1716235920645	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235921647	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235921647	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9365	1716235921647	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716235922649	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235922649	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9365	1716235922649	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235923651	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235923651	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9365	1716235923651	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235924653	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235924653	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9387	1716235924653	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235925654	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235925654	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9387	1716235925654	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235926656	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235926656	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9387	1716235926656	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235927658	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235927658	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9389	1716235927658	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235928660	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235928660	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9389	1716235928660	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235929662	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235929662	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9389	1716235929662	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235930665	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235930665	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9403	1716235930665	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235931668	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235931668	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9403	1716235931668	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235932670	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235932670	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9403	1716235932670	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235933672	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235933672	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9413	1716235933672	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235934674	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235934674	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9413	1716235934674	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235935675	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235935675	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9413	1716235935675	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235936677	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235936677	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9373	1716235936677	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235936700	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235937679	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235937679	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9373	1716235937679	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235937701	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235938681	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235938681	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9373	1716235938681	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235938704	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235939683	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235939683	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9394	1716235939683	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235939706	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235940685	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235940685	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9394	1716235940685	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235940698	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235941687	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235941687	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9394	1716235941687	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235941709	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716235942689	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235942689	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.941	1716235942689	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235942709	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235943691	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235943691	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.941	1716235943691	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235943712	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	106	1716235944692	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235944692	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.941	1716235944692	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235944714	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235945695	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235945695	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9384000000000001	1716235945695	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235945711	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235946696	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235946696	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9384000000000001	1716235946696	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716235947698	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235947698	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9384000000000001	1716235947698	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235948700	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235948700	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9385999999999999	1716235948700	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235949702	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235949702	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9385999999999999	1716235949702	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235950704	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235950704	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9385999999999999	1716235950704	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235951706	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235951706	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9404000000000001	1716235951706	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235952708	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235952708	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9404000000000001	1716235952708	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716235953709	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	4.4	1716235953709	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9404000000000001	1716235953709	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235954711	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235954711	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9423	1716235954711	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235955713	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235955713	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9423	1716235955713	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235956715	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235956715	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9423	1716235956715	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235957717	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235957717	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9382000000000001	1716235957717	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	98	1716235958719	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235958719	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9382000000000001	1716235958719	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235959721	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235959721	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9382000000000001	1716235959721	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235960722	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235960722	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9416	1716235960722	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235961724	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235961724	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9416	1716235961724	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235962726	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235962726	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9416	1716235962726	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716235963728	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235963728	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9427	1716235963728	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235964730	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235964730	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9427	1716235964730	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235965732	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235965732	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9427	1716235965732	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235966734	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235966734	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.943	1716235966734	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235967735	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235967735	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.943	1716235967735	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235946721	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235947719	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235948723	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235949723	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235950718	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235951720	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235952732	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235953730	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235954732	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235955726	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235956730	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235957730	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235958743	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235959734	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235960743	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235961739	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235962748	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235963750	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235964744	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235965753	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235966757	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235967757	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235968753	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235969752	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235970755	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235971764	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235972767	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235973768	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235974761	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235975764	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235976775	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235977779	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235978773	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235979775	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235980784	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235981787	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235982789	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235983782	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235984784	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235985784	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235986794	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235987798	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235988797	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235989792	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235990794	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235991803	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235992804	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235993807	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235994804	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235995811	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236134051	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236134051	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9501	1716236134051	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236135053	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236135053	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9501	1716236135053	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236136055	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236136055	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9501	1716236136055	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236137056	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236137056	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9502000000000002	1716236137056	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236138058	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236138058	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9502000000000002	1716236138058	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235968737	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235968737	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.943	1716235968737	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235969739	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235969739	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9422000000000001	1716235969739	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235970741	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235970741	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9422000000000001	1716235970741	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235971743	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235971743	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9422000000000001	1716235971743	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235972745	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235972745	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9424000000000001	1716235972745	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235973747	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235973747	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9424000000000001	1716235973747	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235974748	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235974748	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9424000000000001	1716235974748	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235975750	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235975750	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9432	1716235975750	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235976752	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235976752	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9432	1716235976752	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235977754	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235977754	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9432	1716235977754	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235978756	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235978756	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9384000000000001	1716235978756	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235979758	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235979758	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9384000000000001	1716235979758	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235980760	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235980760	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9384000000000001	1716235980760	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235981763	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235981763	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9425999999999999	1716235981763	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235982765	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235982765	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9425999999999999	1716235982765	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235983767	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235983767	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9425999999999999	1716235983767	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235984769	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235984769	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9422000000000001	1716235984769	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235985771	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235985771	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9422000000000001	1716235985771	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235986773	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235986773	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9422000000000001	1716235986773	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235987775	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235987775	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9424000000000001	1716235987775	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235988776	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235988776	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9424000000000001	1716235988776	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235989778	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235989778	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9424000000000001	1716235989778	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235990780	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.5	1716235990780	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9454	1716235990780	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235991782	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.7	1716235991782	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9454	1716235991782	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235992784	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716235992784	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9454	1716235992784	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235993786	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716235993786	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9429	1716235993786	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235994788	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716235994788	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9429	1716235994788	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235995789	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716235995789	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9429	1716235995789	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716235996791	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6	1716235996791	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9456	1716235996791	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235996813	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716235997793	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716235997793	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9456	1716235997793	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235997816	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716235998795	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716235998795	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9456	1716235998795	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235998817	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716235999797	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716235999797	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9410999999999998	1716235999797	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716235999811	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236000799	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236000799	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9410999999999998	1716236000799	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236000814	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236001800	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236001800	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9410999999999998	1716236001800	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236001822	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236002802	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236002802	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9467	1716236002802	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236002826	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236003804	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236003804	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9467	1716236003804	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236003824	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236004806	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236004806	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9467	1716236004806	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236004819	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236005808	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236005808	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.946	1716236005808	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236005825	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236006810	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236006810	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.946	1716236006810	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236006835	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236007812	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236007812	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.946	1716236007812	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236008814	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236008814	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9461	1716236008814	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236009815	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236009815	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9461	1716236009815	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236010817	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236010817	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9461	1716236010817	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236011819	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236011819	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9465	1716236011819	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236012821	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236012821	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9465	1716236012821	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236013823	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236013823	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9465	1716236013823	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236014825	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236014825	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9496	1716236014825	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236015826	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236015826	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9496	1716236015826	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236016828	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236016828	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9496	1716236016828	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236017830	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236017830	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9465	1716236017830	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236018832	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236018832	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9465	1716236018832	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236019835	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6	1716236019835	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9465	1716236019835	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236020837	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236020837	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9455	1716236020837	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236021839	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236021839	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9455	1716236021839	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236022841	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236022841	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9455	1716236022841	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236023843	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236023843	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9467	1716236023843	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236024845	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236024845	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9467	1716236024845	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236025847	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236025847	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9467	1716236025847	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236026849	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236026849	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9450999999999998	1716236026849	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236027851	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236027851	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9450999999999998	1716236027851	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236028852	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236007833	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236008836	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236009830	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236010832	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236011840	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236012842	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236013844	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236014838	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236015840	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236016849	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236017851	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236018854	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236019852	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236020852	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236021855	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236022857	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236023857	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236024859	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236025861	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236026863	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236027868	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236028870	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236029868	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236030873	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236031873	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236032874	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236033875	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236034877	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236035890	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236036882	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236037891	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236038885	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236039887	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236040889	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236041891	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236042894	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236043896	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236044896	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236045901	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236046909	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236047916	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236048913	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236049907	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236050910	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236051919	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236052920	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236053924	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236054918	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236139060	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236139060	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9502000000000002	1716236139060	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236140062	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236140062	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9518	1716236140062	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236141064	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236141064	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9518	1716236141064	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236142065	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236142065	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9518	1716236142065	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236143066	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236143066	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9521	1716236143066	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236144068	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236144068	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236028852	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9450999999999998	1716236028852	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236029855	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236029855	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9454	1716236029855	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236030857	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236030857	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9454	1716236030857	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236031858	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236031858	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9454	1716236031858	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236032860	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236032860	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9447999999999999	1716236032860	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236033862	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236033862	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9447999999999999	1716236033862	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236034864	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236034864	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9447999999999999	1716236034864	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236035866	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236035866	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9484000000000001	1716236035866	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236036868	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236036868	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9484000000000001	1716236036868	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236037870	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236037870	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9484000000000001	1716236037870	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236038872	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236038872	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9484000000000001	1716236038872	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236039874	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236039874	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9484000000000001	1716236039874	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236040875	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236040875	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9484000000000001	1716236040875	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236041877	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236041877	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9490999999999998	1716236041877	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236042879	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236042879	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9490999999999998	1716236042879	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236043881	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236043881	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9490999999999998	1716236043881	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236044883	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236044883	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9475	1716236044883	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236045886	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236045886	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9475	1716236045886	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236046888	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236046888	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9475	1716236046888	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236047890	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236047890	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9490999999999998	1716236047890	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236048892	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236048892	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9490999999999998	1716236048892	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236049894	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236049894	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9490999999999998	1716236049894	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236050896	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236050896	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9481	1716236050896	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236051898	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236051898	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9481	1716236051898	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236052900	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236052900	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9481	1716236052900	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236053902	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236053902	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9487999999999999	1716236053902	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236054904	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236054904	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9487999999999999	1716236054904	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236055905	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236055905	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9487999999999999	1716236055905	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236055923	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236056907	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236056907	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9479000000000002	1716236056907	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236056928	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236057911	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236057911	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9479000000000002	1716236057911	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236057931	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236058912	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236058912	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9479000000000002	1716236058912	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236058935	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236059914	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236059914	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9495	1716236059914	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236059929	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236060916	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	4.5	1716236060916	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9495	1716236060916	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236060931	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236061918	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236061918	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9495	1716236061918	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236061939	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236062920	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236062920	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9478	1716236062920	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236062934	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236063922	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236063922	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9478	1716236063922	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236063943	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236064924	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236064924	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9478	1716236064924	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236064937	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236065926	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236065926	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9502000000000002	1716236065926	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236065941	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236066927	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236066927	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9502000000000002	1716236066927	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236066949	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236067929	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236067929	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9502000000000002	1716236067929	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236068931	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236068931	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9494	1716236068931	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236069933	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	2.7	1716236069933	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9494	1716236069933	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236070934	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236070934	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9494	1716236070934	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236071936	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236071936	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9484000000000001	1716236071936	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236072938	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236072938	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9484000000000001	1716236072938	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236073940	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236073940	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9484000000000001	1716236073940	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236074942	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236074942	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9510999999999998	1716236074942	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236075944	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236075944	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9510999999999998	1716236075944	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236076945	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236076945	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9510999999999998	1716236076945	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236077947	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236077947	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9495	1716236077947	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236078949	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236078949	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9495	1716236078949	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236079951	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236079951	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9495	1716236079951	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236080953	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236080953	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9482000000000002	1716236080953	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236081954	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236081954	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9482000000000002	1716236081954	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236082956	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236082956	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9482000000000002	1716236082956	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236083958	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236083958	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9503	1716236083958	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236084959	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236084959	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9503	1716236084959	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236085961	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236085961	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9503	1716236085961	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236086963	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236086963	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9472	1716236086963	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236087965	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236087965	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9472	1716236087965	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236088967	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236067944	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236068953	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236069947	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236070949	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236071960	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236072963	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236073962	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236074956	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236075960	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236076968	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236077969	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236078968	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236079964	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236080966	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236081969	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236082978	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236083981	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236084975	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236085977	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236086987	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236087987	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236088991	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236089981	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236090984	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236091993	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236092996	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236093999	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236094993	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236095995	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236097003	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236098004	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236099006	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236100001	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236101010	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236102014	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236103013	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236104015	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236105009	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236106014	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236107014	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236108019	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236109018	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236110019	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236111025	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236112028	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236113031	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236114034	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236115028	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9521	1716236144068	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236145070	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236145070	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9521	1716236145070	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236146072	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236146072	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9547999999999999	1716236146072	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236147074	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236147074	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9547999999999999	1716236147074	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236148076	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236148076	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9547999999999999	1716236148076	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236149078	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236149078	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.955	1716236149078	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236150080	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236088967	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9472	1716236088967	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236089968	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236089968	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.949	1716236089968	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236090970	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236090970	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.949	1716236090970	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236091972	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236091972	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.949	1716236091972	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236092974	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6	1716236092974	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.949	1716236092974	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236093976	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236093976	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.949	1716236093976	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236094978	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236094978	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.949	1716236094978	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236095979	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236095979	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9483	1716236095979	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236096981	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236096981	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9483	1716236096981	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236097983	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236097983	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9483	1716236097983	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236098985	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236098985	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9492	1716236098985	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236099987	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236099987	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9492	1716236099987	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236100989	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236100989	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9492	1716236100989	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236101991	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236101991	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9524000000000001	1716236101991	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236102993	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236102993	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9524000000000001	1716236102993	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236103994	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236103994	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9524000000000001	1716236103994	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236104996	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236104996	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9519000000000002	1716236104996	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236105998	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236105998	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9519000000000002	1716236105998	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236107000	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236107000	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9519000000000002	1716236107000	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236108002	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236108002	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9524000000000001	1716236108002	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236109004	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236109004	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9524000000000001	1716236109004	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236110004	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236110004	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9524000000000001	1716236110004	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236111006	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236111006	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.948	1716236111006	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236112008	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236112008	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.948	1716236112008	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236113010	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236113010	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.948	1716236113010	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236114012	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.800000000000001	1716236114012	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9493	1716236114012	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236115014	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.6000000000000005	1716236115014	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9493	1716236115014	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236145086	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236146093	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236147094	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236148097	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236149099	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236150080	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.955	1716236150080	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236150094	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236151082	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236151082	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.955	1716236151082	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236151102	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236152084	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236152084	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9554	1716236152084	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236152107	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236153085	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236153085	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9554	1716236153085	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236153107	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236154087	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236154087	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9554	1716236154087	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236154112	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236155089	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236155089	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9501	1716236155089	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236155107	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236156091	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236156091	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9501	1716236156091	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236156114	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236157093	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236157093	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9501	1716236157093	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236157116	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236158095	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236158095	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9533	1716236158095	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236158108	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236159097	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236159097	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9533	1716236159097	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236159118	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236160098	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236160098	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9533	1716236160098	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236160115	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236161100	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236161100	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9532	1716236161100	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236162102	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236162102	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9532	1716236162102	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236163104	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236163104	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9532	1716236163104	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236164106	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236164106	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.955	1716236164106	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236165108	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236165108	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.955	1716236165108	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236166110	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236166110	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.955	1716236166110	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236167111	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236167111	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9538	1716236167111	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236168113	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236168113	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9538	1716236168113	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236169115	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236169115	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9538	1716236169115	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236170117	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236170117	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9547	1716236170117	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236171119	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236171119	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9547	1716236171119	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236172121	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236172121	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9547	1716236172121	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236173122	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236173122	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9553	1716236173122	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236174124	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236174124	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9553	1716236174124	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236175127	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236175127	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9553	1716236175127	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236536815	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236536815	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9749	1716236536815	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236537816	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236537816	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9749	1716236537816	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236538818	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236538818	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9749	1716236538818	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236539820	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236539820	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9759	1716236539820	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236540822	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236540822	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9759	1716236540822	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236541824	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236541824	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9759	1716236541824	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236542826	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236161123	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236162123	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236163124	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236164127	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236165124	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236166125	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236167132	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236168136	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236169129	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236170134	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236171133	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236172144	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236173137	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236174147	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236175142	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236176129	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236176129	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9563	1716236176129	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236176153	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236177131	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236177131	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9563	1716236177131	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236177153	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236178133	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236178133	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9563	1716236178133	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236178154	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236179135	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236179135	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.953	1716236179135	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236179158	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236180137	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236180137	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.953	1716236180137	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236180159	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236181139	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236181139	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.953	1716236181139	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236181152	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236182141	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236182141	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9541	1716236182141	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236182161	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236183143	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236183143	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9541	1716236183143	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236183167	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236184145	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236184145	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9541	1716236184145	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236184166	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	105	1716236185146	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236185146	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9542	1716236185146	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236185168	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236186149	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236186149	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9542	1716236186149	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236186165	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236187150	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236187150	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9542	1716236187150	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236187174	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236188152	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	4.6	1716236188152	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9562	1716236188152	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236189154	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236189154	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9562	1716236189154	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236190156	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236190156	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9562	1716236190156	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236191157	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236191157	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9564000000000001	1716236191157	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236192159	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236192159	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9564000000000001	1716236192159	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236193161	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236193161	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9564000000000001	1716236193161	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236194163	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236194163	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9556	1716236194163	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236195165	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236195165	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9556	1716236195165	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236196168	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236196168	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9556	1716236196168	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236197169	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236197169	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9561	1716236197169	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236198171	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236198171	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9561	1716236198171	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236199173	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.3	1716236199173	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9561	1716236199173	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236200174	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236200174	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9516	1716236200174	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236201176	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236201176	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9516	1716236201176	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236202178	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236202178	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9516	1716236202178	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236203180	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236203180	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9529	1716236203180	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236204183	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236204183	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9529	1716236204183	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236205185	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236205185	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9529	1716236205185	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236206187	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236206187	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9557	1716236206187	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236207188	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236207188	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9557	1716236207188	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236208190	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236208190	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9557	1716236208190	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236209192	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236209192	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9554	1716236209192	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236188165	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236189175	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236190168	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236191181	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236192173	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236193186	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236194184	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236195187	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236196183	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236197191	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236198185	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236199199	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236200195	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236201191	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236202192	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236203194	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236204198	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236205206	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236206207	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236207201	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236208204	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236209214	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236210216	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236211209	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236212214	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236213217	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236214215	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236215217	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236216219	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236217228	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236218222	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236219232	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236220236	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236221236	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236222229	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236223241	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236224240	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236225244	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236226244	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236227245	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236228247	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236229250	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236230246	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236231255	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236232256	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236233259	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236234259	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236235254	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236536836	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236537831	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236538840	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236539844	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236540837	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236541846	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236542841	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236543849	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236544850	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236545845	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236546854	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236547857	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236548858	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236549861	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236550861	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236551865	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236552866	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236210194	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236210194	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9554	1716236210194	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236211196	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236211196	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9554	1716236211196	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236212198	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236212198	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9561	1716236212198	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236213199	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236213199	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9561	1716236213199	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236214201	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236214201	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9561	1716236214201	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236215203	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236215203	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9567	1716236215203	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236216205	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236216205	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9567	1716236216205	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236217207	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236217207	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9567	1716236217207	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236218208	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236218208	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9586	1716236218208	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236219210	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236219210	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9586	1716236219210	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236220212	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236220212	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9586	1716236220212	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236221214	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236221214	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9595	1716236221214	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236222216	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236222216	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9595	1716236222216	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236223218	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236223218	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9595	1716236223218	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236224220	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236224220	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.955	1716236224220	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236225221	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236225221	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.955	1716236225221	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236226223	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236226223	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.955	1716236226223	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236227225	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236227225	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9561	1716236227225	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236228226	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236228226	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9561	1716236228226	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236229228	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236229228	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9561	1716236229228	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236230230	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236230230	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9558	1716236230230	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236231232	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236231232	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9558	1716236231232	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236232235	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236232235	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9558	1716236232235	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236233236	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236233236	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9567	1716236233236	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236234238	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236234238	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9567	1716236234238	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236235240	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236235240	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9567	1716236235240	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236236242	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236236242	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9576	1716236236242	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236236263	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236237244	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236237244	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9576	1716236237244	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236237258	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236238246	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236238246	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9576	1716236238246	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236238267	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236239248	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236239248	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9573	1716236239248	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236239268	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236240249	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236240249	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9573	1716236240249	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236240273	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236241251	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236241251	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9573	1716236241251	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236241267	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236242254	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236242254	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.958	1716236242254	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236242268	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236243256	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236243256	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.958	1716236243256	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236243274	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236244258	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236244258	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.958	1716236244258	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236244275	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236245260	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236245260	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9581	1716236245260	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236245282	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236246261	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236246261	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9581	1716236246261	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236246277	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236247263	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236247263	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9581	1716236247263	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236247285	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236248265	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236248265	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9584000000000001	1716236248265	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236249266	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236249266	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9584000000000001	1716236249266	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236250269	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236250269	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9584000000000001	1716236250269	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236251271	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236251271	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.959	1716236251271	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236252273	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236252273	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.959	1716236252273	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236253275	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236253275	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.959	1716236253275	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236254277	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236254277	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9582	1716236254277	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236255279	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236255279	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9582	1716236255279	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236256280	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236256280	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9582	1716236256280	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236257282	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236257282	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9590999999999998	1716236257282	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236258284	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236258284	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9590999999999998	1716236258284	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236259286	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236259286	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9590999999999998	1716236259286	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236260288	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236260288	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9605	1716236260288	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236261289	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236261289	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9605	1716236261289	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236262291	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236262291	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9605	1716236262291	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236263293	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236263293	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9603	1716236263293	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236264295	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236264295	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9603	1716236264295	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236265297	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236265297	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9603	1716236265297	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236266299	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236266299	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.958	1716236266299	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236267301	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236267301	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.958	1716236267301	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236268303	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236268303	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.958	1716236268303	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236269305	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236269305	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9605	1716236269305	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236248286	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236249290	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236250290	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236251292	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236252295	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236253298	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236254299	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236255303	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236256297	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236257303	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236258307	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236259309	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236260301	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236261310	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236262306	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236263308	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236264317	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236265311	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236266327	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236267320	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236268326	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236269328	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236270322	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236271322	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236272325	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236273336	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236274336	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236275328	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236276334	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236277343	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236278342	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236279344	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236280339	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236281350	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236282344	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236283351	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236284355	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236285357	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236286350	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236287358	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236288363	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236289363	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236290357	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236291360	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236292368	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236293371	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236294372	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236295376	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236542826	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9763	1716236542826	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236543828	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236543828	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9763	1716236543828	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236544829	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236544829	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9763	1716236544829	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236545831	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236545831	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9750999999999999	1716236545831	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236546833	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236546833	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9750999999999999	1716236546833	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236547835	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236547835	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9750999999999999	1716236547835	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236270307	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236270307	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9605	1716236270307	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236271308	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236271308	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9605	1716236271308	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236272310	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236272310	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9609	1716236272310	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236273312	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236273312	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9609	1716236273312	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236274314	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236274314	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9609	1716236274314	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236275316	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236275316	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9598	1716236275316	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236276318	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236276318	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9598	1716236276318	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236277320	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236277320	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9598	1716236277320	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236278322	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236278322	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9606	1716236278322	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236279323	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236279323	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9606	1716236279323	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236280325	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236280325	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9606	1716236280325	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236281327	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236281327	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9612	1716236281327	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236282328	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236282328	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9612	1716236282328	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236283330	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236283330	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9612	1716236283330	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236284332	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236284332	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9606	1716236284332	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236285334	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236285334	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9606	1716236285334	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236286336	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236286336	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9606	1716236286336	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236287338	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236287338	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9601	1716236287338	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236288340	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236288340	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9601	1716236288340	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236289341	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236289341	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9601	1716236289341	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236290343	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236290343	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9587	1716236290343	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236291345	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236291345	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9587	1716236291345	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236292347	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236292347	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9587	1716236292347	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236293349	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236293349	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9612	1716236293349	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236294351	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236294351	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9612	1716236294351	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236295353	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236295353	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9612	1716236295353	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236296355	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236296355	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9607	1716236296355	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236296378	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236297356	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236297356	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9607	1716236297356	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236297372	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236298358	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236298358	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9607	1716236298358	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236298383	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236299360	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236299360	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9618	1716236299360	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236299381	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236300362	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.7	1716236300362	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9618	1716236300362	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236300384	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236301364	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	5.9	1716236301364	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9618	1716236301364	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236301378	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236302366	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236302366	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.96	1716236302366	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236302387	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236303367	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236303367	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.96	1716236303367	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236303391	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236304369	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236304369	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.96	1716236304369	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236304392	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236305370	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236305370	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9615	1716236305370	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236305391	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236306372	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236306372	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9615	1716236306372	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236306386	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236307374	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236307374	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9615	1716236307374	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236307395	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236308376	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236308376	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9612	1716236308376	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236309378	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236309378	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9612	1716236309378	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236310380	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236310380	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9612	1716236310380	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236311381	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236311381	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9616	1716236311381	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236312383	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236312383	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9616	1716236312383	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236313386	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236313386	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9616	1716236313386	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236314388	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236314388	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9605	1716236314388	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236315390	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236315390	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9605	1716236315390	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236316392	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236316392	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9605	1716236316392	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236317394	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236317394	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9612	1716236317394	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236318396	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236318396	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9612	1716236318396	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236319398	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236319398	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9612	1716236319398	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236320401	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236320401	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9621	1716236320401	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236321403	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236321403	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9621	1716236321403	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236322405	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236322405	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9621	1716236322405	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236323407	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236323407	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9617	1716236323407	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236324408	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236324408	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9617	1716236324408	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236325410	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236325410	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9617	1716236325410	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236326412	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236326412	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9627999999999999	1716236326412	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236327414	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236327414	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9627999999999999	1716236327414	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236328416	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236328416	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9627999999999999	1716236328416	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236329418	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236329418	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.963	1716236329418	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236308396	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236309400	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236310403	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236311402	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236312406	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236313407	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236314412	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236315407	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236316413	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236317415	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236318417	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236319422	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236320416	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236321427	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236322422	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236323429	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236324430	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236325423	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236326434	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236327437	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236328439	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236329439	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236330441	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236331442	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236332445	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236333447	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236334451	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236335444	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236336453	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236337457	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236338459	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236339461	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236340461	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236341462	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236342465	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236343459	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236344470	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236345472	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236346467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236347475	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236348480	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236349480	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236350481	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236351476	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236352484	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236353478	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236354490	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236355494	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236356490	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236357494	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236358496	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236359498	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236360500	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236361494	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236362504	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236363506	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236364507	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236365510	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236366506	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236367516	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236368516	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236369516	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236370519	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236371519	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236372524	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236330420	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236330420	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.963	1716236330420	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236331422	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236331422	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.963	1716236331422	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236332423	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236332423	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9619000000000002	1716236332423	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236333425	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236333425	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9619000000000002	1716236333425	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236334429	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236334429	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9619000000000002	1716236334429	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236335431	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236335431	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9636	1716236335431	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236336432	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236336432	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9636	1716236336432	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236337435	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236337435	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9636	1716236337435	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236338436	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236338436	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9637	1716236338436	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236339438	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236339438	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9637	1716236339438	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236340440	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236340440	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9637	1716236340440	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236341442	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236341442	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9644000000000001	1716236341442	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236342444	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236342444	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9644000000000001	1716236342444	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236343446	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236343446	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9644000000000001	1716236343446	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236344448	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236344448	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9626	1716236344448	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	99	1716236345450	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	2.9	1716236345450	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9626	1716236345450	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236346452	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236346452	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9626	1716236346452	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236347454	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236347454	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9629	1716236347454	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236348456	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236348456	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9629	1716236348456	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236349458	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236349458	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9629	1716236349458	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236350460	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236350460	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9649	1716236350460	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236351461	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236351461	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9649	1716236351461	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236352463	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236352463	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9649	1716236352463	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236353465	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236353465	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9643	1716236353465	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236354467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236354467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9643	1716236354467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236355469	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236355469	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9643	1716236355469	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236356471	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236356471	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9637	1716236356471	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236357473	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236357473	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9637	1716236357473	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236358475	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236358475	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9637	1716236358475	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236359476	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236359476	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9613	1716236359476	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236360478	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236360478	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9613	1716236360478	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236361480	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236361480	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9613	1716236361480	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236362482	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236362482	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.964	1716236362482	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236363484	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236363484	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.964	1716236363484	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236364486	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236364486	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.964	1716236364486	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236365488	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236365488	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.965	1716236365488	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236366490	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236366490	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.965	1716236366490	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236367492	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236367492	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.965	1716236367492	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236368494	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236368494	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9657	1716236368494	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236369495	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236369495	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9657	1716236369495	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236370497	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236370497	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9657	1716236370497	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236371499	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236371499	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9642	1716236371499	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236372501	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236372501	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9642	1716236372501	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236373503	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236373503	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9642	1716236373503	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236374505	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236374505	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.968	1716236374505	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236375507	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236375507	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.968	1716236375507	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236376508	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236376508	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.968	1716236376508	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236377510	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236377510	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9650999999999998	1716236377510	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236378512	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236378512	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9650999999999998	1716236378512	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236379516	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236379516	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9650999999999998	1716236379516	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236380518	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236380518	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9646	1716236380518	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236381519	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236381519	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9646	1716236381519	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236382521	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236382521	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9646	1716236382521	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236383524	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236383524	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9666	1716236383524	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236384526	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236384526	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9666	1716236384526	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236385528	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236385528	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9666	1716236385528	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236386530	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236386530	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9681	1716236386530	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236387532	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236387532	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9681	1716236387532	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236388534	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8	1716236388534	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9681	1716236388534	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236389536	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6	1716236389536	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9667000000000001	1716236389536	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236390538	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236390538	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9667000000000001	1716236390538	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236391540	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236391540	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9667000000000001	1716236391540	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236392542	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236392542	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9682	1716236392542	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236393544	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236393544	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9682	1716236393544	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236373525	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236374527	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236375524	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236376533	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236377531	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236378537	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236379537	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236380533	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236381542	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236382543	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236383547	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236384548	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236385551	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236386550	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236387553	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236388555	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236389557	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236390551	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236391563	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236392563	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236393567	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236394566	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236395561	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236396571	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236397577	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236398576	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236399577	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236400571	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236401579	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236402574	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236403584	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236404584	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236405580	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236406582	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236407583	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236408593	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236409594	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236410589	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236411590	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236412593	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236413603	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236414607	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236415606	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236548837	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236548837	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9764000000000002	1716236548837	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236549839	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236549839	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9764000000000002	1716236549839	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236550841	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236550841	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9764000000000002	1716236550841	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236551843	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236551843	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9764000000000002	1716236551843	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236552845	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236552845	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9764000000000002	1716236552845	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236553847	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236553847	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9764000000000002	1716236553847	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236554849	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236554849	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9762	1716236554849	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236555852	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236394546	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236394546	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9682	1716236394546	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236395547	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236395547	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9682	1716236395547	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236396549	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236396549	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9682	1716236396549	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236397551	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236397551	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9682	1716236397551	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236398553	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236398553	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9638	1716236398553	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236399555	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236399555	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9638	1716236399555	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236400557	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236400557	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9638	1716236400557	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236401559	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236401559	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9663	1716236401559	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236402560	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236402560	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9663	1716236402560	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236403562	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236403562	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9663	1716236403562	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236404564	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236404564	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9670999999999998	1716236404564	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236405566	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236405566	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9670999999999998	1716236405566	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236406568	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236406568	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9670999999999998	1716236406568	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236407570	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236407570	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9683	1716236407570	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236408571	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236408571	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9683	1716236408571	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236409573	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236409573	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9683	1716236409573	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236410575	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236410575	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9650999999999998	1716236410575	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236411577	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236411577	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9650999999999998	1716236411577	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236412579	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236412579	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9650999999999998	1716236412579	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236413581	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236413581	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9663	1716236413581	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236414583	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236414583	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9663	1716236414583	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236415585	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236415585	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9663	1716236415585	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236416587	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236416587	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9696	1716236416587	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236416607	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236417588	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236417588	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9696	1716236417588	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236417604	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236418590	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236418590	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9696	1716236418590	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236418613	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236419592	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236419592	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9625	1716236419592	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236419613	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236420594	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236420594	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9625	1716236420594	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236420609	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236421596	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236421596	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9625	1716236421596	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236421617	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236422599	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236422599	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9654	1716236422599	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236422613	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236423601	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236423601	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9654	1716236423601	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236423622	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236424603	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236424603	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9654	1716236424603	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236424616	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236425607	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236425607	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9669	1716236425607	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236425623	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236426608	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236426608	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9669	1716236426608	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236426621	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236427610	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236427610	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9669	1716236427610	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236427623	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236428612	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236428612	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9675	1716236428612	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236428637	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236429614	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236429614	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9675	1716236429614	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236429636	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236430616	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236430616	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9675	1716236430616	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236430638	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236431618	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236431618	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9693	1716236431618	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236432619	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236432619	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9693	1716236432619	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236433621	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236433621	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9693	1716236433621	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236434623	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236434623	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9704000000000002	1716236434623	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236435625	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236435625	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9704000000000002	1716236435625	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236436627	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236436627	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9704000000000002	1716236436627	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236437629	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236437629	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9710999999999999	1716236437629	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236438630	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236438630	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9710999999999999	1716236438630	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236439632	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236439632	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9710999999999999	1716236439632	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236440634	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236440634	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9699	1716236440634	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236441636	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236441636	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9699	1716236441636	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236442638	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236442638	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9699	1716236442638	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236443640	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236443640	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9667999999999999	1716236443640	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236444641	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236444641	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9667999999999999	1716236444641	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236445643	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236445643	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9667999999999999	1716236445643	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236446645	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236446645	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9693	1716236446645	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236447647	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236447647	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9693	1716236447647	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236448648	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236448648	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9693	1716236448648	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236449650	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236449650	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9694	1716236449650	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236450652	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236450652	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9694	1716236450652	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236451654	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236451654	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9694	1716236451654	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236452656	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236452656	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9702	1716236452656	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236431631	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236432634	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236433641	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236434645	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236435640	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236436649	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236437645	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236438651	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236439653	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236440649	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236441657	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236442654	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236443667	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236444668	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236445665	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236446666	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236447660	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236448670	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236449671	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236450667	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236451676	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236452669	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236453680	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236454682	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236455676	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236456677	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236457680	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236458689	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236459690	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236460685	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236461694	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236462688	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236463698	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236464701	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236465699	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236466705	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236467698	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236468707	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236469710	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236470713	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236471714	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236472710	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236473720	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236474723	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236475723	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236476727	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236477722	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236478728	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236479729	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236480726	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236481733	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236482728	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236483738	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236484740	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236485734	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236486737	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236487738	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236488748	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236489748	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236490751	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236491752	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236492746	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236493755	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236494761	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236495755	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236453659	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236453659	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9702	1716236453659	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236454660	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236454660	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9702	1716236454660	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236455662	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236455662	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9707000000000001	1716236455662	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236456664	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236456664	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9707000000000001	1716236456664	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236457666	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236457666	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9707000000000001	1716236457666	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236458668	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236458668	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9705	1716236458668	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236459669	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236459669	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9705	1716236459669	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236460671	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236460671	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9705	1716236460671	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236461673	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236461673	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.971	1716236461673	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236462675	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236462675	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.971	1716236462675	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236463677	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236463677	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.971	1716236463677	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236464679	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236464679	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9667000000000001	1716236464679	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236465682	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236465682	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9667000000000001	1716236465682	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236466683	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236466683	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9667000000000001	1716236466683	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236467685	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236467685	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9705	1716236467685	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236468687	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236468687	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9705	1716236468687	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236469689	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236469689	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9705	1716236469689	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236470690	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236470690	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9716	1716236470690	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236471692	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236471692	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9716	1716236471692	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236472696	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236472696	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9716	1716236472696	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236473698	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236473698	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9714	1716236473698	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236474700	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236474700	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9714	1716236474700	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236475702	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236475702	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9714	1716236475702	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236476704	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236476704	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9721	1716236476704	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236477705	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236477705	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9721	1716236477705	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	105	1716236478706	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236478706	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9721	1716236478706	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236479708	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236479708	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9732	1716236479708	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236480710	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236480710	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9732	1716236480710	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236481712	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236481712	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9732	1716236481712	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236482714	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236482714	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9714	1716236482714	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236483716	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236483716	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9714	1716236483716	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236484717	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236484717	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9714	1716236484717	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236485719	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236485719	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9701	1716236485719	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236486721	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236486721	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9701	1716236486721	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236487723	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236487723	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9701	1716236487723	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236488725	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236488725	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9713	1716236488725	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236489727	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236489727	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9713	1716236489727	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236490729	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236490729	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9713	1716236490729	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236491731	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236491731	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9714	1716236491731	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236492732	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236492732	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9714	1716236492732	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236493734	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236493734	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9714	1716236493734	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236494736	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236494736	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9721	1716236494736	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236495738	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236495738	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9721	1716236495738	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236496740	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236496740	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9721	1716236496740	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236497742	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236497742	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9727999999999999	1716236497742	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236498744	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236498744	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9727999999999999	1716236498744	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236499745	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236499745	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9727999999999999	1716236499745	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236500747	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236500747	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9735	1716236500747	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236501749	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236501749	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9735	1716236501749	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236502751	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236502751	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9735	1716236502751	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236503753	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236503753	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9716	1716236503753	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236504755	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236504755	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9716	1716236504755	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236505756	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236505756	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9716	1716236505756	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236506758	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236506758	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9723	1716236506758	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236507760	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236507760	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9723	1716236507760	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236508762	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236508762	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9723	1716236508762	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236509765	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236509765	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9722	1716236509765	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	105	1716236510766	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236510766	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9722	1716236510766	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236511768	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236511768	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9722	1716236511768	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236512770	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236512770	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.975	1716236512770	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236513772	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236513772	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.975	1716236513772	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236514773	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236514773	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.975	1716236514773	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236515775	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236515775	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9762	1716236515775	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236516776	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236516776	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9762	1716236516776	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236496761	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236497754	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236498766	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236499767	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236500761	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236501774	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236502765	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236503773	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236504779	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236505771	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236506780	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236507773	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236508783	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236509778	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236510782	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236511789	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236512785	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236513798	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236514795	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236515791	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236516799	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236517793	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236518803	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236519803	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236520804	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236521808	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236522803	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236523813	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236524816	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236525808	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236526818	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236527814	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236528815	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236529823	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236530820	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236531827	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236532820	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236533830	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236534836	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236535836	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236553867	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236554871	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236555866	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236556875	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9772	1716236557856	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236557878	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236558858	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236558858	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9772	1716236558858	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236558873	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236559859	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236559859	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9772	1716236559859	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236559880	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236560861	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236560861	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9775	1716236560861	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236560879	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236561863	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236561863	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9775	1716236561863	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236561885	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236562865	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236562865	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9775	1716236562865	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236517778	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236517778	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9762	1716236517778	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236518780	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236518780	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9762	1716236518780	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236519782	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236519782	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9762	1716236519782	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236520784	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236520784	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9762	1716236520784	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236521786	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236521786	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9766	1716236521786	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236522788	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7.8999999999999995	1716236522788	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9766	1716236522788	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236523791	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.1	1716236523791	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9766	1716236523791	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236524793	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236524793	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9757	1716236524793	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236525794	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236525794	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9757	1716236525794	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236526796	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236526796	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9757	1716236526796	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236527798	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236527798	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9763	1716236527798	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236528800	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236528800	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9763	1716236528800	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236529802	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236529802	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9763	1716236529802	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236530804	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236530804	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9734	1716236530804	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236531805	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236531805	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9734	1716236531805	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236532807	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236532807	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9734	1716236532807	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236533809	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236533809	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9732	1716236533809	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236534811	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236534811	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9732	1716236534811	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236535813	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236535813	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9732	1716236535813	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236555852	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9762	1716236555852	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236556854	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236556854	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9762	1716236556854	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236557856	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236557856	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236562883	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236563891	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236564892	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236565894	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236566898	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236567898	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236568893	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236569894	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236570895	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236571906	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236572907	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236573907	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236574910	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236575905	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236576915	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236577908	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236578917	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236579923	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236580921	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236581922	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236582925	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236583921	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236584921	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236585922	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236586931	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236587939	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236588927	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236589937	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236590932	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236591943	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236592936	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236593944	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236594946	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236595941	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236596950	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236597952	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236598953	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236599955	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236600951	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236601960	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236602962	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236603964	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236604969	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236605961	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236606967	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236607962	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236608972	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236609975	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236610975	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236611977	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236612980	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236613984	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236614985	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236615979	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236616989	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236617989	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236618992	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236619995	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236620989	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236621999	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236622994	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236624002	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236624995	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236626005	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236627002	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236563868	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236563868	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9779	1716236563868	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236564870	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236564870	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9779	1716236564870	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236565872	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236565872	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9779	1716236565872	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236566874	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236566874	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9789	1716236566874	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236567876	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236567876	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9789	1716236567876	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236568878	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236568878	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9789	1716236568878	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236569880	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236569880	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9772	1716236569880	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236570882	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236570882	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9772	1716236570882	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236571884	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236571884	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9772	1716236571884	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236572885	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236572885	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9788	1716236572885	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236573887	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236573887	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9788	1716236573887	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236574889	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236574889	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9788	1716236574889	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236575891	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236575891	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9784000000000002	1716236575891	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236576893	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236576893	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9784000000000002	1716236576893	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236577895	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236577895	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9784000000000002	1716236577895	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236578897	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236578897	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9747000000000001	1716236578897	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236579898	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236579898	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9747000000000001	1716236579898	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236580899	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236580899	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9747000000000001	1716236580899	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236581901	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236581901	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9784000000000002	1716236581901	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236582903	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236582903	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9784000000000002	1716236582903	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236583905	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236583905	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9784000000000002	1716236583905	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	105	1716236584906	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236584906	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9764000000000002	1716236584906	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236585908	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236585908	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9764000000000002	1716236585908	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236586910	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236586910	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9764000000000002	1716236586910	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236587912	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236587912	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9795999999999998	1716236587912	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236588914	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236588914	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9795999999999998	1716236588914	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236589916	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236589916	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9795999999999998	1716236589916	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236590918	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236590918	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9794	1716236590918	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236591919	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236591919	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9794	1716236591919	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236592921	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236592921	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9794	1716236592921	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236593923	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236593923	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9772	1716236593923	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236594925	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236594925	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9772	1716236594925	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236595927	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236595927	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9772	1716236595927	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236596929	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236596929	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9793	1716236596929	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236597930	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236597930	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9793	1716236597930	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236598932	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236598932	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9793	1716236598932	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236599934	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236599934	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9774	1716236599934	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236600936	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236600936	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9774	1716236600936	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236601938	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236601938	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9774	1716236601938	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236602940	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236602940	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9775	1716236602940	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236603942	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236603942	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9775	1716236603942	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236604943	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236604943	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9775	1716236604943	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236605945	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236605945	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9777	1716236605945	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	105	1716236606947	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716236606947	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9777	1716236606947	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236607949	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236607949	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9777	1716236607949	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236608951	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236608951	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9766	1716236608951	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236609952	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236609952	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9766	1716236609952	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236610954	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236610954	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9766	1716236610954	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236611956	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236611956	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9813	1716236611956	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236612959	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236612959	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9813	1716236612959	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236613961	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236613961	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9813	1716236613961	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236614963	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236614963	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9815999999999998	1716236614963	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236615964	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236615964	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9815999999999998	1716236615964	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236616966	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236616966	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9815999999999998	1716236616966	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236617968	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236617968	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9795999999999998	1716236617968	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236618970	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236618970	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9795999999999998	1716236618970	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236619972	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236619972	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9795999999999998	1716236619972	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236620974	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236620974	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9750999999999999	1716236620974	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236621977	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236621977	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9750999999999999	1716236621977	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236622979	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236622979	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9750999999999999	1716236622979	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236623981	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236623981	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9758	1716236623981	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236624982	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236624982	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9758	1716236624982	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236625984	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236625984	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9758	1716236625984	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236626986	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236626986	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9757	1716236626986	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236627988	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236627988	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9757	1716236627988	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236628990	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236628990	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9757	1716236628990	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236629991	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236629991	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9768	1716236629991	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236630993	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236630993	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9768	1716236630993	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236631995	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236631995	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9768	1716236631995	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236632996	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236632996	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9802	1716236632996	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236633998	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236633998	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9802	1716236633998	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236635000	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236635000	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9802	1716236635000	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236636002	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236636002	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9789	1716236636002	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236637004	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236637004	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9789	1716236637004	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236638006	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236638006	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9789	1716236638006	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236639008	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236639008	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9787000000000001	1716236639008	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236640010	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236640010	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9787000000000001	1716236640010	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236641011	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236641011	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9787000000000001	1716236641011	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236642015	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236642015	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9786	1716236642015	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236643016	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236643016	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9786	1716236643016	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236644018	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236644018	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9784000000000002	1716236644018	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236645020	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236645020	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9784000000000002	1716236645020	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236646022	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236646022	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9784000000000002	1716236646022	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236647024	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236647024	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.981	1716236647024	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236648026	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236648026	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.981	1716236648026	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236649028	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236628011	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236629012	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236630005	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236631014	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236632017	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236633017	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236634020	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236635023	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236636024	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236637026	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236638021	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236639029	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236640031	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236641032	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236642035	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236643039	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236644039	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236645042	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236646035	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236647047	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236648050	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236649049	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236650051	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236651048	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236652054	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236653048	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236654058	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236655054	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716237016724	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237016724	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0027	1716237016724	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237017726	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237017726	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0027	1716237017726	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237018728	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237018728	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0027	1716237018728	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237019730	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237019730	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.005	1716237019730	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237020732	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237020732	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.005	1716237020732	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237021733	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237021733	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.005	1716237021733	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237022735	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237022735	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0025999999999997	1716237022735	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716237023736	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237023736	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0025999999999997	1716237023736	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237024738	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237024738	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0025999999999997	1716237024738	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237025740	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237025740	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0057	1716237025740	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237026742	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237026742	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0057	1716237026742	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237027744	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237027744	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0057	1716237027744	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237028746	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236649028	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.981	1716236649028	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236650029	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236650029	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.981	1716236650029	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236651032	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236651032	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.981	1716236651032	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236652033	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236652033	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.981	1716236652033	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236653035	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236653035	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9825	1716236653035	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236654036	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236654036	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9825	1716236654036	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236655038	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236655038	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9825	1716236655038	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236656040	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236656040	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9822	1716236656040	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236656054	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236657042	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236657042	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9822	1716236657042	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236657057	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236658044	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236658044	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9822	1716236658044	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236658065	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236659046	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236659046	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9815	1716236659046	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236659068	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	105	1716236660047	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236660047	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9815	1716236660047	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236660061	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236661049	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236661049	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9815	1716236661049	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236661075	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236662051	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236662051	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9824000000000002	1716236662051	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236662072	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236663053	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236663053	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9824000000000002	1716236663053	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236663076	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236664056	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236664056	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9824000000000002	1716236664056	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236664080	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236665058	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236665058	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9804000000000002	1716236665058	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236665073	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236666060	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236666060	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9804000000000002	1716236666060	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236666082	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236667062	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236667062	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9804000000000002	1716236667062	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236668063	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236668063	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9819	1716236668063	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236669065	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236669065	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9819	1716236669065	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236670066	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236670066	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9819	1716236670066	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236671068	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236671068	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9814	1716236671068	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236672070	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236672070	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9814	1716236672070	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236673072	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236673072	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9814	1716236673072	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236674074	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236674074	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9807000000000001	1716236674074	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236675076	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236675076	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9807000000000001	1716236675076	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236676078	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236676078	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9807000000000001	1716236676078	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236677080	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236677080	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9808	1716236677080	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236678082	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236678082	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9808	1716236678082	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236679083	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236679083	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9808	1716236679083	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236680085	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236680085	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9810999999999999	1716236680085	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236681087	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236681087	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9810999999999999	1716236681087	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236682089	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.2	1716236682089	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9810999999999999	1716236682089	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236683090	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8	1716236683090	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9821	1716236683090	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236684092	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236684092	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9821	1716236684092	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236685094	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236685094	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9821	1716236685094	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236686096	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.700000000000001	1716236686096	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9793	1716236686096	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236687098	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236687098	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9793	1716236687098	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236688099	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236667081	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236668084	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236669087	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236670080	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236671089	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236672092	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236673096	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236674096	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236675098	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236676093	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236677104	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236678106	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236679106	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236680108	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236681101	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236682111	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236683114	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236684115	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236685107	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236686120	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236687111	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236688122	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236689124	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236690116	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236691120	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236692129	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236693130	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236694133	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236695131	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236696129	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236697141	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236698139	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236699142	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236700137	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236701148	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236702148	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236703151	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236704151	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236705148	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236706148	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236707149	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236708160	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236709162	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236710154	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236711165	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236712167	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236713169	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236714173	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236715165	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236716168	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236717176	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236718178	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236719182	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236720186	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236721185	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236722187	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236723189	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236724191	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236725192	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236726193	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236727198	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236728197	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236729198	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236730205	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236731203	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236688099	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9793	1716236688099	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236689102	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236689102	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9824000000000002	1716236689102	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236690104	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236690104	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9824000000000002	1716236690104	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236691106	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236691106	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9824000000000002	1716236691106	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236692107	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236692107	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9829	1716236692107	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236693109	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236693109	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9829	1716236693109	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236694111	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236694111	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9829	1716236694111	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236695113	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236695113	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9841	1716236695113	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236696115	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236696115	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9841	1716236696115	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236697117	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236697117	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9841	1716236697117	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236698119	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236698119	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9848	1716236698119	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236699121	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236699121	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9848	1716236699121	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236700122	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236700122	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9848	1716236700122	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236701124	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236701124	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9845	1716236701124	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236702126	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236702126	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9845	1716236702126	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236703128	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236703128	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9845	1716236703128	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236704130	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236704130	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9855999999999998	1716236704130	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236705132	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236705132	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9855999999999998	1716236705132	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236706134	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236706134	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9855999999999998	1716236706134	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236707136	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236707136	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9858	1716236707136	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236708138	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236708138	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9858	1716236708138	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236709139	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236709139	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9858	1716236709139	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236710141	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236710141	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9825	1716236710141	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236711143	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236711143	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9825	1716236711143	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236712145	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236712145	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9825	1716236712145	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236713147	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236713147	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9838	1716236713147	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236714149	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236714149	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9838	1716236714149	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236715151	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236715151	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9838	1716236715151	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236716153	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236716153	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9877	1716236716153	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236717155	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236717155	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9877	1716236717155	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236718157	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236718157	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9877	1716236718157	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236719159	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236719159	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9868	1716236719159	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236720161	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236720161	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9868	1716236720161	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236721163	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236721163	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9868	1716236721163	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236722165	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236722165	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9857	1716236722165	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236723167	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236723167	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9857	1716236723167	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236724168	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236724168	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9857	1716236724168	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236725170	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236725170	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9837	1716236725170	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236726172	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236726172	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9837	1716236726172	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236727174	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236727174	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9837	1716236727174	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236728176	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236728176	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9855999999999998	1716236728176	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236729178	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236729178	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9855999999999998	1716236729178	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236730180	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236730180	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9855999999999998	1716236730180	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236731182	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236731182	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9832	1716236731182	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236732183	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236732183	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9832	1716236732183	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236733185	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236733185	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9832	1716236733185	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236734187	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236734187	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9855999999999998	1716236734187	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236735189	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236735189	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9855999999999998	1716236735189	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236736191	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236736191	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9855999999999998	1716236736191	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236737192	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236737192	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9846	1716236737192	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236738194	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236738194	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9846	1716236738194	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	105	1716236739196	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236739196	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9846	1716236739196	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236740199	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236740199	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9863	1716236740199	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236741201	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236741201	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9863	1716236741201	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236742203	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236742203	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9863	1716236742203	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236743205	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236743205	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9864000000000002	1716236743205	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236744207	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236744207	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9864000000000002	1716236744207	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236745209	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236745209	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9864000000000002	1716236745209	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236746211	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236746211	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9870999999999999	1716236746211	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236747213	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236747213	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9870999999999999	1716236747213	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236748215	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236748215	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9870999999999999	1716236748215	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236749217	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236749217	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9861	1716236749217	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236750219	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236750219	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9861	1716236750219	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236751220	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236751220	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9861	1716236751220	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236752222	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236732206	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236733207	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236734212	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236735203	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236736214	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236737213	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236738216	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236739220	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236740219	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236741229	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236742225	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236743228	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236744231	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236745232	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236746233	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236747236	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236748237	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236749239	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236750241	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236751234	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236752244	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236753246	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236754248	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236755241	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236756245	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236757253	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236758256	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236759257	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236760257	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236761261	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236762262	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236763265	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236764265	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236765269	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236766261	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236767271	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236768272	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236769274	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236770269	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236771271	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236772282	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236773284	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236774284	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236775286	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237016745	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237017747	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237018749	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237019751	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237020745	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237021759	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237022757	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237023758	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237024759	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237025756	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237026765	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237027767	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237028766	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237029768	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237030763	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237031774	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237032775	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237033778	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237034782	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237035776	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237036786	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236752222	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9881	1716236752222	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236753224	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236753224	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9881	1716236753224	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236754226	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236754226	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9881	1716236754226	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236755228	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236755228	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9848	1716236755228	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236756230	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236756230	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9848	1716236756230	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236757232	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236757232	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9848	1716236757232	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236758234	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236758234	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9855999999999998	1716236758234	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236759235	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236759235	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9855999999999998	1716236759235	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236760236	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236760236	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9855999999999998	1716236760236	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236761238	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236761238	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9890999999999999	1716236761238	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236762240	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236762240	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9890999999999999	1716236762240	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236763242	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236763242	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9890999999999999	1716236763242	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236764244	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236764244	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9897	1716236764244	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236765246	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236765246	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9897	1716236765246	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236766248	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236766248	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9897	1716236766248	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236767249	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236767249	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.989	1716236767249	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236768251	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236768251	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.989	1716236768251	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236769253	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236769253	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.989	1716236769253	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236770255	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236770255	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9894	1716236770255	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236771257	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236771257	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9894	1716236771257	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236772259	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236772259	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9894	1716236772259	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236773261	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236773261	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9890999999999999	1716236773261	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236774263	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236774263	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9890999999999999	1716236774263	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236775265	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236775265	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9890999999999999	1716236775265	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236776266	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236776266	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9847000000000001	1716236776266	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236776288	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	99	1716236777268	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236777268	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9847000000000001	1716236777268	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236777289	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236778271	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236778271	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9847000000000001	1716236778271	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236778294	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236779273	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236779273	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9872999999999998	1716236779273	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236779294	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236780274	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236780274	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9872999999999998	1716236780274	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236780295	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236781277	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236781277	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9872999999999998	1716236781277	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236781294	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236782279	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236782279	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9897	1716236782279	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236782302	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236783281	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236783281	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9897	1716236783281	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236783302	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236784283	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236784283	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9897	1716236784283	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236784305	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236785285	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236785285	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9902	1716236785285	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236785298	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236786286	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.5	1716236786286	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9902	1716236786286	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236786301	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236787288	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236787288	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9902	1716236787288	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236787313	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236788290	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236788290	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9907000000000001	1716236788290	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236788311	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236789292	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236789292	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9907000000000001	1716236789292	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236789313	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236790294	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236790294	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9907000000000001	1716236790294	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236791296	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236791296	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9912999999999998	1716236791296	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236792298	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.1	1716236792298	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9912999999999998	1716236792298	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236793300	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236793300	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9912999999999998	1716236793300	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236794301	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236794301	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9887000000000001	1716236794301	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236795303	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236795303	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9887000000000001	1716236795303	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236796305	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236796305	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9887000000000001	1716236796305	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236797307	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236797307	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.99	1716236797307	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236798308	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236798308	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.99	1716236798308	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236799310	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236799310	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.99	1716236799310	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236800312	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236800312	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9867000000000001	1716236800312	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236801314	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236801314	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9867000000000001	1716236801314	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236802316	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.100000000000001	1716236802316	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9867000000000001	1716236802316	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236803318	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.300000000000001	1716236803318	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9885	1716236803318	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236804320	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236804320	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9885	1716236804320	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236805321	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236805321	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9885	1716236805321	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236806323	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236806323	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9881	1716236806323	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236807325	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236807325	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9881	1716236807325	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236808327	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236808327	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9881	1716236808327	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236809329	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236809329	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.988	1716236809329	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236810331	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236810331	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.988	1716236810331	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236811332	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236811332	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236790308	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236791317	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236792320	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236793321	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236794322	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236795317	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236796328	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236797327	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236798329	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236799331	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236800327	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236801328	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236802338	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236803338	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236804333	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236805343	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236806344	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236807348	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236808348	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236809351	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236810354	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236811347	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236812356	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236813357	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236814361	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236815362	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236816356	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236817366	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236818366	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236819370	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236820364	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236821374	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236822377	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236823377	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236824378	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236825375	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236826382	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236827387	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236828385	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236829386	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236830381	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236831390	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236832393	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236833394	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236834402	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236835399	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236836399	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236837401	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236838404	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236839407	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236840399	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236841410	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236842410	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236843413	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236844417	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236845409	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236846420	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236847420	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236848420	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236849423	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236850418	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236851426	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236852432	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236853424	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236854435	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.988	1716236811332	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236812334	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236812334	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9894	1716236812334	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236813336	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236813336	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9894	1716236813336	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236814338	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236814338	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9894	1716236814338	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236815340	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236815340	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9899	1716236815340	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236816342	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236816342	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9899	1716236816342	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236817344	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236817344	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9899	1716236817344	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236818345	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236818345	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9895	1716236818345	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236819347	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236819347	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9895	1716236819347	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236820349	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236820349	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9895	1716236820349	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236821351	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236821351	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9892999999999998	1716236821351	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236822353	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236822353	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9892999999999998	1716236822353	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236823355	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236823355	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9892999999999998	1716236823355	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236824356	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236824356	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9895999999999998	1716236824356	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236825358	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236825358	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9895999999999998	1716236825358	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236826360	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236826360	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9895999999999998	1716236826360	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236827362	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236827362	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9899	1716236827362	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236828364	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236828364	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9899	1716236828364	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236829366	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236829366	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9899	1716236829366	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236830367	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236830367	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9912	1716236830367	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236831369	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236831369	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9912	1716236831369	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236832371	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236832371	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9912	1716236832371	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236833373	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236833373	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9914	1716236833373	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236834375	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236834375	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9914	1716236834375	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236835376	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236835376	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9914	1716236835376	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236836378	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236836378	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.991	1716236836378	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236837380	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236837380	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.991	1716236837380	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236838382	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236838382	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.991	1716236838382	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236839384	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236839384	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9927000000000001	1716236839384	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236840386	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236840386	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9927000000000001	1716236840386	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236841388	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236841388	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9927000000000001	1716236841388	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236842390	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236842390	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.992	1716236842390	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236843391	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236843391	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.992	1716236843391	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236844393	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236844393	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.992	1716236844393	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236845395	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236845395	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9887000000000001	1716236845395	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236846396	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236846396	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9887000000000001	1716236846396	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236847398	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236847398	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9887000000000001	1716236847398	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236848400	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236848400	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9895999999999998	1716236848400	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236849402	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236849402	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9895999999999998	1716236849402	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236850404	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236850404	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9895999999999998	1716236850404	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236851406	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236851406	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9878	1716236851406	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236852409	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236852409	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9878	1716236852409	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236853411	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.6	1716236853411	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9878	1716236853411	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236854413	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236854413	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9901	1716236854413	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236855415	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236855415	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9901	1716236855415	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236856416	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236856416	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9901	1716236856416	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236857419	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236857419	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.992	1716236857419	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236858420	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236858420	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.992	1716236858420	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236859422	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236859422	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.992	1716236859422	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236860424	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236860424	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9925	1716236860424	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236861426	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236861426	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9925	1716236861426	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236862427	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236862427	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9925	1716236862427	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236863429	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236863429	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9912999999999998	1716236863429	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236864431	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236864431	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9912999999999998	1716236864431	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236865433	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236865433	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9912999999999998	1716236865433	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236866435	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236866435	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9901	1716236866435	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236867437	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236867437	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9901	1716236867437	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236868439	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236868439	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9901	1716236868439	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236869441	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236869441	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9903	1716236869441	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236870443	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236870443	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9903	1716236870443	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236871444	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236871444	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9903	1716236871444	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236872446	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236872446	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9924000000000002	1716236872446	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236873448	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236873448	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9924000000000002	1716236873448	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236874450	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236874450	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9924000000000002	1716236874450	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236875452	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236875452	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236855436	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236856435	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236857440	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236858442	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236859443	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236860445	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236861439	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236862448	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236863451	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236864452	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236865454	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236866456	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236867458	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236868459	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236869460	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236870464	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236871467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236872468	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236873471	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236874471	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236875467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236876467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236877479	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236878477	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236879480	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236880475	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236881484	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236882486	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236883490	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236884491	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236885483	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236886486	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236887493	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236888490	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236889492	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236890499	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236891506	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236892511	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236893500	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236894509	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236895505	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237028746	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0064	1716237028746	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237029748	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237029748	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0064	1716237029748	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237030749	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237030749	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0064	1716237030749	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237031751	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237031751	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0059	1716237031751	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237032753	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237032753	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0059	1716237032753	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237033755	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237033755	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0059	1716237033755	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237034758	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237034758	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0061	1716237034758	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716237035762	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237035762	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0061	1716237035762	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237036763	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9925	1716236875452	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236876454	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236876454	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9925	1716236876454	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236877456	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236877456	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9925	1716236877456	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236878457	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236878457	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.994	1716236878457	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236879459	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236879459	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.994	1716236879459	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236880461	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236880461	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.994	1716236880461	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236881463	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236881463	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9930999999999999	1716236881463	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236882465	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236882465	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9930999999999999	1716236882465	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236883467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236883467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9930999999999999	1716236883467	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236884469	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236884469	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9932999999999998	1716236884469	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236885471	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236885471	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9932999999999998	1716236885471	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236886472	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236886472	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9932999999999998	1716236886472	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236887474	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236887474	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9945	1716236887474	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236888476	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236888476	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9945	1716236888476	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236889477	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236889477	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9945	1716236889477	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236890480	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236890480	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9914	1716236890480	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236891482	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236891482	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9914	1716236891482	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236892484	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236892484	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9914	1716236892484	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236893486	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236893486	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9958	1716236893486	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236894488	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236894488	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9958	1716236894488	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236895490	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236895490	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9958	1716236895490	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236896492	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236896492	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9948	1716236896492	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236896516	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236897516	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236898521	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236899520	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236900516	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236901525	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236902518	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236903527	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236904531	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236905526	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236906525	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236907538	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236908537	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236909543	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236910534	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236911543	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236912549	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236913551	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236914550	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236915550	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236916547	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236917556	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236918560	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236919560	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236920563	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236921559	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236922557	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236923566	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236924569	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236925571	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236926572	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236927575	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236928570	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236929580	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236930580	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236931583	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236932584	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236933588	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236934588	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236935584	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236936595	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236937595	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236938597	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236939597	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236940603	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236941602	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236942604	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236943606	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236944608	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236945602	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236946611	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236947613	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236948615	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236949622	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236950611	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236951622	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236952622	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236953625	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236954628	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236955621	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236956631	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236957625	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236958635	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236959628	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236960638	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236897495	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236897495	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9948	1716236897495	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236898497	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236898497	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9948	1716236898497	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236899498	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236899498	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9941	1716236899498	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236900500	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236900500	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9941	1716236900500	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236901502	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236901502	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9941	1716236901502	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236902504	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236902504	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9938	1716236902504	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236903506	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236903506	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9938	1716236903506	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236904508	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236904508	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9938	1716236904508	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236905510	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236905510	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9935999999999998	1716236905510	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236906512	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236906512	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9935999999999998	1716236906512	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236907515	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236907515	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9935999999999998	1716236907515	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236908516	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236908516	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9930999999999999	1716236908516	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236909518	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236909518	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9930999999999999	1716236909518	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236910520	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236910520	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9930999999999999	1716236910520	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236911522	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236911522	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9939	1716236911522	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236912525	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236912525	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9939	1716236912525	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236913527	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236913527	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9939	1716236913527	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236914528	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236914528	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.996	1716236914528	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236915531	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236915531	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.996	1716236915531	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236916533	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236916533	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.996	1716236916533	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236917534	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236917534	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9958	1716236917534	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236918536	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236918536	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9958	1716236918536	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236919538	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236919538	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9958	1716236919538	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236920540	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236920540	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9974	1716236920540	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236921542	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236921542	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9974	1716236921542	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236922544	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236922544	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9974	1716236922544	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236923546	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236923546	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9969000000000001	1716236923546	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236924548	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236924548	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9969000000000001	1716236924548	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236925550	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236925550	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9969000000000001	1716236925550	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236926551	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236926551	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9970999999999999	1716236926551	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236927553	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236927553	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9970999999999999	1716236927553	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236928555	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236928555	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9970999999999999	1716236928555	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236929557	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236929557	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9975	1716236929557	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236930559	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236930559	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9975	1716236930559	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236931561	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236931561	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9975	1716236931561	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236932563	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236932563	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9970999999999999	1716236932563	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236933565	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236933565	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9970999999999999	1716236933565	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236934566	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236934566	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9970999999999999	1716236934566	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236935568	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236935568	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.994	1716236935568	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236936570	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236936570	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.994	1716236936570	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236937572	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236937572	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.994	1716236937572	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236938574	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236938574	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9981	1716236938574	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236939576	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236939576	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9981	1716236939576	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236940579	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236940579	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9981	1716236940579	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236941581	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236941581	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9983	1716236941581	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236942583	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236942583	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9983	1716236942583	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236943585	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236943585	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9983	1716236943585	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236944586	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236944586	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9975	1716236944586	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236945588	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236945588	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9975	1716236945588	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236946590	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236946590	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9975	1716236946590	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236947592	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236947592	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9955	1716236947592	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236948594	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236948594	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9955	1716236948594	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	105	1716236949596	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236949596	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9955	1716236949596	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236950598	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236950598	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9968	1716236950598	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236951600	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236951600	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9968	1716236951600	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236952602	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236952602	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9968	1716236952602	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236953604	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236953604	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9987000000000001	1716236953604	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236954605	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236954605	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9987000000000001	1716236954605	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236955607	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236955607	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9987000000000001	1716236955607	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236956609	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.800000000000001	1716236956609	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9928	1716236956609	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236957611	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236957611	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9928	1716236957611	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236958613	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236958613	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9928	1716236958613	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236959615	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.200000000000001	1716236959615	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9958	1716236959615	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236960616	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.4	1716236960616	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9958	1716236960616	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236961620	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236961620	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9958	1716236961620	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236962622	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236962622	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9975	1716236962622	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236963624	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236963624	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9975	1716236963624	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236964625	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236964625	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9975	1716236964625	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236965626	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236965626	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9963	1716236965626	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236966628	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236966628	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9963	1716236966628	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236967630	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236967630	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9963	1716236967630	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236968632	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236968632	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9978	1716236968632	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236969635	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236969635	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9978	1716236969635	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	105	1716236970637	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236970637	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9978	1716236970637	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236971639	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236971639	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9963	1716236971639	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236972641	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236972641	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9963	1716236972641	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236973644	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236973644	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9963	1716236973644	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236974646	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236974646	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9994	1716236974646	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236975648	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236975648	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9994	1716236975648	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236976650	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236976650	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9994	1716236976650	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236977651	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236977651	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9955	1716236977651	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236978653	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236978653	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9955	1716236978653	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236979655	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236979655	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9955	1716236979655	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236980656	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236980656	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9989000000000001	1716236980656	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236981658	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236981658	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9989000000000001	1716236981658	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236982660	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236961635	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236962643	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236963644	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236964646	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236965647	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236966642	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236967651	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236968653	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236969657	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236970658	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236971658	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236972663	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236973666	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236974667	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236975663	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236976671	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236977672	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236978669	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236979677	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236980670	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236981680	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236982684	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236983683	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236984685	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236985687	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236986688	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236987691	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236988692	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236989694	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236990690	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236991699	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236992701	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236993703	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236994705	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236995699	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236996708	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236997710	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236998712	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716236999714	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237000709	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237001717	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237002722	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237003717	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237004724	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237005726	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237006720	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237007728	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237008723	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237009733	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237010738	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237011729	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237012729	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237013740	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237014741	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237015736	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237036763	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0061	1716237036763	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237037765	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237037765	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0053	1716237037765	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716237038766	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237038766	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0053	1716237038766	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716237039768	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237039768	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236982660	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9989000000000001	1716236982660	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236983662	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236983662	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9995999999999998	1716236983662	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236984664	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236984664	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9995999999999998	1716236984664	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236985666	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236985666	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9995999999999998	1716236985666	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236986668	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236986668	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0002999999999997	1716236986668	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236987669	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236987669	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0002999999999997	1716236987669	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236988671	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236988671	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0002999999999997	1716236988671	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236989673	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236989673	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0005	1716236989673	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236990675	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236990675	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0005	1716236990675	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236991677	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236991677	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0005	1716236991677	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236992679	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236992679	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9995999999999998	1716236992679	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236993681	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236993681	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9995999999999998	1716236993681	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716236994684	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236994684	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9995999999999998	1716236994684	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236995686	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236995686	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2	1716236995686	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716236996687	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236996687	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2	1716236996687	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716236997689	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236997689	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2	1716236997689	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716236998691	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716236998691	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0012	1716236998691	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716236999693	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716236999693	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0012	1716236999693	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237000695	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237000695	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0012	1716237000695	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237001697	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237001697	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9985	1716237001697	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237002699	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237002699	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9985	1716237002699	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237003701	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237003701	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.9985	1716237003701	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237004703	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237004703	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.999	1716237004703	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237005704	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237005704	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.999	1716237005704	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237006706	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237006706	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	1.999	1716237006706	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237007708	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237007708	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0025	1716237007708	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237008710	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237008710	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0025	1716237008710	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237009712	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237009712	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0025	1716237009712	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237010714	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237010714	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0044	1716237010714	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237011715	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237011715	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0044	1716237011715	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716237012717	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237012717	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0044	1716237012717	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716237013718	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237013718	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0032	1716237013718	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237014720	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237014720	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0032	1716237014720	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237015722	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237015722	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0032	1716237015722	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237037786	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237038784	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0053	1716237039768	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237039789	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237040770	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237040770	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0063	1716237040770	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237040784	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237041772	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237041772	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0063	1716237041772	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237041793	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237042774	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237042774	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0063	1716237042774	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237042791	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237043776	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237043776	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0023	1716237043776	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237043798	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716237044778	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237044778	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0023	1716237044778	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237044799	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237045780	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237045780	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0023	1716237045780	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237045802	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237046801	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237047807	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237048811	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237049811	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237050806	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237051818	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237052816	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237053817	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237054819	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237055816	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237056825	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237057825	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237058827	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237059829	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237060835	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237061835	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237062834	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237063837	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237064837	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237065834	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237066843	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237067846	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237068847	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237069848	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237070841	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237071850	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237072845	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237073855	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237074855	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237075850	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237046783	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237046783	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0057	1716237046783	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237047785	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237047785	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0057	1716237047785	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237048787	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237048787	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0057	1716237048787	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237049789	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237049789	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0052	1716237049789	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237050790	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237050790	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0052	1716237050790	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237051792	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237051792	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0052	1716237051792	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237052794	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237052794	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0078	1716237052794	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716237053796	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237053796	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0078	1716237053796	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237054798	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237054798	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0078	1716237054798	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716237055800	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237055800	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0082	1716237055800	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237056802	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237056802	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0082	1716237056802	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237057804	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237057804	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0082	1716237057804	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237058805	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237058805	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0063	1716237058805	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237059807	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237059807	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0063	1716237059807	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237060809	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237060809	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0063	1716237060809	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237061811	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237061811	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0058	1716237061811	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237062813	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237062813	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0058	1716237062813	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237063815	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237063815	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0058	1716237063815	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237064816	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237064816	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0052	1716237064816	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237065818	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237065818	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0052	1716237065818	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237066820	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237066820	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0052	1716237066820	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237067822	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237067822	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0042	1716237067822	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237068824	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237068824	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0042	1716237068824	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716237069826	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237069826	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0042	1716237069826	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237070827	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237070827	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0074	1716237070827	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716237071829	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237071829	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0074	1716237071829	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237072831	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237072831	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0074	1716237072831	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237073833	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237073833	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0077000000000003	1716237073833	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237074834	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237074834	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0077000000000003	1716237074834	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237075836	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237075836	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0077000000000003	1716237075836	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237076838	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237076838	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0075	1716237076838	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237076854	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237077840	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237077840	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0075	1716237077840	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237077861	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237078842	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.3	1716237078842	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0075	1716237078842	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237078855	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237079844	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.5	1716237079844	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0067	1716237079844	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237079865	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716237080846	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237080846	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0067	1716237080846	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237080859	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237081848	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237081848	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0067	1716237081848	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237081871	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237082850	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237082850	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0079000000000002	1716237082850	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237082872	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237083851	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237083851	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0079000000000002	1716237083851	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237083874	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237084853	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237084853	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0079000000000002	1716237084853	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237084875	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237085855	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237085855	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0077000000000003	1716237085855	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716237086857	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237086857	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0077000000000003	1716237086857	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237087859	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237087859	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0077000000000003	1716237087859	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237088861	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237088861	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0033	1716237088861	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237089863	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237089863	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0033	1716237089863	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237090865	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237090865	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0033	1716237090865	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237091866	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237091866	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0073	1716237091866	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716237092868	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237092868	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0073	1716237092868	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237093871	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237093871	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0073	1716237093871	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237094872	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237094872	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0084	1716237094872	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237095874	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237095874	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0084	1716237095874	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237096876	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237096876	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0084	1716237096876	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237097878	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237097878	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0084	1716237097878	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237098880	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237098880	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0084	1716237098880	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237099882	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237099882	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0084	1716237099882	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237100884	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237100884	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0067	1716237100884	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237101885	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237101885	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0067	1716237101885	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716237102886	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237102886	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0067	1716237102886	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237103888	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237103888	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0077000000000003	1716237103888	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237104890	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237104890	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0077000000000003	1716237104890	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237105892	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237105892	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0077000000000003	1716237105892	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237106894	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237106894	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.008	1716237106894	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237085872	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237086879	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237087881	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237088883	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237089884	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237090877	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237091879	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237092891	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237093892	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237094893	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237095890	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237096898	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237097901	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237098903	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237099903	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237100901	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237101908	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237102900	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237103910	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237104911	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237105915	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237106910	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237107918	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237108920	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237109922	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237110917	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237111928	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237112929	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237113930	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237114932	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237115927	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237116936	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237117939	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237118939	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237119941	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237120944	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237121945	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237122947	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237123947	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237124951	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237125948	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237126956	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237127958	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237128962	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237129955	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237130955	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237131966	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237132969	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237133974	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237134963	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237135966	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237136966	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237137971	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237138981	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237139975	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237140977	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237141987	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237142988	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237143991	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237144985	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237145985	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237146997	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237147997	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237149002	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237149994	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237107897	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237107897	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.008	1716237107897	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237108899	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237108899	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.008	1716237108899	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237109901	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237109901	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0088	1716237109901	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237110904	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237110904	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0088	1716237110904	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237111906	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237111906	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0088	1716237111906	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237112907	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237112907	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0068	1716237112907	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716237113909	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237113909	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0068	1716237113909	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237114911	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237114911	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0068	1716237114911	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237115913	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237115913	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0068	1716237115913	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237116915	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237116915	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0068	1716237116915	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237117917	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237117917	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0068	1716237117917	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237118919	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237118919	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.008	1716237118919	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237119920	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	7	1716237119920	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.008	1716237119920	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237120922	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237120922	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.008	1716237120922	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237121924	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237121924	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0069	1716237121924	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237122926	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237122926	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0069	1716237122926	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237123928	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237123928	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0069	1716237123928	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237124930	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237124930	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0073	1716237124930	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237125933	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237125933	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0073	1716237125933	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237126935	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237126935	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0073	1716237126935	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	104	1716237127937	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237127937	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.007	1716237127937	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	100	1716237128938	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237128938	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.007	1716237128938	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237129940	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237129940	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.007	1716237129940	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237130942	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237130942	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0119000000000002	1716237130942	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237131944	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237131944	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0119000000000002	1716237131944	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237132946	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237132946	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0119000000000002	1716237132946	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237133948	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237133948	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0077000000000003	1716237133948	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237134950	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237134950	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0077000000000003	1716237134950	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237135952	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237135952	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0077000000000003	1716237135952	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237136954	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237136954	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0112	1716237136954	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237137957	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237137957	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0112	1716237137957	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237138959	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237138959	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0112	1716237138959	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237139961	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237139961	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0107	1716237139961	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237140963	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237140963	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0107	1716237140963	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237141965	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237141965	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0107	1716237141965	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237142967	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237142967	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0119000000000002	1716237142967	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237143969	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237143969	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0119000000000002	1716237143969	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237144970	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237144970	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0119000000000002	1716237144970	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237145972	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237145972	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0114	1716237145972	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237146974	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237146974	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0114	1716237146974	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237147976	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237147976	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0114	1716237147976	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237148978	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237148978	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0097	1716237148978	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237149980	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237149980	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0097	1716237149980	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237150982	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237150982	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.0097	1716237150982	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	101	1716237151984	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237151984	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.013	1716237151984	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	103	1716237152986	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	8.4	1716237152986	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.013	1716237152986	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - CPU Utilization	102	1716237153988	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Utilization	6.6	1716237153988	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Memory Usage GB	2.013	1716237153988	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237150995	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237152005	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237153008	12f7bcc1326849ebb1b120cd129bcc57	0	f
TOP - Swap Memory GB	0.0005	1716237154013	12f7bcc1326849ebb1b120cd129bcc57	0	f
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
letter	0	47d23ffe097b431e8b4d90f4a444eab6
workload	0	47d23ffe097b431e8b4d90f4a444eab6
listeners	smi+top+dcgmi	47d23ffe097b431e8b4d90f4a444eab6
params	'"-"'	47d23ffe097b431e8b4d90f4a444eab6
file	cifar10.py	47d23ffe097b431e8b4d90f4a444eab6
workload_listener	''	47d23ffe097b431e8b4d90f4a444eab6
letter	0	12f7bcc1326849ebb1b120cd129bcc57
workload	0	12f7bcc1326849ebb1b120cd129bcc57
listeners	smi+top+dcgmi	12f7bcc1326849ebb1b120cd129bcc57
params	'"-"'	12f7bcc1326849ebb1b120cd129bcc57
file	cifar10.py	12f7bcc1326849ebb1b120cd129bcc57
workload_listener	''	12f7bcc1326849ebb1b120cd129bcc57
model	cifar10.py	12f7bcc1326849ebb1b120cd129bcc57
manual	False	12f7bcc1326849ebb1b120cd129bcc57
max_epoch	5	12f7bcc1326849ebb1b120cd129bcc57
max_time	172800	12f7bcc1326849ebb1b120cd129bcc57
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
47d23ffe097b431e8b4d90f4a444eab6	delicate-lamb-831	UNKNOWN			daga	FAILED	1716235587216	1716235720553		active	s3://mlflow-storage/0/47d23ffe097b431e8b4d90f4a444eab6/artifacts	0	\N
12f7bcc1326849ebb1b120cd129bcc57	(0 0) crawling-gnat-748	UNKNOWN			daga	FINISHED	1716235786273	1716237155321		active	s3://mlflow-storage/0/12f7bcc1326849ebb1b120cd129bcc57/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	47d23ffe097b431e8b4d90f4a444eab6
mlflow.source.name	file:///home/daga/radt#examples/pytorch	47d23ffe097b431e8b4d90f4a444eab6
mlflow.source.type	PROJECT	47d23ffe097b431e8b4d90f4a444eab6
mlflow.project.entryPoint	main	47d23ffe097b431e8b4d90f4a444eab6
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	47d23ffe097b431e8b4d90f4a444eab6
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	47d23ffe097b431e8b4d90f4a444eab6
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	47d23ffe097b431e8b4d90f4a444eab6
mlflow.runName	delicate-lamb-831	47d23ffe097b431e8b4d90f4a444eab6
mlflow.project.env	conda	47d23ffe097b431e8b4d90f4a444eab6
mlflow.project.backend	local	47d23ffe097b431e8b4d90f4a444eab6
mlflow.user	daga	12f7bcc1326849ebb1b120cd129bcc57
mlflow.source.name	file:///home/daga/radt#examples/pytorch	12f7bcc1326849ebb1b120cd129bcc57
mlflow.source.type	PROJECT	12f7bcc1326849ebb1b120cd129bcc57
mlflow.project.entryPoint	main	12f7bcc1326849ebb1b120cd129bcc57
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	12f7bcc1326849ebb1b120cd129bcc57
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	12f7bcc1326849ebb1b120cd129bcc57
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	12f7bcc1326849ebb1b120cd129bcc57
mlflow.project.env	conda	12f7bcc1326849ebb1b120cd129bcc57
mlflow.project.backend	local	12f7bcc1326849ebb1b120cd129bcc57
mlflow.runName	(0 0) crawling-gnat-748	12f7bcc1326849ebb1b120cd129bcc57
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

