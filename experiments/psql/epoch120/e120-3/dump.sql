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
-- Name: experiment_id; Type: SEQUENCE; Schema: public; Owner: mlflow_user
--

CREATE SEQUENCE public.experiment_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.experiment_id OWNER TO mlflow_user;

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
    experiment_id integer DEFAULT nextval('public.experiment_id'::regclass) NOT NULL,
    name character varying(256) NOT NULL,
    artifact_location character varying(256),
    lifecycle_stage character varying(32),
    creation_time bigint,
    last_update_time bigint,
    CONSTRAINT experiments_lifecycle_stage CHECK (((lifecycle_stage)::text = ANY ((ARRAY['active'::character varying, 'deleted'::character varying])::text[])))
);


ALTER TABLE public.experiments OWNER TO mlflow_user;

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
0	Default	s3://mlflow-storage/0	active	1715672641742	1715672641742
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
SMI - Power Draw	16.46	1715672776735	0	f	816c658dd62e4ea7ae7fd4332bb6cfe8
SMI - Timestamp	1715672776.72	1715672776735	0	f	816c658dd62e4ea7ae7fd4332bb6cfe8
SMI - GPU Util	0	1715672776735	0	f	816c658dd62e4ea7ae7fd4332bb6cfe8
SMI - Mem Util	0	1715672776735	0	f	816c658dd62e4ea7ae7fd4332bb6cfe8
SMI - Mem Used	0	1715672776735	0	f	816c658dd62e4ea7ae7fd4332bb6cfe8
SMI - Performance State	0	1715672776735	0	f	816c658dd62e4ea7ae7fd4332bb6cfe8
TOP - CPU Utilization	102	1715675814372	0	f	816c658dd62e4ea7ae7fd4332bb6cfe8
TOP - Memory Usage GB	2.5370999999999997	1715675814372	0	f	816c658dd62e4ea7ae7fd4332bb6cfe8
TOP - Memory Utilization	8.9	1715675814372	0	f	816c658dd62e4ea7ae7fd4332bb6cfe8
TOP - Swap Memory GB	0.0329	1715675814387	0	f	816c658dd62e4ea7ae7fd4332bb6cfe8
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	16.46	1715672776735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
SMI - Timestamp	1715672776.72	1715672776735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
SMI - GPU Util	0	1715672776735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
SMI - Mem Util	0	1715672776735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
SMI - Mem Used	0	1715672776735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
SMI - Performance State	0	1715672776735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	0	1715672776790	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	0	1715672776790	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.6690999999999998	1715672776790	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0254	1715672777239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	193.3	1715672777792	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715672777792	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.6690999999999998	1715672777792	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0254	1715672777809	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	143	1715672778794	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715672778794	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.6690999999999998	1715672778794	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0254	1715672778807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672779797	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672779797	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9055	1715672779797	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672779813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672780799	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.399999999999999	1715672780799	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9055	1715672780799	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672780819	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672781801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715672781801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9055	1715672781801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672781818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	106	1715672782803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672782803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9067	1715672782803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672783301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672783805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715672783805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9067	1715672783805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672783819	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	150.5	1715672784807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.799999999999999	1715672784807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9067	1715672784807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672784822	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672785810	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672785810	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9347999999999999	1715672785810	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672785825	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715672786812	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672786812	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9347999999999999	1715672786812	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672786826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715672787814	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672787814	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9347999999999999	1715672787814	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672787829	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672788816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672788816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9349	1715672788816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672788832	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672789819	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672789819	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9349	1715672789819	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672789835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672790821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715672790821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9349	1715672790821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672790841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672795833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715672795833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9350999999999998	1715672795833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672797855	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672798854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672799858	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672800860	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672825901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715672825901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4595	1715672825901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672830927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672833933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672836941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672839946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673081453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673081453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4021	1715673081453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673084460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715673084460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3949000000000003	1715673084460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673095497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673096503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673102498	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715673102498	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3994	1715673102498	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673103500	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673103500	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3994	1715673103500	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673105504	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715673105504	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.399	1715673105504	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673107509	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715673107509	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3929	1715673107509	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673109513	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715673109513	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3929	1715673109513	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673113521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673113521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3992	1715673113521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673114524	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673114524	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3992	1715673114524	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673116543	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673122541	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715673122541	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4002	1715673122541	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673127552	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673127552	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4009	1715673127552	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673128554	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673128554	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3999	1715673128554	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673130559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673130559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3999	1715673130559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673132563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673132563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4011	1715673132563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673134567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673134567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3993	1715673134567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673135569	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672791823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672791823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9356	1715672791823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672807861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672807861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4533	1715672807861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672808887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672811884	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672814894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672815896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672817900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672829929	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672831932	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672836925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715672836925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3752	1715672836925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673081469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673084477	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673096485	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673096485	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3984	1715673096485	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673100494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673100494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4001	1715673100494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673102515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673103517	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673105520	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673107523	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673109531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673113539	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673116528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715673116528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4011	1715673116528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673120551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673122559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673127568	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673128573	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673130577	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673132577	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673134581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673137573	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715673137573	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3981999999999997	1715673137573	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673138575	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673138575	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3981999999999997	1715673138575	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673264861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673270859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.8	1715673270859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4071	1715673270859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673275869	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.8	1715673275869	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4046999999999996	1715673275869	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673277873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673277873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4046999999999996	1715673277873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673280880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715673280880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4069000000000003	1715673280880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673283886	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673283886	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4101	1715673283886	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673285907	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673293922	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673307937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672791840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672808863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715672808863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4533	1715672808863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672811870	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672811870	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4520999999999997	1715672811870	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715672814877	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672814877	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.455	1715672814877	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672815879	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672815879	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631	1715672815879	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672817884	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715672817884	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631	1715672817884	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672823913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672831914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715672831914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3722	1715672831914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672834938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672840950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673082456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715673082456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4021	1715673082456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673083474	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673086479	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673090472	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673090472	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3956999999999997	1715673090472	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673094481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673094481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3956999999999997	1715673094481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673097487	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	4.6	1715673097487	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3984	1715673097487	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673098489	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715673098489	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4001	1715673098489	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673099492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673099492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4001	1715673099492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673100509	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673106506	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673106506	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.399	1715673106506	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673108527	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673110532	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673111533	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673124546	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715673124546	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4002	1715673124546	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673126550	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673126550	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4009	1715673126550	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673129556	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715673129556	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3999	1715673129556	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673131561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673131561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4011	1715673131561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673136571	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673136571	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3993	1715673136571	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672792826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.1	1715672792826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9356	1715672792826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672793843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	106	1715672796835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672796835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9350999999999998	1715672796835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672804854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715672804854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.24	1715672804854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715672805857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.800000000000001	1715672805857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.24	1715672805857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672806859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672806859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4533	1715672806859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672809881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672812890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672813892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672816897	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672824899	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672824899	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4595	1715672824899	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672826903	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672826903	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4595	1715672826903	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715672830912	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672830912	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3722	1715672830912	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672835938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672837942	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672838944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673082471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673089485	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673092491	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673093493	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673112520	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673112520	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3964000000000003	1715673112520	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673115526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715673115526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3992	1715673115526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673118533	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715673118533	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4011	1715673118533	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673119535	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673119535	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4002	1715673119535	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673121539	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673121539	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4002	1715673121539	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673139577	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715673139577	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3981999999999997	1715673139577	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673140580	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715673140580	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3991	1715673140580	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673268869	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673273865	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673273865	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4048000000000003	1715673273865	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673276890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673284888	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673284888	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672792841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672795849	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672796850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672804869	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672805871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672809866	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.899999999999999	1715672809866	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4520999999999997	1715672809866	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672812873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672812873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.455	1715672812873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672813875	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672813875	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.455	1715672813875	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672816882	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672816882	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631	1715672816882	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672821892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672821892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4566999999999997	1715672821892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672824915	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672826917	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672835923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672835923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3741	1715672835923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672837927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672837927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3752	1715672837927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672838929	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.899999999999999	1715672838929	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3752	1715672838929	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673083458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715673083458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3949000000000003	1715673083458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673086463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715673086463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3961	1715673086463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673087481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673090488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673094495	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673097503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673098507	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673099506	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673101496	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673101496	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3994	1715673101496	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673108511	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673108511	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3929	1715673108511	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673110515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673110515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3964000000000003	1715673110515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673111518	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715673111518	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3964000000000003	1715673111518	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673120537	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673120537	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4002	1715673120537	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673124562	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673126567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673129572	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673131578	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673136586	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673271875	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672793828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715672793828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9356	1715672793828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672797837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715672797837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9347999999999999	1715672797837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	106	1715672798840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672798840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9347999999999999	1715672798840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672799842	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715672799842	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9347999999999999	1715672799842	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672800844	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	4.3	1715672800844	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9352	1715672800844	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672823897	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672823897	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4566999999999997	1715672823897	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672829910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672829910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715672829910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672833918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672833918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3741	1715672833918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672834921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672834921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3741	1715672834921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672839931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672839931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3781999999999996	1715672839931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672840933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672840933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3781999999999996	1715672840933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673085461	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673085461	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3949000000000003	1715673085461	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673087465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673087465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3961	1715673087465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673088483	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673091488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673104502	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715673104502	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.399	1715673104502	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673106520	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673117530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673117530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4011	1715673117530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673123543	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673123543	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4002	1715673123543	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673125548	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673125548	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4009	1715673125548	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673133565	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673133565	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4011	1715673133565	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673135585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673273880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673278890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673284901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673287908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673288913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673289914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	106	1715672794830	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672794830	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9350999999999998	1715672794830	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	106	1715672801846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715672801846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9352	1715672801846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672802850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715672802850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	1.9352	1715672802850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672803852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672803852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.24	1715672803852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672806877	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672810868	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.1	1715672810868	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4520999999999997	1715672810868	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672818886	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672818886	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4528000000000003	1715672818886	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672819888	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672819888	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4528000000000003	1715672819888	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672820891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715672820891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4528000000000003	1715672820891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672821906	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672822914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672827905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715672827905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715672827905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672828908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715672828908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715672828908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672832916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715672832916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3722	1715672832916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673085476	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673088467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673088467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3961	1715673088467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673091474	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673091474	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3956999999999997	1715673091474	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673095483	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673095483	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3984	1715673095483	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673104518	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673114537	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673117545	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673123558	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673125563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673133580	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4079	1715673284888	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673287894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.9	1715673287894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4086999999999996	1715673287894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673288896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715673288896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4086999999999996	1715673288896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673289898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673289898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4086999999999996	1715673289898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673291902	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673291902	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672794848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672801861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672802867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672803867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672807878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672810884	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672818901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672819903	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672820906	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672822896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672822896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4566999999999997	1715672822896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672825917	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672827920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672828923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672832932	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672841935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672841935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3781999999999996	1715672841935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672841949	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672842938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.899999999999999	1715672842938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3805	1715672842938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672842952	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672843940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672843940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3805	1715672843940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672843954	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672844941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672844941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3805	1715672844941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672844956	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672845944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.3	1715672845944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3799	1715672845944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672845958	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672846946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672846946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3799	1715672846946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672846959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715672847948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672847948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3799	1715672847948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672847963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672848950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672848950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3803	1715672848950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672848964	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672849951	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672849951	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3803	1715672849951	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672849965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672850953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672850953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3803	1715672850953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672850969	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672851956	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672851956	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.381	1715672851956	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672851974	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672852957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715672852957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.381	1715672852957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672852971	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672853959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672853959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.381	1715672853959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672855964	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672855964	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3790999999999998	1715672855964	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	106	1715672859972	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672859972	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3781999999999996	1715672859972	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672860988	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672862995	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672865999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672870996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672870996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3838000000000004	1715672870996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672874001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672874001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3835	1715672874001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672881033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672885039	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672888047	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672891051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672899072	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672900073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673089470	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715673089470	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3956999999999997	1715673089470	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673092476	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673092476	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3956999999999997	1715673092476	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673093478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673093478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3956999999999997	1715673093478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673101515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673112535	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673115540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673118547	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673119553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673121555	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673139592	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673140593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4114	1715673291902	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673297916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673297916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4129	1715673297916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673299935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673308953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673315954	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715673315954	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.413	1715673315954	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673325977	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673325977	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673325977	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673326979	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715673326979	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673326979	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673327999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673331003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673347036	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673350043	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673357042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673357042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4137	1715673357042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673361064	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673370087	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673377099	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672853975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672855980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672860974	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715672860974	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3804000000000003	1715672860974	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672862978	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672862978	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3804000000000003	1715672862978	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672865985	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672865985	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3811999999999998	1715672865985	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672870011	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672871012	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672881016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.899999999999999	1715672881016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3829000000000002	1715672881016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672885024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715672885024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3870999999999998	1715672885024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672888031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672888031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3875	1715672888031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672891037	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672891037	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3870999999999998	1715672891037	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672899055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672899055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3846	1715672899055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672900057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672900057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3879	1715672900057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673135569	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3993	1715673135569	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673137588	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673291918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673299920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.9	1715673299920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.413	1715673299920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673308939	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673308939	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4106	1715673308939	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673313950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715673313950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673313950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673315971	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673325994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673326992	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673330988	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673330988	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4093	1715673330988	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673340025	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673350027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673350027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4122	1715673350027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673352031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673352031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.411	1715673352031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673357057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673370069	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673370069	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4134	1715673370069	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673376098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673382113	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673383114	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672854961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715672854961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3790999999999998	1715672854961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672856966	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672856966	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3790999999999998	1715672856966	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672861976	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13.1	1715672861976	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3804000000000003	1715672861976	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672868007	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672876006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715672876006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3868	1715672876006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672879029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672883035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672887047	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672889049	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672890050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672892056	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672893057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673138594	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673303928	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673303928	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.413	1715673303928	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673305933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715673305933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4103000000000003	1715673305933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673306935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673306935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4103000000000003	1715673306935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673310943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673310943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4106	1715673310943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673312948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673312948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673312948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673313965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673319982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673322970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673322970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4143000000000003	1715673322970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673331990	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673331990	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4093	1715673331990	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673332993	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673332993	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4118000000000004	1715673332993	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673334997	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715673334997	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4118000000000004	1715673334997	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673335999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715673335999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4107	1715673335999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673349045	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673351044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673354049	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673359064	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673360063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673373076	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673373076	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4137	1715673373076	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673374078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673374078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4137	1715673374078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672854976	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672856980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715672857968	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672857968	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3781999999999996	1715672857968	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672858970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672858970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3781999999999996	1715672858970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672861991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672866987	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672866987	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3829000000000002	1715672866987	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672867989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672867989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3829000000000002	1715672867989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672871998	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672871998	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3838000000000004	1715672871998	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672873000	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672873000	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3835	1715672873000	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672874017	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672876019	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672877008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672877008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3868	1715672877008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672878010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672878010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3868	1715672878010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672880014	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	2.7	1715672880014	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3829000000000002	1715672880014	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672882018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.3	1715672882018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3857	1715672882018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672883020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672883020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3857	1715672883020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672884037	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672886042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672887029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672887029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3870999999999998	1715672887029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672889033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.899999999999999	1715672889033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3875	1715672889033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672890035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715672890035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3875	1715672890035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672892040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672892040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3870999999999998	1715672892040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672893042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672893042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3870999999999998	1715672893042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672895061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672897067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673141581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673141581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3991	1715673141581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673142583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673142583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3991	1715673142583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673146591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672857986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672858988	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672867003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715672869994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13.6	1715672869994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3838000000000004	1715672869994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672872015	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672873020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672877023	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672878024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672880028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672884022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672884022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3857	1715672884022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672886027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672886027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3870999999999998	1715672886027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672895046	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672895046	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3861	1715672895046	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672897051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672897051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3846	1715672897051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673141595	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673145590	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673145590	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673145590	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673146607	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673148609	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673152603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673152603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3989000000000003	1715673152603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673153624	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673155609	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673155609	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3993	1715673155609	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673156612	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.200000000000001	1715673156612	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3993	1715673156612	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673162627	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673162627	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3991	1715673162627	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673164631	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673164631	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673164631	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673170660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673171662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673175674	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673182684	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673183685	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673195696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673195696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4032	1715673195696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673199717	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715673307937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4103000000000003	1715673307937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673311945	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673311945	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673311945	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673316970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673317974	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673320984	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673323989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673341010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672859991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672863995	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672864997	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672869007	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672875019	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672882034	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672894061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672896064	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672898071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672901077	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673142599	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673143599	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673151617	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673157614	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673157614	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3993	1715673157614	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673167637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673167637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.399	1715673167637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673168639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673168639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.399	1715673168639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673169642	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673169642	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.399	1715673169642	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673173650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715673173650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4028	1715673173650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673180664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715673180664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4036	1715673180664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673181666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673181666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4036	1715673181666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673189683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.8	1715673189683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4035	1715673189683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673191687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673191687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4015	1715673191687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673193691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673193691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4015	1715673193691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673194694	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715673194694	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4032	1715673194694	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673195711	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673196713	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673197716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673198716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4143000000000003	1715673320966	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673323972	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715673323972	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673323972	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673333995	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673333995	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4118000000000004	1715673333995	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673341027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673353048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673355052	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673356056	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673358058	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673362068	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673363071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673366060	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672863980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672863980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3811999999999998	1715672863980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672864983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672864983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3811999999999998	1715672864983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672868991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672868991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3829000000000002	1715672868991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672875003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672875003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3835	1715672875003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672879012	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672879012	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3829000000000002	1715672879012	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672894044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672894044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3861	1715672894044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672896048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715672896048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3861	1715672896048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672898053	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672898053	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3846	1715672898053	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672901059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672901059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3879	1715672901059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672902061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672902061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3879	1715672902061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672902075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672903064	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672903064	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.379	1715672903064	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672903082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672904066	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672904066	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.379	1715672904066	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672904083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672905068	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672905068	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.379	1715672905068	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672905086	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672906070	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.6	1715672906070	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3788	1715672906070	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672906087	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672907071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672907071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3788	1715672907071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672907085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	106	1715672908073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715672908073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3788	1715672908073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672908089	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672909076	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672909076	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3855	1715672909076	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672909089	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672910078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672910078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3855	1715672910078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672910093	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672911080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672911080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3855	1715672911080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672914088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672914088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3872	1715672914088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672919098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.3	1715672919098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3874	1715672919098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672923109	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715672923109	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3855999999999997	1715672923109	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672924112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715672924112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3898	1715672924112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672925114	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672925114	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3898	1715672925114	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672926132	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672934133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672934133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3897	1715672934133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672937139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672937139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3891	1715672937139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672946172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672954189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672955192	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672956194	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672960208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673143586	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673143586	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673143586	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673151601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715673151601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3996999999999997	1715673151601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673154625	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673157633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673167651	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673168658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673169656	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673176657	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673176657	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.403	1715673176657	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673180680	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673181682	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673189698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673191703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673193705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673194708	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673196698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673196698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4032	1715673196698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673197700	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673197700	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4038000000000004	1715673197700	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673198701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673198701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4038000000000004	1715673198701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673324975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673324975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673324975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673327982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673327982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673327982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672911094	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672914102	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672919113	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672923126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672924126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672926116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672926116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3898	1715672926116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672933131	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672933131	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3897	1715672933131	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672934149	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672937155	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672954175	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.899999999999999	1715672954175	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3921	1715672954175	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672955177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672955177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3921	1715672955177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715672956180	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715672956180	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3921	1715672956180	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672960189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672960189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3928000000000003	1715672960189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673144588	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13.3	1715673144588	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673144588	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673145603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673147608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673152622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673159636	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673161640	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673166651	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673172664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673177675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673184672	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715673184672	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4017	1715673184672	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673192689	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673192689	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4015	1715673192689	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673200706	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673200706	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4024	1715673200706	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673329002	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673330000	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673337001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715673337001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4107	1715673337001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673338003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673338003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4107	1715673338003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673339005	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673339005	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.411	1715673339005	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673340007	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673340007	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.411	1715673340007	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673342028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673343028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673344120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673345033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673346035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672912083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672912083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3872	1715672912083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672916092	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672916092	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3874	1715672916092	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672920100	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672920100	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3874	1715672920100	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672922106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672922106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3855999999999997	1715672922106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672930141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672931142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672935152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672938157	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672940160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672943168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673144602	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673147593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715673147593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3979	1715673147593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673149597	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715673149597	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3996999999999997	1715673149597	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673159620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673159620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673159620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673161625	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673161625	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3991	1715673161625	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673166635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673166635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673166635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673172648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.8	1715673172648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.404	1715673172648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673176674	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673178660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715673178660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.403	1715673178660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673184686	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673192705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673200721	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673341010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.411	1715673341010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673353034	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715673353034	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.411	1715673353034	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673355038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673355038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4094	1715673355038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673356040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715673356040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4094	1715673356040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	110	1715673358044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673358044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4137	1715673358044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673362052	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673362052	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4144	1715673362052	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673363055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715673363055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673363055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672912100	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672916108	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672920115	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672930125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672930125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3881	1715672930125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715672931127	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672931127	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3881	1715672931127	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672935135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.3	1715672935135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3897	1715672935135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672938141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672938141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3891	1715672938141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672940145	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672940145	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3929	1715672940145	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672943152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672943152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3925	1715672943152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672952188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673146591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3979	1715673146591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673148595	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.8	1715673148595	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3979	1715673148595	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673149611	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673153605	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673153605	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3989000000000003	1715673153605	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673154607	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.8	1715673154607	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3989000000000003	1715673154607	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673155623	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673156628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673162641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673164650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673171646	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673171646	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.404	1715673171646	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673175654	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673175654	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4028	1715673175654	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673179678	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673183670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673183670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4017	1715673183670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673187695	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673199704	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673199704	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4038000000000004	1715673199704	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673342011	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4137	1715673342011	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673343013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.3	1715673343013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4137	1715673343013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673344016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673344016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4137	1715673344016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673345018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673345018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4119	1715673345018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	113	1715673346020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715672913085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715672913085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3872	1715672913085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672915090	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672915090	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3874	1715672915090	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672917094	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672917094	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3874	1715672917094	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672921120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672927118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715672927118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3895	1715672927118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715672929123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715672929123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3895	1715672929123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672932129	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672932129	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3881	1715672932129	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672933146	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672936151	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672939159	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672942164	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672944168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672945172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672947177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672950180	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672952171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672952171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3941999999999997	1715672952171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672957197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672958199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672959201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673150599	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673150599	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3996999999999997	1715673150599	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673158618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673158618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673158618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673160622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673160622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673160622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673163629	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673163629	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3991	1715673163629	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673165633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673165633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673165633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673170644	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673170644	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.404	1715673170644	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673174652	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673174652	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4028	1715673174652	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673177659	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673177659	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.403	1715673177659	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673179662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715673179662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4036	1715673179662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673185675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673185675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4028	1715673185675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673186677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672913101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672915105	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672917113	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672925128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672927135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672929139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672932144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672936137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672936137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3891	1715672936137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672939143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672939143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3929	1715672939143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672942150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672942150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3925	1715672942150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672944154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672944154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3925	1715672944154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672945156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672945156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3939	1715672945156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672947160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672947160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3939	1715672947160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672950166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672950166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3941	1715672950166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672951168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672951168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3941999999999997	1715672951168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672957182	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672957182	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3939	1715672957182	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672958184	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672958184	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3939	1715672958184	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672959187	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672959187	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3939	1715672959187	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673150613	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673158635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673160637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673163647	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673165649	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673173666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673174669	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673178676	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673182668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673182668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4017	1715673182668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673185692	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673186695	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673188681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673188681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4035	1715673188681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673190685	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673190685	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4035	1715673190685	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715673346020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4119	1715673346020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673347021	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673347021	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4119	1715673347021	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672918096	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672918096	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3874	1715672918096	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672921104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672921104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3855999999999997	1715672921104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672928121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672928121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3895	1715672928121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672941147	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672941147	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3929	1715672941147	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672946158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672946158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3939	1715672946158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672948176	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672949181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672953173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.500000000000001	1715672953173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3941999999999997	1715672953173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715673186677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4028	1715673186677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673187679	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673187679	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4028	1715673187679	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673188697	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673190703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673348023	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673348023	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4122	1715673348023	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673349025	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715673349025	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4122	1715673349025	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673364057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673364057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673364057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673365059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715673365059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673365059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673371088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673375080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673375080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4152	1715673375080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673378087	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	14	1715673378087	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4103000000000003	1715673378087	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673384101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673384101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4159	1715673384101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673392119	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673392119	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4149000000000003	1715673392119	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673395125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673395125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4165	1715673395125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673400152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673403141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673403141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4194	1715673403141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673406163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673408169	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673410174	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673413163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673413163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672918111	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672922120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672928139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672941163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672948162	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715672948162	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3941	1715672948162	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672949164	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672949164	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3941	1715672949164	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672951183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672953194	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672961191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672961191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3928000000000003	1715672961191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672961208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672962193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.800000000000001	1715672962193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3928000000000003	1715672962193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672962209	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672963195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715672963195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3919	1715672963195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672963210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672964198	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715672964198	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3919	1715672964198	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672964211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672965200	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672965200	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3919	1715672965200	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672965215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672966201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715672966201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3918000000000004	1715672966201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672966219	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672967203	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715672967203	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3918000000000004	1715672967203	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672967218	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672968206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.2	1715672968206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3918000000000004	1715672968206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672968221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672969208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715672969208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3921	1715672969208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672969224	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672970210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715672970210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3921	1715672970210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672970227	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672971212	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715672971212	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3921	1715672971212	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672971227	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715672972214	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715672972214	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3908	1715672972214	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672972230	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672973216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715672973216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3908	1715672973216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672973236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672974218	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715672974218	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3908	1715672974218	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672975221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715672975221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3919	1715672975221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672976223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715672976223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3919	1715672976223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672985241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715672985241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3952	1715672985241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672989250	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715672989250	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.393	1715672989250	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672993274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672999271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715672999271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.398	1715672999271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673000273	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715673000273	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.398	1715673000273	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673005300	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673017324	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673201708	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673201708	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4024	1715673201708	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673202710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673202710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4024	1715673202710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673205716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673205716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4046	1715673205716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673216739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673216739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.404	1715673216739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673217741	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673217741	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.404	1715673217741	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673219745	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715673219745	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4057	1715673219745	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673223773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673230785	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673231787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673248810	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673248810	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4081	1715673248810	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673250814	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673250814	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4081	1715673250814	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673257845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673258848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673348038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673352048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673364073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673371071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715673371071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4134	1715673371071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673374161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673375096	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673378103	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673384116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4147	1715673405146	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672974233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672975239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672976236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672985259	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672990267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672997267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715672997267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3968000000000003	1715672997267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672999286	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673000288	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673015306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673015306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3984	1715673015306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673020332	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673201722	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673202726	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673205731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673216753	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673217757	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673223755	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673223755	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4075	1715673223755	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673230771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673230771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4024	1715673230771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673231773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673231773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4024	1715673231773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673236783	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673236783	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4048000000000003	1715673236783	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673248828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673257831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673257831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.405	1715673257831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673258833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715673258833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.405	1715673258833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673359046	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4137	1715673359046	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673360048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715673360048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4144	1715673360048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673361050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715673361050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4144	1715673361050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673373091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673380091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715673380091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4103000000000003	1715673380091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673381094	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673381094	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4148	1715673381094	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673385104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673385104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4159	1715673385104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673387123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673391131	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673396142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673399149	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673401152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673402157	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673405146	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715673405146	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672977225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715672977225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3919	1715672977225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672982235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715672982235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3899	1715672982235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672987246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715672987246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.393	1715672987246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672995263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715672995263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3975	1715672995263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672998270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715672998270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3968000000000003	1715672998270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673004297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673006287	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715673006287	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.397	1715673006287	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673007303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673010295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673010295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3956999999999997	1715673010295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673019314	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715673019314	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3975999999999997	1715673019314	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673203712	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715673203712	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4046	1715673203712	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673206718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673206718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4002	1715673206718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673209725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673209725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4023000000000003	1715673209725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673210727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673210727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4023000000000003	1715673210727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673215737	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673215737	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.404	1715673215737	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673219764	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673220767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673224771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673225774	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673227779	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673235795	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673239790	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673239790	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.408	1715673239790	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673242795	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.9	1715673242795	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4086	1715673242795	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673243813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673246819	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673247823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673249826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673253821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715673253821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4074	1715673253821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673254838	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673365077	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673366075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673367078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672977241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672982249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672987260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672995279	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673004281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673004281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3996	1715673004281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673005285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673005285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.397	1715673005285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673006303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673009293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.499999999999998	1715673009293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3956999999999997	1715673009293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673010312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673019329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673203728	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673206732	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673209739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673210742	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673215751	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673220747	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673220747	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4057	1715673220747	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673224757	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.200000000000001	1715673224757	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4054	1715673224757	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673225759	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715673225759	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4054	1715673225759	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673227764	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673227764	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4036999999999997	1715673227764	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673235781	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673235781	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4046	1715673235781	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673237803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673239805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673243798	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673243798	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4086	1715673243798	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673246804	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673246804	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4066	1715673246804	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673247807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673247807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4066	1715673247807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673249812	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673249812	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4081	1715673249812	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673251832	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673254823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673254823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4079	1715673254823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673366060	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4135999999999997	1715673366060	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673367062	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715673367062	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4135999999999997	1715673367062	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673368065	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673368065	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4135999999999997	1715673368065	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673369067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673369067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672978227	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715672978227	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.385	1715672978227	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672980231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715672980231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.385	1715672980231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672981233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715672981233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3899	1715672981233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672983237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715672983237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3899	1715672983237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672984239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715672984239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3952	1715672984239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672988248	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715672988248	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.393	1715672988248	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672990252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715672990252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3975999999999997	1715672990252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672992257	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715672992257	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3975999999999997	1715672992257	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715672993259	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715672993259	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3975	1715672993259	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672996281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673001275	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673001275	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.398	1715673001275	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673002278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673002278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3996	1715673002278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673009309	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673012299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715673012299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3971999999999998	1715673012299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673013301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673013301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3971999999999998	1715673013301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673015321	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673016325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673204714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673204714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4046	1715673204714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673207721	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673207721	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4002	1715673207721	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673212731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673212731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4049	1715673212731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673213733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673213733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4049	1715673213733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673228766	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673228766	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4036999999999997	1715673228766	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673229769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715673229769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4036999999999997	1715673229769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673234779	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673234779	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4046	1715673234779	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672978244	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672980245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672981249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672983253	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672984255	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672988265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672991254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715672991254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3975999999999997	1715672991254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672992271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672996265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715672996265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3968000000000003	1715672996265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672997284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673001291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673002293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673011313	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673012313	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673013317	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673016308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673016308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3984	1715673016308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673204730	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673207738	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673212744	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673213749	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673228781	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673229785	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673234793	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673240806	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673245802	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673245802	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4066	1715673245802	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673251816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673251816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4074	1715673251816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673255826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13.9	1715673255826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4079	1715673255826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673256828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673256828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4079	1715673256828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673259835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715673259835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.405	1715673259835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673368079	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673369082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673372091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673377085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673377085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4152	1715673377085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673379103	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673385122	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673386123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673388124	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673389127	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673392134	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673400136	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673400136	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4166999999999996	1715673400136	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673406148	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673406148	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4147	1715673406148	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673408152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715673408152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672979229	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715672979229	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.385	1715672979229	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715672986244	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715672986244	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3952	1715672986244	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672989266	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715672994261	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715672994261	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3975	1715672994261	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672998288	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673003299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673008291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715673008291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3956999999999997	1715673008291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673011297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715673011297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3971999999999998	1715673011297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673014319	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673018312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673018312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3975999999999997	1715673018312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673020316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673020316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3988	1715673020316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673208723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673208723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4002	1715673208723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673211729	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.8	1715673211729	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4023000000000003	1715673211729	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673214735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673214735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4049	1715673214735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673218743	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673218743	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4057	1715673218743	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673221749	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715673221749	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4075	1715673221749	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673222752	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673222752	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4075	1715673222752	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673226761	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673226761	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4054	1715673226761	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673232775	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673232775	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4024	1715673232775	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673233777	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715673233777	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4046	1715673233777	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673236799	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673238787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715673238787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4048000000000003	1715673238787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673241793	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673241793	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.408	1715673241793	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673244800	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.8	1715673244800	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4086	1715673244800	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673250830	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673252833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672979243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672986259	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672991270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715672994278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673003280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673003280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3996	1715673003280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673007289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673007289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.397	1715673007289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673008306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673014304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673014304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3984	1715673014304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673017310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715673017310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3975999999999997	1715673017310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673018330	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673021318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715673021318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3988	1715673021318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673021340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673022320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673022320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3988	1715673022320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673022335	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673023323	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715673023323	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3993	1715673023323	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673023338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673024325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715673024325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3993	1715673024325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673024342	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673025327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673025327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3993	1715673025327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673025342	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673026329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715673026329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673026329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673026345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673027331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673027331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673027331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673027348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673028333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715673028333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673028333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673028347	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673029335	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715673029335	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.393	1715673029335	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673029350	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673030338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673030338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.393	1715673030338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673030354	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673031340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715673031340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.393	1715673031340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673031357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673032343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673032343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3956	1715673032343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673043368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673043368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3963	1715673043368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673044385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673046391	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673048380	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715673048380	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3959	1715673048380	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673049397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673050448	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673056417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673063429	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673065418	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673065418	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3968000000000003	1715673065418	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673068424	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673068424	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3986	1715673068424	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673070444	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673071448	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673073450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673074453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673075454	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673077460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673208737	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673211748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673214750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673218759	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673221766	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673222768	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673226778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673232792	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673233792	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673237785	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673237785	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4048000000000003	1715673237785	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673238802	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673241810	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673244813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673252818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673252818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4074	1715673252818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673260837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673260837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4055	1715673260837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4134	1715673369067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673372073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673372073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4137	1715673372073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	110	1715673376083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715673376083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4152	1715673376083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673379089	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	3	1715673379089	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4103000000000003	1715673379089	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673386106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673386106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4159	1715673386106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673388110	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715673388110	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4135999999999997	1715673388110	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673389112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673389112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4135999999999997	1715673389112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673032361	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673042381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673048396	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673052409	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673064431	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673066435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673067437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673072449	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673078447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.200000000000001	1715673078447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673078447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673079449	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673079449	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673079449	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673240791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673240791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.408	1715673240791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673242814	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673245816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673253836	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673255841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673256844	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673259850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673380111	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673381111	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673387108	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715673387108	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4135999999999997	1715673387108	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673391117	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715673391117	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4149000000000003	1715673391117	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673396128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673396128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4162	1715673396128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673399134	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673399134	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4166999999999996	1715673399134	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673401138	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673401138	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4166999999999996	1715673401138	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673402140	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715673402140	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4194	1715673402140	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673403158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673405162	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4148	1715673408152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673410157	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673410157	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4148	1715673410157	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4154	1715673413163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673413178	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673415167	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673415167	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4173	1715673415167	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673415183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673416169	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673416169	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4173	1715673416169	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673416188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673417171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673417171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4158000000000004	1715673417171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673417185	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673418173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673419175	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673033345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715673033345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3956	1715673033345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673035369	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673037371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673039376	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673041383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673051408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673053408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673054411	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673062429	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673069441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673260852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673382097	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715673382097	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4148	1715673382097	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673383099	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673383099	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4148	1715673383099	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673390115	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673390115	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4149000000000003	1715673390115	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673390129	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673393121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673393121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4165	1715673393121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673393137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673394123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715673394123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4165	1715673394123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673394137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673395141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673397130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673397130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4162	1715673397130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673397144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673398132	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673398132	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4162	1715673398132	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673398146	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673404143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715673404143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4194	1715673404143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673404158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673407150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673407150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4147	1715673407150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673407244	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	111	1715673409155	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673409155	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4148	1715673409155	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673409170	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673411159	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673411159	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4154	1715673411159	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673411173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673412161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715673412161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4154	1715673412161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673412178	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673414165	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673414165	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4173	1715673414165	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673414181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673033360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673036352	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715673036352	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3955	1715673036352	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673038373	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673041364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715673041364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3963	1715673041364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673051388	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673051388	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3984	1715673051388	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673053392	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673053392	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3955	1715673053392	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673054394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715673054394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3955	1715673054394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673062412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673062412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.398	1715673062412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673069426	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673069426	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3986	1715673069426	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673079465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673261839	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673261839	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4055	1715673261839	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673262857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673265863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673269857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673269857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4071	1715673269857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673272863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673272863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4048000000000003	1715673272863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673276871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673276871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4046999999999996	1715673276871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673281897	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673286910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673290916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673294923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673296928	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673298933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673302942	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673303945	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673305950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673306948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673310959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673312964	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673314968	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673321986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673322984	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673332003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673333009	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673335012	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673336016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673351030	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715673351030	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.411	1715673351030	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673354036	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673354036	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4094	1715673354036	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673359046	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673034348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715673034348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3956	1715673034348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673036376	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673038357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715673038357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.393	1715673038357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673040376	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673044371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715673044371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.397	1715673044371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673047393	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673055412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673057415	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673058418	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673059419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673061410	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715673061410	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3946	1715673061410	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673070428	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673070428	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3986	1715673070428	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673080470	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673261854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673263859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673266864	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673271861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673271861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4071	1715673271861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673274881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673279877	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673279877	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4069000000000003	1715673279877	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673282883	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715673282883	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4101	1715673282883	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673285890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715673285890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4079	1715673285890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673292920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673295925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673300938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673301937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673304947	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673309955	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673316956	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715673316956	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.413	1715673316956	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673318977	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673321968	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715673321968	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4143000000000003	1715673321968	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673324991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673328984	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715673328984	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673328984	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673329986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715673329986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4093	1715673329986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673334013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673337016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673338021	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673339020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673342011	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673034364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673037355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715673037355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3955	1715673037355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673040362	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715673040362	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.393	1715673040362	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673042366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715673042366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3963	1715673042366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673046376	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715673046376	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.397	1715673046376	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673055397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673055397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3955	1715673055397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673057401	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715673057401	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3924000000000003	1715673057401	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673058403	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673058403	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3924000000000003	1715673058403	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673059405	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715673059405	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3946	1715673059405	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673060407	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715673060407	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3946	1715673060407	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673061423	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673076443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673076443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3978	1715673076443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673262841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673262841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4055	1715673262841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673265848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673265848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4076999999999997	1715673265848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673268854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673268854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.407	1715673268854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673269871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673272878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673281881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673281881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4101	1715673281881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673286892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673286892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4079	1715673286892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673290900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673290900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4114	1715673290900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673294909	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715673294909	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673294909	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673296914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673296914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4129	1715673296914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673298918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673298918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4129	1715673298918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673302925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673302925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.413	1715673302925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673035350	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673035350	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3955	1715673035350	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673045389	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	108	1715673052390	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673052390	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3984	1715673052390	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673060422	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673066420	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.700000000000001	1715673066420	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3968000000000003	1715673066420	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673067422	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673067422	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3968000000000003	1715673067422	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673072432	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13.200000000000001	1715673072432	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3996999999999997	1715673072432	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673076485	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673078463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673080451	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673080451	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4021	1715673080451	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673263843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715673263843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4076999999999997	1715673263843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673266850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673266850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.407	1715673266850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673267868	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673274867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715673274867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4048000000000003	1715673274867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673278875	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715673278875	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4069000000000003	1715673278875	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673279893	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673282898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673292905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715673292905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4114	1715673292905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673295911	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673295911	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673295911	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673300921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673300921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.413	1715673300921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673301923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673301923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.413	1715673301923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673304930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673304930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.413	1715673304930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673309941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673309941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4106	1715673309941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673314952	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673314952	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.413	1715673314952	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673318961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715673318961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4129	1715673318961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673319963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673319963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4129	1715673319963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673039359	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715673039359	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.393	1715673039359	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673043383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673045373	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673045373	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.397	1715673045373	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673047378	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715673047378	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3959	1715673047378	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673049383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715673049383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3959	1715673049383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673050386	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715673050386	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3984	1715673050386	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673056399	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673056399	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3924000000000003	1715673056399	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673063414	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.3	1715673063414	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.398	1715673063414	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673064416	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673064416	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.398	1715673064416	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673065434	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673068441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673071430	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673071430	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3996999999999997	1715673071430	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673073434	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673073434	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3996999999999997	1715673073434	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673074437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673074437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3978	1715673074437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673075439	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715673075439	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3978	1715673075439	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673077445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673077445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.3987	1715673077445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673264846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715673264846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4076999999999997	1715673264846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673267852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715673267852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.407	1715673267852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673270873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673275884	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673277890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673280895	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673283901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673293907	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715673293907	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4126	1715673293907	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673297931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673307953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673311959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673317959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673317959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4129	1715673317959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673320966	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673320966	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673418173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4158000000000004	1715673418173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673420178	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673420178	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4156999999999997	1715673420178	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673422182	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715673422182	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4156999999999997	1715673422182	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673425189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673425189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4175999999999997	1715673425189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673428210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673429212	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673431217	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673436230	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673450243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673450243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4181999999999997	1715673450243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673454252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673454252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4172	1715673454252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673456271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673458276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673461281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673464291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673471304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673478301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673478301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4205	1715673478301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673483312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673483312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4213	1715673483312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673486319	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673486319	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4206	1715673486319	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673487321	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715673487321	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4206	1715673487321	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673496341	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673496341	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4179	1715673496341	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673500349	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673500349	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4215999999999998	1715673500349	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673501351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673501351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4221999999999997	1715673501351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673508381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673512388	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673513390	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673514393	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673516397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673521393	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.100000000000001	1715673521393	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4226	1715673521393	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715673522395	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4219	1715673522395	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673522411	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673527429	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673529411	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715673529411	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4223000000000003	1715673529411	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673529427	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673531415	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673418189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673420193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673422199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673428195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673428195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4164	1715673428195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673429197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673429197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4185	1715673429197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673431202	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673431202	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4185	1715673431202	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673436213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673436213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4179	1715673436213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673441223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673441223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4175	1715673441223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673450258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673456256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715673456256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4164	1715673456256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673458260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673458260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4164	1715673458260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673461266	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673461266	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4144	1715673461266	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673463287	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673471288	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673471288	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4194	1715673471288	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673473291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673473291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4194	1715673473291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673478318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673483327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673486333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673487337	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673496359	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673500363	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673501366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673502372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673503372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673505377	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673509382	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673518387	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673518387	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4240999999999997	1715673518387	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673519389	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715673519389	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4226	1715673519389	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673523413	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673526405	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715673526405	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4199	1715673526405	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673530413	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715673530413	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4223000000000003	1715673530413	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715673531415	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4208000000000003	1715673531415	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673532436	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673534422	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673534422	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673419175	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4158000000000004	1715673419175	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673427193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.9	1715673427193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4164	1715673427193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673433207	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715673433207	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4145	1715673433207	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673440237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673443244	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673446235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715673446235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4175	1715673446235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673447237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673447237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4172	1715673447237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673448239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673448239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4172	1715673448239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673452247	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673452247	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4181999999999997	1715673452247	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673454272	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673462283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673474293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673474293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4209	1715673474293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673477299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673477299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4205	1715673477299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673480306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673480306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4165	1715673480306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673482310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673482310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4165	1715673482310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673485331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673499365	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673502353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715673502353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4221999999999997	1715673502353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673503355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673503355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4221999999999997	1715673503355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673505360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673505360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4199	1715673505360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673509368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673509368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4206	1715673509368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673517399	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673518403	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673523398	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673523398	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4219	1715673523398	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673524419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673526419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673530428	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673531429	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673533435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673534435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673538445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673539447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673541437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673419191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673427210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673433222	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673443228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715673443228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4175	1715673443228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673444248	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673446249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673447251	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673448255	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673452263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673462268	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673462268	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4156	1715673462268	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673473309	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673474309	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673477315	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673480320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673482325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673499347	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	16.599999999999998	1715673499347	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4215999999999998	1715673499347	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673504357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673504357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4199	1715673504357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673507364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673507364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4206	1715673507364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673515381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673515381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4226	1715673515381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673517385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673517385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4240999999999997	1715673517385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673524400	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673524400	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4219	1715673524400	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673528409	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673528409	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4223000000000003	1715673528409	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4232	1715673534422	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673535440	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673536440	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673538430	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673538430	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4231	1715673538430	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673540450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673541437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4245	1715673541437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673542441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715673542441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4245	1715673542441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673543443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673543443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4229000000000003	1715673543443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673544445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715673544445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4229000000000003	1715673544445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673544458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673545447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4229000000000003	1715673545447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673545462	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673546449	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673546449	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673421180	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715673421180	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4156999999999997	1715673421180	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673423185	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673423185	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4175999999999997	1715673423185	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673424187	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.9	1715673424187	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4175999999999997	1715673424187	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673425204	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673430215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673435211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673435211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4179	1715673435211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673438217	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673438217	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4175999999999997	1715673438217	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673439219	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673439219	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4175999999999997	1715673439219	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673440221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673440221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4175999999999997	1715673440221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673442241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673445248	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673449257	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673455270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673457276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673459277	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673464273	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673464273	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4156	1715673464273	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673466291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673467294	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673469283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673469283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4184	1715673469283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673470285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673470285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4184	1715673470285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673484314	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673484314	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4213	1715673484314	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673491330	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673491330	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4202	1715673491330	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673492332	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673492332	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4169	1715673492332	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673504372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673512374	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673512374	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4223000000000003	1715673512374	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673513376	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673513376	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4226	1715673513376	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673514378	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673514378	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4226	1715673514378	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673516383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673516383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4240999999999997	1715673516383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673520406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673522395	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673421193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673423201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673424201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673430199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673430199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4185	1715673430199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673432219	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673435225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673438231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673439236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673442226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673442226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4175	1715673442226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673445233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673445233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4175	1715673445233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673449241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673449241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4172	1715673449241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673455254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715673455254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4172	1715673455254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673457258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.7	1715673457258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4164	1715673457258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673459262	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673459262	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4144	1715673459262	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673463271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673463271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4156	1715673463271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673466277	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715673466277	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4171	1715673466277	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673467279	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715673467279	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4171	1715673467279	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673468281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673468281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4184	1715673468281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673469299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673470301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673484334	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673491345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673492347	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673506361	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715673506361	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4199	1715673506361	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673507379	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673515395	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673521407	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673527407	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673527407	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4199	1715673527407	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673535424	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715673535424	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4232	1715673535424	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673536426	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715673536426	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4232	1715673536426	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4231	1715673537428	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673542457	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673543459	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673545447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673426191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673426191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4164	1715673426191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673432205	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673432205	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4145	1715673432205	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673434226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673437231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673444231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673444231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4175	1715673444231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673451261	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673453265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673460280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673465291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673472290	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673472290	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4194	1715673472290	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673475295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673475295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4209	1715673475295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673476297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715673476297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4209	1715673476297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673479303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673479303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4205	1715673479303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673481308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673481308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4165	1715673481308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673485316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673485316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4213	1715673485316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673488339	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673489340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673490343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673493350	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673494350	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673495354	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673497359	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673498362	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673506376	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673510370	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715673510370	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4223000000000003	1715673510370	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673511372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673511372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4223000000000003	1715673511372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673519405	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673525402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673525402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4199	1715673525402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673528425	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673533420	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673533420	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4208000000000003	1715673533420	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673537444	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673539433	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673539433	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4231	1715673539433	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673540435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673540435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4245	1715673540435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673541451	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673426205	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673434209	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673434209	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4145	1715673434209	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673437215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715673437215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4179	1715673437215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673441238	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673451245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673451245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4181999999999997	1715673451245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673453250	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673453250	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4172	1715673453250	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673460264	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673460264	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4144	1715673460264	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673465275	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673465275	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4171	1715673465275	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673468296	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673472306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673475314	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673476316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673479319	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673481324	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673488323	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673488323	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4206	1715673488323	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673489325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673489325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4202	1715673489325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673490328	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673490328	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4202	1715673490328	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673493334	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673493334	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4169	1715673493334	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673494337	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715673494337	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4169	1715673494337	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673495339	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673495339	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4179	1715673495339	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673497343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673497343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4179	1715673497343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673498345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673498345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4215999999999998	1715673498345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673508366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673508366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4206	1715673508366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673510385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673511387	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673520391	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673520391	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4226	1715673520391	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673525419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673532417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673532417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4208000000000003	1715673532417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673537428	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673537428	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4243	1715673546449	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673549456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673549456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4225	1715673549456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673550458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673550458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4225	1715673550458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673552463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673552463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4236999999999997	1715673552463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673556471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673556471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4200999999999997	1715673556471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673561482	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673561482	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4225	1715673561482	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673563502	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673566508	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673578536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673579536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673581542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673582544	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673588555	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673590544	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673590544	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4246	1715673590544	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673595556	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673595556	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4246	1715673595556	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673599563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673599563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4266	1715673599563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673601568	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.100000000000001	1715673601568	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4264	1715673601568	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673609601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673981410	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673984417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673988423	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673993433	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673995437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674002437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715674002437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4486999999999997	1715674002437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674005443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715674005443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4479	1715674005443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674008450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715674008450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4492	1715674008450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674016481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674019492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674021494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674022495	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674026503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674029495	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674029495	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4503000000000004	1715674029495	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674030497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674030497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674030497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674033503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715674033503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.451	1715674033503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673546463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673549469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673550473	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673552479	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673556485	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673561496	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673566492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673566492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4205	1715673566492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673569499	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673569499	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4232	1715673569499	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673579521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673579521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4255999999999998	1715673579521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673581526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673581526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4255999999999998	1715673581526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673582528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715673582528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4231	1715673582528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673588540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673588540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4246	1715673588540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673589542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673589542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4246	1715673589542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673590562	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673595573	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673599580	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673609585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673609585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4261	1715673609585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673611603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673982394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673982394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4497	1715673982394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673984398	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715673984398	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4497	1715673984398	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673985415	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673994421	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673994421	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4486999999999997	1715673994421	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673996440	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674004441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715674004441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4479	1715674004441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674008466	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674012474	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674014462	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674014462	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4473000000000003	1715674014462	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674018487	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674069597	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674071606	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674072608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674074609	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674075610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674081608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674081608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4541	1715674081608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674085616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674085616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673547451	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673547451	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4243	1715673547451	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673548453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673548453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4243	1715673548453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673551460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715673551460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4225	1715673551460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673559478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673559478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4195	1715673559478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673562484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673562484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4225	1715673562484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673565491	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.3	1715673565491	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4205	1715673565491	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673567495	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715673567495	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4232	1715673567495	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673570501	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673570501	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.424	1715673570501	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673571503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715673571503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.424	1715673571503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673572507	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673572507	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.424	1715673572507	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673573509	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673573509	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4267	1715673573509	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673574525	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673576529	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673580524	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.600000000000001	1715673580524	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4255999999999998	1715673580524	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673584531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673584531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4231	1715673584531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673585534	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673585534	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4239	1715673585534	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673587538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673587538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4239	1715673587538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673594553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.3	1715673594553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4246	1715673594553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673601585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673602586	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673605593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673608598	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673612591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673612591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4225	1715673612591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673613594	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673613594	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4225	1715673613594	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673617603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673617603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4227	1715673617603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673982413	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673547466	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673548469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673557489	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673559492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673562498	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673565507	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673567510	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673570516	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673571519	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673572522	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673574511	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673574511	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4267	1715673574511	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673576515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673576515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4257	1715673576515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673578520	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.6	1715673578520	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4257	1715673578520	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673580539	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673584545	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673585550	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673591547	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.100000000000001	1715673591547	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4254000000000002	1715673591547	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673594568	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673602570	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.3	1715673602570	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4264	1715673602570	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673605576	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673605576	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4263000000000003	1715673605576	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673608583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673608583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.424	1715673608583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673611589	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673611589	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4261	1715673611589	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673612607	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673613608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673617618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673983396	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715673983396	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4497	1715673983396	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673991433	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673992431	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674001455	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674009467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674010470	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674015481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674017487	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674023498	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674024500	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674027508	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674036510	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674036510	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4479	1715674036510	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674038515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715674038515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4479	1715674038515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674039530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674040534	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674078601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4524	1715674078601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674082610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673551474	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673554483	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673555485	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673558489	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673560497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673564502	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673568510	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673575513	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	4.9	1715673575513	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4267	1715673575513	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673577517	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8999999999999995	1715673577517	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4257	1715673577517	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673587552	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673591561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673598579	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673600580	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673603589	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673607581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715673607581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.424	1715673607581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673610587	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673610587	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4261	1715673610587	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673615599	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715673615599	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4227	1715673615599	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673616601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673616601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4227	1715673616601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673618605	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715673618605	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4229000000000003	1715673618605	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673620610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673620610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4229000000000003	1715673620610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673983412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673985400	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673985400	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4463000000000004	1715673985400	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673987404	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673987404	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4463000000000004	1715673987404	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673994435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674000433	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674000433	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4486999999999997	1715674000433	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674004458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674012458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674012458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4473000000000003	1715674012458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674013460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715674013460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4473000000000003	1715674013460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674014479	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674082610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4541	1715674082610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674083627	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674088639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674089638	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674094635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674094635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4534000000000002	1715674094635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674099645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673553465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715673553465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4236999999999997	1715673553465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673557473	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715673557473	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4200999999999997	1715673557473	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673573524	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673583544	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673586553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673593551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715673593551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4254000000000002	1715673593551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673596558	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715673596558	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4246	1715673596558	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673597560	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673597560	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4266	1715673597560	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673598561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673598561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4266	1715673598561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673606579	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.100000000000001	1715673606579	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.424	1715673606579	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673614596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673614596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4225	1715673614596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673619607	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673619607	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4229000000000003	1715673619607	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673986402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715673986402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4463000000000004	1715673986402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673987418	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673989424	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673990432	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673997441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673999431	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715673999431	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4488000000000003	1715673999431	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674000450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674003440	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715674003440	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4479	1715674003440	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674006446	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674006446	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4492	1715674006446	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674007448	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674007448	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4492	1715674007448	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674011456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674011456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4468	1715674011456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674015465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674015465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4461999999999997	1715674015465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674020475	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715674020475	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4488000000000003	1715674020475	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674025486	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674025486	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4492	1715674025486	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674031499	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674031499	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673553479	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673563486	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.3	1715673563486	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4225	1715673563486	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673583530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.200000000000001	1715673583530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4231	1715673583530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673586536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715673586536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4239	1715673586536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673592549	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673592549	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4254000000000002	1715673592549	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673593567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673596575	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673597574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673604592	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673606598	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673614612	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673619622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673986419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673989408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715673989408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4479	1715673989408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673990412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673990412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4479	1715673990412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673997427	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673997427	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4488000000000003	1715673997427	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673998445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673999448	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674001435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715674001435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4486999999999997	1715674001435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674003456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674006463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674007462	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674011472	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674018471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715674018471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4488000000000003	1715674018471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674020491	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674025501	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674031514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674032518	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4541	1715674083612	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674088623	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674088623	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4480999999999997	1715674088623	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674089625	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674089625	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4480999999999997	1715674089625	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674090627	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674090627	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674090627	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674094651	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674099666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674100661	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674105673	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	99	1715674111672	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674111672	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4489	1715674111672	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674114694	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674117700	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673554467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673554467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4236999999999997	1715673554467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673555469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673555469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4200999999999997	1715673555469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673558475	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673558475	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4195	1715673558475	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673560480	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673560480	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4195	1715673560480	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673564488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3999999999999995	1715673564488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4205	1715673564488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673568497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673568497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4232	1715673568497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673569514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673575528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673577536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673589557	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673592563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673600566	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673600566	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4264	1715673600566	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673603572	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.600000000000001	1715673603572	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4263000000000003	1715673603572	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673604574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673604574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4263000000000003	1715673604574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673607595	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673610601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673615628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673616618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673618622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673620625	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673621612	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673621612	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.425	1715673621612	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673621626	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673622614	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673622614	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.425	1715673622614	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673622628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673623616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673623616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.425	1715673623616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673623630	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673624618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673624618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4244	1715673624618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673624632	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673625620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673625620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4244	1715673625620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673625636	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673626623	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673626623	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4244	1715673626623	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673626637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673627626	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673627626	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4259	1715673627626	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673629630	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673629630	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4259	1715673629630	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673630633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673630633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4219	1715673630633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673632637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673632637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4219	1715673632637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673633639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673633639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4242	1715673633639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673634642	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673634642	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4242	1715673634642	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673635644	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673635644	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4242	1715673635644	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673636661	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673638650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673638650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4253	1715673638650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673645666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673645666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4258	1715673645666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673647684	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673651678	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673651678	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4257	1715673651678	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673652679	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.200000000000001	1715673652679	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4257	1715673652679	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673655703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673658707	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673660713	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673667728	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673668728	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673676745	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673682745	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673682745	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4263000000000003	1715673682745	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673686754	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673686754	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4266	1715673686754	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673699780	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673699780	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4292	1715673699780	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673700782	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673700782	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4292	1715673700782	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673706796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673706796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4295999999999998	1715673706796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673707798	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.3	1715673707798	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4295999999999998	1715673707798	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673710805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673710805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.427	1715673710805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673711822	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673712824	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673713826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673716831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673627641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673629644	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673630653	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673632652	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673633654	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673634656	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673635660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673637662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673638668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673645681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673650691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673651693	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673652696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673656687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673656687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4244	1715673656687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673660697	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673660697	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.424	1715673660697	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673667712	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673667712	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4264	1715673667712	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673668714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673668714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4264	1715673668714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673676731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673676731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4240999999999997	1715673676731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673681758	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673682762	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673686767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673699794	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673700797	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673706812	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673707813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673711807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673711807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4284	1715673711807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673712809	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.100000000000001	1715673712809	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4284	1715673712809	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673713811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673713811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4284	1715673713811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673716817	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673716817	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4267	1715673716817	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673718821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673718821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4271	1715673718821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673725837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715673725837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4289	1715673725837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673726840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673726840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4292	1715673726840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673728845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673728845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4292	1715673728845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673730849	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673730849	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4266	1715673730849	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673731852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715673731852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673628628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715673628628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4259	1715673628628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673641657	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673641657	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4258	1715673641657	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673648671	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673648671	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4246999999999996	1715673648671	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673657689	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.600000000000001	1715673657689	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4218	1715673657689	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673659695	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13.6	1715673659695	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4218	1715673659695	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673662720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673669731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673673725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.600000000000001	1715673673725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4249	1715673673725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673677733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715673677733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4240999999999997	1715673677733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673679739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673679739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4261	1715673679739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673695772	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715673695772	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4275	1715673695772	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673704791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673704791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4295	1715673704791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673705794	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673705794	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4295999999999998	1715673705794	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673709817	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673714813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.600000000000001	1715673714813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4267	1715673714813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673715815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673715815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4267	1715673715815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673717819	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.3	1715673717819	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4271	1715673717819	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673719823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673719823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4271	1715673719823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673720826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673720826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4269000000000003	1715673720826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673721828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673721828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4269000000000003	1715673721828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673733856	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.3	1715673733856	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4246	1715673733856	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673736862	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673736862	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4291	1715673736862	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673738867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673738867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4309000000000003	1715673738867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673988406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673628647	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673641671	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673648689	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673658692	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715673658692	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4218	1715673658692	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673659713	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673665722	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673670733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673673742	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673677750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673679753	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673695786	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673704806	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673709803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673709803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.427	1715673709803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673710820	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673714829	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673715829	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673717837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673719838	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673720840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673722831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673722831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4269000000000003	1715673722831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673735876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673736878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673739869	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673739869	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4309000000000003	1715673739869	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673988406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4479	1715673988406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673993419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673993419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4475	1715673993419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673995423	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673995423	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4486999999999997	1715673995423	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673996425	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673996425	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4486999999999997	1715673996425	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674002452	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674005458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674016467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674016467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4461999999999997	1715674016467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674019473	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674019473	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4488000000000003	1715674019473	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674021477	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674021477	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4475	1715674021477	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674022479	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715674022479	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4475	1715674022479	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674026488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674026488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4492	1715674026488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674028508	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674029511	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674030515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674033520	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674034525	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674035524	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673631635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673631635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4219	1715673631635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673637648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.500000000000002	1715673637648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4253	1715673637648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673640670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673644678	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673653681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673653681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4257	1715673653681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673654683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673654683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4244	1715673654683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673655685	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715673655685	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4244	1715673655685	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673657707	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673665708	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673665708	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4244	1715673665708	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673670718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673670718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4251	1715673670718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673671735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673672738	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673675742	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673684750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673684750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4266	1715673684750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673687756	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673687756	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4261	1715673687756	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673689760	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715673689760	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4261	1715673689760	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673693768	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715673693768	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4275	1715673693768	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673694770	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673694770	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4275	1715673694770	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673696774	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673696774	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4274	1715673696774	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673702787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673702787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4295	1715673702787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673723833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.3	1715673723833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4289	1715673723833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673729847	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673729847	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4266	1715673729847	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673732854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673732854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4246	1715673732854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673735860	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673735860	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4291	1715673735860	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673737881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673740885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673991414	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673991414	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673631650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673640655	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.100000000000001	1715673640655	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4258	1715673640655	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673644663	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673644663	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4266	1715673644663	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673647670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673647670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4258	1715673647670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673653697	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673654699	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673656701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673662701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673662701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.424	1715673662701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673669716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673669716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4251	1715673669716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673671720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715673671720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4251	1715673671720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673672723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715673672723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4249	1715673672723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673675729	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673675729	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4240999999999997	1715673675729	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673681743	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673681743	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4263000000000003	1715673681743	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673684765	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673687771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673689774	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673693782	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673694787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673696789	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673702802	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673723849	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673729862	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673732868	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673737864	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673737864	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4291	1715673737864	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673740871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715673740871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4309000000000003	1715673740871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4475	1715673991414	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673992417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673992417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4475	1715673992417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673998429	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715673998429	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4488000000000003	1715673998429	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674009452	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715674009452	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4468	1715674009452	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674010454	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715674010454	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4468	1715674010454	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674013478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674017469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13.799999999999999	1715674017469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4461999999999997	1715674017469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673636646	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673636646	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4253	1715673636646	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673639666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673642676	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673643676	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673646684	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673649687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673661699	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673661699	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.424	1715673661699	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673663703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673663703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4244	1715673663703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673664705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715673664705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4244	1715673664705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673666710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673666710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4264	1715673666710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673674727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673674727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4249	1715673674727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673678736	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673678736	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4261	1715673678736	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673680741	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.600000000000001	1715673680741	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4261	1715673680741	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673683748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715673683748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4263000000000003	1715673683748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673685751	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673685751	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4266	1715673685751	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673688758	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673688758	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4261	1715673688758	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673690761	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673690761	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4267	1715673690761	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673691763	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715673691763	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4267	1715673691763	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673692765	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.200000000000001	1715673692765	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4267	1715673692765	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673697776	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715673697776	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4274	1715673697776	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673698778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673698778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4274	1715673698778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673701785	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715673701785	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4292	1715673701785	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673703789	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673703789	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4295	1715673703789	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673705808	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673708818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673722846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673724850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673727857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673639652	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715673639652	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4258	1715673639652	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673642660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715673642660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4266	1715673642660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673643661	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673643661	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4266	1715673643661	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673646668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715673646668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4258	1715673646668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673649673	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.600000000000001	1715673649673	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4246999999999996	1715673649673	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673650675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673650675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4246999999999996	1715673650675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673661715	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673663719	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673664719	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673666726	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673674741	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673678752	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673680756	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673683762	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673685765	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673688774	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673690777	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673691779	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673692780	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673697792	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673698797	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673701803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673703803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673708801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673708801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.427	1715673708801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673721843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673724835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.100000000000001	1715673724835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4289	1715673724835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673727842	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.300000000000001	1715673727842	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4292	1715673727842	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673733873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673734872	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674023482	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674023482	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4475	1715674023482	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674024484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715674024484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4492	1715674024484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674027490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715674027490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4503000000000004	1715674027490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674028492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674028492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4503000000000004	1715674028492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674036524	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674038528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674040519	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674040519	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4484	1715674040519	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673718837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673725852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673726856	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673728860	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673730865	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673731866	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673739885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674031499	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674032501	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674032501	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674032501	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674039517	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674039517	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4484	1715674039517	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4518	1715674085616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674086618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715674086618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4518	1715674086618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674091644	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674096655	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674097658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674110670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674110670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4548	1715674110670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674112675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674112675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4489	1715674112675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674113677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674113677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4489	1715674113677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674115681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674115681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4522	1715674115681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674116683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674116683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4522	1715674116683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674118687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674118687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4522	1715674118687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674120691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715674120691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4519	1715674120691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674121693	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674121693	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4519	1715674121693	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674123698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715674123698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4545	1715674123698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674129710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674129710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4549000000000003	1715674129710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674130711	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674130711	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4549000000000003	1715674130711	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674132716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674132716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4553000000000003	1715674132716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674136725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674136725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4534000000000002	1715674136725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674140733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674140733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4528000000000003	1715674140733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674142738	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4266	1715673731852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673738881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674034505	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715674034505	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.451	1715674034505	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674035508	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674035508	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.451	1715674035508	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674037512	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674037512	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4479	1715674037512	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674092631	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674092631	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674093633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674093633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4534000000000002	1715674093633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674095638	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674095638	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4534000000000002	1715674095638	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674101650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674101650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4536	1715674101650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674102653	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674102653	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4554	1715674102653	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674106676	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674109668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674109668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4548	1715674109668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674114679	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674114679	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4522	1715674114679	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674119705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674125717	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674133718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715674133718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4553000000000003	1715674133718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674134720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674134720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4553000000000003	1715674134720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674135741	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674138744	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674139748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674142738	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4533	1715674142738	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674143754	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674145745	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715674145745	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4536	1715674145745	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674148751	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674148751	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4556	1715674148751	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674151776	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4568000000000003	1715674154767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674154784	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674155769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674155769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4568000000000003	1715674155769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674155785	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674156771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674156771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4564	1715674156771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674156787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674157773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673734858	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673734858	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4246	1715673734858	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673741873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.200000000000001	1715673741873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4314	1715673741873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673741887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673742875	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673742875	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4314	1715673742875	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673742893	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673743878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.600000000000001	1715673743878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4314	1715673743878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673743893	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673744880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715673744880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.432	1715673744880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673744896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673745882	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.200000000000001	1715673745882	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.432	1715673745882	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673745898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673746884	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673746884	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.432	1715673746884	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673746899	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673747887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.200000000000001	1715673747887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4304	1715673747887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673747904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673748889	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673748889	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4304	1715673748889	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673748907	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673749891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673749891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4304	1715673749891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673749905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673750893	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673750893	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4349000000000003	1715673750893	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673750910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673751895	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673751895	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4349000000000003	1715673751895	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673751909	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673752898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13.700000000000001	1715673752898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4349000000000003	1715673752898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673752913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673753900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673753900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4301999999999997	1715673753900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673753916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673754902	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.200000000000001	1715673754902	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4301999999999997	1715673754902	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673754918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673755904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673755904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4301999999999997	1715673755904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673755919	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673756907	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.200000000000001	1715673756907	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4307	1715673756907	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673758911	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673758911	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4307	1715673758911	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673759928	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673763935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673773963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673784967	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673784967	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4333	1715673784967	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673785969	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673785969	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4333	1715673785969	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673786971	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673786971	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.436	1715673786971	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673789992	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673800000	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673800000	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4379	1715673800000	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673801019	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673807017	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673807017	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4386	1715673807017	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673812028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673812028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4341999999999997	1715673812028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673814032	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673814032	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4345	1715673814032	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673815036	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673815036	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4345	1715673815036	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673817040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673817040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4372	1715673817040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673818041	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673818041	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4372	1715673818041	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673827076	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673837100	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673838099	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673845115	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673848123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673852132	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673853135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673855139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674037526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674099645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4536	1715674099645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674100648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715674100648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4536	1715674100648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674105660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674105660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4548	1715674105660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674108682	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674111686	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674117685	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674117685	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4522	1715674117685	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674122696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674122696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673756923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673759913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673759913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4301	1715673759913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673763921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673763921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4320999999999997	1715673763921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673773943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673773943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4294000000000002	1715673773943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673775948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.1	1715673775948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4316	1715673775948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673784983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673785987	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673789978	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673789978	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4372	1715673789978	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673793986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673793986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4388	1715673793986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673800016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673804010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673804010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4372	1715673804010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673807032	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673812042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673814046	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673815052	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673817056	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673818055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673837082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673837082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4386	1715673837082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673838084	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673838084	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4371	1715673838084	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673845101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673845101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4398	1715673845101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673848109	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673848109	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4406999999999996	1715673848109	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673852117	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673852117	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4398	1715673852117	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673853119	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715673853119	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.44	1715673853119	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673855123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673855123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.44	1715673855123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674041521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	3.4	1715674041521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4484	1715674041521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674043526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674043526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4493	1715674043526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674045531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674045531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4498	1715674045531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674046533	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674046533	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4498	1715674046533	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673757909	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673757909	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4307	1715673757909	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673760915	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.600000000000001	1715673760915	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4301	1715673760915	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673765925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673765925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4301999999999997	1715673765925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673767931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673767931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4301999999999997	1715673767931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673768949	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673769954	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673772959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673774963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673791982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673791982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4372	1715673791982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673792984	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715673792984	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4388	1715673792984	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673795991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715673795991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4395	1715673795991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673802022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673806030	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673813046	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673816054	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673822063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673823067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673824070	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673827059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673827059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4386	1715673827059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673828078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673829078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673835096	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673847123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673860134	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673860134	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4354	1715673860134	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673861136	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673861136	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4354	1715673861136	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674041535	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674043542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674045546	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674046550	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674051559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674056569	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674061566	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715674061566	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.446	1715674061566	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674065574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674065574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4501	1715674065574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674067596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674077600	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674077600	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4508	1715674077600	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674079619	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674080622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674084628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674092631	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673757926	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673760929	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673765940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673768933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.3	1715673768933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4314	1715673768933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673769935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715673769935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4314	1715673769935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673772941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673772941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4294000000000002	1715673772941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673774946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673774946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4316	1715673774946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673781960	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673781960	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4309000000000003	1715673781960	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673791998	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673792999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673802006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673802006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4372	1715673802006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673806015	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715673806015	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4386	1715673806015	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673813030	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673813030	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4341999999999997	1715673813030	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673816038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673816038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4345	1715673816038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673822050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673822050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4381999999999997	1715673822050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673823051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.6	1715673823051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4371	1715673823051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673824053	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673824053	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4371	1715673824053	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673826075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673828062	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715673828062	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4386	1715673828062	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673829064	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673829064	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4400999999999997	1715673829064	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673835078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.6	1715673835078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4386	1715673835078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673847107	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673847107	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4406999999999996	1715673847107	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673851115	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673851115	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4398	1715673851115	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673860148	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673861155	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674042524	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674042524	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4493	1715674042524	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674048538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674048538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673758925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673761932	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673762933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673764937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673770938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673770938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4314	1715673770938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673771940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673771940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4294000000000002	1715673771940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673775963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673778970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673781979	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673786987	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673787988	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673790997	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673798998	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673798998	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4379	1715673798998	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673801004	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673801004	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4379	1715673801004	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673819059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673825055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673825055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4371	1715673825055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673826057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673826057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4386	1715673826057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673830081	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673833073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673833073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4249	1715673833073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673836080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673836080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4386	1715673836080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673840088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673840088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4371	1715673840088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673842094	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673842094	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4379	1715673842094	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673843096	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673843096	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4379	1715673843096	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673846103	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673846103	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4398	1715673846103	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673854121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673854121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.44	1715673854121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673856125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673856125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4395	1715673856125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673858130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673858130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4395	1715673858130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674042541	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674048554	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674049554	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674054551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674054551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4485	1715674054551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674058575	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673761917	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673761917	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4301	1715673761917	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673762920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673762920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4320999999999997	1715673762920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673764923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673764923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4320999999999997	1715673764923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673767947	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673770953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673771955	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673778953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673778953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4311	1715673778953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673780975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673782977	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673787973	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673787973	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.436	1715673787973	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673790980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673790980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4372	1715673790980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673796006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673799012	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673809038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673821048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673821048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4381999999999997	1715673821048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673825072	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673830066	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673830066	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4400999999999997	1715673830066	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673832086	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673833089	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673836096	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673840103	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673842108	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673843112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673846118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673854137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673856142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673858144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674044528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715674044528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4493	1715674044528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674047536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674047536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4498	1715674047536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674050542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715674050542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674050542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674052561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674055553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674055553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4485	1715674055553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674060563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715674060563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.446	1715674060563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674068598	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674076598	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13.899999999999999	1715674076598	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4508	1715674076598	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674078601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673766929	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715673766929	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4301999999999997	1715673766929	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673776950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673776950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4316	1715673776950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673777951	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.6	1715673777951	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4311	1715673777951	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673779956	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673779956	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4311	1715673779956	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673780958	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673780958	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4309000000000003	1715673780958	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673783965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715673783965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4333	1715673783965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673788975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715673788975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.436	1715673788975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673794002	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673795004	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673797009	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673798016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673803022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673805013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673805013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4386	1715673805013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673808020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673808020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4335	1715673808020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673809021	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673809021	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4335	1715673809021	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673810038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673811040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673820045	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673820045	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4381999999999997	1715673820045	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673821063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673831085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673834075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673834075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4249	1715673834075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673839086	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.1	1715673839086	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4371	1715673839086	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673841092	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673841092	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4379	1715673841092	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673844098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673844098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4398	1715673844098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673849111	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715673849111	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4406999999999996	1715673849111	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673850113	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673850113	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4398	1715673850113	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673851131	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673857143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673859146	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674044544	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673766945	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673776965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673777971	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673779970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673782962	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673782962	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4309000000000003	1715673782962	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673783979	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673788991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673794989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673794989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4388	1715673794989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673796994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673796994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4395	1715673796994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673797996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715673797996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4395	1715673797996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673803008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715673803008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4372	1715673803008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673804027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673805029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673808035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673810023	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673810023	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4335	1715673810023	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673811025	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.6	1715673811025	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4341999999999997	1715673811025	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673819043	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673819043	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4372	1715673819043	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673820062	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673831068	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673831068	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4400999999999997	1715673831068	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673832071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715673832071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4249	1715673832071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673834092	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673839106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673841106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673844115	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673849125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673850129	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673857128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673857128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4395	1715673857128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673859132	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673859132	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4354	1715673859132	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673862138	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.1	1715673862138	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4394	1715673862138	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673862153	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673863140	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673863140	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4394	1715673863140	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673863154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673864142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673864142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4394	1715673864142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673864159	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673865144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673865144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4421	1715673865144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673878172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673878172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.443	1715673878172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673879190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673883199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673885187	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673885187	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.439	1715673885187	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673887208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673896210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673896210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4414000000000002	1715673896210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673898214	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715673898214	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4425	1715673898214	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673901238	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673910257	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673911257	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673914249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673914249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4428	1715673914249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673920276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673926289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673932302	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673942326	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673943327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673944329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673947334	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673957357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673959363	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673961364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673962366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673965358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673965358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4486	1715673965358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673966360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715673966360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4486	1715673966360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673967362	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715673967362	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4480999999999997	1715673967362	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673970369	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673970369	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4474	1715673970369	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673973375	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673973375	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4476999999999998	1715673973375	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673975397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673977400	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673978405	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674047552	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674050560	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674053566	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674055567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674060578	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674073591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674073591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4513000000000003	1715674073591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674076613	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674078618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674083612	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674083612	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673865160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673878188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673883183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673883183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.439	1715673883183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673884185	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715673884185	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.439	1715673884185	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673887191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.1	1715673887191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4421	1715673887191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673891200	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673891200	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.443	1715673891200	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673896225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673898229	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673910240	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673910240	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4412	1715673910240	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673911243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673911243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4412	1715673911243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673913263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673914265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715673926274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673926274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4461999999999997	1715673926274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673932287	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673932287	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4454000000000002	1715673932287	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673942310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673942310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4444	1715673942310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673943311	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673943311	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4457	1715673943311	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673944313	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673944313	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4457	1715673944313	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673947320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673947320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4449	1715673947320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673957342	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673957342	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4476999999999998	1715673957342	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673959346	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673959346	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4471	1715673959346	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673961350	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673961350	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4463000000000004	1715673961350	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673962352	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673962352	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4463000000000004	1715673962352	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673964356	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673964356	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4486	1715673964356	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673965376	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673966376	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673967379	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673970384	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673973390	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673977383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715673977383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673866146	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715673866146	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4421	1715673866146	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673866160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673867163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673869169	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673870172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673872160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715673872160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4384	1715673872160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673873177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673874179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673875180	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673876183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673877188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673880177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673880177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4427	1715673880177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673884199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673886189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715673886189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4421	1715673886189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673888193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715673888193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4421	1715673888193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673889213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673893219	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673899233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673900220	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673900220	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4425	1715673900220	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673902240	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673903245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673904242	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673906248	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673908254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673912263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673915267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673917273	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673919260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673919260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4442	1715673919260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673919278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673921263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715673921263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4442	1715673921263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673923284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673924270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673924270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4461999999999997	1715673924270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673927293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673929295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673930283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673930283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4468	1715673930283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673931299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673933303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673934305	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673935307	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673937299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715673937299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4432	1715673937299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673940306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12	1715673940306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4444	1715673940306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673867148	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673867148	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4421	1715673867148	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673869154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673869154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4418	1715673869154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673870156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673870156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4418	1715673870156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673871158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715673871158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4384	1715673871158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673872174	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673876168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715673876168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4400999999999997	1715673876168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673877170	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673877170	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.443	1715673877170	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673889195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715673889195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.443	1715673889195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673893204	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715673893204	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4433000000000002	1715673893204	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673899216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673899216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4425	1715673899216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673904228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673904228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4427	1715673904228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673908236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673908236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4433000000000002	1715673908236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673915252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715673915252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4428	1715673915252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673917256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673917256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4448000000000003	1715673917256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673918258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673918258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4448000000000003	1715673918258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673920261	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715673920261	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4442	1715673920261	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673921280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673924284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673930299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673937316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673940322	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673941322	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673948337	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673950341	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673951344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673953348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673955354	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673956357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673958358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673968364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673968364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4480999999999997	1715673968364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673971371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673971371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673868152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715673868152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4418	1715673868152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673873162	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715673873162	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4384	1715673873162	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673881179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715673881179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4427	1715673881179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673882181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673882181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4427	1715673882181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673890197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673890197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.443	1715673890197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673891216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673892216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673894220	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673895225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673897228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673901221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673901221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4425	1715673901221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673905245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673907252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673909253	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673916268	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673922266	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715673922266	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4461999999999997	1715673922266	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673925272	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673925272	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4461999999999997	1715673925272	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673928279	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673928279	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4468	1715673928279	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673936297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673936297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4406999999999996	1715673936297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673938301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673938301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4432	1715673938301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673939303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673939303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4432	1715673939303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673945316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673945316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4457	1715673945316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673946318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673946318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4449	1715673946318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673952331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673952331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4485	1715673952331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673954356	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673963369	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673969382	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673979402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674048538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674049540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674049540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674049540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674053548	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715674053548	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673868166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673874164	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673874164	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4400999999999997	1715673874164	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673881193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673882195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673890212	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673892202	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715673892202	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4433000000000002	1715673892202	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673894206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673894206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4433000000000002	1715673894206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673895208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673895208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4414000000000002	1715673895208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673897211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673897211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4414000000000002	1715673897211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673900237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673905230	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673905230	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4427	1715673905230	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673907234	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673907234	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4433000000000002	1715673907234	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673909238	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673909238	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4433000000000002	1715673909238	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673916254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673916254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4448000000000003	1715673916254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673918275	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673922281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673925287	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673928297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673936312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673938317	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673939318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673945329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673946332	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673954335	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715673954335	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4485	1715673954335	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673963354	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673963354	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4463000000000004	1715673963354	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673969367	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673969367	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4480999999999997	1715673969367	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673979388	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715673979388	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4484	1715673979388	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673981391	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673981391	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4484	1715673981391	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674051544	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674051544	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4495999999999998	1715674051544	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674056555	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715674056555	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4485	1715674056555	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674059579	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674061581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673871173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673875166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	3.4	1715673875166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4400999999999997	1715673875166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673879174	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715673879174	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.443	1715673879174	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673880192	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673885203	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673886203	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673888209	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673902224	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673902224	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4425	1715673902224	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673903226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715673903226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4425	1715673903226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673906232	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673906232	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4427	1715673906232	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673912245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673912245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4412	1715673912245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673913247	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673913247	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4428	1715673913247	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673923268	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673923268	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4461999999999997	1715673923268	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673927276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673927276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4461999999999997	1715673927276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673929281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673929281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4468	1715673929281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673931285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673931285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4454000000000002	1715673931285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673933289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673933289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4454000000000002	1715673933289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673934291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673934291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4406999999999996	1715673934291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673935293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.6	1715673935293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4406999999999996	1715673935293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673949325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673949325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4467	1715673949325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673952347	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673960363	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673974393	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673976381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673976381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4484	1715673976381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674052546	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674052546	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4495999999999998	1715674052546	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674057572	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674059561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674059561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4499	1715674059561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674063586	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673941308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673941308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4444	1715673941308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673948323	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715673948323	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4449	1715673948323	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673950327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673950327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4467	1715673950327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673951329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6000000000000005	1715673951329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4467	1715673951329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715673953333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673953333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4485	1715673953333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715673955337	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673955337	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4476999999999998	1715673955337	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673956340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673956340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4476999999999998	1715673956340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673958344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673958344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4471	1715673958344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673964371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673968379	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673971385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673972391	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673980405	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4495999999999998	1715674053548	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674054567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674062568	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674062568	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.446	1715674062568	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674064572	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674064572	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4501	1715674064572	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674065589	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674066590	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674070585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674070585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674070585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674082627	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674087621	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674087621	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4480999999999997	1715674087621	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674098643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674098643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4537	1715674098643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674103655	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674103655	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4554	1715674103655	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674104658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674104658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4554	1715674104658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674107664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674107664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4548	1715674107664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4519	1715674122696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674124700	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674124700	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4545	1715674124700	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674126719	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674127705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673949338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673960348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715673960348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4471	1715673960348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715673974378	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715673974378	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4476999999999998	1715673974378	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673975380	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715673975380	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4476999999999998	1715673975380	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715673976402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674057557	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674057557	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4499	1715674057557	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674058559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674058559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4499	1715674058559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674063570	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674063570	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4501	1715674063570	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674069583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674069583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674069583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674071587	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674071587	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674071587	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674072589	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674072589	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4513000000000003	1715674072589	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674073608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674075596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674075596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4508	1715674075596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674077615	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674081622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674085634	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674091629	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674091629	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674091629	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674096640	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674096640	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4537	1715674096640	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674097641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674097641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4537	1715674097641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674102668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674110686	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674112688	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674113693	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674115696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674116699	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674118703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674120706	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674121708	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674122709	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674123712	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674127720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674129727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674130726	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674132732	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674136739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674140747	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674142753	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674145759	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674146747	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4474	1715673971371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715673972373	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673972373	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4474	1715673972373	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673980390	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715673980390	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4484	1715673980390	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674062584	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674064586	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674066576	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674066576	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4509000000000003	1715674066576	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674068581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674068581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4509000000000003	1715674068581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674070602	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674086633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674087635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674098660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674103672	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674104673	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674107680	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674124715	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674127705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4551	1715674127705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674128707	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674128707	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4551	1715674128707	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674131714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674131714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4549000000000003	1715674131714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674135723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674135723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4534000000000002	1715674135723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674137743	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674141735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674141735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4533	1715674141735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674144742	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674144742	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4536	1715674144742	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674146747	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4536	1715674146747	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674146767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674147750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674147750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4556	1715674147750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674148766	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674149753	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674149753	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4556	1715674149753	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674149769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674150756	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674150756	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4555	1715674150756	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674150772	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674152760	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674152760	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4555	1715674152760	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674152774	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674153763	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674153763	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4568000000000003	1715674153763	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674153778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4484	1715673977383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715673978386	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715673978386	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4484	1715673978386	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674067578	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13.799999999999999	1715674067578	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4509000000000003	1715674067578	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674074593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674074593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4513000000000003	1715674074593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674079603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.7	1715674079603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4524	1715674079603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674080605	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674080605	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4524	1715674080605	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674084614	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674084614	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4518	1715674084614	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674090643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674092651	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674093649	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674095654	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674101670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674106662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715674106662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4548	1715674106662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674108666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715674108666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4548	1715674108666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674109682	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674119689	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674119689	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4522	1715674119689	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674125701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674125701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4545	1715674125701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674126703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674126703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4551	1715674126703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674128721	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674131728	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674133733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674134740	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674137727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715674137727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4534000000000002	1715674137727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674138730	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674138730	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4528000000000003	1715674138730	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674139731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715674139731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4528000000000003	1715674139731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674141750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674143740	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715674143740	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4533	1715674143740	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674144758	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674147766	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674151758	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674151758	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4555	1715674151758	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674154767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674154767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674157773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4564	1715674157773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674161781	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674161781	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4576	1715674161781	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674162783	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674162783	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4541	1715674162783	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674164787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674164787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4541	1715674164787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674165789	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715674165789	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4541999999999997	1715674165789	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674167811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674171804	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674171804	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.458	1715674171804	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674176815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674176815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4595	1715674176815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674177832	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674181841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674183830	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674183830	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4599	1715674183830	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674187838	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715674187838	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4571	1715674187838	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674189841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674189841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4613	1715674189841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674196856	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674196856	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4605	1715674196856	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674197858	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674197858	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4605	1715674197858	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674198860	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.600000000000001	1715674198860	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4594	1715674198860	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674199862	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674199862	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4594	1715674199862	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674201866	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674201866	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4569	1715674201866	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674203872	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674203872	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4569	1715674203872	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674204891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674205892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674208898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674214910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674216915	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674217917	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674581700	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674581700	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4677	1715674581700	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674582717	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674585725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674590733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674601755	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674608772	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674157788	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674161800	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674162797	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674164803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674165804	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674168796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715674168796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4563	1715674168796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674172821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674177817	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674177817	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4599	1715674177817	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674181825	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674181825	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4600999999999997	1715674181825	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674182827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715674182827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4600999999999997	1715674182827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674183845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674187860	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674190859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674196870	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674197874	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674198874	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674199877	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674201883	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674204876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715674204876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4568000000000003	1715674204876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674205878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674205878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4568000000000003	1715674205878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674208883	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674208883	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4551999999999996	1715674208883	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674214896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674214896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.455	1715674214896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674216900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674216900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4591	1715674216900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674217902	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674217902	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4591	1715674217902	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674220923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674581714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674593739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674596747	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674597747	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674599736	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674599736	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4616	1715674599736	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674606750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715674606750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4626	1715674606750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674611761	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715674611761	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4651	1715674611761	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674614767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674614767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4656	1715674614767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674615769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715674615769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715674615769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674158775	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674158775	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4564	1715674158775	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674159777	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674159777	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4576	1715674159777	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674160779	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674160779	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4576	1715674160779	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674169798	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674169798	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4563	1715674169798	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674170800	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674170800	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4563	1715674170800	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674173826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674175828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674185834	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674185834	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4599	1715674185834	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674186836	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674186836	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4571	1715674186836	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674195853	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674195853	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4605	1715674195853	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674200864	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.8	1715674200864	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4594	1715674200864	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674209885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674209885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4551999999999996	1715674209885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674218904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674218904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4591	1715674218904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674582702	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674582702	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4663000000000004	1715674582702	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674585708	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674585708	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4671999999999996	1715674585708	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674590718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674590718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.469	1715674590718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674601740	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674601740	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4566	1715674601740	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674608754	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674608754	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4626	1715674608754	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674610759	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674610759	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4651	1715674610759	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674618775	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674618775	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631999999999996	1715674618775	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674620797	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674621796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674622802	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674635825	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674642845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674644846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674648840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674648840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674158790	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674159793	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674167794	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674167794	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4541999999999997	1715674167794	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674169815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674173809	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715674173809	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.458	1715674173809	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	106	1715674175813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715674175813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4595	1715674175813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674180823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674180823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4600999999999997	1715674180823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674185850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674186850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674195867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674200880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674209904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674220908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674220908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4611	1715674220908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674583704	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674583704	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4663000000000004	1715674583704	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674584706	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715674584706	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4663000000000004	1715674584706	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674586724	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674591734	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674592739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674594740	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674604746	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674604746	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4619	1715674604746	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674609770	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674612778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674613781	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674616786	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674629799	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674629799	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4663000000000004	1715674629799	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674638818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674638818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4669	1715674638818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674641824	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674641824	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4679	1715674641824	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674643829	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674643829	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.467	1715674643829	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674645833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674645833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4675	1715674645833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674646850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674649858	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674650859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674663871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674663871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631999999999996	1715674663871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674665876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674665876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631999999999996	1715674665876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674160796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674168813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674174826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674178836	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674179836	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674184849	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674188854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674191845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674191845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4613	1715674191845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674193850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715674193850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.46	1715674193850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674194851	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674194851	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.46	1715674194851	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674202868	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674202868	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4569	1715674202868	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674206895	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674211904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674212907	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674219920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674583720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674586710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715674586710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4671999999999996	1715674586710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674591720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674591720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.458	1715674591720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674592722	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674592722	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.458	1715674592722	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674594726	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674594726	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4583000000000004	1715674594726	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674603758	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674609757	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674609757	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4651	1715674609757	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674612763	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674612763	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4656	1715674612763	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674613765	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674613765	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4656	1715674613765	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674616771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674616771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715674616771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674624803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674629829	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674638833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674641840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674643846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674646835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674646835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4675	1715674646835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674649842	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674649842	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4684	1715674649842	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674650844	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674650844	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4684	1715674650844	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674655870	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674163785	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674163785	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4541	1715674163785	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674174811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674174811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4595	1715674174811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674178819	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674178819	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4599	1715674178819	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674179821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674179821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4599	1715674179821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674184832	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.899999999999999	1715674184832	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4599	1715674184832	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674188840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674188840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4571	1715674188840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674189857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674191861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674193863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674194866	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674206880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674206880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4568000000000003	1715674206880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674211890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674211890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4539	1715674211890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674212892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674212892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4539	1715674212892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674219906	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674219906	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4611	1715674219906	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674584720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674587727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674588729	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674589731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674595743	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674599756	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674600754	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674602758	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674605748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715674605748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4619	1715674605748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674607752	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674607752	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4626	1715674607752	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674617773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674617773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715674617773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674618790	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674623801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674628813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674633807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715674633807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4682	1715674633807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674634809	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674634809	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4682	1715674634809	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674635811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674635811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4682	1715674635811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674637831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674163801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674166805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674171821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674176830	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674182843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674192848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674192848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.46	1715674192848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674202884	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674207881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674207881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4551999999999996	1715674207881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674210888	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674210888	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4539	1715674210888	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674213894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674213894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.455	1715674213894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674215898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674215898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.455	1715674215898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674218919	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674587711	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674587711	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4671999999999996	1715674587711	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674588714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674588714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.469	1715674588714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674589716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674589716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.469	1715674589716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674595728	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674595728	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4583000000000004	1715674595728	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674598749	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674600738	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715674600738	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4566	1715674600738	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674602742	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674602742	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4566	1715674602742	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674604762	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674605766	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674607766	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674617789	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674623786	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674623786	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4644	1715674623786	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674628796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674628796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4663000000000004	1715674628796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674631803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674631803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4673000000000003	1715674631803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674633822	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674634826	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674637815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715674637815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4669	1715674637815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674647838	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715674647838	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4675	1715674647838	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674654853	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674654853	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674166791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674166791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4541999999999997	1715674166791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674170818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674172807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715674172807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.458	1715674172807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674180839	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674190843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674190843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4613	1715674190843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674192862	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674203887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674207895	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674210903	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674213908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674215912	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674221910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674221910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4611	1715674221910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674221925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674222913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.2	1715674222913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715674222913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674222927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674223915	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674223915	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715674223915	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674223929	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674224917	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674224917	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715674224917	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674224934	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674225919	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674225919	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4584	1715674225919	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674225935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674226921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674226921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4584	1715674226921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674226935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674227923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.899999999999999	1715674227923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4584	1715674227923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674227940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674228925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674228925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4581999999999997	1715674228925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674228941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674229927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715674229927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4581999999999997	1715674229927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674229944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674230930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674230930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4581999999999997	1715674230930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674230944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674231932	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715674231932	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4591999999999996	1715674231932	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674231952	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674232934	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674232934	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4591999999999996	1715674232934	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674232948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674233955	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674237958	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674240965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674246977	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674264017	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674265018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674266019	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674273034	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674274037	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674278046	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674286064	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674287064	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674291073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674293079	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674304102	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674316126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674317131	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674329156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674332165	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674336176	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674338178	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674341184	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674345195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674347197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674354199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674354199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4678	1715674354199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674356205	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715674356205	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4678	1715674356205	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674361229	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674365245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674368230	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.3	1715674368230	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4648000000000003	1715674368230	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674374242	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715674374242	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4661	1715674374242	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674375244	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674375244	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4680999999999997	1715674375244	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674377248	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674377248	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4680999999999997	1715674377248	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674388274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674388274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4656	1715674388274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674395304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674397311	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674398310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674400315	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674593724	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715674593724	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.458	1715674593724	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674596730	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674596730	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4583000000000004	1715674596730	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674597731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674597731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4616	1715674597731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674598733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674598733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4616	1715674598733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674603744	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674233936	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674233936	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4591999999999996	1715674233936	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674237944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715674237944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.46	1715674237944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674240950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674240950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4624	1715674240950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674245961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674245961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4634	1715674245961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674264001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674264001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4629000000000003	1715674264001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674265003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674265003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4624	1715674265003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674266005	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674266005	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4624	1715674266005	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674273020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674273020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4615	1715674273020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674274022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674274022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4615	1715674274022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674278030	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674278030	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4642	1715674278030	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674286048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674286048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4628	1715674286048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674287050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674287050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4628	1715674287050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674291059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674291059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4619	1715674291059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674293063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674293063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4619	1715674293063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674304086	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674304086	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4652	1715674304086	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674316112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674316112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.459	1715674316112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674317116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674317116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.459	1715674317116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674329142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715674329142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4635	1715674329142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674332150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674332150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4643	1715674332150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674336159	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674336159	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4609	1715674336159	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674338163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674338163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4609	1715674338163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674341170	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674234939	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674234939	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4395	1715674234939	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674235940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674235940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4395	1715674235940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674239963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674241967	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674243975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674247965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715674247965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4635	1715674247965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674251974	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674251974	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4649	1715674251974	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674253978	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674253978	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4643	1715674253978	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674254980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674254980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4643	1715674254980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674256984	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674256984	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4643	1715674256984	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674267007	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674267007	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4624	1715674267007	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674275043	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674283041	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674283041	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4637	1715674283041	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674285045	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674285045	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4628	1715674285045	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674290057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674290057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4594	1715674290057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674302082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674302082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4645	1715674302082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674305089	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674305089	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4652	1715674305089	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674313120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674323129	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674323129	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4625	1715674323129	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674326135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674326135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4643	1715674326135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674335157	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674335157	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4651	1715674335157	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674339166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674339166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4633000000000003	1715674339166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674344177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674344177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4648000000000003	1715674344177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674350205	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674357207	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674357207	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4685	1715674357207	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674370233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674234958	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674235954	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674238960	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674239948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674239948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.46	1715674239948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674241952	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715674241952	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4624	1715674241952	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674243957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674243957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4634	1715674243957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674245975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674247979	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674251989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674252976	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674252976	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4643	1715674252976	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674253994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674254996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674257986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674257986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4643	1715674257986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674258000	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674260006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674261009	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674268009	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674268009	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4640999999999997	1715674268009	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674269011	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715674269011	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4640999999999997	1715674269011	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674272018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674272018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4624	1715674272018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674275024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674275024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4615	1715674275024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674276026	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674276026	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4642	1715674276026	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674280035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715674280035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4646	1715674280035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674280055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674283056	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674285061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674289069	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674290073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674296084	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674298087	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674300094	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674302098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674307093	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715674307093	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4636	1715674307093	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674310099	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674310099	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4635	1715674310099	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674311101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674311101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4635	1715674311101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674311118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674312118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674236942	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674236942	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4395	1715674236942	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674242954	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674242954	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4624	1715674242954	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674244959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674244959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4634	1715674244959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674248968	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715674248968	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4635	1715674248968	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674249970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674249970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4649	1715674249970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674250972	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674250972	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4649	1715674250972	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674255982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715674255982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4643	1715674255982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674257005	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674259006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674262012	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674263012	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674270029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674271031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674277044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674279051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674281053	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674282056	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674284058	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674288067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674292077	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674294082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674295083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674297087	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674299091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674301095	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674303102	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674306104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674308110	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674309112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674314108	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674314108	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4595	1715674314108	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674318118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674318118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4614000000000003	1715674318118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674319135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674321139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674324147	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674325147	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674327153	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674328153	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674330163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674334170	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674346196	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674348200	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674355219	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674360227	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674362236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674367243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674369246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674373256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674236961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674242969	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674244975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674248983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674249985	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674250986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674256000	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674258989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715674258989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4642	1715674258989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674261996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674261996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4629000000000003	1715674261996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674262999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674262999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4629000000000003	1715674262999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674270013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674270013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4624	1715674270013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674271015	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674271015	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4624	1715674271015	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674277028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674277028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4642	1715674277028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674279033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674279033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4646	1715674279033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674281038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674281038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4646	1715674281038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674282040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715674282040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4637	1715674282040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674284043	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674284043	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4637	1715674284043	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674288052	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715674288052	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4594	1715674288052	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674292061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674292061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4619	1715674292061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674294065	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674294065	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4627	1715674294065	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674295067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674295067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4627	1715674295067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674297071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.7	1715674297071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4636	1715674297071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674299075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674299075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4636	1715674299075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674301080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674301080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4645	1715674301080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674303084	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674303084	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4652	1715674303084	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674306091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674306091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4636	1715674306091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674238946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674238946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.46	1715674238946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674246963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715674246963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4635	1715674246963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674252991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674259991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674259991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4642	1715674259991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674260994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674260994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4642	1715674260994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674267023	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674268024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674269026	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674272031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674276042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674289055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674289055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4594	1715674289055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674296070	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715674296070	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4627	1715674296070	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674298073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674298073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4636	1715674298073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674300078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674300078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4645	1715674300078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674305103	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674307109	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674310114	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674312104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674312104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4595	1715674312104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674315110	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.7	1715674315110	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.459	1715674315110	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674320122	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674320122	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4614000000000003	1715674320122	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674322126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674322126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4625	1715674322126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674331148	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674331148	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4643	1715674331148	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674333153	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674333153	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4651	1715674333153	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674337161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674337161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4609	1715674337161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674340168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674340168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4633000000000003	1715674340168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674342172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674342172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4648000000000003	1715674342172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674343174	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674343174	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4648000000000003	1715674343174	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674344191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674308095	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715674308095	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4636	1715674308095	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674309097	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674309097	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4635	1715674309097	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674313106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715674313106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4595	1715674313106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674314121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674319120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674319120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4614000000000003	1715674319120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674321124	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674321124	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4625	1715674321124	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674324131	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674324131	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4643	1715674324131	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674325133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674325133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4643	1715674325133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674327137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674327137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4635	1715674327137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674328139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674328139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4635	1715674328139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674330144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674330144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4643	1715674330144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674334155	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674334155	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4651	1715674334155	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674346181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715674346181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4624	1715674346181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674348186	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674348186	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4649	1715674348186	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674355202	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13.899999999999999	1715674355202	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4678	1715674355202	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674360213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.899999999999999	1715674360213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4692	1715674360213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674362217	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674362217	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4692	1715674362217	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674367228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674367228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4648000000000003	1715674367228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674369231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674369231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4654000000000003	1715674369231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674373240	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674373240	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4661	1715674373240	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674376246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674376246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4680999999999997	1715674376246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674378266	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674380255	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674380255	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674315124	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674320138	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674322142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674331163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674333170	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674337177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674340186	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674342190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674343190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674349188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715674349188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4649	1715674349188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674351192	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674351192	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4674	1715674351192	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674352194	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715674352194	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4674	1715674352194	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674358209	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674358209	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4685	1715674358209	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674359211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674359211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4685	1715674359211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674361215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674361215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4692	1715674361215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674363234	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674364238	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674372238	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674372238	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4661	1715674372238	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674376261	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674383263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674383263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4671	1715674383263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674387271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674387271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4656	1715674387271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674399297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674399297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.467	1715674399297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674603744	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4619	1715674603744	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674606767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674611776	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674614782	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674615785	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674620780	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715674620780	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631999999999996	1715674620780	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674625790	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674625790	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4646	1715674625790	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674626792	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.1	1715674626792	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4646	1715674626792	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674627794	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674627794	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4663000000000004	1715674627794	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674630801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674630801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4673000000000003	1715674630801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674632805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674318133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674323144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674326153	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674335172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674339181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674350190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674350190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4649	1715674350190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674353197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.8	1715674353197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4674	1715674353197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674357223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674370250	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674371251	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674381275	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674384283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674385284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674389294	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674396306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674401301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715674401301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.467	1715674401301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674610774	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674619796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674621782	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715674621782	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4644	1715674621782	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674622784	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715674622784	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4644	1715674622784	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674631818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674642827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674642827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.467	1715674642827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674644831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674644831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.467	1715674644831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674645850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674648856	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674651861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674653867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674657859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715674657859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4693	1715674657859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674658861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674658861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4693	1715674658861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674659864	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674659864	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4693	1715674659864	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674660866	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674660866	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4584	1715674660866	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674666892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674667895	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674671906	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674673910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674684937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674685936	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674687943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674694954	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674698965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674703974	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674706981	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674717990	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674341170	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4633000000000003	1715674341170	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674345179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.1	1715674345179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4624	1715674345179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674347183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674347183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4624	1715674347183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674353212	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674354217	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674356219	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674365224	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.9	1715674365224	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4656	1715674365224	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674366226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715674366226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4648000000000003	1715674366226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674368248	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674374257	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674375262	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674377264	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674395289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674395289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4685	1715674395289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674397293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674397293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4711	1715674397293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674398295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674398295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4711	1715674398295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674400299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674400299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.467	1715674400299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674619778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674619778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631999999999996	1715674619778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674624788	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674624788	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4646	1715674624788	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674625806	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674626809	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674627812	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674630816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674632821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674636828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674639834	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674640836	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674652863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674661886	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674662887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674664893	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674666878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674666878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4680999999999997	1715674666878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674672906	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674677918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674686923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674686923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.467	1715674686923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674688928	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674688928	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4658	1715674688928	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674689930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674689930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674349204	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674351206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674352210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674358224	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674359224	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674363220	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715674363220	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4656	1715674363220	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674364222	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674364222	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4656	1715674364222	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674366241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674372253	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674379253	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674379253	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4686999999999997	1715674379253	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674383278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674387287	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674632805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4673000000000003	1715674632805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674636813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674636813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4669	1715674636813	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674639820	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674639820	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4679	1715674639820	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674640822	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674640822	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4679	1715674640822	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674652848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715674652848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.467	1715674652848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674661868	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674661868	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4584	1715674661868	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674662870	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674662870	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4584	1715674662870	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674664874	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674664874	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631999999999996	1715674664874	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674665890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674672891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674672891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4603	1715674672891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674677903	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674677903	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4623000000000004	1715674677903	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674679924	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674686938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674688944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674689957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674690947	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674695957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674699965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674705980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674707985	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674708987	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674710989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674721999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674721999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.472	1715674721999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674727010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715674727010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674370233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4654000000000003	1715674370233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674371236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674371236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4654000000000003	1715674371236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674381258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715674381258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4671	1715674381258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674384265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674384265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4685	1715674384265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674385267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.9	1715674385267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4685	1715674385267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674389276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.9	1715674389276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4656	1715674389276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674396291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674396291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4711	1715674396291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674399312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674401315	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674647853	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674654867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674656874	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674668898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674669901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674674909	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674676916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674680910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715674680910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4645	1715674680910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674681912	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674681912	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4668	1715674681912	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674682929	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674691949	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674693954	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674701971	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674711978	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674711978	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4724	1715674711978	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674712996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674723001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674723001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.472	1715674723001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674724004	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674724004	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4724	1715674724004	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674725006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674725006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4724	1715674725006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674726022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674731019	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674731019	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4739	1715674731019	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674733024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674733024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4781	1715674733024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674743048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674743048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4661999999999997	1715674743048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674745065	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674747074	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674378251	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715674378251	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4686999999999997	1715674378251	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674379269	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674380271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674382279	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674386285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674390278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715674390278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4680999999999997	1715674390278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674391280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674391280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4680999999999997	1715674391280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674392282	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674392282	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4680999999999997	1715674392282	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674393284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674393284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4685	1715674393284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674394286	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674394286	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4685	1715674394286	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4684	1715674648840	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674651846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674651846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.467	1715674651846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674653850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674653850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.467	1715674653850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674655855	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674655855	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4683	1715674655855	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674657874	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674658877	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674659878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674660882	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674667880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715674667880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4680999999999997	1715674667880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674671889	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674671889	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4704	1715674671889	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674673893	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674673893	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4603	1715674673893	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674684920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674684920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.467	1715674684920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674685921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674685921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.467	1715674685921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674687925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674687925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4658	1715674687925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674694941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674694941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4676	1715674694941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674698949	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715674698949	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4666	1715674698949	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674702958	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674702958	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.471	1715674702958	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674706967	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4686999999999997	1715674380255	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674382260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674382260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4671	1715674382260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674386270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674386270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4685	1715674386270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674388289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674390293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674391294	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674392297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674393298	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674394302	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674402303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674402303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.468	1715674402303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674402321	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674403305	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674403305	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.468	1715674403305	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674403320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674404308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.9	1715674404308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.468	1715674404308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674404325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674405310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.9	1715674405310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4427	1715674405310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674405325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674406311	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674406311	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4427	1715674406311	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674406329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674407313	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.9	1715674407313	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4427	1715674407313	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674407327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674408316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674408316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.446	1715674408316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674408331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674409318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674409318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.446	1715674409318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674409333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674410320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715674410320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.446	1715674410320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674410335	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674411321	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674411321	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4516	1715674411321	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674411337	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674412324	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674412324	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4516	1715674412324	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674412338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	99	1715674413326	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.4	1715674413326	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4516	1715674413326	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674413340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674414328	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.3	1715674414328	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674414328	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674414343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674415344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674423363	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674425351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6000000000000005	1715674425351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4537	1715674425351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674427355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715674427355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4528000000000003	1715674427355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674433368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674433368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4535	1715674433368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674435373	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.9	1715674435373	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4547	1715674435373	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674437393	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674446412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674447415	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674455417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715674455417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4583000000000004	1715674455417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674460435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674460435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4535	1715674460435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674468452	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674468452	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4604	1715674468452	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674473462	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674473462	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4596	1715674473462	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674481479	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674481479	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715674481479	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674482481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	14.1	1715674482481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715674482481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674483497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674488509	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674493522	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674496512	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674496512	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4606	1715674496512	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674503527	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715674503527	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4585	1715674503527	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674508553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674516568	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674520577	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674523569	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715674523569	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4605	1715674523569	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674531587	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715674531587	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4551	1715674531587	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674536599	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674536599	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.459	1715674536599	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674538620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674541625	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674545618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674545618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631	1715674545618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674550647	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674555656	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674415330	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674415330	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674415330	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674423346	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674423346	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4537	1715674423346	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674424349	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674424349	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4537	1715674424349	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674425366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674427371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674433386	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674435388	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674441400	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674447399	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674447399	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4591	1715674447399	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674450406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674450406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4584	1715674450406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674459432	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674459432	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4535	1715674459432	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674460450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674468468	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674473479	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674481494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674482498	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674488494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715674488494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4618	1715674488494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674493506	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674493506	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4604	1715674493506	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674495529	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674501523	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674501523	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4585	1715674501523	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674503543	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674516554	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674516554	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4583000000000004	1715674516554	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674520563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674520563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4556	1715674520563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674522583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674523583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674531601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674536616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674541610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715674541610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631999999999996	1715674541610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674542612	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674542612	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631999999999996	1715674542612	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674550631	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674550631	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.465	1715674550631	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674555641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674555641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4644	1715674555641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674556643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674556643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4644	1715674556643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674416331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715674416331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4514	1715674416331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674424364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674428372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674430379	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674431379	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674442389	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.8	1715674442389	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4545	1715674442389	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674443391	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715674443391	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4545	1715674443391	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674445411	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674449419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674451408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674451408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4584	1715674451408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674456426	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674456426	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4471999999999996	1715674456426	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674458430	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674458430	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4471999999999996	1715674458430	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674459445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674462455	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674469454	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715674469454	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4604	1715674469454	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674475466	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674475466	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4591999999999996	1715674475466	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674477470	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674477470	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4608000000000003	1715674477470	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674480477	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674480477	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715674480477	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674487491	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674487491	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4618	1715674487491	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674489511	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674494525	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674497514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674497514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4606	1715674497514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674499518	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674499518	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4605	1715674499518	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674500521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674500521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4605	1715674500521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674502538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674504546	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674505547	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674507551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674509540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674509540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4628	1715674509540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674510541	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674510541	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4608000000000003	1715674510541	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674514550	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715674514550	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674416346	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674428358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674428358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4528000000000003	1715674428358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674430362	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674430362	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4541999999999997	1715674430362	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674431364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674431364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4541999999999997	1715674431364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674440385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674440385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4573	1715674440385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674442403	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674443407	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674449404	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674449404	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4591	1715674449404	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674450421	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674451426	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674456441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674458446	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674462439	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674462439	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715674462439	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674463460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674469469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674475486	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674477488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674480494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674489496	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674489496	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4585	1715674489496	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674492519	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674495510	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674495510	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4606	1715674495510	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674497532	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674499533	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674500534	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674504529	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.5	1715674504529	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4606999999999997	1715674504529	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674505531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674505531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4606999999999997	1715674505531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674507536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715674507536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4628	1715674507536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674508538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674508538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4628	1715674508538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674509557	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674510555	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674514566	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674515571	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674518574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674526576	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674526576	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4617	1715674526576	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674529582	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674529582	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4526	1715674529582	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674533592	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674417333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.9	1715674417333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.454	1715674417333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674420339	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674420339	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4519	1715674420339	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674432366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674432366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4535	1715674432366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674436375	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674436375	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4547	1715674436375	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674437377	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715674437377	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4547	1715674437377	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674438395	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674444393	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674444393	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4559	1715674444393	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674453428	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674457443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674461452	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674464443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674464443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715674464443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674465446	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715674465446	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4602	1715674465446	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674466448	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674466448	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4602	1715674466448	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674467450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674467450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4602	1715674467450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674471458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674471458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4596	1715674471458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674483483	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674483483	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4619	1715674483483	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674484503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674490499	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674490499	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4585	1715674490499	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674491501	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674491501	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4585	1715674491501	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674492504	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674492504	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4604	1715674492504	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674496529	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674498531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674502525	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674502525	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4585	1715674502525	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674506549	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674513548	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674513548	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4564	1715674513548	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674522567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674522567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4605	1715674522567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674527596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674534594	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674417348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674420357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674432382	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674436389	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674438380	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674438380	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4573	1715674438380	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674439397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674444408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674457428	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715674457428	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4471999999999996	1715674457428	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674461437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674461437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4535	1715674461437	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674463441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674463441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4593000000000003	1715674463441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674464460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674465460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674466461	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674467467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674471474	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674484485	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674484485	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4619	1715674484485	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674487507	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674490517	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674491516	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674494508	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.6	1715674494508	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4604	1715674494508	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	106	1715674498516	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	14.1	1715674498516	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4605	1715674498516	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674501538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674506534	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674506534	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4606999999999997	1715674506534	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674512562	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674513563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674527578	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674527578	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4617	1715674527578	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674529597	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674534620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674539606	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674539606	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4616	1715674539606	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674544631	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674549644	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674554656	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674562656	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674562656	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4656	1715674562656	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674569687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674576688	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674576688	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4682	1715674576688	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674577691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674577691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4682	1715674577691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674578693	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674578693	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674418335	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715674418335	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.454	1715674418335	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674419337	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674419337	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.454	1715674419337	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674421342	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674421342	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4519	1715674421342	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674422344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674422344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4519	1715674422344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674426353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.899999999999999	1715674426353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4528000000000003	1715674426353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674429360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.9	1715674429360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4541999999999997	1715674429360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674434370	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715674434370	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4535	1715674434370	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674439382	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.3	1715674439382	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4573	1715674439382	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674441387	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.6	1715674441387	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4545	1715674441387	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674446397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674446397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4559	1715674446397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674448418	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674452424	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674454415	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674454415	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4583000000000004	1715674454415	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674455435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674470472	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674472476	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674474481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674476484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674478491	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674479494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674485503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674486503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674511558	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674517557	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674517557	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4583000000000004	1715674517557	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674519561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674519561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4556	1715674519561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674521582	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674524586	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674525590	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674528596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674530600	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674540608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.1	1715674540608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631999999999996	1715674540608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674543614	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674543614	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631	1715674543614	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674544616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.1	1715674544616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674418351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674419357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674421357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674422361	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674426367	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674429376	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674434389	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674440406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674445395	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715674445395	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4559	1715674445395	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674448401	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715674448401	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4591	1715674448401	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674452410	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715674452410	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4584	1715674452410	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674453412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674453412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4583000000000004	1715674453412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674454436	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674470456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674470456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4604	1715674470456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674472460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674472460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4596	1715674472460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674474464	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674474464	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4591999999999996	1715674474464	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674476468	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674476468	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4591999999999996	1715674476468	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674478474	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674478474	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4608000000000003	1715674478474	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674479475	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674479475	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4608000000000003	1715674479475	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674485487	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715674485487	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4619	1715674485487	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674486490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674486490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4618	1715674486490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674511543	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674511543	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4608000000000003	1715674511543	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674512546	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715674512546	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4608000000000003	1715674512546	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674517573	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674521565	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674521565	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4556	1715674521565	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674524571	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.1	1715674524571	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4605	1715674524571	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674525574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674525574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4617	1715674525574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674528580	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.6	1715674528580	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4526	1715674528580	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4564	1715674514550	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674515552	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674515552	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4564	1715674515552	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674518559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674518559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4583000000000004	1715674518559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674519579	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674526590	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674532590	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674532590	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4551	1715674532590	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674533607	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674535611	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674537616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674546620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715674546620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4651	1715674546620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674548626	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674548626	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4651	1715674548626	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674563658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674563658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4656	1715674563658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674564660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715674564660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4603	1715674564660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674565664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674565664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4603	1715674565664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674567682	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674568687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674570691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4683	1715674654853	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674656857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674656857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4683	1715674656857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674668882	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.1	1715674668882	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4680999999999997	1715674668882	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674669885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674669885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4704	1715674669885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674674896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715674674896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4603	1715674674896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674676900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674676900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4623000000000004	1715674676900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674679907	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674679907	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4645	1715674679907	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674680926	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674682914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674682914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4668	1715674682914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674691935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674691935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4666	1715674691935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674693939	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674693939	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4676	1715674693939	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674701956	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674701956	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674530585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674530585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4526	1715674530585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674532605	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674540621	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674543631	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674545634	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674547638	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674551648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674552649	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674553653	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674557661	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674558662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674573699	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674663887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674670887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674670887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4704	1715674670887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674675898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674675898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4623000000000004	1715674675898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674678905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674678905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4645	1715674678905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674681926	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674683935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674692952	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674696959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674697963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674700967	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674703960	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674703960	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.471	1715674703960	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674709973	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674709973	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4726	1715674709973	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674712980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674712980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4724	1715674712980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674713999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674714999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674719995	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674719995	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4698	1715674719995	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674725020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674732036	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	99	1715674742046	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674742046	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4661999999999997	1715674742046	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674745051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674745051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4608000000000003	1715674745051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674748076	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674749076	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4675	1715674750063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674750077	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674754072	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715674754072	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.469	1715674754072	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674754087	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674755089	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674759083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674759083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4714	1715674759083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674759097	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674533592	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4551	1715674533592	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674535596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674535596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.459	1715674535596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674537601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674537601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4616	1715674537601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674539620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674546634	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674548640	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674563672	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674564678	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674565678	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674568671	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11	1715674568671	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4634	1715674568671	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674570675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674570675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4642	1715674570675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674670905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674675912	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674678921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674683917	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715674683917	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4668	1715674683917	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674692937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674692937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4666	1715674692937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674696945	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674696945	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4666	1715674696945	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674697947	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674697947	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4666	1715674697947	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674700953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674700953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4686	1715674700953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674702976	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674704980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674709989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674713982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674713982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4724	1715674713982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674714983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674714983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4726999999999997	1715674714983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674715986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674715986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4726999999999997	1715674715986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674720009	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674729014	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.1	1715674729014	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4739	1715674729014	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674736045	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674742063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674748057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674748057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.465	1715674748057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674749061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674749061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.465	1715674749061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674750063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674750063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715674534594	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.459	1715674534594	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674538604	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674538604	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4616	1715674538604	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674542626	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674549628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674549628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.465	1715674549628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674554639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674554639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4639	1715674554639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674559650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674559650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4635	1715674559650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674569673	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674569673	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4634	1715674569673	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674573682	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674573682	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4658	1715674573682	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674576704	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674577710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674578708	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4658	1715674689930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674690933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674690933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4666	1715674690933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674695943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674695943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4676	1715674695943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674699951	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674699951	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4686	1715674699951	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674705964	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715674705964	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4731	1715674705964	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674707969	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674707969	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4731	1715674707969	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674708971	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674708971	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4726	1715674708971	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674710975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674710975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4726	1715674710975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674717003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674722013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674728012	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674728012	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4735	1715674728012	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674730016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674730016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4739	1715674730016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674732021	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674732021	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4781	1715674732021	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674737049	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674740040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715674740040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4666	1715674740040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674741059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674744063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674751079	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4631	1715674544616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674547622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674547622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4651	1715674547622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674551633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674551633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.465	1715674551633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674552635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.1	1715674552635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4639	1715674552635	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674553637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674553637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4639	1715674553637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674557645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.3	1715674557645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4644	1715674557645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674558648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674558648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4635	1715674558648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674562672	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4686	1715674701956	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674704962	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715674704962	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.471	1715674704962	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674711992	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674716988	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674716988	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4726999999999997	1715674716988	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674723018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674724019	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674726008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674726008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4724	1715674726008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674728028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674731036	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674733041	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674743062	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674747056	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715674747056	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.465	1715674747056	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674751065	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674751065	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4675	1715674751065	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674753070	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674753070	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.469	1715674753070	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674755075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674755075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.469	1715674755075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674756092	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674757097	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674760099	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674765110	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674766113	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674767114	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674768118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674769121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674772111	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674772111	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4696	1715674772111	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674773113	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674773113	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4696	1715674773113	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674774115	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674556657	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674560652	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.6	1715674560652	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4635	1715674560652	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674561654	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674561654	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4656	1715674561654	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674566666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674566666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4603	1715674566666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674567668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715674567668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4634	1715674567668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674571693	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674572694	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674574699	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674575701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674579711	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674580712	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715674706967	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4731	1715674706967	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674716003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674718004	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674719008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674721013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674734027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674734027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4781	1715674734027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674735029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674735029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4664	1715674735029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674736031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674736031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4664	1715674736031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674739038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674739038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4666	1715674739038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674740055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674746068	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674756077	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674756077	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.47	1715674756077	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674757079	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715674757079	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.47	1715674757079	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674758096	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674762103	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674767100	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674767100	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4697	1715674767100	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674768102	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715674768102	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4699	1715674768102	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674773128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674774115	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4716	1715674774115	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674774129	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674778124	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674778124	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4735	1715674778124	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674779126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674779126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4735	1715674779126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674779141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674559665	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674560667	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674561668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674566681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674571677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674571677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4642	1715674571677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674572680	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715674572680	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4642	1715674572680	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674574684	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8	1715674574684	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4658	1715674574684	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674575686	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715674575686	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4658	1715674575686	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674579696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674579696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4677	1715674579696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674580698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674580698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4677	1715674580698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715674717990	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4698	1715674717990	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674718993	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674718993	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4698	1715674718993	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674720997	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674720997	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.472	1715674720997	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674727024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674734043	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674735043	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674738050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674739052	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674746053	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715674746053	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4608000000000003	1715674746053	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674752067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674752067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4675	1715674752067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674758081	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.1	1715674758081	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.47	1715674758081	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674761087	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674761087	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4714	1715674761087	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674762090	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674762090	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4705	1715674762090	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674763106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674764107	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674771109	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674771109	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4696	1715674771109	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674775117	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674775117	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4716	1715674775117	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674776119	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674776119	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4716	1715674776119	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674777121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674777121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4735	1715674777121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4682	1715674578693	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4735	1715674727010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674729033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674730032	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674737033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674737033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4664	1715674737033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674738035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715674738035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4666	1715674738035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674741044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674741044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4661999999999997	1715674741044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674744050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674744050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4608000000000003	1715674744050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674752084	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674753084	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674760085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674760085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4714	1715674760085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674761101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674763091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674763091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4705	1715674763091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674764093	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715674764093	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4705	1715674764093	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674765096	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674765096	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4697	1715674765096	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674766098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715674766098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4697	1715674766098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674769104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674769104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4699	1715674769104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674770107	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.5	1715674770107	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4699	1715674770107	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674770121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674771127	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674772125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674775132	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674776134	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674777138	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674778142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674780128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715674780128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4724	1715674780128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674780142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674781130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674781130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4724	1715674781130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674781144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674782132	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715674782132	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4724	1715674782132	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674782147	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674783134	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674783134	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4756	1715674783134	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674783149	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674784136	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674784136	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4756	1715674784136	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674786140	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674786140	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4738	1715674786140	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674789162	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674796179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674809191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674809191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4683	1715674809191	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674812197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674812197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4701999999999997	1715674812197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674813199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674813199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4701	1715674813199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674816206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674816206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4657	1715674816206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675302268	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715675302268	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5038	1715675302268	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675303270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675303270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5038	1715675303270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675306276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715675306276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.502	1715675306276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675309283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715675309283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.502	1715675309283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675319304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715675319304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.503	1715675319304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675320326	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675326336	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675327339	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675328338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675329341	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675331343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675340366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675342367	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675351372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715675351372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5029	1715675351372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675352374	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715675352374	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5029	1715675352374	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675353377	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675353377	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5039000000000002	1715675353377	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675356398	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675407504	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675412516	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675415524	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675421538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675431542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675431542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5185999999999997	1715675431542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675433547	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675433547	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5185999999999997	1715675433547	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675436553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715675436553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674784152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674789147	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674789147	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4755	1715674789147	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674796163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715674796163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.475	1715674796163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674802190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674809206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674812211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674813213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674816220	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675302284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675303285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675306292	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675316298	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675316298	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5011	1715675316298	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675320307	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675320307	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5034	1715675320307	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675326320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675326320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4915	1715675326320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675327322	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675327322	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4915	1715675327322	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675328323	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675328323	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4915	1715675328323	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675329325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675329325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4971	1715675329325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675331330	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675331330	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4971	1715675331330	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675333334	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675333334	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5003	1715675333334	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675341366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675346375	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675351386	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675352390	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675356383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675356383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5055	1715675356383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675361394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675361394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5046	1715675361394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5105999999999997	1715675426531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675429538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.6	1715675429538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5096999999999996	1715675429538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675437572	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675439577	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675448579	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715675448579	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5179	1715675448579	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675452588	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715675452588	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5197	1715675452588	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675459602	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715675459602	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5188	1715675459602	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674785138	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674785138	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4756	1715674785138	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674787142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674787142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4738	1715674787142	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674795175	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674801173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674801173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4736	1715674801173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674817208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674817208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4657	1715674817208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674818210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674818210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4657	1715674818210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675304272	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675304272	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5038	1715675304272	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675305274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675305274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.502	1715675305274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675309298	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675315296	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675315296	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5011	1715675315296	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675317300	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715675317300	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.503	1715675317300	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675318302	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675318302	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.503	1715675318302	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675321309	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675321309	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5034	1715675321309	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675325317	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715675325317	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5042	1715675325317	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675330344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675338344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715675338344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4963	1715675338344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675339346	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675339346	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4963	1715675339346	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675343353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675343353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4993000000000003	1715675343353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675344356	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715675344356	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5017	1715675344356	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675345358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675345358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5017	1715675345358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675346360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715675346360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5017	1715675346360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675349381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675350385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675354396	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675359409	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675360408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5096999999999996	1715675428536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675430540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674785152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674795161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.1	1715674795161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.475	1715674795161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674797179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674801187	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674817223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674818225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675304288	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675305289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675311302	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675315312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675317314	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675318319	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675321325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675325333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675333348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675338360	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675339363	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675343369	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675344371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675345374	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675349367	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715675349367	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5031	1715675349367	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675350369	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.6	1715675350369	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5029	1715675350369	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675354379	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675354379	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5039000000000002	1715675354379	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675359390	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675359390	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5046	1715675359390	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675360392	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715675360392	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5046	1715675360392	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715675430540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5096999999999996	1715675430540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675432544	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715675432544	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5185999999999997	1715675432544	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675434549	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715675434549	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5181	1715675434549	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675435551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675435551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5181	1715675435551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675436570	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675444584	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675446593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675450599	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675454607	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675455609	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675462624	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675463626	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675465615	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715675465615	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5153000000000003	1715675465615	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675467620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715675467620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5176	1715675467620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675471643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675474651	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675475653	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674786155	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674788160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674790162	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674791168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674799170	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674799170	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4726	1715674799170	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674802176	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.800000000000001	1715674802176	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4736	1715674802176	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674806184	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674806184	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.462	1715674806184	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674807187	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674807187	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4683	1715674807187	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674814201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674814201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4701	1715674814201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674819211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674819211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4725	1715674819211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674820213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674820213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4725	1715674820213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674821230	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675307278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675307278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.502	1715675307278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675308281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675308281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.502	1715675308281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675310285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715675310285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.502	1715675310285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675323313	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675323313	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5042	1715675323313	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675330327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675330327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4971	1715675330327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675334353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675336354	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675342351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.6	1715675342351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4993000000000003	1715675342351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675353395	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675358406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5181	1715675436553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675440578	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675443568	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13	1715675443568	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5171	1715675443568	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675445588	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675449596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675453607	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675460618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675462608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.2	1715675462608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.52	1715675462608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675469638	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675472630	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715675472630	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5051	1715675472630	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674787159	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674792167	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674793171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674797165	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674797165	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.475	1715674797165	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674798183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674800188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674803193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674804195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674808189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674808189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4683	1715674808189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674810193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674810193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4701999999999997	1715674810193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674811195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674811195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4701999999999997	1715674811195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674815204	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674815204	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4701	1715674815204	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674820227	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675307294	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675308296	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675310302	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675323328	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675334336	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675334336	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5003	1715675334336	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675336340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715675336340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5031	1715675336340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675340348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.1	1715675340348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4963	1715675340348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675348365	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715675348365	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5031	1715675348365	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675358388	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675358388	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5055	1715675358388	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675455593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715675455593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5195	1715675455593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675457614	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675463611	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.2	1715675463611	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.52	1715675463611	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675464613	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715675464613	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5153000000000003	1715675464613	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675466617	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675466617	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5153000000000003	1715675466617	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675467633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675473633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675473633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5103	1715675473633	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675477660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675478660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675479648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675479648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5164	1715675479648	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674788144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715674788144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4738	1715674788144	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674790149	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715674790149	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4755	1715674790149	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674791151	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674791151	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4755	1715674791151	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674794174	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674799183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674805198	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674806201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674807201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674814215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674819227	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674821215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674821215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4725	1715674821215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675311287	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.1	1715675311287	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5033000000000003	1715675311287	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675312306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675313309	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675314310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675319320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675322326	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675324333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675332348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675335353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675337357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675347362	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.1	1715675347362	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5031	1715675347362	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675348379	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675355397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675357401	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715675456596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5195	1715675456596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675458600	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675458600	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5188	1715675458600	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675460604	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.299999999999999	1715675460604	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5188	1715675460604	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675468622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715675468622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5176	1715675468622	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675473650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675476658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675479662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675482653	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.6	1715675482653	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5119000000000002	1715675482653	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675484672	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675485674	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675486662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675486662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5151	1715675486662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675487664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675487664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5151	1715675487664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675488666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715675488666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674792153	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715674792153	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4715	1715674792153	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674793157	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674793157	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4715	1715674793157	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674794159	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674794159	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4715	1715674794159	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674798168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674798168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4726	1715674798168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674800171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.4	1715674800171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4726	1715674800171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674803178	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674803178	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4736	1715674803178	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674804180	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715674804180	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.462	1715674804180	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674805182	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674805182	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.462	1715674805182	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674808205	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674810207	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674811211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674815220	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674822218	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715674822218	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4745	1715674822218	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674822233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674823220	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674823220	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4745	1715674823220	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674823237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674824221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715674824221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4745	1715674824221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674824236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674825223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715674825223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4762	1715674825223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674825243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674826225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674826225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4762	1715674826225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674826241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674827228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674827228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4762	1715674827228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674827242	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674828230	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674828230	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4756	1715674828230	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674828246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674829232	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.2	1715674829232	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4756	1715674829232	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674829246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674830234	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674830234	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4756	1715674830234	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674830251	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674831236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674831236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4736	1715674831236	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674834260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674838267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674853304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674854302	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674858309	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674866327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674870337	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674875349	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674881345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674881345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4755	1715674881345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674882349	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674882349	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4805	1715674882349	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674885356	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674885356	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4781999999999997	1715674885356	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674886358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674886358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4781999999999997	1715674886358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674894375	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715674894375	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4802	1715674894375	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674895377	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674895377	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4802	1715674895377	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674898402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674902410	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674905415	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674918447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674922440	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674922440	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4851	1715674922440	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674929473	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674937473	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674937473	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4845	1715674937473	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674944503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674946507	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674952506	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674952506	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4854000000000003	1715674952506	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674962528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715674962528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4867	1715674962528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674966551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674970559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674980586	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674992607	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674994598	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715674994598	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4848000000000003	1715674994598	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674995600	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.8	1715674995600	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4848000000000003	1715674995600	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675005620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675005620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4864	1715675005620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675010630	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715675010630	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4873000000000003	1715675010630	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674831252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674838251	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674838251	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4758	1715674838251	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674853284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674853284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.476	1715674853284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674854286	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674854286	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.476	1715674854286	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674858294	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674858294	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4775	1715674858294	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674866312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.6	1715674866312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4773	1715674866312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674870322	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674870322	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4747	1715674870322	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674875333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674875333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4776	1715674875333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674877338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674877338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4701	1715674877338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674881361	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674882363	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674885374	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674889382	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674894394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674895394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674902394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674902394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4831	1715674902394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674905402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674905402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4845	1715674905402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674918431	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674918431	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4831999999999996	1715674918431	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674920450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674922457	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674930472	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674937489	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674946492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715674946492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4871	1715674946492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674948514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674960541	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674966536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674966536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4838	1715674966536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674967556	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674974569	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715674992593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674992593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4829	1715674992593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674993595	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674993595	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4848000000000003	1715674993595	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674994611	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674995615	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675005634	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675010645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674832238	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674832238	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4736	1715674832238	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674833241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674833241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4736	1715674833241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674839253	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715674839253	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4758	1715674839253	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674842260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715674842260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4686999999999997	1715674842260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674848273	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674848273	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4743000000000004	1715674848273	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674849275	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674849275	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4762	1715674849275	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674855288	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674855288	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4764	1715674855288	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674860299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674860299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4775	1715674860299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674864326	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674867330	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674868332	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674872344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674873343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674874345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674880358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674887377	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674888378	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674890367	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674890367	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4771	1715674890367	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674891384	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674896379	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674896379	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4802	1715674896379	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674901392	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674901392	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4831	1715674901392	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674910412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715674910412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4839	1715674910412	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674912416	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674912416	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4848000000000003	1715674912416	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674913435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674916442	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674920436	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674920436	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4831999999999996	1715674920436	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674921452	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674923456	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674926462	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674931479	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674933480	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674934482	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674944488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715674944488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4836	1715674944488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674947511	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674832256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674833259	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674839269	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674842277	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674848290	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674849292	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674855302	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674860316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674867315	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674867315	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4765	1715674867315	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674868317	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674868317	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4765	1715674868317	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674872326	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674872326	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4747	1715674872326	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674873329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674873329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4776	1715674873329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674874331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674874331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4776	1715674874331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674880343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674880343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4755	1715674880343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674887361	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674887361	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4781999999999997	1715674887361	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674888363	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715674888363	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4771	1715674888363	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674889365	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674889365	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4771	1715674889365	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674890381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674893373	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715674893373	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4773	1715674893373	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674896394	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674901408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674910427	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674912435	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674916427	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674916427	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4794	1715674916427	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674917429	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715674917429	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4794	1715674917429	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674921438	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674921438	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4851	1715674921438	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674923441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674923441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4851	1715674923441	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674926447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674926447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4837	1715674926447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674931461	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674931461	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4836	1715674931461	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674933465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674933465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4849	1715674933465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674834243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674834243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4766999999999997	1715674834243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674836261	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674843284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674844280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674845283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674846283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674847285	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674852301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674861316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674862320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674869320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674869320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4765	1715674869320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674871324	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674871324	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4747	1715674871324	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674876336	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674876336	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4701	1715674876336	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674877355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674878356	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674892371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674892371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4773	1715674892371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674893388	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674899402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674903414	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674904416	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674907422	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674911414	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674911414	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4839	1715674911414	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674914421	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674914421	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4848000000000003	1715674914421	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674915440	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674924458	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674925460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674928453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674928453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4821999999999997	1715674928453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674930459	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674930459	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4836	1715674930459	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674935483	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674936487	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674938490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674941496	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674945505	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674949498	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674949498	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4864	1715674949498	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674950500	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674950500	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4864	1715674950500	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674954510	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674954510	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4869	1715674954510	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674955512	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715674955512	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4869	1715674955512	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674957516	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674835245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674835245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4766999999999997	1715674835245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674837249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674837249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4758	1715674837249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674840256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674840256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4686999999999997	1715674840256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674841258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674841258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4686999999999997	1715674841258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674850277	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674850277	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4762	1715674850277	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674851280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674851280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4762	1715674851280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674856290	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674856290	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4764	1715674856290	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674857292	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674857292	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4764	1715674857292	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674859297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674859297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4775	1715674859297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674863306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674863306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4766999999999997	1715674863306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674865310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674865310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4773	1715674865310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674879341	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.7	1715674879341	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4755	1715674879341	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674883351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674883351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4805	1715674883351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674884368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674891369	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.2	1715674891369	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4773	1715674891369	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674897399	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674900389	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715674900389	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4831	1715674900389	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674906404	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674906404	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4838	1715674906404	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674908408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674908408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4838	1715674908408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674909425	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674915425	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715674915425	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4794	1715674915425	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674919433	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715674919433	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4831999999999996	1715674919433	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674927450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674927450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4821999999999997	1715674927450	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674932463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674835259	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674837263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674840273	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674841272	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674850292	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674851294	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674856304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674857307	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674859316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674863324	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674865325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674879358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674883369	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674886374	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674897383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715674897383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4811	1715674897383	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674898385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674898385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4811	1715674898385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674900403	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674906419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674909410	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674909410	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4839	1715674909410	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674913419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674913419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4848000000000003	1715674913419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674917443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674919451	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674929457	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674929457	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4821999999999997	1715674929457	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674932479	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674939494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674940494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674943486	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674943486	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4836	1715674943486	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674951502	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674951502	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4854000000000003	1715674951502	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674952520	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674961539	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674968557	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674969560	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674972549	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715674972549	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4835	1715674972549	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674976575	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674977574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674979583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674988585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715674988585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4853	1715674988585	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674989587	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674989587	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4853	1715674989587	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674990589	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674990589	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4829	1715674990589	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674993610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674996615	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675004618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675004618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674836247	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674836247	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4766999999999997	1715674836247	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674843263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674843263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4731	1715674843263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674844265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	4	1715674844265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4731	1715674844265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674845267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715674845267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4731	1715674845267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674846269	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674846269	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4743000000000004	1715674846269	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674847271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674847271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4743000000000004	1715674847271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674852281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674852281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.476	1715674852281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674861302	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674861302	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4766999999999997	1715674861302	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674862304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674862304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4766999999999997	1715674862304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674864308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674864308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4773	1715674864308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674869334	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674871338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674876352	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674878340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.2	1715674878340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4701	1715674878340	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674884353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674884353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4805	1715674884353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674892386	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674899387	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674899387	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4811	1715674899387	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674903397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674903397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4845	1715674903397	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674904399	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674904399	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4845	1715674904399	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674907406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674907406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4838	1715674907406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674908423	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674911429	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674914438	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674924443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674924443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4837	1715674924443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674925445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674925445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4837	1715674925445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674927465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674928469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674935469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674932463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4836	1715674932463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674939478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674939478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4813	1715674939478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	99	1715674940480	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674940480	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4813	1715674940480	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674942484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674942484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4836	1715674942484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674943503	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674951516	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674956514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674956514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4869	1715674956514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674968540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674968540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4838	1715674968540	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674969542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674969542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4842	1715674969542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674970545	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674970545	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4842	1715674970545	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674976557	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715674976557	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4846	1715674976557	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674977560	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674977560	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4846	1715674977560	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674979564	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674979564	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4835	1715674979564	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674980567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674980567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4835	1715674980567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674988603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674989603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674991606	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674996601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715674996601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4839	1715674996601	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674999608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715674999608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.482	1715674999608	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675004632	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675008639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675009643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675011646	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675012652	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675016658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675018663	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675022673	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675023673	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675027682	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675028683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675029684	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675046707	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.7	1715675046707	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4892	1715675046707	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675049713	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675049713	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4898000000000002	1715675049713	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674934467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674934467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4849	1715674934467	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674942505	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674947494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674947494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4871	1715674947494	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674953508	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674953508	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4854000000000003	1715674953508	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674955529	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674961526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674961526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4867	1715674961526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674964547	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674971547	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674971547	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4842	1715674971547	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674972564	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674981584	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674983589	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674986580	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674986580	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4838	1715674986580	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674997604	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715674997604	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4839	1715674997604	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674998606	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674998606	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4839	1715674998606	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675002613	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715675002613	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4842	1715675002613	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675003616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675003616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4842	1715675003616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675007623	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675007623	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4864	1715675007623	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675020651	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.8	1715675020651	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4886999999999997	1715675020651	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675021654	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675021654	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4886999999999997	1715675021654	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675033679	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675033679	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4907	1715675033679	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675034681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675034681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4907	1715675034681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675041710	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675042713	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675047709	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715675047709	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4898000000000002	1715675047709	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675048725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675053736	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675059750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675312289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715675312289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5033000000000003	1715675312289	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675313292	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.1	1715675313292	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674935469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4849	1715674935469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674936471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715674936471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4845	1715674936471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674938476	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674938476	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4845	1715674938476	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674941482	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674941482	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4813	1715674941482	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674945490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715674945490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4871	1715674945490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674948497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674948497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4864	1715674948497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674949515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674950514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674954526	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674956530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674957530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674958534	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674959537	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674963530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715674963530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.486	1715674963530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715674965534	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674965534	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.486	1715674965534	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674973551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715674973551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4835	1715674973551	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674974553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715674974553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4835	1715674974553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674975570	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674978577	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674982588	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674984594	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674987582	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.7	1715674987582	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4853	1715674987582	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674990604	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674999624	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675000627	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675001627	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675006636	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675024660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675024660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4885	1715675024660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675025662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675025662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4885	1715675025662	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675026664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715675026664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4877	1715675026664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675030687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675035698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675036699	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675037703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675039706	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675043715	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675045705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674953522	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	106	1715674960523	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	14.299999999999999	1715674960523	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4867	1715674960523	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674964532	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.7	1715674964532	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.486	1715674964532	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674967538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.2	1715674967538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4838	1715674967538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674971563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674981569	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674981569	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4853	1715674981569	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674983574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715674983574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4853	1715674983574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674985578	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715674985578	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4838	1715674985578	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674986597	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674997620	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674998623	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675002629	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675003631	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675007639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675020668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675021667	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675033694	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675034696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675042698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675042698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4894000000000003	1715675042698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675044718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675047724	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675051732	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675059735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675059735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4880999999999998	1715675059735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5033000000000003	1715675313292	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675314294	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675314294	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5011	1715675314294	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675316313	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675322311	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675322311	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5034	1715675322311	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675324315	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715675324315	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5042	1715675324315	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675332332	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.8	1715675332332	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5003	1715675332332	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675335338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.1	1715675335338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5031	1715675335338	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675337342	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675337342	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5031	1715675337342	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675341350	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715675341350	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4993000000000003	1715675341350	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675347378	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675355381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715674957516	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4853	1715674957516	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715674958519	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.7	1715674958519	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4853	1715674958519	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674959521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.5	1715674959521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4853	1715674959521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674962543	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674963547	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674965549	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674973567	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715674975555	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715674975555	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4846	1715674975555	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674978562	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674978562	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4835	1715674978562	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674982571	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.2	1715674982571	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4853	1715674982571	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715674984576	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715674984576	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4838	1715674984576	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674985593	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715674987598	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715674991591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715674991591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4829	1715674991591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675000610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675000610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.482	1715675000610	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675001611	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.299999999999999	1715675001611	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.482	1715675001611	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675006621	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675006621	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4864	1715675006621	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675019649	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675019649	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4876	1715675019649	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675024676	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675025677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675030672	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.2	1715675030672	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4871999999999996	1715675030672	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675035683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675035683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4905999999999997	1715675035683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675036685	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675036685	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4905999999999997	1715675036685	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675037687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675037687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4905999999999997	1715675037687	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675039692	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715675039692	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4892	1715675039692	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675043701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675043701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4894000000000003	1715675043701	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675044703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675044703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4892	1715675044703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4842	1715675004618	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675008625	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675008625	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4873000000000003	1715675008625	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675009628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675009628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4873000000000003	1715675009628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675011632	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675011632	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.487	1715675011632	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675012634	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675012634	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.487	1715675012634	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675016643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675016643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.486	1715675016643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675018647	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675018647	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4876	1715675018647	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675022656	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675022656	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4886999999999997	1715675022656	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675023658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675023658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4885	1715675023658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675027666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715675027666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4877	1715675027666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675028668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675028668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4877	1715675028668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675029670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675029670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4871999999999996	1715675029670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675040714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675048711	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.2	1715675048711	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4898000000000002	1715675048711	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675049729	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.6	1715675355381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5039000000000002	1715675355381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675357385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675357385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5055	1715675357385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675361410	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715675457598	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5195	1715675457598	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675461623	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675469624	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715675469624	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5176	1715675469624	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675470626	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675470626	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5051	1715675470626	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675472645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675477643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675477643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5139	1715675477643	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675478645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715675478645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5139	1715675478645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675480664	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675481665	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675483674	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675013637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675013637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.487	1715675013637	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675014639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675014639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.486	1715675014639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675015641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675015641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.486	1715675015641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675017645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675017645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4876	1715675017645	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675019669	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675031675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675031675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4871999999999996	1715675031675	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675032677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675032677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4907	1715675032677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675038689	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715675038689	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4892	1715675038689	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675040694	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675040694	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4892	1715675040694	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675046723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675055726	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.999999999999998	1715675055726	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4855	1715675055726	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675056729	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715675056729	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4874	1715675056729	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675057731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675057731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4874	1715675057731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675058733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675058733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4874	1715675058733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675060737	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675060737	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4880999999999998	1715675060737	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675362396	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715675362396	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.506	1715675362396	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675364416	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675365417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675369411	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715675369411	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.505	1715675369411	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675370413	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675370413	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.505	1715675370413	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675371415	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715675371415	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5048000000000004	1715675371415	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675374421	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.1	1715675374421	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5071999999999997	1715675374421	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675377427	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675377427	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5071999999999997	1715675377427	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675402480	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715675402480	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5037	1715675402480	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675013653	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675014653	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675015657	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675017660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675026678	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675031692	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675032691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675038704	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675041696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675041696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4894000000000003	1715675041696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675053722	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715675053722	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4855	1715675053722	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675055745	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675056744	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675057746	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675058750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675060752	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675362413	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675366404	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675366404	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5028	1715675366404	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675381449	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675385445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715675385445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5055	1715675385445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675387449	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715675387449	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5044	1715675387449	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675389453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715675389453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5025999999999997	1715675389453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675390471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675392478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675399474	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675399474	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4959000000000002	1715675399474	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675400476	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675400476	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4959000000000002	1715675400476	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675401478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715675401478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5037	1715675401478	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675403481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.6	1715675403481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5037	1715675403481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675413519	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675414527	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675417514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675417514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5086999999999997	1715675417514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675422523	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675422523	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5095	1715675422523	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675423525	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.1	1715675423525	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5095	1715675423525	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675424527	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715675424527	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5095	1715675424527	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675425544	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675428536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715675428536	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715675045705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4892	1715675045705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675050716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675050716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4842	1715675050716	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675051718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675051718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4842	1715675051718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675052734	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675054738	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675363398	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715675363398	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.506	1715675363398	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675381436	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675381436	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5049	1715675381436	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675383455	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675385461	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675387463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675390455	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.6	1715675390455	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5025999999999997	1715675390455	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675392460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715675392460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5035	1715675392460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675395466	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675395466	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5037	1715675395466	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675399490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675400492	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675402495	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675413504	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675413504	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5076	1715675413504	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675414507	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715675414507	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5076	1715675414507	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675416525	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675418531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675422538	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675423542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675425530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715675425530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5105999999999997	1715675425530	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675427533	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715675427533	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5105999999999997	1715675427533	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675428552	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675430555	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675432558	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675434564	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675435566	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675444571	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675444571	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5171	1715675444571	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675446575	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715675446575	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5179	1715675446575	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675450583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675450583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5195	1715675450583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675454591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.2	1715675454591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5197	1715675454591	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675045721	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675050731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675052720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675052720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4842	1715675052720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675054724	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675054724	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4855	1715675054724	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675061739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675061739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4880999999999998	1715675061739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675061756	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675062741	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675062741	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.489	1715675062741	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675062757	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675063743	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675063743	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.489	1715675063743	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675063760	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675064746	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675064746	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.489	1715675064746	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675064762	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675065748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675065748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4897	1715675065748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675065762	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675066750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675066750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4897	1715675066750	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675066767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675067752	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675067752	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4897	1715675067752	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675067769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675068753	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675068753	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.491	1715675068753	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675068768	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675069756	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675069756	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.491	1715675069756	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675069774	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675070758	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675070758	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.491	1715675070758	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675070773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675071760	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715675071760	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4901	1715675071760	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675071775	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675072762	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.7	1715675072762	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4901	1715675072762	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675072776	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675073764	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715675073764	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4901	1715675073764	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675073781	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675074767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675074767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4918	1715675074767	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675074783	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675075769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715675075769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4918	1715675075769	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675078775	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675078775	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4944	1715675078775	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675080797	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675102830	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675102830	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4941	1715675102830	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675110848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.2	1715675110848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4949	1715675110848	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675112868	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675115875	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675118882	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675126881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675126881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4896	1715675126881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675128885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715675128885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4896	1715675128885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675129904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675135921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675136921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675141930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675148944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675155959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675156962	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675159969	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675161972	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675164979	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675168972	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715675168972	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4922	1715675168972	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675169990	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675170993	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675172997	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675184029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675188029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675195046	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675198049	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675201059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675202058	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675203062	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675211082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675214088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675215092	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675219085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675219085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4959000000000002	1715675219085	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675221090	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675221090	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4996	1715675221090	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675222093	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675222093	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4996	1715675222093	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675223095	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675223095	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4996	1715675223095	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675224112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675228120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675236121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.1	1715675236121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5014000000000003	1715675236121	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675075783	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675080780	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715675080780	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4931	1715675080780	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675081784	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675081784	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4931	1715675081784	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675102846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675110862	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675115859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675115859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4917	1715675115859	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675118865	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675118865	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4929	1715675118865	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675119867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675119867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4945999999999997	1715675119867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675127898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675129888	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715675129888	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4896	1715675129888	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675135901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675135901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4938000000000002	1715675135901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675136903	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675136903	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4938000000000002	1715675136903	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675141914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715675141914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4924	1715675141914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675148930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.1	1715675148930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4951	1715675148930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675154941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675154941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4971	1715675154941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675156946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715675156946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4959000000000002	1715675156946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675159953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675159953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4973	1715675159953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675161957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675161957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4976	1715675161957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675164964	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12	1715675164964	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4922	1715675164964	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675165966	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675165966	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4922	1715675165966	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675168987	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675170976	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675170976	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4951	1715675170976	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675172981	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675172981	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4951	1715675172981	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675184006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715675184006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4851	1715675184006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675186010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675186010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675076771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715675076771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4918	1715675076771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675077773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715675077773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4944	1715675077773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675081799	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675084806	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675087815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675088815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675093828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675106852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675107857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675111850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715675111850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4949	1715675111850	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675113873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675116861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675116861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4929	1715675116861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675120870	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715675120870	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4945999999999997	1715675120870	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675121872	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715675121872	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4945999999999997	1715675121872	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675122874	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.999999999999998	1715675122874	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4858000000000002	1715675122874	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675123876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675123876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4858000000000002	1715675123876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675124878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675124878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4858000000000002	1715675124878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675127883	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675127883	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4896	1715675127883	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675130890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.7	1715675130890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4896	1715675130890	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675134899	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.2	1715675134899	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4938000000000002	1715675134899	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675137905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675137905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4898000000000002	1715675137905	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675142916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675142916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4924	1715675142916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675145922	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715675145922	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4931	1715675145922	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675149931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715675149931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4944	1715675149931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675155943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675155943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4959000000000002	1715675155943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675157962	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675158967	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675162959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.1	1715675162959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4976	1715675162959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675076787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675077790	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675084791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675084791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4955	1715675084791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675087797	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675087797	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4965	1715675087797	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675088799	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675088799	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4965	1715675088799	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675093812	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675093812	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4948	1715675093812	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675106839	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675106839	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4925	1715675106839	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675107841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675107841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4954	1715675107841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675108858	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675113855	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.999999999999998	1715675113855	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4917	1715675113855	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675114872	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675116876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675120886	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675121889	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675122889	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675123891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675124894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675128901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675130904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675134914	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675137921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675144937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675146925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.1	1715675146925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4951	1715675146925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675150951	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675157948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675157948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4959000000000002	1715675157948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675158950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675158950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4973	1715675158950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675160973	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675167970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.8	1715675167970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4922	1715675167970	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675173983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715675173983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4991	1715675173983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675175987	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675175987	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4991	1715675175987	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675176989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675176989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4977	1715675176989	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675178008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675185008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675185008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4851	1715675185008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675186024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675078795	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675079792	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675083802	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675086810	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675089815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675096818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675096818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4954	1715675096818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675099824	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675099824	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4937	1715675099824	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675104835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675104835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4925	1715675104835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675105837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675105837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4925	1715675105837	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675109846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675109846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4954	1715675109846	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675111866	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675131892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715675131892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4903000000000004	1715675131892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675132894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675132894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4903000000000004	1715675132894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675138908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675138908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4898000000000002	1715675138908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675144920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715675144920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4931	1715675144920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675146941	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675151936	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.8	1715675151936	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4944	1715675151936	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675152953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675153954	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675160955	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675160955	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4973	1715675160955	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675163976	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675166968	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675166968	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4922	1715675166968	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675169974	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675169974	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4922	1715675169974	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675177003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675180012	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675190018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715675190018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4932	1715675190018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675191020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675191020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4941	1715675191020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675193024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	4.2	1715675193024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4941	1715675193024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675196031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675196031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4903000000000004	1715675196031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675197033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675079778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675079778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4944	1715675079778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675083788	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.299999999999999	1715675083788	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4955	1715675083788	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675086795	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675086795	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4965	1715675086795	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675089801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675089801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4945999999999997	1715675089801	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675095832	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675096833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675101842	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675104849	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675105852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675109862	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675112853	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.7	1715675112853	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4949	1715675112853	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675131907	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675133897	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715675133897	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4903000000000004	1715675133897	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675138923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675145938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675150933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675150933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4944	1715675150933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675152938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.1	1715675152938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4971	1715675152938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675153940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715675153940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4971	1715675153940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675154957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675163961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675163961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4976	1715675163961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675165981	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675166983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675171995	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675179996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675179996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.498	1715675179996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675188014	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675188014	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4932	1715675188014	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675190036	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675191035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675193040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675196047	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675197048	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675199052	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675208074	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675212082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675213091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675217079	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675217079	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4951	1715675217079	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675224097	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675224097	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5017	1715675224097	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675082786	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.7	1715675082786	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4931	1715675082786	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675085793	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675085793	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4955	1715675085793	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675090803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675090803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4945999999999997	1715675090803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675091805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675091805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4945999999999997	1715675091805	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675092807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675092807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4948	1715675092807	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675094814	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675094814	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4948	1715675094814	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675095816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675095816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4954	1715675095816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675097839	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675098838	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675100827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675100827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4937	1715675100827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675101829	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675101829	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4941	1715675101829	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675103849	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675114857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.7	1715675114857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4917	1715675114857	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675117878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675125880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675125880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4896	1715675125880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675126896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675133913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675139926	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675140927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675143918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.8	1715675143918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4931	1715675143918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675147927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.4	1715675147927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4951	1715675147927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675149946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675162975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675174985	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675174985	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4991	1715675174985	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675178994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	14.6	1715675178994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4977	1715675178994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675180999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675180999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.498	1715675180999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675182002	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675182002	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.498	1715675182002	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675183021	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675187026	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675204064	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675082802	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675085809	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675090817	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675091820	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675092823	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675094830	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675097820	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675097820	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4954	1715675097820	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675098822	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675098822	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4937	1715675098822	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675099838	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675100841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675103832	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.899999999999999	1715675103832	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4941	1715675103832	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675108843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.199999999999999	1715675108843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4954	1715675108843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675117863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.6	1715675117863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4929	1715675117863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675119885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675125895	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675132911	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675139910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675139910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4898000000000002	1715675139910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675140912	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675140912	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4924	1715675140912	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675142929	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675143934	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675147943	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675151950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675171979	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.8	1715675171979	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4951	1715675171979	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675175000	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675179008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675181015	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675183004	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675183004	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4851	1715675183004	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675187011	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675187011	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4924	1715675187011	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675204049	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675204049	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4983	1715675204049	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675205051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675205051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4983	1715675205051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675206070	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675207074	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675209078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675210080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675231112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675231112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4985999999999997	1715675231112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675233116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715675233116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4994	1715675233116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675167986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675174000	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675176003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675177991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675177991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4977	1715675177991	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675182017	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675185024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675189016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675189016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4932	1715675189016	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675192022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675192022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4941	1715675192022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675194027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675194027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4903000000000004	1715675194027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675200040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675200040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4945999999999997	1715675200040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675211066	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715675211066	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4987	1715675211066	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675218098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675220106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675232114	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675232114	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4985999999999997	1715675232114	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675234133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675258173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715675258173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4959000000000002	1715675258173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675259175	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675259175	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4959000000000002	1715675259175	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675260177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675260177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4966	1715675260177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675263184	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675263184	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4981	1715675263184	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675271201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675271201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4962	1715675271201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675272203	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675272203	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.499	1715675272203	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675288239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675288239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5012	1715675288239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675289257	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675294252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675294252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5061	1715675294252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675297258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	14.499999999999998	1715675297258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5027	1715675297258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675301267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715675301267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.501	1715675301267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675363414	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675367423	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675372433	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675375444	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4924	1715675186010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675195029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675195029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4903000000000004	1715675195029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675198035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675198035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4951999999999996	1715675198035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675201042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675201042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4945999999999997	1715675201042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675202044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675202044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4945999999999997	1715675202044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675203047	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.7	1715675203047	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4983	1715675203047	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675206054	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715675206054	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4987	1715675206054	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675214073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675214073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4962	1715675214073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675215075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675215075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4951	1715675215075	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675216091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675219104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675221107	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675222107	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675223112	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675228105	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675228105	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5021999999999998	1715675228105	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675235120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715675235120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4994	1715675235120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675236137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675239143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675241147	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675243156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675249166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675251156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675251156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.501	1715675251156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675252158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715675252158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.501	1715675252158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675254176	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675256168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.7	1715675256168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5014000000000003	1715675256168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675257188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675266190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715675266190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4920999999999998	1715675266190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675267192	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675267192	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4920999999999998	1715675267192	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675268195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675268195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4920999999999998	1715675268195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675273221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675274223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675275224	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675189031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675192037	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675194043	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675200054	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675218083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715675218083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4959000000000002	1715675218083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675220088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675220088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4959000000000002	1715675220088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675230124	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675232128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675242150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675258186	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675259190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675260193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675263201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675271216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675272217	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675289242	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675289242	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5012	1715675289242	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675293267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675294270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675297272	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675301280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675364400	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675364400	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.506	1715675364400	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675365402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715675365402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5028	1715675365402	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675366422	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675369427	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675370429	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675371430	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675374436	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675384443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675384443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5055	1715675384443	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675407490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675407490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5061999999999998	1715675407490	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675412501	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675412501	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5061	1715675412501	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675415509	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.5	1715675415509	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5076	1715675415509	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675417528	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675429553	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675431558	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675433562	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675440563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675440563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5166	1715675440563	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675441565	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715675441565	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5166	1715675441565	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675443583	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675449581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675449581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5195	1715675449581	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675452603	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675457598	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675197033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4951999999999996	1715675197033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675199038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675199038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4951999999999996	1715675199038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675208059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.399999999999999	1715675208059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4987	1715675208059	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675212068	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675212068	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4962	1715675212068	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675213071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.8	1715675213071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4962	1715675213071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675216077	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675216077	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4951	1715675216077	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675217101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675225099	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.7	1715675225099	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5017	1715675225099	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675226101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715675226101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5017	1715675226101	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675227103	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675227103	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5021999999999998	1715675227103	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675229107	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675229107	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5021999999999998	1715675229107	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675234118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675234118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4994	1715675234118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675237123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.8	1715675237123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5014000000000003	1715675237123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675238125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675238125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5014000000000003	1715675238125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675240130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675240130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4974000000000003	1715675240130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675245143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675245143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4995	1715675245143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675246160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675247162	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675248164	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675255166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12	1715675255166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5014000000000003	1715675255166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675261179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.700000000000001	1715675261179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4966	1715675261179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675265188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675265188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4981	1715675265188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675269197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675269197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4962	1715675269197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675277228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675278232	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675292263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675298260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675205069	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675207057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675207057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4987	1715675207057	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675209061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715675209061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4987	1715675209061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675210063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675210063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4987	1715675210063	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675230110	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675230110	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4985999999999997	1715675230110	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675231126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675233133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675244141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12	1715675244141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4995	1715675244141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675249152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675249152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5002	1715675249152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675253178	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675262181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675262181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4966	1715675262181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675264186	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675264186	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4981	1715675264186	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675270199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675270199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4962	1715675270199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675276211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675276211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5002	1715675276211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675280222	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675280222	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4995	1715675280222	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675281224	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675281224	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5016	1715675281224	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675282240	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675287252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675290243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	5.9	1715675290243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5042	1715675290243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675291246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675291246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5042	1715675291246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675295269	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675300265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675300265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.501	1715675300265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675367406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715675367406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5028	1715675367406	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675372417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675372417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5048000000000004	1715675372417	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675375423	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675375423	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5071999999999997	1715675375423	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675376425	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675376425	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5071999999999997	1715675376425	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675225116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675226116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675227122	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675229123	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675235138	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675237139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675238141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675240146	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675246145	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675246145	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4995	1715675246145	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675247147	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	14.499999999999998	1715675247147	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4995	1715675247147	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675248149	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675248149	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5002	1715675248149	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675253161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675253161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.501	1715675253161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675256182	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675261193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675265205	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675269211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675278215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675278215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4995	1715675278215	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675292248	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715675292248	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5042	1715675292248	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675293250	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675293250	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5061	1715675293250	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675300287	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675368408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715675368408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.505	1715675368408	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675373419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715675373419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5048000000000004	1715675373419	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675377442	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675378445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675379445	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675382453	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675389469	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675391476	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675396481	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675406488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675406488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5056	1715675406488	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675416511	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715675416511	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5086999999999997	1715675416511	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675419531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675427549	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675438574	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675442582	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675447577	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715675447577	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5179	1715675447577	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675451586	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675451586	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5195	1715675451586	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675456596	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675239127	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675239127	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4974000000000003	1715675239127	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675241133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675241133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4974000000000003	1715675241133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675243139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675243139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4995	1715675243139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675245158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675250168	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675251171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675252172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675255182	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675257171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715675257171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4959000000000002	1715675257171	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675264203	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675266205	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675267208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675273206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675273206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.499	1715675273206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675274208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675274208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.499	1715675274208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675275210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675275210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5002	1715675275210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675277213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675277213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5002	1715675277213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675279235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675283228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715675283228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5016	1715675283228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675284231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675284231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5037	1715675284231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675285233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675285233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5037	1715675285233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675286235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675286235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5037	1715675286235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675295254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675295254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5061	1715675295254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675296270	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675299263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675299263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.501	1715675299263	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675368425	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675373438	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675378430	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.2	1715675378430	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5071999999999997	1715675378430	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675379432	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.3	1715675379432	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5071999999999997	1715675379432	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675382438	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675382438	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5049	1715675382438	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675384457	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675242135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675242135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4995	1715675242135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675244155	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675250154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675250154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5002	1715675250154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675254163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.4	1715675254163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5014000000000003	1715675254163	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675262196	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675268210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675270216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675276226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675280238	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675281242	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675287237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675287237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5012	1715675287237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675288255	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675290257	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675291261	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675299278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675376444	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675380448	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675386447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715675386447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5044	1715675386447	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675388451	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.1	1715675388451	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5044	1715675388451	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675393461	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6	1715675393461	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5035	1715675393461	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675394463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715675394463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5035	1715675394463	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675395480	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675397484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675398485	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675404484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.8	1715675404484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5056	1715675404484	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675405486	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.6	1715675405486	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5056	1715675405486	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675408491	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675408491	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5061999999999998	1715675408491	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675409495	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9	1715675409495	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5061999999999998	1715675409495	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675410497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675410497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5061	1715675410497	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675411499	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675411499	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5061	1715675411499	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675418516	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675418516	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5086999999999997	1715675418516	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675420534	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675426531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675426531	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675279219	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.8	1715675279219	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4995	1715675279219	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675282226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675282226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5016	1715675282226	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675283244	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675284245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675285249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675286250	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675296256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.300000000000001	1715675296256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5027	1715675296256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675298275	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675380434	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675380434	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5049	1715675380434	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675383440	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.8	1715675383440	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5055	1715675383440	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675386460	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675388465	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675393476	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675394482	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675397470	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715675397470	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5037	1715675397470	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675398471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675398471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.4959000000000002	1715675398471	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675401493	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675404499	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675405502	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675408507	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675409511	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675410515	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675411514	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675420520	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.9	1715675420520	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5096999999999996	1715675420520	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675421521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675421521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5096999999999996	1715675421521	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675426546	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675437555	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715675437555	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5188	1715675437555	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675439561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715675439561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5188	1715675439561	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675441579	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675448594	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675453590	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675453590	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5197	1715675453590	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675459616	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675461606	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675461606	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.52	1715675461606	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675464626	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675466631	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675470641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675471628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675471628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.7	1715675298260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5027	1715675298260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675391457	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13	1715675391457	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5025999999999997	1715675391457	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675396468	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675396468	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5037	1715675396468	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675403498	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675406506	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675419518	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.5	1715675419518	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5096999999999996	1715675419518	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675424542	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675438559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715675438559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5188	1715675438559	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675442566	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675442566	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5166	1715675442566	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675445573	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675445573	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5171	1715675445573	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675447592	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675451600	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675456609	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675458615	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675465630	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675468636	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5051	1715675471628	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675474636	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675474636	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5103	1715675474636	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675475639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.2	1715675475639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5103	1715675475639	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675476641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675476641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5139	1715675476641	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675480650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675480650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5164	1715675480650	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675481651	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715675481651	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5164	1715675481651	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675482670	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675483655	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675483655	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5119000000000002	1715675483655	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675484658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675484658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5119000000000002	1715675484658	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675485660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675485660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5151	1715675485660	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675486677	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675487680	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5144	1715675488666	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675488681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675489668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715675489668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5144	1715675489668	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675489688	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675490673	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715675490673	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5144	1715675490673	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675495686	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675495686	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5155	1715675495686	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675496704	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675503718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675504720	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675509731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675510732	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675512739	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675515746	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675516746	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675517749	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675521742	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675521742	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5184	1715675521742	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675528757	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.299999999999999	1715675528757	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5183	1715675528757	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675533784	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675535772	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715675535772	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.517	1715675535772	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675536774	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	14.899999999999999	1715675536774	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5181999999999998	1715675536774	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675537792	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675539781	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675539781	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5049	1715675539781	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675541802	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675551822	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675554828	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675555832	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675561842	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675568845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715675568845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5191	1715675568845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675577880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675579869	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675579869	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5188	1715675579869	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675580887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675590908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675591909	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675600927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675606923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675606923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5246	1715675606923	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675612935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675612935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5245	1715675612935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675617946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.399999999999999	1715675617946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5231999999999997	1715675617946	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675625963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675625963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5165	1715675625963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675629971	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.6	1715675629971	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5228	1715675629971	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675630973	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675630973	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675490690	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675495699	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675500696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675500696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5175	1715675500696	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675504705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675504705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.517	1715675504705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675509717	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675509717	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5159000000000002	1715675509717	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675510719	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675510719	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5159000000000002	1715675510719	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675512723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675512723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5155	1715675512723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675515730	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675515730	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5138000000000003	1715675515730	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675516731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675516731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5138000000000003	1715675516731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675517733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715675517733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5138000000000003	1715675517733	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675518736	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715675518736	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5174000000000003	1715675518736	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675521755	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675528774	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675534786	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675535786	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675537776	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675537776	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5181999999999998	1715675537776	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675538778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.2	1715675538778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5181999999999998	1715675538778	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675539799	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675551808	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675551808	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5088000000000004	1715675551808	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675554814	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675554814	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.515	1715675554814	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675555816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675555816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.515	1715675555816	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675561829	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675561829	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.518	1715675561829	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675565838	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675565838	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5178000000000003	1715675565838	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675568861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675578867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715675578867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5188	1715675578867	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675579886	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675590891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675590891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5174000000000003	1715675590891	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675591894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675491676	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715675491676	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5134000000000003	1715675491676	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675500713	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675501717	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675507712	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675507712	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5162	1715675507712	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675511721	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715675511721	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5159000000000002	1715675511721	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675514727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675514727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5155	1715675514727	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675525768	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675527771	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675547815	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675549804	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715675549804	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5169	1715675549804	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675558822	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675558822	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5176999999999996	1715675558822	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675560827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675560827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.518	1715675560827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675564852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675569847	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675569847	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5188	1715675569847	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675570849	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675570849	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5188	1715675570849	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675572854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675572854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.518	1715675572854	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675574875	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675580871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715675580871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5188	1715675580871	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675581888	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675584896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675587900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675589903	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675593913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675603932	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675609930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675609930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5239000000000003	1715675609930	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675615959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675633995	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675640994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715675640994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5265	1715675640994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675646005	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675646005	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5256	1715675646005	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675647007	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715675647007	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5256	1715675647007	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675648027	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675649025	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675656040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675660033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675491691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675501698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675501698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5175	1715675501698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675506724	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675507730	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675511735	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675514744	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675527755	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715675527755	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5183	1715675527755	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675536788	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675548818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675549819	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675558836	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675560845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675565852	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675569861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675570865	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675574858	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675574858	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.518	1715675574858	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675577865	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675577865	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5194	1715675577865	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675581873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675581873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5195	1715675581873	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675584880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675584880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5166	1715675584880	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675585896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675589889	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675589889	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5165	1715675589889	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675593898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715675593898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5176999999999996	1715675593898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675603918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675603918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5227	1715675603918	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675604935	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675609945	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675633980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675633980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5242	1715675633980	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675636985	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715675636985	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.526	1715675636985	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675641008	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675646022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675648009	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675648009	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5268	1715675648009	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675649011	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.399999999999999	1715675649011	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5268	1715675649011	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675656026	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675656026	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.528	1715675656026	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675658030	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675658030	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.528	1715675658030	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675660050	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675492678	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715675492678	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5134000000000003	1715675492678	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675493681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675493681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5134000000000003	1715675493681	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675494683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.4	1715675494683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5155	1715675494683	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675498691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	6.9	1715675498691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5164	1715675498691	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675502700	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715675502700	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5175	1715675502700	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675503703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675503703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.517	1715675503703	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675505723	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675508714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13.1	1715675508714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5162	1715675508714	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675518752	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675519755	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675522761	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675523764	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675529759	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675529759	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5183	1715675529759	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675530761	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715675530761	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5164	1715675530761	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675532765	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675532765	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5164	1715675532765	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675540800	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675543791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715675543791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5118	1715675543791	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675544793	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675544793	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5118	1715675544793	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675545796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675545796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5147	1715675545796	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675548802	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675548802	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5169	1715675548802	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675556818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715675556818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.515	1715675556818	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675563833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715675563833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5178000000000003	1715675563833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675564836	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675564836	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5178000000000003	1715675564836	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675566853	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675567858	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675573870	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675575875	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675582876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715675582876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5195	1715675582876	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675492695	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675493697	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675494698	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675498707	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675502718	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675505707	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	14.799999999999999	1715675505707	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.517	1715675505707	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675506709	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675506709	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5162	1715675506709	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675508731	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675519738	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715675519738	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5174000000000003	1715675519738	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675522744	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675522744	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5184	1715675522744	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675523746	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675523746	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5184	1715675523746	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675526768	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675529773	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675530776	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675532780	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675541787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715675541787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5049	1715675541787	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675543809	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675544808	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675545811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675552810	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675552810	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5088000000000004	1715675552810	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675556833	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675563849	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675566841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.6	1715675566841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5191	1715675566841	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675567843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675567843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5191	1715675567843	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675573856	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675573856	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.518	1715675573856	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675575861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675575861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5194	1715675575861	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675578885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675582889	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675583892	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675587885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.6	1715675587885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5165	1715675587885	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675588902	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675592910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675595916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675596921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675604920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715675604920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5227	1715675604920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675608927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675608927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5239000000000003	1715675608927	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675496688	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675496688	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5155	1715675496688	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675497705	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675499711	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675513740	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675520756	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675524765	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675526753	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675526753	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5202	1715675526753	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675531779	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675534770	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675534770	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.517	1715675534770	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675540783	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715675540783	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5049	1715675540783	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675542803	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675546812	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675550806	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.299999999999999	1715675550806	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5169	1715675550806	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675552827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675553827	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675557835	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675559839	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675562845	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675571866	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675576863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675576863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5194	1715675576863	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675586883	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.399999999999999	1715675586883	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5166	1715675586883	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675594900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675594900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5176999999999996	1715675594900	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675597906	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675597906	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5191999999999997	1715675597906	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675598924	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675599925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675601928	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675602931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675607939	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675610947	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675614955	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675620953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675620953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5276	1715675620953	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675621955	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675621955	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5276	1715675621955	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675622957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675622957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5276	1715675622957	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675623959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675623959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5165	1715675623959	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675631975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675631975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5228	1715675631975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675632977	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675497690	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.6	1715675497690	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5164	1715675497690	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675499693	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675499693	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5164	1715675499693	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675513725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675513725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5155	1715675513725	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675520740	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715675520740	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5174000000000003	1715675520740	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675524748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675524748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5202	1715675524748	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675525751	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.6	1715675525751	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5202	1715675525751	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675531763	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675531763	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5164	1715675531763	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675533768	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675533768	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.517	1715675533768	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675538797	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675542789	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.6	1715675542789	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5118	1715675542789	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675546798	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675546798	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5147	1715675546798	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675547800	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675547800	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5147	1715675547800	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675550821	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675553811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675553811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5088000000000004	1715675553811	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675557820	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675557820	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5176999999999996	1715675557820	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675559824	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.299999999999999	1715675559824	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5176999999999996	1715675559824	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675562831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675562831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.518	1715675562831	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675571851	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675571851	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5188	1715675571851	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675572869	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675576878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675586898	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675594916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675598908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675598908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5191999999999997	1715675598908	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675599910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675599910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5223	1715675599910	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675601913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675601913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5223	1715675601913	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675602916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675583878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675583878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5195	1715675583878	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675585881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675585881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5166	1715675585881	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675588887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675588887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5165	1715675588887	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675592896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715675592896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5174000000000003	1715675592896	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675595901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715675595901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5176999999999996	1715675595901	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675596904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675596904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5191999999999997	1715675596904	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675597920	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675605938	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675608944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675611947	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675613951	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675616961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675618963	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675619966	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675624977	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675626982	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675627983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675628986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675635983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715675635983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.526	1715675635983	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675640007	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675654022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675654022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5251	1715675654022	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675657028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675657028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.528	1715675657028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715675591894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5174000000000003	1715675591894	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675600911	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675600911	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5223	1715675600911	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675605921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675605921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5246	1715675605921	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675606937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675612952	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675617964	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675625977	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675629986	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675632994	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675634997	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675639006	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675641996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10	1715675641996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5235	1715675641996	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675644001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675644001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5235	1715675644001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675645003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.299999999999999	1715675645003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5256	1715675645003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675651015	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675651015	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5286	1715675651015	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675652018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675652018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5286	1715675652018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675653020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675653020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5251	1715675653020	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675658044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675659047	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675602916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5227	1715675602916	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675607925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675607925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5246	1715675607925	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675610931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675610931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5239000000000003	1715675610931	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675614940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675614940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5202	1715675614940	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675615942	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675615942	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5202	1715675615942	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675620966	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675621969	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675622974	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675623975	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675631995	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675637001	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675638003	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675647024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675650028	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675655039	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675611933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675611933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5245	1715675611933	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675613937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675613937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5245	1715675613937	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675616944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675616944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5202	1715675616944	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675618948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675618948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5231999999999997	1715675618948	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675619950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.1	1715675619950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5231999999999997	1715675619950	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675624961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675624961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5165	1715675624961	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675626965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675626965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5242	1715675626965	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675627967	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7	1715675627967	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5242	1715675627967	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675628969	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.2	1715675628969	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5242	1715675628969	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675630988	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675635998	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675643013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675654037	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675657044	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5228	1715675630973	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675634981	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.7	1715675634981	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5242	1715675634981	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675638990	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675638990	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5265	1715675638990	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675639992	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675639992	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5265	1715675639992	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675642010	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675644017	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675645018	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675651029	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675652032	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675653035	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675659031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675659031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5267	1715675659031	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.7	1715675632977	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5242	1715675632977	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675637988	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.5	1715675637988	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.526	1715675637988	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675642999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675642999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5235	1715675642999	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675650013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675650013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5286	1715675650013	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675655024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715675655024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5251	1715675655024	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.2	1715675660033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5267	1715675660033	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675661036	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675661036	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5267	1715675661036	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675661051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675662038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675662038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5299	1715675662038	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675662055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675663040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675663040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5299	1715675663040	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675663055	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675664042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.499999999999998	1715675664042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5299	1715675664042	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675664056	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675665045	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675665045	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5262	1715675665045	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675665061	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675666047	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675666047	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5262	1715675666047	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675666062	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675667049	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	13.299999999999999	1715675667049	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5262	1715675667049	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675667066	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675668051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675668051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5303	1715675668051	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675668067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675669054	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675669054	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5303	1715675669054	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675669070	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675670056	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715675670056	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5303	1715675670056	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675670070	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675671058	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675671058	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5305999999999997	1715675671058	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675671074	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675672060	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675672060	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5305999999999997	1715675672060	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675672074	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675673062	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675673062	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5305999999999997	1715675673062	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675673082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675674065	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675674065	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5305999999999997	1715675674065	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675674082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675675067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675675067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5305999999999997	1715675675067	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675675083	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675676069	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675676069	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5305999999999997	1715675676069	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675676087	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675677071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675677071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5307	1715675677071	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675677087	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675679091	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675680095	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675690100	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715675690100	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5231	1715675690100	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675691118	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675698120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675698120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5214000000000003	1715675698120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675699122	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675699122	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5214000000000003	1715675699122	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675700141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675701141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675711164	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675712166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675716158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675716158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5286	1715675716158	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675722172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675722172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5321	1715675722172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675723189	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675734199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675734199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5328000000000004	1715675734199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675736220	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675739225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675741214	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.399999999999999	1715675741214	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5326999999999997	1715675741214	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675745240	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675747243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675750249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675751251	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675754256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675756264	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675760274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675764281	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675768290	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675770294	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675771295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675774302	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675775303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675777306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675780313	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675784324	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675790335	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675800343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.800000000000001	1715675800343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5359000000000003	1715675800343	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675802347	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.800000000000001	1715675802347	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5359000000000003	1715675802347	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675803349	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675803349	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5345	1715675803349	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675813370	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.3	1715675813370	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5370999999999997	1715675813370	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675678073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675678073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5307	1715675678073	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675684086	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675684086	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5313000000000003	1715675684086	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675686107	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675693120	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675702128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715675702128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5242	1715675702128	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675703145	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675704149	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675707139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.799999999999999	1715675707139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5258000000000003	1715675707139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675708141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715675708141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5258000000000003	1715675708141	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675709143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675709143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5258000000000003	1715675709143	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675710160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675713152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675713152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5284	1715675713152	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675715172	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675717176	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675721169	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675721169	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5294	1715675721169	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675722190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675725198	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675727199	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675740228	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675744235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675752237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675752237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5391	1715675752237	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675758251	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675758251	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5256999999999996	1715675758251	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675759254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	14.899999999999999	1715675759254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5256999999999996	1715675759254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675760256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675760256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5256999999999996	1715675760256	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675762279	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675765283	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675766284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675773301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675776304	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675778311	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675786325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675789333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675791339	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675792341	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675801345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715675801345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5359000000000003	1715675801345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675804365	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675807357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.7	1715675807357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675678088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675684104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675693106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675693106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5271999999999997	1715675693106	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675695111	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675695111	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5203	1715675695111	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675702145	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675704133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675704133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5269	1715675704133	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675705135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715675705135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5269	1715675705135	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675707154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675708155	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675709161	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675711148	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675711148	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5258000000000003	1715675711148	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675713166	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675717160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675717160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5286	1715675717160	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675719165	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675719165	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5294	1715675719165	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675721182	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675725179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675725179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5329	1715675725179	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675727183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675727183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5329	1715675727183	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675730206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675744221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.399999999999999	1715675744221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5331	1715675744221	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675745223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675745223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5331	1715675745223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675752252	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675758268	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675759269	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675762260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675762260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5267	1715675762260	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675765267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675765267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5299	1715675765267	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675766269	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675766269	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5299	1715675766269	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675773284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675773284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5277	1715675773284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675776291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675776291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5296	1715675776291	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675778295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.2	1715675778295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5296	1715675778295	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675786312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675679076	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715675679076	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5307	1715675679076	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675680078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675680078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5303	1715675680078	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675688095	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.1	1715675688095	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5205	1715675688095	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675690116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675695127	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675698137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675699139	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675701126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675701126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5242	1715675701126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675706137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675706137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5269	1715675706137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675712150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.5	1715675712150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5258000000000003	1715675712150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675715156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675715156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5284	1715675715156	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675716173	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675723175	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.2	1715675723175	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5321	1715675723175	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675730190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675730190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5314	1715675730190	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675734214	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675739210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675739210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5311999999999997	1715675739210	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675740212	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675740212	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5326999999999997	1715675740212	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675741229	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675747227	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675747227	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5383	1715675747227	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675750233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715675750233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5395	1715675750233	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675751235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675751235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5395	1715675751235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675754241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675754241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5391	1715675754241	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675756246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675756246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5376	1715675756246	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675757249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675757249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5376	1715675757249	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675764265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675764265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5299	1715675764265	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675768274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675768274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.522	1715675768274	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675681080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675681080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5303	1715675681080	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675682082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675682082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5303	1715675682082	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675685088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675685088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5313000000000003	1715675685088	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675687108	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675692125	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675697137	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675703130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675703130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5242	1715675703130	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675710146	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675710146	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5258000000000003	1715675710146	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675714169	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675718178	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675724193	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675728201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675729202	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675732211	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675733213	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675735216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675737206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675737206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5311999999999997	1715675737206	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675738208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.399999999999999	1715675738208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5311999999999997	1715675738208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675742216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.2	1715675742216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5326999999999997	1715675742216	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675749231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675749231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5395	1715675749231	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675753239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675753239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5391	1715675753239	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675755259	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675761276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675767284	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675779312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675787329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675796348	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675805368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675808381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675810378	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675681095	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675682099	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675686090	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675686090	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5205	1715675686090	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675692104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675692104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5271999999999997	1715675692104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675697116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675697116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5203	1715675697116	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675700124	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675700124	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5214000000000003	1715675700124	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675705150	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675714154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675714154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5284	1715675714154	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675718162	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675718162	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5286	1715675718162	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675719181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675728186	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675728186	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5314	1715675728186	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675729188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675729188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5314	1715675729188	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675732195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675732195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5304	1715675732195	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675733197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675733197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5304	1715675733197	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675735201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675735201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5328000000000004	1715675735201	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675736203	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675736203	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5328000000000004	1715675736203	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675737222	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675738223	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675742232	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675749245	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675753254	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675757264	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675767271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675767271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.522	1715675767271	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675779297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675779297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5317	1715675779297	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675787314	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675787314	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5333	1715675787314	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675796333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675796333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5342	1715675796333	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675805353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.800000000000001	1715675805353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5345	1715675805353	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675808359	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.4	1715675808359	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5349	1715675808359	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675683084	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675683084	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5313000000000003	1715675683084	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675685104	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675688111	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675689115	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675694108	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675694108	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5271999999999997	1715675694108	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675696113	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675696113	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5203	1715675696113	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675706151	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675720184	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675726181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.399999999999999	1715675726181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5329	1715675726181	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675731192	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675731192	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5304	1715675731192	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675743218	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675743218	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5331	1715675743218	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675746225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675746225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5383	1715675746225	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675748229	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675748229	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5383	1715675748229	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	104	1715675755244	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675755244	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5376	1715675755244	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675763262	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.7	1715675763262	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5267	1715675763262	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675769276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675769276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.522	1715675769276	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675772282	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675772282	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5283	1715675772282	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675781301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.299999999999999	1715675781301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5317	1715675781301	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675782303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675782303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.533	1715675782303	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675783306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675783306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.533	1715675783306	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675785310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675785310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5333	1715675785310	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675788316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675788316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5329	1715675788316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675793327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675793327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5324	1715675793327	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675794329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.2	1715675794329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5342	1715675794329	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675795331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675795331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675683100	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675687093	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675687093	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5205	1715675687093	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675689098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.399999999999999	1715675689098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5231	1715675689098	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675691102	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675691102	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5231	1715675691102	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675694124	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675696126	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675720167	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675720167	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5294	1715675720167	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675724177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675724177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5321	1715675724177	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675726196	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675731208	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675743235	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675746242	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675748243	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675761258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675761258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5267	1715675761258	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675763277	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675769290	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675772298	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675781316	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675782318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675784308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715675784308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.533	1715675784308	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675785324	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675788331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675793341	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675794344	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675797350	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675798352	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675799355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675806371	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675809375	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675770278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675770278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5283	1715675770278	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675771280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675771280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5283	1715675771280	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675774286	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675774286	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5277	1715675774286	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675775288	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.799999999999999	1715675775288	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5277	1715675775288	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675777293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675777293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5296	1715675777293	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675780299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675780299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5317	1715675780299	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675783319	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675790320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.699999999999999	1715675790320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5329	1715675790320	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675795345	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675800358	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675802363	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675803364	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675813385	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	10.799999999999999	1715675786312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5333	1715675786312	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675789318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	14.899999999999999	1715675789318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5329	1715675789318	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675791322	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.1	1715675791322	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5324	1715675791322	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675792325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12.399999999999999	1715675792325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5324	1715675792325	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675797336	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.399999999999999	1715675797336	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5354	1715675797336	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675801359	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675806355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	12	1715675806355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5349	1715675806355	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675807372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675811381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675812381	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5342	1715675795331	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	100	1715675798339	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.6	1715675798339	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5354	1715675798339	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	103	1715675799341	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	11.899999999999999	1715675799341	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5354	1715675799341	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675804351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.5	1715675804351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5345	1715675804351	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675809361	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.2	1715675809361	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.537	1715675809361	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	102	1715675814372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	8.9	1715675814372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5370999999999997	1715675814372	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5349	1715675807357	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675811366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	7.800000000000001	1715675811366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.537	1715675811366	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	101	1715675812368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715675812368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.5370999999999997	1715675812368	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - CPU Utilization	105	1715675810363	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Utilization	9.4	1715675810363	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Memory Usage GB	2.537	1715675810363	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
TOP - Swap Memory GB	0.0329	1715675814387	816c658dd62e4ea7ae7fd4332bb6cfe8	0	f
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
letter	0	816c658dd62e4ea7ae7fd4332bb6cfe8
workload	0	816c658dd62e4ea7ae7fd4332bb6cfe8
listeners	smi+top+dcgmi	816c658dd62e4ea7ae7fd4332bb6cfe8
params	'"-"'	816c658dd62e4ea7ae7fd4332bb6cfe8
file	cifar10.py	816c658dd62e4ea7ae7fd4332bb6cfe8
workload_listener	''	816c658dd62e4ea7ae7fd4332bb6cfe8
model	cifar10.py	816c658dd62e4ea7ae7fd4332bb6cfe8
manual	False	816c658dd62e4ea7ae7fd4332bb6cfe8
max_epoch	5	816c658dd62e4ea7ae7fd4332bb6cfe8
max_time	172800	816c658dd62e4ea7ae7fd4332bb6cfe8
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
816c658dd62e4ea7ae7fd4332bb6cfe8	(0 0) dapper-grouse-767	UNKNOWN			daga	FINISHED	1715672768842	1715675815892		active	s3://mlflow-storage/0/816c658dd62e4ea7ae7fd4332bb6cfe8/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	816c658dd62e4ea7ae7fd4332bb6cfe8
mlflow.source.name	file:///home/daga/radt#examples/pytorch	816c658dd62e4ea7ae7fd4332bb6cfe8
mlflow.source.type	PROJECT	816c658dd62e4ea7ae7fd4332bb6cfe8
mlflow.project.entryPoint	main	816c658dd62e4ea7ae7fd4332bb6cfe8
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	816c658dd62e4ea7ae7fd4332bb6cfe8
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	816c658dd62e4ea7ae7fd4332bb6cfe8
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	816c658dd62e4ea7ae7fd4332bb6cfe8
mlflow.project.env	conda	816c658dd62e4ea7ae7fd4332bb6cfe8
mlflow.project.backend	local	816c658dd62e4ea7ae7fd4332bb6cfe8
mlflow.runName	(0 0) dapper-grouse-767	816c658dd62e4ea7ae7fd4332bb6cfe8
\.


--
-- Name: experiment_id; Type: SEQUENCE SET; Schema: public; Owner: mlflow_user
--

SELECT pg_catalog.setval('public.experiment_id', 1, false);


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
    ADD CONSTRAINT model_version_tags_name_version_fkey FOREIGN KEY (name, version) REFERENCES public.model_versions(name, version) ON UPDATE RESTRICT;


--
-- Name: model_versions model_versions_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.model_versions
    ADD CONSTRAINT model_versions_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE RESTRICT;


--
-- Name: params params_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.params
    ADD CONSTRAINT params_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- Name: registered_model_aliases registered_model_alias_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.registered_model_aliases
    ADD CONSTRAINT registered_model_alias_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: registered_model_tags registered_model_tags_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow_user
--

ALTER TABLE ONLY public.registered_model_tags
    ADD CONSTRAINT registered_model_tags_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE RESTRICT;


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

