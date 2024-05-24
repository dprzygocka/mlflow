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
0	Default	s3://mlflow-storage/0	active	1716308328880	1716308328880
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
SMI - Power Draw	15.29	1716309529968	0	f	28b34e9cf1724de78c0db1a4e90a4bef
SMI - Timestamp	1716309529.954	1716309529968	0	f	28b34e9cf1724de78c0db1a4e90a4bef
SMI - GPU Util	0	1716309529968	0	f	28b34e9cf1724de78c0db1a4e90a4bef
SMI - Mem Util	0	1716309529968	0	f	28b34e9cf1724de78c0db1a4e90a4bef
SMI - Mem Used	0	1716309529968	0	f	28b34e9cf1724de78c0db1a4e90a4bef
SMI - Performance State	0	1716309529968	0	f	28b34e9cf1724de78c0db1a4e90a4bef
TOP - CPU Utilization	103	1716310031019	0	f	28b34e9cf1724de78c0db1a4e90a4bef
TOP - Memory Usage GB	1.9937	1716310031019	0	f	28b34e9cf1724de78c0db1a4e90a4bef
TOP - Memory Utilization	7.999999999999999	1716310031019	0	f	28b34e9cf1724de78c0db1a4e90a4bef
TOP - Swap Memory GB	0.0171	1716310031041	0	f	28b34e9cf1724de78c0db1a4e90a4bef
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	15.29	1716309529968	28b34e9cf1724de78c0db1a4e90a4bef	0	f
SMI - Timestamp	1716309529.954	1716309529968	28b34e9cf1724de78c0db1a4e90a4bef	0	f
SMI - GPU Util	0	1716309529968	28b34e9cf1724de78c0db1a4e90a4bef	0	f
SMI - Mem Util	0	1716309529968	28b34e9cf1724de78c0db1a4e90a4bef	0	f
SMI - Mem Used	0	1716309529968	28b34e9cf1724de78c0db1a4e90a4bef	0	f
SMI - Performance State	0	1716309529968	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	0	1716309530027	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	0	1716309530027	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.2721	1716309530027	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309530041	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	137.5	1716309531029	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	9.2	1716309531029	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.2721	1716309531029	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309531046	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309532031	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309532031	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.2721	1716309532031	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309532044	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309533032	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309533032	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.5065	1716309533032	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309533045	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309534034	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309534034	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.5065	1716309534034	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309534049	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309535036	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309535036	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.5065	1716309535036	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309535050	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309536038	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309536038	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.5075	1716309536038	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309536052	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	107	1716309537040	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309537040	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.5075	1716309537040	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309537056	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	106	1716309538042	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309538042	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.5075	1716309538042	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309538056	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	106	1716309539044	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309539044	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.5079	1716309539044	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309539060	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	108	1716309540046	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309540046	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.5079	1716309540046	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309540060	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309541048	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309541048	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.5079	1716309541048	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309541061	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	106	1716309542050	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309542050	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.5049000000000001	1716309542050	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309542065	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	107	1716309543052	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309543052	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.5049000000000001	1716309543052	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309543067	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309544054	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309544054	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.5049000000000001	1716309544054	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0091	1716309544067	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0111	1716309545068	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0111	1716309546070	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0111	1716309547076	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309548079	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309549079	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309550090	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309551086	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309552094	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309553095	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309554098	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309555089	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309556092	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309557102	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309558107	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309559101	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309560111	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309561104	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309562111	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309563115	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309564116	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309565114	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309566113	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309567125	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309568127	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309569130	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309570124	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309571125	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309572131	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309573134	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309574131	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309575136	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309576134	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309577144	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309578147	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309579144	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309580151	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309880722	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309880722	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9639000000000002	1716309880722	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309881724	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309881724	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9649	1716309881724	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309882727	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309882727	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9649	1716309882727	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309883728	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309883728	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9649	1716309883728	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309884730	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309884730	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9626	1716309884730	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309885732	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309885732	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9626	1716309885732	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309886734	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309886734	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9626	1716309886734	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309887736	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309887736	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9623	1716309887736	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309888738	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309888738	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9623	1716309888738	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309889740	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309545055	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309545055	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.8037999999999998	1716309545055	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309546057	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309546057	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.8037999999999998	1716309546057	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309547061	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309547061	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.8037999999999998	1716309547061	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309548063	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309548063	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.0125	1716309548063	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309549064	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309549064	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.0125	1716309549064	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	105	1716309550066	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309550066	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.0125	1716309550066	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309551069	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309551069	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.016	1716309551069	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309552070	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309552070	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.016	1716309552070	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309553072	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309553072	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.016	1716309553072	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309554074	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309554074	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.017	1716309554074	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309555076	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309555076	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.017	1716309555076	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309556078	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309556078	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.017	1716309556078	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309557081	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309557081	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.019	1716309557081	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309558083	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309558083	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.019	1716309558083	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309559086	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309559086	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.019	1716309559086	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309560088	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309560088	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.0172	1716309560088	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309561090	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309561090	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.0172	1716309561090	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309562092	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309562092	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.0172	1716309562092	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309563094	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309563094	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.0184	1716309563094	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309564096	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309564096	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.0184	1716309564096	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309565098	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309565098	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.0184	1716309565098	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309566100	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309566100	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.0187	1716309566100	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309567102	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309567102	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.0187	1716309567102	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309568104	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309568104	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	2.0187	1716309568104	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309569106	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309569106	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9417	1716309569106	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309570108	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309570108	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9417	1716309570108	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309571110	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309571110	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9417	1716309571110	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309572112	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309572112	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9441	1716309572112	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309573114	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309573114	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9441	1716309573114	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309574116	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309574116	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9441	1716309574116	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309575119	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309575119	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9447	1716309575119	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309576121	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309576121	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9447	1716309576121	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309577122	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309577122	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9447	1716309577122	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309578124	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309578124	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9470999999999998	1716309578124	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309579126	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309579126	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9470999999999998	1716309579126	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309580129	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309580129	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9470999999999998	1716309580129	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309581131	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309581131	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9470999999999998	1716309581131	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309581149	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309582133	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309582133	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9470999999999998	1716309582133	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309582146	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309583134	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309583134	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9470999999999998	1716309583134	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309583151	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309584138	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309584138	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9475	1716309584138	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309584153	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309585140	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309585140	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9475	1716309585140	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309585155	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309586141	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309586141	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9475	1716309586141	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309587143	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309587143	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9473	1716309587143	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309588145	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309588145	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9473	1716309588145	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309589147	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309589147	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9473	1716309589147	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309590149	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309590149	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9465	1716309590149	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309591151	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309591151	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9465	1716309591151	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309592153	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309592153	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9465	1716309592153	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309593155	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309593155	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9467	1716309593155	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309594157	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309594157	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9467	1716309594157	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309595158	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309595158	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9467	1716309595158	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309596160	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309596160	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9433	1716309596160	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309597162	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309597162	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9433	1716309597162	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309598165	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.300000000000001	1716309598165	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9433	1716309598165	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309599167	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309599167	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9438	1716309599167	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309600169	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309600169	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9438	1716309600169	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309601172	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309601172	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9438	1716309601172	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309602175	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309602175	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9473	1716309602175	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	105	1716309603177	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309603177	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9473	1716309603177	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309604180	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309604180	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9473	1716309604180	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309605182	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309605182	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9465999999999999	1716309605182	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309606184	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309606184	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9465999999999999	1716309606184	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309607186	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309586159	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309587158	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309588161	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309589161	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309590163	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309591165	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309592168	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309593168	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309594173	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309595179	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309596178	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309597179	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309598179	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309599187	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309600184	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309601188	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309602191	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309603193	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309604194	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309605198	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309606198	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309607202	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309608201	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309609204	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309610207	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309611208	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309612211	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309613212	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309614214	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309615216	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309616219	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309617229	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309618228	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309619223	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309620228	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309621228	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309622231	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309623232	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309624244	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309625238	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309626238	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309627238	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309628247	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309629254	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309630245	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309631249	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309632255	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309633259	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309634255	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309635258	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309636256	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309637259	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309638262	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309639270	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309640270	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309880738	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309881739	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309882743	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309883744	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309884747	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309885748	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309886750	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309887751	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309888755	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309889755	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309607186	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9465999999999999	1716309607186	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309608188	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309608188	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9487999999999999	1716309608188	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309609190	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309609190	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9487999999999999	1716309609190	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309610192	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309610192	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9487999999999999	1716309610192	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309611194	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309611194	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9482000000000002	1716309611194	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309612196	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309612196	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9482000000000002	1716309612196	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309613197	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309613197	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9482000000000002	1716309613197	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309614200	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309614200	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9496	1716309614200	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309615201	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309615201	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9496	1716309615201	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309616203	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309616203	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9496	1716309616203	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309617205	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309617205	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9484000000000001	1716309617205	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309618207	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309618207	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9484000000000001	1716309618207	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309619209	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309619209	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9484000000000001	1716309619209	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309620211	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309620211	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9456	1716309620211	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309621213	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309621213	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9456	1716309621213	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309622215	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309622215	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9456	1716309622215	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309623217	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309623217	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9474	1716309623217	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309624219	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309624219	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9474	1716309624219	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309625221	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309625221	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9474	1716309625221	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309626223	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309626223	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.949	1716309626223	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309627225	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309627225	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.949	1716309627225	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309628227	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309628227	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.949	1716309628227	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309629229	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309629229	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9487	1716309629229	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309630231	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309630231	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9487	1716309630231	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309631232	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309631232	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9487	1716309631232	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309632234	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309632234	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9490999999999998	1716309632234	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309633236	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309633236	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9490999999999998	1716309633236	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309634239	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309634239	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9490999999999998	1716309634239	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309635240	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309635240	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9474	1716309635240	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309636242	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309636242	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9474	1716309636242	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309637244	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309637244	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9474	1716309637244	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309638246	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309638246	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9469	1716309638246	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309639248	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309639248	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9469	1716309639248	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309640251	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309640251	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9469	1716309640251	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309641255	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309641255	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9473	1716309641255	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309641270	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309642257	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309642257	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9473	1716309642257	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309642276	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309643259	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309643259	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9473	1716309643259	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309643282	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309644261	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309644261	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9483	1716309644261	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309644283	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309645263	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309645263	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9483	1716309645263	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309645277	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309646265	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309646265	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9483	1716309646265	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309646279	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309647267	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309647267	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9482000000000002	1716309647267	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309647282	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309648286	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309649293	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309650347	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309651289	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309652300	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309653295	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309654304	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309655305	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309656300	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309657303	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309658304	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309659308	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309660307	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309661309	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309662312	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309663315	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309664314	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309665318	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309666317	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309667320	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309668324	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309669332	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309670333	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309671330	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309672329	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309673339	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309674341	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309675345	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309676339	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309677341	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309678343	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309679353	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309680352	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309681348	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309682349	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309683362	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309684363	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309685363	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309686358	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309687360	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309688366	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309689365	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309690366	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309691366	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309692381	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309693378	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309694385	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309695375	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309696375	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309697385	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309698386	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309699390	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309700382	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309889740	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9623	1716309889740	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309890742	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309890742	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.962	1716309890742	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309891744	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309891744	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.962	1716309891744	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309892746	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309892746	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.962	1716309892746	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309648269	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309648269	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9482000000000002	1716309648269	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309649271	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309649271	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9482000000000002	1716309649271	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309650273	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309650273	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9474	1716309650273	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309651275	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309651275	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9474	1716309651275	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	110	1716309652277	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309652277	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9474	1716309652277	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309653279	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309653279	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9485	1716309653279	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309654281	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309654281	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9485	1716309654281	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309655283	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309655283	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9485	1716309655283	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309656285	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309656285	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9498	1716309656285	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309657287	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309657287	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9498	1716309657287	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309658289	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309658289	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9498	1716309658289	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309659291	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309659291	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9512	1716309659291	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309660292	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309660292	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9512	1716309660292	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309661294	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309661294	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9512	1716309661294	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309662296	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309662296	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.952	1716309662296	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309663298	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309663298	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.952	1716309663298	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309664300	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309664300	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.952	1716309664300	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309665302	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309665302	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.951	1716309665302	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309666304	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309666304	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.951	1716309666304	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309667306	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309667306	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.951	1716309667306	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309668308	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309668308	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9472	1716309668308	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	99	1716309669310	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309669310	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9472	1716309669310	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309670312	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309670312	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9472	1716309670312	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309671314	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309671314	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9509	1716309671314	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309672316	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.6000000000000005	1716309672316	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9509	1716309672316	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309673318	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	5.9	1716309673318	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9509	1716309673318	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309674320	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.7	1716309674320	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9499000000000002	1716309674320	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309675323	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309675323	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9499000000000002	1716309675323	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309676324	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.7	1716309676324	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9499000000000002	1716309676324	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309677326	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	2.7	1716309677326	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9493	1716309677326	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309678328	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.7	1716309678328	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9493	1716309678328	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309679330	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309679330	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9493	1716309679330	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309680332	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.7	1716309680332	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9517	1716309680332	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309681334	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.7	1716309681334	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9517	1716309681334	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	108	1716309682336	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309682336	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9517	1716309682336	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309683338	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309683338	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9518	1716309683338	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309684339	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309684339	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9518	1716309684339	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309685341	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309685341	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9518	1716309685341	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309686343	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309686343	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9527999999999999	1716309686343	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309687345	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309687345	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9527999999999999	1716309687345	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309688347	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309688347	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9527999999999999	1716309688347	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309689349	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309689349	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9536	1716309689349	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309690351	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309690351	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9536	1716309690351	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309691353	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309691353	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9536	1716309691353	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309692355	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309692355	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9541	1716309692355	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309693357	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309693357	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9541	1716309693357	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309694358	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309694358	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9541	1716309694358	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309695360	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309695360	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9485	1716309695360	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309696362	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309696362	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9485	1716309696362	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309697364	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309697364	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9485	1716309697364	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309698365	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.4	1716309698365	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9498	1716309698365	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309699366	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309699366	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9498	1716309699366	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309700368	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309700368	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9498	1716309700368	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309701370	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309701370	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9523	1716309701370	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309701384	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309702372	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309702372	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9523	1716309702372	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309702386	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309703374	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309703374	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9523	1716309703374	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309703400	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309704376	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309704376	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9506	1716309704376	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309704404	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309705378	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309705378	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9506	1716309705378	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309705395	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309706380	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309706380	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9506	1716309706380	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309706392	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309707382	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309707382	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9525	1716309707382	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309707398	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309708383	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309708383	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9525	1716309708383	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309708401	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309709385	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309709385	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9525	1716309709385	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309710387	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309710387	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9537	1716309710387	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309711389	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309711389	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9537	1716309711389	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309712390	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309712390	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9537	1716309712390	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309713393	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309713393	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9537	1716309713393	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309714395	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309714395	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9537	1716309714395	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309715397	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309715397	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9537	1716309715397	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309716399	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309716399	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9394	1716309716399	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309717401	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309717401	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9394	1716309717401	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309718403	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309718403	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9394	1716309718403	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309719404	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309719404	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9507	1716309719404	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309720406	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309720406	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9507	1716309720406	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309721408	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309721408	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9507	1716309721408	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309722410	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309722410	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9537	1716309722410	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309723412	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309723412	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9537	1716309723412	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309724414	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309724414	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9537	1716309724414	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309725416	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309725416	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9547	1716309725416	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309726418	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309726418	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9547	1716309726418	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309727420	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309727420	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9547	1716309727420	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309728422	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309728422	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9525	1716309728422	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309729423	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309729423	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9525	1716309729423	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309730424	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309730424	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309709401	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309710404	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309711403	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309712404	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309713407	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309714410	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309715410	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309716414	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309717426	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309718427	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309719424	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309720422	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309721423	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309722425	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309723427	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309724432	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309725429	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309726432	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309727437	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309728438	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309729439	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309730442	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309731441	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309732442	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309733448	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309734446	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309735451	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309736452	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309737456	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309738462	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309739463	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309740463	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309741468	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309742474	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309743481	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309744473	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309745482	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309746478	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309747482	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309748491	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309749495	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309750485	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309751485	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309752491	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309753494	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309754496	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309755506	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309756505	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309757506	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309758508	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309759508	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309760515	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309890755	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309891758	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309892760	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309893765	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309894765	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309895767	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309896776	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309897775	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309898774	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309899777	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309900775	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309901784	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309902782	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9525	1716309730424	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309731427	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309731427	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9534	1716309731427	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309732429	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309732429	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9534	1716309732429	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309733430	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309733430	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9534	1716309733430	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309734432	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309734432	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9550999999999998	1716309734432	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309735434	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309735434	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9550999999999998	1716309735434	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309736436	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309736436	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9550999999999998	1716309736436	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309737439	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309737439	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9542	1716309737439	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309738440	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309738440	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9542	1716309738440	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309739442	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309739442	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9542	1716309739442	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309740446	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309740446	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9492	1716309740446	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309741448	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309741448	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9492	1716309741448	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309742454	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309742454	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9492	1716309742454	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309743456	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309743456	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9505	1716309743456	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309744458	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309744458	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9505	1716309744458	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309745460	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309745460	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9505	1716309745460	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309746462	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309746462	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9533	1716309746462	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309747464	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309747464	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9533	1716309747464	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309748466	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309748466	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9533	1716309748466	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309749468	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309749468	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.956	1716309749468	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309750470	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309750470	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.956	1716309750470	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309751472	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309751472	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.956	1716309751472	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309752474	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309752474	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9557	1716309752474	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309753475	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309753475	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9557	1716309753475	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309754477	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309754477	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9557	1716309754477	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309755480	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309755480	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9557	1716309755480	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309756483	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309756483	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9557	1716309756483	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309757485	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309757485	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9557	1716309757485	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309758488	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309758488	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9567	1716309758488	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309759489	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309759489	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9567	1716309759489	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309760493	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309760493	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9567	1716309760493	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309761495	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309761495	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9576	1716309761495	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309761522	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309762497	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309762497	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9576	1716309762497	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309762515	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309763499	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309763499	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9576	1716309763499	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309763513	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309764501	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309764501	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9578	1716309764501	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309764519	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309765502	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309765502	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9578	1716309765502	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309765516	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309766504	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309766504	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9578	1716309766504	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309766519	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309767507	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309767507	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.957	1716309767507	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309767530	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309768510	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309768510	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.957	1716309768510	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309768531	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309769512	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309769512	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.957	1716309769512	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309769532	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309770514	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309770514	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.954	1716309770514	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309771516	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309771516	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.954	1716309771516	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309772518	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309772518	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.954	1716309772518	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309773520	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309773520	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9547999999999999	1716309773520	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309774522	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309774522	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9547999999999999	1716309774522	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309775524	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309775524	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9547999999999999	1716309775524	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309776526	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309776526	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.954	1716309776526	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309777528	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309777528	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.954	1716309777528	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309778529	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309778529	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.954	1716309778529	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309779531	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309779531	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.954	1716309779531	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309780533	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309780533	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.954	1716309780533	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309781535	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309781535	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.954	1716309781535	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309782537	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309782537	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9561	1716309782537	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309783539	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309783539	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9561	1716309783539	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309784541	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309784541	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9561	1716309784541	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309785543	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309785543	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9541	1716309785543	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309786545	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309786545	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9541	1716309786545	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309787547	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309787547	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9541	1716309787547	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309788548	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309788548	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9553	1716309788548	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309789550	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309789550	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9553	1716309789550	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309790552	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309790552	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9553	1716309790552	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309791554	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309791554	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309770531	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309771530	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309772532	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309773535	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309774535	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309775542	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309776540	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309777542	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309778546	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309779547	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309780547	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309781548	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309782559	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309783560	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309784564	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309785556	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309786562	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309787563	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309788563	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309789567	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309790574	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309791584	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309792572	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309793574	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309794576	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309795578	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309796582	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309797583	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309798584	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309799585	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309800588	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309801595	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309802591	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309803593	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309804596	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309805595	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309806605	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309807600	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309808601	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309809604	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309810606	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309811608	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309812609	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309813619	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309814625	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309815620	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309816630	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309817619	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309818629	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309819623	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309893748	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309893748	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9652	1716309893748	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309894750	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309894750	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9652	1716309894750	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309895752	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309895752	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9652	1716309895752	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309896754	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309896754	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9647999999999999	1716309896754	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309897756	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309897756	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9647999999999999	1716309897756	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9554	1716309791554	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309792556	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309792556	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9554	1716309792556	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	99	1716309793558	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309793558	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9554	1716309793558	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309794560	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309794560	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9547999999999999	1716309794560	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309795562	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309795562	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9547999999999999	1716309795562	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309796564	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309796564	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9547999999999999	1716309796564	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309797566	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309797566	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9553	1716309797566	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309798568	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309798568	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9553	1716309798568	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309799569	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309799569	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9553	1716309799569	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309800572	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309800572	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9566	1716309800572	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309801573	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309801573	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9566	1716309801573	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309802575	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309802575	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9566	1716309802575	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309803577	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309803577	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9573	1716309803577	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309804579	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309804579	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9573	1716309804579	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309805581	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309805581	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9573	1716309805581	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309806583	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309806583	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9587999999999999	1716309806583	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309807585	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309807585	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9587999999999999	1716309807585	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309808587	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309808587	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9587999999999999	1716309808587	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309809589	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309809589	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9630999999999998	1716309809589	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309810591	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309810591	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9630999999999998	1716309810591	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309811593	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309811593	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9630999999999998	1716309811593	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309812594	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309812594	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9607999999999999	1716309812594	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309813596	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8	1716309813596	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9607999999999999	1716309813596	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309814598	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6	1716309814598	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9607999999999999	1716309814598	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309815600	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	8.200000000000001	1716309815600	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9462000000000002	1716309815600	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309816602	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309816602	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9462000000000002	1716309816602	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309817604	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309817604	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9462000000000002	1716309817604	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309818606	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309818606	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9577	1716309818606	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309819608	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309819608	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9577	1716309819608	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309820610	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309820610	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9577	1716309820610	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309820625	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309821612	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309821612	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9586	1716309821612	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309821635	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309822614	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309822614	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9586	1716309822614	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309822638	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309823616	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309823616	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9586	1716309823616	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309823633	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309824617	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309824617	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.959	1716309824617	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309824632	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309825618	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309825618	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.959	1716309825618	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309825631	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309826620	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309826620	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.959	1716309826620	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309826640	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309827622	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309827622	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9612	1716309827622	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309827636	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309828624	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309828624	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9612	1716309828624	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309828641	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309829626	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309829626	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9612	1716309829626	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309829647	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309830628	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309830628	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9616	1716309830628	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309830643	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309831651	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309832647	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309833649	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309834661	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309835660	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309836653	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309837654	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309838657	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309839667	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309840662	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309841671	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309842669	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309843667	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309844670	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309845670	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309846674	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309847674	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309848685	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309849685	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309850688	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309851689	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309852696	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309853686	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309854698	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309855690	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309856705	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309857692	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309858705	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309859704	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309860698	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309861707	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309862705	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309863704	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309864714	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309865708	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309866709	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309867711	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309868713	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309869722	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309870718	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309871728	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309872721	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309873725	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309874726	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309875727	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309876730	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309877731	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309878732	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309879735	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309898757	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309898757	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9647999999999999	1716309898757	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309899760	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309899760	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.964	1716309899760	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309900761	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309900761	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.964	1716309900761	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309901764	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309901764	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.964	1716309901764	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309902766	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309902766	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.967	1716309902766	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309831630	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309831630	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9616	1716309831630	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309832632	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309832632	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9616	1716309832632	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309833634	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309833634	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9629	1716309833634	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309834636	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309834636	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9629	1716309834636	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309835638	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309835638	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9629	1716309835638	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309836640	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309836640	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9645	1716309836640	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309837642	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309837642	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9645	1716309837642	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309838644	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309838644	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9645	1716309838644	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309839646	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309839646	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9595	1716309839646	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309840648	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309840648	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9595	1716309840648	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309841650	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309841650	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9595	1716309841650	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309842652	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309842652	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.963	1716309842652	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309843654	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309843654	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.963	1716309843654	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309844656	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309844656	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.963	1716309844656	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309845657	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309845657	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.962	1716309845657	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309846659	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309846659	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.962	1716309846659	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309847660	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309847660	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.962	1716309847660	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309848662	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309848662	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9622	1716309848662	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309849664	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309849664	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9622	1716309849664	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309850666	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309850666	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9622	1716309850666	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309851668	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309851668	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9616	1716309851668	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309852670	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309852670	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9616	1716309852670	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309853672	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309853672	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9616	1716309853672	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309854674	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309854674	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9627999999999999	1716309854674	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309855675	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309855675	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9627999999999999	1716309855675	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309856677	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309856677	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9627999999999999	1716309856677	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309857679	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309857679	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9647999999999999	1716309857679	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309858680	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309858680	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9647999999999999	1716309858680	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309859682	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309859682	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9647999999999999	1716309859682	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309860684	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309860684	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9663	1716309860684	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309861686	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309861686	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9663	1716309861686	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309862688	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309862688	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9663	1716309862688	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309863690	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309863690	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.962	1716309863690	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309864692	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309864692	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.962	1716309864692	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309865693	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309865693	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.962	1716309865693	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309866695	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309866695	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9632	1716309866695	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309867697	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309867697	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9632	1716309867697	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309868699	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309868699	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9632	1716309868699	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309869701	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309869701	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9627999999999999	1716309869701	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309870703	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309870703	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9627999999999999	1716309870703	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309871705	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309871705	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9627999999999999	1716309871705	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309872708	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309872708	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9635	1716309872708	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309873710	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309873710	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9635	1716309873710	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309874712	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309874712	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9635	1716309874712	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309875713	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309875713	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9644000000000001	1716309875713	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309876715	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309876715	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9644000000000001	1716309876715	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309877717	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309877717	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9644000000000001	1716309877717	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309878718	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309878718	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9639000000000002	1716309878718	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309879720	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309879720	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9639000000000002	1716309879720	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309903769	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309903769	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.967	1716309903769	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309903800	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309904771	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309904771	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.967	1716309904771	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309904793	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309905773	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309905773	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9670999999999998	1716309905773	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309905786	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309906774	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309906774	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9670999999999998	1716309906774	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309906790	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309907776	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309907776	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9670999999999998	1716309907776	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309907792	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309908779	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309908779	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9645	1716309908779	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309908808	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309909781	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309909781	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9645	1716309909781	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309909798	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309910783	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309910783	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9645	1716309910783	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309910798	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309911785	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309911785	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9649	1716309911785	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309911808	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309912786	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309912786	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9649	1716309912786	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309912808	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309913788	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309913788	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9649	1716309913788	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309913811	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309914790	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309914790	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9663	1716309914790	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309915792	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309915792	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9663	1716309915792	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309916794	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309916794	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9663	1716309916794	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309917796	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309917796	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.966	1716309917796	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309918798	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309918798	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.966	1716309918798	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309919800	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309919800	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.966	1716309919800	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309920802	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309920802	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9655	1716309920802	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309921804	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309921804	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9655	1716309921804	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309922807	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309922807	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9655	1716309922807	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309923809	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309923809	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9656	1716309923809	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309924810	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309924810	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9656	1716309924810	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309925812	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309925812	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9656	1716309925812	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309926814	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309926814	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9658	1716309926814	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309927816	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.5	1716309927816	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9658	1716309927816	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309928818	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309928818	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9658	1716309928818	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309929820	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309929820	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9687000000000001	1716309929820	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309930822	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309930822	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9687000000000001	1716309930822	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309931824	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309931824	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9687000000000001	1716309931824	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309932826	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309932826	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9638	1716309932826	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309933828	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309933828	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9638	1716309933828	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309934830	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309934830	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9638	1716309934830	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309935832	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309935832	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309914812	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309915807	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309916817	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309917810	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309918818	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309919821	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309920818	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309921821	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309922828	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309923830	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309924833	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309925827	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309926836	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309927831	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309928839	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309929835	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309930840	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309931847	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309932850	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309933848	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309934852	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309935847	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309936847	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309937849	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309938854	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309939854	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9670999999999998	1716309935832	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309936834	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309936834	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9670999999999998	1716309936834	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309937836	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309937836	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9670999999999998	1716309937836	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309938838	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309938838	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9655	1716309938838	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309939840	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309939840	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9655	1716309939840	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309940841	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309940841	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9655	1716309940841	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309940855	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309941843	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309941843	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9683	1716309941843	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309941857	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309942844	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309942844	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9683	1716309942844	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309942870	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309943846	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309943846	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9683	1716309943846	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309943871	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309944848	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309944848	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9696	1716309944848	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309944861	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309945850	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309945850	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9696	1716309945850	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309945864	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309946852	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309946852	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9696	1716309946852	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309946873	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309947854	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309947854	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9713	1716309947854	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309947868	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309948856	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309948856	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9713	1716309948856	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309948871	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309949857	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309949857	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9713	1716309949857	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309949885	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309950859	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309950859	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9721	1716309950859	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309950873	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309951861	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309951861	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9721	1716309951861	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309951882	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309952863	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309952863	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9721	1716309952863	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309952884	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309953886	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309954893	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309955882	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309956892	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309957886	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309958898	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309959891	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309960895	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309961904	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309962897	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309963899	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309964901	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309965904	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309966911	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309967906	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309968915	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309969912	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309970912	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309971914	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309972923	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309973930	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309974925	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309975931	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309976924	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309977938	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309978927	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309979937	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309980943	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309981947	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309982946	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309983949	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309984951	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309985952	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309986953	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309987954	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309988950	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309989954	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309990957	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309991964	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309992967	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309993959	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309994978	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309995970	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309996975	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309997974	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309998973	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716309999983	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309953865	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309953865	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9729	1716309953865	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309954867	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309954867	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9729	1716309954867	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309955869	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309955869	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9729	1716309955869	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309956871	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309956871	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9721	1716309956871	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309957873	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309957873	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9721	1716309957873	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309958875	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309958875	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9721	1716309958875	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309959877	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309959877	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9761	1716309959877	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309960879	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309960879	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9761	1716309960879	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309961881	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309961881	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9761	1716309961881	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309962882	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309962882	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9745	1716309962882	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309963884	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309963884	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9745	1716309963884	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309964886	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309964886	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9745	1716309964886	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309965888	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309965888	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9741	1716309965888	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309966890	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309966890	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9741	1716309966890	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309967892	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309967892	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9741	1716309967892	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309968894	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309968894	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9804000000000002	1716309968894	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309969896	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309969896	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9804000000000002	1716309969896	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309970898	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309970898	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9804000000000002	1716309970898	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309971900	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309971900	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9830999999999999	1716309971900	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309972902	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309972902	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9830999999999999	1716309972902	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309973905	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309973905	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9830999999999999	1716309973905	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309974907	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309974907	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9814	1716309974907	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309975909	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309975909	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9814	1716309975909	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309976911	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309976911	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9814	1716309976911	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309977913	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309977913	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9810999999999999	1716309977913	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309978914	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.1	1716309978914	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9810999999999999	1716309978914	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309979916	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.8999999999999995	1716309979916	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9810999999999999	1716309979916	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309980919	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716309980919	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9782	1716309980919	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309981922	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716309981922	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9782	1716309981922	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309982924	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716309982924	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9782	1716309982924	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309983925	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716309983925	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9813	1716309983925	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309984927	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716309984927	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9813	1716309984927	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309985929	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716309985929	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9813	1716309985929	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309986931	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716309986931	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9827000000000001	1716309986931	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309987933	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716309987933	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9827000000000001	1716309987933	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309988935	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716309988935	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9827000000000001	1716309988935	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309989937	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716309989937	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.986	1716309989937	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716309990940	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716309990940	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.986	1716309990940	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309991942	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716309991942	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.986	1716309991942	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309992944	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716309992944	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9872999999999998	1716309992944	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716309993946	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716309993946	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9872999999999998	1716309993946	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309994948	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716309994948	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9872999999999998	1716309994948	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309995950	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716309995950	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9877	1716309995950	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309996952	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716309996952	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9877	1716309996952	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716309997954	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716309997954	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9877	1716309997954	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716309998957	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716309998957	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.987	1716309998957	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716309999958	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716309999958	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.987	1716309999958	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716310000961	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310000961	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.987	1716310000961	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310000983	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716310001963	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310001963	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9868	1716310001963	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310001978	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716310002965	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310002965	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9868	1716310002965	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310002986	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716310003967	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310003967	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9868	1716310003967	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310003985	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716310004970	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310004970	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9883	1716310004970	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310004988	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716310005971	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310005971	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9883	1716310005971	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310005988	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716310006973	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310006973	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9883	1716310006973	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310006995	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716310007975	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310007975	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9883	1716310007975	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310007997	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716310008977	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310008977	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9883	1716310008977	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310008991	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716310009980	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310009980	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9883	1716310009980	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310010012	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716310010982	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310010982	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9855	1716310010982	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310010996	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716310011984	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310011984	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9855	1716310011984	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310012006	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716310012986	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310012986	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9855	1716310012986	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310013002	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310014005	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310015011	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310016013	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310017017	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310018017	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310019020	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310020013	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310021014	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310022017	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310023028	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310024021	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310025033	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310026024	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310027034	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310028027	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310029042	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310030035	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Swap Memory GB	0.0171	1716310031041	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	100	1716310013988	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310013988	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9875	1716310013988	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	104	1716310014990	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310014990	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9875	1716310014990	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716310015991	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310015991	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9875	1716310015991	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716310016993	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310016993	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9879	1716310016993	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716310017994	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310017994	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9879	1716310017994	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716310018996	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310018996	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9879	1716310018996	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716310019998	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310019998	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.991	1716310019998	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716310021000	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310021000	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.991	1716310021000	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716310022002	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310022002	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.991	1716310022002	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716310023004	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310023004	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9918	1716310023004	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716310024006	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310024006	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9918	1716310024006	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716310025008	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310025008	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9918	1716310025008	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	101	1716310026009	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310026009	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9915	1716310026009	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716310027011	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310027011	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9915	1716310027011	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716310028013	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310028013	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9915	1716310028013	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716310029015	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310029015	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9937	1716310029015	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	102	1716310030017	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	6.199999999999999	1716310030017	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9937	1716310030017	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - CPU Utilization	103	1716310031019	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Utilization	7.999999999999999	1716310031019	28b34e9cf1724de78c0db1a4e90a4bef	0	f
TOP - Memory Usage GB	1.9937	1716310031019	28b34e9cf1724de78c0db1a4e90a4bef	0	f
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
letter	0	e4002f4233e04b009587cc7de9320256
workload	0	e4002f4233e04b009587cc7de9320256
listeners	smi+top+dcgmi	e4002f4233e04b009587cc7de9320256
params	'"-"'	e4002f4233e04b009587cc7de9320256
file	cifar10.py	e4002f4233e04b009587cc7de9320256
workload_listener	''	e4002f4233e04b009587cc7de9320256
letter	0	28b34e9cf1724de78c0db1a4e90a4bef
workload	0	28b34e9cf1724de78c0db1a4e90a4bef
listeners	smi+top+dcgmi	28b34e9cf1724de78c0db1a4e90a4bef
params	'"-"'	28b34e9cf1724de78c0db1a4e90a4bef
file	cifar10.py	28b34e9cf1724de78c0db1a4e90a4bef
workload_listener	''	28b34e9cf1724de78c0db1a4e90a4bef
model	cifar10.py	28b34e9cf1724de78c0db1a4e90a4bef
manual	False	28b34e9cf1724de78c0db1a4e90a4bef
max_epoch	5	28b34e9cf1724de78c0db1a4e90a4bef
max_time	172800	28b34e9cf1724de78c0db1a4e90a4bef
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
e4002f4233e04b009587cc7de9320256	crawling-robin-374	UNKNOWN			daga	FAILED	1716309210764	1716309314654		active	s3://mlflow-storage/0/e4002f4233e04b009587cc7de9320256/artifacts	0	\N
28b34e9cf1724de78c0db1a4e90a4bef	(0 0) marvelous-wasp-4	UNKNOWN			daga	FINISHED	1716309523541	1716310032328		active	s3://mlflow-storage/0/28b34e9cf1724de78c0db1a4e90a4bef/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	e4002f4233e04b009587cc7de9320256
mlflow.source.name	file:///home/daga/radt#examples/pytorch	e4002f4233e04b009587cc7de9320256
mlflow.source.type	PROJECT	e4002f4233e04b009587cc7de9320256
mlflow.project.entryPoint	main	e4002f4233e04b009587cc7de9320256
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	e4002f4233e04b009587cc7de9320256
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	e4002f4233e04b009587cc7de9320256
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	e4002f4233e04b009587cc7de9320256
mlflow.runName	crawling-robin-374	e4002f4233e04b009587cc7de9320256
mlflow.project.env	conda	e4002f4233e04b009587cc7de9320256
mlflow.project.backend	local	e4002f4233e04b009587cc7de9320256
mlflow.user	daga	28b34e9cf1724de78c0db1a4e90a4bef
mlflow.source.name	file:///home/daga/radt#examples/pytorch	28b34e9cf1724de78c0db1a4e90a4bef
mlflow.source.type	PROJECT	28b34e9cf1724de78c0db1a4e90a4bef
mlflow.project.entryPoint	main	28b34e9cf1724de78c0db1a4e90a4bef
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	28b34e9cf1724de78c0db1a4e90a4bef
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	28b34e9cf1724de78c0db1a4e90a4bef
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	28b34e9cf1724de78c0db1a4e90a4bef
mlflow.project.env	conda	28b34e9cf1724de78c0db1a4e90a4bef
mlflow.project.backend	local	28b34e9cf1724de78c0db1a4e90a4bef
mlflow.runName	(0 0) marvelous-wasp-4	28b34e9cf1724de78c0db1a4e90a4bef
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

