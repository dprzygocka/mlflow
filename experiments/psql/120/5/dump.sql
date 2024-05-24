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
0	Default	s3://mlflow-storage/0	active	1716231859526	1716231859526
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
SMI - Power Draw	14.75	1716232195905	0	f	436b0fe0581b40b39a3b1162534bcede
SMI - Timestamp	1716232195.892	1716232195905	0	f	436b0fe0581b40b39a3b1162534bcede
SMI - GPU Util	0	1716232195905	0	f	436b0fe0581b40b39a3b1162534bcede
SMI - Mem Util	0	1716232195905	0	f	436b0fe0581b40b39a3b1162534bcede
SMI - Mem Used	0	1716232195905	0	f	436b0fe0581b40b39a3b1162534bcede
SMI - Performance State	0	1716232195905	0	f	436b0fe0581b40b39a3b1162534bcede
TOP - CPU Utilization	103	1716234832977	0	f	436b0fe0581b40b39a3b1162534bcede
TOP - Memory Usage GB	2.1369000000000002	1716234832977	0	f	436b0fe0581b40b39a3b1162534bcede
TOP - Memory Utilization	9.3	1716234832977	0	f	436b0fe0581b40b39a3b1162534bcede
TOP - Swap Memory GB	0.0003	1716234833002	0	f	436b0fe0581b40b39a3b1162534bcede
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.75	1716232195905	436b0fe0581b40b39a3b1162534bcede	0	f
SMI - Timestamp	1716232195.892	1716232195905	436b0fe0581b40b39a3b1162534bcede	0	f
SMI - GPU Util	0	1716232195905	436b0fe0581b40b39a3b1162534bcede	0	f
SMI - Mem Util	0	1716232195905	436b0fe0581b40b39a3b1162534bcede	0	f
SMI - Mem Used	0	1716232195905	436b0fe0581b40b39a3b1162534bcede	0	f
SMI - Performance State	0	1716232195905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	0	1716232195971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	0	1716232195971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.2422	1716232195971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232195986	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	166.70000000000002	1716232196973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716232196973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.2422	1716232196973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232196988	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232197975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.4	1716232197975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.2422	1716232197975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232197989	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232198977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1000000000000005	1716232198977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4746	1716232198977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232198991	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232199979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.4	1716232199979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4746	1716232199979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232199993	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232200981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1000000000000005	1716232200981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4746	1716232200981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232200995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	106	1716232201983	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.4	1716232201983	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4718	1716232201983	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232202004	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232202985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1000000000000005	1716232202985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4718	1716232202985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232203006	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232203987	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.4	1716232203987	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4718	1716232203987	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232204008	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232204989	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.4	1716232204989	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4719	1716232204989	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232205012	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716232205991	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1000000000000005	1716232205991	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4719	1716232205991	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232206004	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232206993	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.4	1716232206993	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4719	1716232206993	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232207006	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716232207995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1000000000000005	1716232207995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4723	1716232207995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232208016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232208997	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.4	1716232208997	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4723	1716232208997	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232209019	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232209999	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.4	1716232209999	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4723	1716232209999	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232210020	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232211016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232212024	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232213017	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232214019	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232215023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232216035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232217033	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232218027	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232219037	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232220035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232221045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232222035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232223046	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232224038	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232225047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232226053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232227054	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232228057	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232229058	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232230049	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232231053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232232062	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232233062	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232234065	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232235058	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232236067	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232237070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232238073	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232239076	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232240067	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232241079	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232242081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232243081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232244084	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232245080	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232246087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232247088	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232248090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232249092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232250086	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232251098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232252100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232253100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232254104	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232255099	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232256102	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232257109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232258111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232259112	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232260105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232261119	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232262120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232263119	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232264120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232265116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232266126	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232267127	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232268129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232269131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232510566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232510566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.933	1716232510566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232511569	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232511569	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	106	1716232211001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1000000000000005	1716232211001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4735	1716232211001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716232212003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1000000000000005	1716232212003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4735	1716232212003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232213004	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	2.5	1716232213004	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4735	1716232213004	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716232214006	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232214006	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4730999999999999	1716232214006	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232215008	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232215008	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4730999999999999	1716232215008	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232216011	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232216011	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.4730999999999999	1716232216011	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232217013	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232217013	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.7738	1716232217013	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232218014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232218014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.7738	1716232218014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232219016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232219016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.7738	1716232219016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232220018	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232220018	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9937	1716232220018	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232221020	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232221020	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9937	1716232221020	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232222021	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232222021	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9937	1716232222021	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232223023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232223023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9955	1716232223023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232224025	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232224025	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9955	1716232224025	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232225027	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232225027	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9955	1716232225027	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232226029	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232226029	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0005	1716232226029	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232227031	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232227031	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0005	1716232227031	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232228032	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232228032	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0005	1716232228032	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232229034	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232229034	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9999	1716232229034	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232230036	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232230036	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9999	1716232230036	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232231038	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232231038	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9999	1716232231038	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232232040	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232232040	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9999	1716232232040	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232233041	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232233041	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9999	1716232233041	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232234043	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232234043	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9999	1716232234043	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232235045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232235045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0002999999999997	1716232235045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232236047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232236047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0002999999999997	1716232236047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232237049	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232237049	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0002999999999997	1716232237049	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232238051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232238051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.002	1716232238051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232239053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232239053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.002	1716232239053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232240055	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232240055	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.002	1716232240055	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232241057	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232241057	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9125999999999999	1716232241057	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232242059	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232242059	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9125999999999999	1716232242059	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232243060	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232243060	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9125999999999999	1716232243060	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232244062	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232244062	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.914	1716232244062	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232245064	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232245064	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.914	1716232245064	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232246066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232246066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.914	1716232246066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232247068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232247068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9135	1716232247068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232248070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232248070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9135	1716232248070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232249071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232249071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9135	1716232249071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232250073	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232250073	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9162000000000001	1716232250073	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232251075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232251075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9162000000000001	1716232251075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232252077	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232252077	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9162000000000001	1716232252077	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232253079	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232253079	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9169	1716232253079	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232254081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232254081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9169	1716232254081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232255083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232255083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9169	1716232255083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232256085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232256085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9137	1716232256085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232257087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232257087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9137	1716232257087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232258089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232258089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9137	1716232258089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232259090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232259090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9137	1716232259090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232260092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232260092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9137	1716232260092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232261094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232261094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9137	1716232261094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232262096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232262096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9129	1716232262096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232263098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232263098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9129	1716232263098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232264100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232264100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9129	1716232264100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232265101	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232265101	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9156	1716232265101	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232266103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232266103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9156	1716232266103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232267105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232267105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9156	1716232267105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232268107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232268107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9165999999999999	1716232268107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232269109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232269109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9165999999999999	1716232269109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232270111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232270111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9165999999999999	1716232270111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232270125	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232271112	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	2.6	1716232271112	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9175	1716232271112	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232271134	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232272114	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232272114	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9175	1716232272114	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232272136	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232273116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232273116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9175	1716232273116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232273139	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232274140	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232275134	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232276143	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232277144	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232278148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232279147	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232280142	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232281152	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232282152	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232283155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232284150	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232285152	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232286163	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232287165	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232288168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232289168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232290164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232291170	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232292173	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232293174	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232294172	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232295171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232296180	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232297185	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232298185	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232299178	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232300180	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232301189	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232302191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232303192	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232304197	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232305189	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232306193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232307203	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232308203	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232309203	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232310198	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232311209	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232312212	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232313211	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232314213	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232315209	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232316277	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232317221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232318222	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232319226	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232320219	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232321229	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232322230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232323232	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232324234	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232325231	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232326237	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232327245	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232328242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232329246	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232510588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232511585	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232512590	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232513593	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232514596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232515589	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232516592	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232517602	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232274118	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232274118	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.917	1716232274118	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232275120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232275120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.917	1716232275120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232276121	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232276121	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.917	1716232276121	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232277123	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232277123	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9158	1716232277123	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232278125	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232278125	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9158	1716232278125	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232279127	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232279127	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9158	1716232279127	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232280129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232280129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9170999999999998	1716232280129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232281131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232281131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9170999999999998	1716232281131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232282133	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232282133	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9170999999999998	1716232282133	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232283135	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232283135	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9158	1716232283135	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232284136	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232284136	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9158	1716232284136	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232285138	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232285138	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9158	1716232285138	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232286140	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232286140	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9133	1716232286140	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232287142	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232287142	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9133	1716232287142	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232288144	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232288144	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9133	1716232288144	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232289146	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232289146	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9159000000000002	1716232289146	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232290148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232290148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9159000000000002	1716232290148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232291150	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232291150	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9159000000000002	1716232291150	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232292151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232292151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.918	1716232292151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232293153	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232293153	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.918	1716232293153	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232294155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232294155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.918	1716232294155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232295157	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232295157	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9167	1716232295157	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232296159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232296159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9167	1716232296159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232297161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232297161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9167	1716232297161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232298162	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232298162	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9177	1716232298162	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232299164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232299164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9177	1716232299164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232300166	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232300166	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9177	1716232300166	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232301168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232301168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9167	1716232301168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232302170	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232302170	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9167	1716232302170	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232303171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232303171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9167	1716232303171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232304173	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232304173	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9169	1716232304173	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232305175	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232305175	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9169	1716232305175	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232306178	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232306178	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9169	1716232306178	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232307180	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232307180	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9157	1716232307180	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232308181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232308181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9157	1716232308181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232309183	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232309183	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9157	1716232309183	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232310185	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232310185	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9179000000000002	1716232310185	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232311187	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232311187	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9179000000000002	1716232311187	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232312189	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232312189	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9179000000000002	1716232312189	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232313191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232313191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9181	1716232313191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232314193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232314193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9181	1716232314193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232315195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232315195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9181	1716232315195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232316196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232316196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.918	1716232316196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232317198	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232317198	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.918	1716232317198	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	108	1716232318202	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232318202	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.918	1716232318202	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232319204	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232319204	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9187	1716232319204	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232320205	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232320205	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9187	1716232320205	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232321207	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232321207	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9187	1716232321207	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232322209	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232322209	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9212	1716232322209	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232323211	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232323211	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9212	1716232323211	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232324213	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232324213	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9212	1716232324213	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232325215	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232325215	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9195	1716232325215	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232326217	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232326217	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9195	1716232326217	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232327219	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232327219	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9195	1716232327219	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232328220	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232328220	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9176	1716232328220	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232329222	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232329222	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9176	1716232329222	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232330224	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232330224	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9176	1716232330224	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232330242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232331226	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232331226	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9188	1716232331226	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232331248	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232332228	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232332228	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9188	1716232332228	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232332251	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232333230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232333230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9188	1716232333230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232333253	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232334231	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232334231	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9201	1716232334231	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232334253	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232335233	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232335233	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9201	1716232335233	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232335249	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232336235	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232336235	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9201	1716232336235	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232337237	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232337237	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9228	1716232337237	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232338239	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232338239	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9228	1716232338239	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232339240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232339240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9228	1716232339240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232340242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232340242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9218	1716232340242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232341244	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232341244	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9218	1716232341244	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232342246	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232342246	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9218	1716232342246	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232343248	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232343248	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9209	1716232343248	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232344250	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232344250	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9209	1716232344250	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232345251	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232345251	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9209	1716232345251	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232346253	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232346253	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9215	1716232346253	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232347255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.2	1716232347255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9215	1716232347255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	107	1716232348257	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716232348257	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9215	1716232348257	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232349259	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3	1716232349259	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9173	1716232349259	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232350261	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232350261	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9173	1716232350261	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232351263	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232351263	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9173	1716232351263	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232352264	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3	1716232352264	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9195	1716232352264	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232353266	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3	1716232353266	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9195	1716232353266	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232354268	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232354268	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9195	1716232354268	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232355270	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.5	1716232355270	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.92	1716232355270	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232356272	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3	1716232356272	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.92	1716232356272	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232357274	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232336248	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232337258	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232338259	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232339255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232340258	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232341265	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232342260	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232343269	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232344271	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232345267	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232346275	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232347277	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232348279	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232349282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232350276	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232351279	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232352287	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232353287	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232354281	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232355284	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232356293	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232357295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232358301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232359292	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232360295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232361304	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232362304	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232363302	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232364313	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232365307	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232366310	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232367318	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232368318	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232369314	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232370316	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232371325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232372325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232373329	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232374331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232375325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232376335	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232377339	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232378335	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232379338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232380332	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232381342	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232382345	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232383346	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232384347	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232385342	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232386351	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232387353	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232388348	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232389357	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9342000000000001	1716232511569	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232512570	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232512570	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9342000000000001	1716232512570	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232513571	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232513571	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9342000000000001	1716232513571	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232514573	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232514573	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9343	1716232514573	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232515575	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232357274	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.92	1716232357274	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232358276	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232358276	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9208	1716232358276	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232359278	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232359278	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9208	1716232359278	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232360280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232360280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9208	1716232360280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232361282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232361282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9236	1716232361282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232362284	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232362284	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9236	1716232362284	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232363287	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232363287	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9236	1716232363287	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232364289	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232364289	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9255	1716232364289	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232365291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232365291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9255	1716232365291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232366294	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232366294	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9255	1716232366294	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232367295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232367295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9243	1716232367295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232368297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232368297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9243	1716232368297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232369299	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232369299	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9243	1716232369299	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232370301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232370301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9234	1716232370301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232371303	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232371303	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9234	1716232371303	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232372304	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232372304	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9234	1716232372304	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232373306	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232373306	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9234	1716232373306	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232374308	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232374308	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9234	1716232374308	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232375310	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232375310	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9234	1716232375310	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232376312	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232376312	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9245	1716232376312	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232377314	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232377314	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9245	1716232377314	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232378315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232378315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9245	1716232378315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232379317	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232379317	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9233	1716232379317	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232380319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232380319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9233	1716232380319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232381321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232381321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9233	1716232381321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232382323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232382323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9242000000000001	1716232382323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232383324	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232383324	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9242000000000001	1716232383324	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232384326	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232384326	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9242000000000001	1716232384326	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232385328	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232385328	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9252	1716232385328	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232386330	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232386330	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9252	1716232386330	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232387331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716232387331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9252	1716232387331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232388333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232388333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.926	1716232388333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232389335	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232389335	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.926	1716232389335	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232390337	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232390337	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.926	1716232390337	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232390351	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232391339	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232391339	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9275	1716232391339	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232391359	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232392341	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232392341	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9275	1716232392341	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232392363	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232393343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232393343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9275	1716232393343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232393365	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232394345	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232394345	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9221	1716232394345	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232394367	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232395347	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232395347	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9221	1716232395347	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232395360	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232396349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232396349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9221	1716232396349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232396366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232397351	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232397351	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9233	1716232397351	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232398352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232398352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9233	1716232398352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232399354	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232399354	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9233	1716232399354	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232400356	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232400356	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9245	1716232400356	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232401358	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232401358	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9245	1716232401358	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232402360	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232402360	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9245	1716232402360	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232403363	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232403363	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9252	1716232403363	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232404364	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232404364	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9252	1716232404364	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232405366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232405366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9252	1716232405366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232406368	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232406368	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9274	1716232406368	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232407370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232407370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9274	1716232407370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232408371	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232408371	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9274	1716232408371	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232409373	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232409373	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9244	1716232409373	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232410374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232410374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9244	1716232410374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232411376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232411376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9244	1716232411376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232412378	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232412378	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9270999999999998	1716232412378	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232413380	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232413380	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9270999999999998	1716232413380	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232414382	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232414382	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9270999999999998	1716232414382	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232415384	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232415384	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9265999999999999	1716232415384	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232416386	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232416386	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9265999999999999	1716232416386	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232417387	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232417387	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9265999999999999	1716232417387	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232418389	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232418389	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.922	1716232418389	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232397371	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232398373	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232399369	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232400369	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232401382	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232402383	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232403376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232404385	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232405380	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232406394	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232407391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232408384	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232409396	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232410388	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232411399	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232412400	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232413401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232414402	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232415398	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232416406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232417410	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232418403	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232419414	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232420415	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232421416	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232422417	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232423420	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232424418	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232425416	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232426422	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232427421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232428423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232429427	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232430426	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232431429	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232432429	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232433434	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232434434	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232435436	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232436447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232437440	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232438448	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232439451	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232440444	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232441447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232442449	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232443450	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232444454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232445454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232446464	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232447465	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232448458	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232449467	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232515575	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9343	1716232515575	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232516577	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232516577	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9343	1716232516577	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232517579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232517579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9354	1716232517579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232518581	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232518581	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9354	1716232518581	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232519583	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232419391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232419391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.922	1716232419391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232420393	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232420393	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.922	1716232420393	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232421395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232421395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9245	1716232421395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232422397	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232422397	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9245	1716232422397	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232423399	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232423399	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9245	1716232423399	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232424400	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232424400	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9250999999999998	1716232424400	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232425402	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232425402	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9250999999999998	1716232425402	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232426404	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232426404	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9250999999999998	1716232426404	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232427406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232427406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9261	1716232427406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232428408	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232428408	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9261	1716232428408	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232429410	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232429410	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9261	1716232429410	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232430412	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232430412	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9276	1716232430412	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232431414	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232431414	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9276	1716232431414	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232432416	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232432416	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9276	1716232432416	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232433418	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232433418	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9255	1716232433418	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232434420	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232434420	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9255	1716232434420	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232435421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232435421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9255	1716232435421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232436423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232436423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9267	1716232436423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232437425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232437425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9267	1716232437425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232438427	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232438427	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9267	1716232438427	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232439429	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232439429	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9272	1716232439429	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232440431	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232440431	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9272	1716232440431	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232441433	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232441433	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9272	1716232441433	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232442435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232442435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9279000000000002	1716232442435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232443436	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232443436	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9279000000000002	1716232443436	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232444438	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232444438	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9279000000000002	1716232444438	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232445440	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232445440	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9305999999999999	1716232445440	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232446441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232446441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9305999999999999	1716232446441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232447443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232447443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9305999999999999	1716232447443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232448445	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232448445	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9292	1716232448445	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232449447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232449447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9292	1716232449447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232450449	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232450449	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9292	1716232450449	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232450470	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232451451	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232451451	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9322000000000001	1716232451451	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232451472	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232452452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232452452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9322000000000001	1716232452452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232452475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232453454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232453454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9322000000000001	1716232453454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232453475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232454456	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232454456	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.932	1716232454456	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232454478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232455458	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232455458	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.932	1716232455458	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232455481	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232456460	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232456460	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.932	1716232456460	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232456480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232457463	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232457463	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9312	1716232457463	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232457484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232458465	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232458465	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9312	1716232458465	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232458488	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232459491	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232460483	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232461494	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232462495	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232463489	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232464497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232465502	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232466502	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232467502	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232468507	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232469500	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232470509	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232471510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232472512	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232473514	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232474513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232475521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232476520	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232477524	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232478526	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232479529	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232480532	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232481532	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232482536	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232483537	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232484531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232485535	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232486541	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232487547	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232488547	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232489550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232490543	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232491554	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232492557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232493556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232494557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232495561	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232496566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232497557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232498568	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232499561	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232500570	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232501570	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232502574	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232503576	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232504569	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232505578	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232506583	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232507583	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232508583	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232509578	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232518601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232519605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232520598	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232521612	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232522610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232523612	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232524612	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232525618	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232526617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232527619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232528621	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232529628	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232530619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232459467	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232459467	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9312	1716232459467	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232460469	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232460469	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9321	1716232460469	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232461471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232461471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9321	1716232461471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232462473	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232462473	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9321	1716232462473	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232463475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232463475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.932	1716232463475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232464476	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232464476	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.932	1716232464476	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232465478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232465478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.932	1716232465478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232466480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232466480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9321	1716232466480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232467482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232467482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9321	1716232467482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232468484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232468484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9321	1716232468484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232469486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232469486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9319000000000002	1716232469486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232470487	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232470487	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9319000000000002	1716232470487	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232471489	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232471489	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9319000000000002	1716232471489	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232472491	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232472491	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9344000000000001	1716232472491	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232473493	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232473493	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9344000000000001	1716232473493	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232474497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232474497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9344000000000001	1716232474497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232475499	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232475499	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9327999999999999	1716232475499	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232476500	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232476500	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9327999999999999	1716232476500	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232477502	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232477502	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9327999999999999	1716232477502	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716232478504	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232478504	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9325999999999999	1716232478504	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232479506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232479506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9325999999999999	1716232479506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232480509	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232480509	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9325999999999999	1716232480509	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232481511	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232481511	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9343	1716232481511	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232482513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232482513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9343	1716232482513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232483515	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232483515	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9343	1716232483515	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232484517	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232484517	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9321	1716232484517	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232485519	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232485519	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9321	1716232485519	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232486521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232486521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9321	1716232486521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232487523	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232487523	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9352	1716232487523	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232488525	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232488525	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9352	1716232488525	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232489526	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232489526	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9352	1716232489526	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232490528	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232490528	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9345	1716232490528	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232491530	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232491530	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9345	1716232491530	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232492534	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232492534	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9345	1716232492534	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232493535	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232493535	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9349	1716232493535	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232494537	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.3999999999999995	1716232494537	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9349	1716232494537	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232495539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232495539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9349	1716232495539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232496540	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232496540	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9373	1716232496540	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232497542	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.6	1716232497542	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9373	1716232497542	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232498544	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232498544	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9373	1716232498544	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232499546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232499546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9361	1716232499546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232500548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232500548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9361	1716232500548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232501550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232501550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9361	1716232501550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232502551	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232502551	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9374	1716232502551	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232503553	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232503553	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9374	1716232503553	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232504555	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232504555	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9374	1716232504555	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232505557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232505557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9330999999999998	1716232505557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232506559	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232506559	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9330999999999998	1716232506559	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232507561	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232507561	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9330999999999998	1716232507561	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232508563	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232508563	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.933	1716232508563	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232509565	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232509565	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.933	1716232509565	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232519583	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9354	1716232519583	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232520585	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232520585	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9349	1716232520585	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232521587	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232521587	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9349	1716232521587	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232522589	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232522589	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9349	1716232522589	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232523591	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232523591	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9349	1716232523591	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232524592	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232524592	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9349	1716232524592	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232525594	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232525594	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9349	1716232525594	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232526596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232526596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9365	1716232526596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232527598	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232527598	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9365	1716232527598	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232528600	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232528600	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9365	1716232528600	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232529601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232529601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9323	1716232529601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232530603	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232530603	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9323	1716232530603	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232531605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232531605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9323	1716232531605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232531626	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232532607	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232532607	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.934	1716232532607	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232533609	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232533609	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.934	1716232533609	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232534611	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232534611	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.934	1716232534611	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232535613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232535613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9354	1716232535613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232536615	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232536615	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9354	1716232536615	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232537617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232537617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9354	1716232537617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232538619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232538619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9379000000000002	1716232538619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232539620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232539620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9379000000000002	1716232539620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232540622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232540622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9379000000000002	1716232540622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232541626	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232541626	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9374	1716232541626	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232542627	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232542627	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9374	1716232542627	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232543629	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716232543629	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9374	1716232543629	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232544631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232544631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9362000000000001	1716232544631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232545633	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232545633	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9362000000000001	1716232545633	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232546635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232546635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9362000000000001	1716232546635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232547637	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232547637	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9381	1716232547637	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232548639	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232548639	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9381	1716232548639	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232549641	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232549641	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9381	1716232549641	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232550642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232550642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9377	1716232550642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232551644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232551644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9377	1716232551644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232552646	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232552646	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9377	1716232552646	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232553648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232532630	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232533631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232534633	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232535628	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232536636	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232537639	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232538642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232539635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232540643	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232541649	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232542650	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232543650	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232544645	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232545656	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232546657	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232547662	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232548661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232549657	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232550664	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232551668	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232552671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232553671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232554663	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232555673	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232556676	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232557678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232558681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232559681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232560678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232561678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232562689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232563691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232564692	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232565685	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232566696	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232567698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232568698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232569696	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232930374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232930374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9555	1716232930374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232931376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232931376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9576	1716232931376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232932377	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232932377	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9576	1716232932377	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232933379	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232933379	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9576	1716232933379	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232934381	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232934381	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9607999999999999	1716232934381	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232935383	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232935383	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9607999999999999	1716232935383	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232936385	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232936385	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9607999999999999	1716232936385	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232937386	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232937386	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9617	1716232937386	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232938388	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	4.9	1716232938388	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9617	1716232938388	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232553648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9382000000000001	1716232553648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232554650	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232554650	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9382000000000001	1716232554650	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232555651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232555651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9382000000000001	1716232555651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232556653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232556653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9393	1716232556653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232557655	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232557655	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9393	1716232557655	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232558658	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232558658	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9393	1716232558658	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232559660	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232559660	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9374	1716232559660	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232560662	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232560662	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9374	1716232560662	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232561664	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232561664	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9374	1716232561664	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232562666	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232562666	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9377	1716232562666	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232563668	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232563668	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9377	1716232563668	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232564670	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232564670	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9377	1716232564670	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232565671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232565671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9397	1716232565671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232566673	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232566673	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9397	1716232566673	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232567675	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232567675	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9397	1716232567675	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232568677	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232568677	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.94	1716232568677	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232569679	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232569679	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.94	1716232569679	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232570681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232570681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.94	1716232570681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232570708	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232571684	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232571684	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.94	1716232571684	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232571710	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232572686	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232572686	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.94	1716232572686	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232572711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232573688	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232573688	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.94	1716232573688	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232574691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232574691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9365999999999999	1716232574691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232575693	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232575693	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9365999999999999	1716232575693	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232576694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232576694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9365999999999999	1716232576694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232577698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232577698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9385999999999999	1716232577698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232578701	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232578701	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9385999999999999	1716232578701	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232579703	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232579703	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9385999999999999	1716232579703	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232580705	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232580705	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9375	1716232580705	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232581707	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232581707	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9375	1716232581707	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232582709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232582709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9375	1716232582709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232583711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232583711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.939	1716232583711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232584713	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232584713	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.939	1716232584713	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232585715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232585715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.939	1716232585715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232586718	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232586718	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9404000000000001	1716232586718	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232587720	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232587720	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9404000000000001	1716232587720	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232588722	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232588722	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9404000000000001	1716232588722	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232589724	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232589724	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.941	1716232589724	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232590725	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232590725	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.941	1716232590725	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232591727	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232591727	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.941	1716232591727	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232592729	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232592729	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9393	1716232592729	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232593731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232593731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9393	1716232593731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232594733	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232594733	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9393	1716232594733	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232573710	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232574711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232575706	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232576709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232577713	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232578717	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232579717	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232580720	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232581721	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232582730	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232583732	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232584726	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232585735	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232586739	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232587743	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232588743	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232589747	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232590739	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232591748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232592751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232593752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232594754	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232595749	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232596757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232597759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232598761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232599754	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232600764	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232601763	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232602763	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232603772	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232604773	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232605767	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232606776	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232607777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232608779	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232609781	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232610777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232611787	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232612789	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232613792	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232614786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232615795	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232616796	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232617797	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232618798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232619796	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232620804	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232621801	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232622805	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232623810	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232624804	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232625814	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232626809	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232627814	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232628819	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232629813	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232930395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232931396	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232932398	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232933401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232934396	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232935404	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232936406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232937407	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232595735	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232595735	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9393	1716232595735	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232596736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232596736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9393	1716232596736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232597738	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232597738	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9393	1716232597738	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232598740	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232598740	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9403	1716232598740	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232599741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232599741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9403	1716232599741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232600743	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232600743	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9403	1716232600743	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232601746	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232601746	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.941	1716232601746	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232602748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232602748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.941	1716232602748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232603750	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232603750	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.941	1716232603750	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232604751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232604751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9403	1716232604751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232605753	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232605753	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9403	1716232605753	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232606755	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232606755	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9403	1716232606755	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232607757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232607757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9407	1716232607757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232608759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232608759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9407	1716232608759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232609761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232609761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9407	1716232609761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232610762	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232610762	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9425	1716232610762	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232611764	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232611764	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9425	1716232611764	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232612766	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232612766	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9425	1716232612766	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232613768	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232613768	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9418	1716232613768	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232614770	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232614770	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9418	1716232614770	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232615771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232615771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9418	1716232615771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232616773	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232616773	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.941	1716232616773	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232617775	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232617775	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.941	1716232617775	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232618777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232618777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.941	1716232618777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232619779	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232619779	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9417	1716232619779	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232620781	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232620781	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9417	1716232620781	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232621783	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232621783	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9417	1716232621783	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232622785	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232622785	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9413	1716232622785	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232623786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232623786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9413	1716232623786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232624788	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232624788	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9413	1716232624788	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232625790	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232625790	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9433	1716232625790	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232626792	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232626792	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9433	1716232626792	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716232627793	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716232627793	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9433	1716232627793	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232628795	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232628795	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9427	1716232628795	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232629796	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232629796	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9427	1716232629796	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232630798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232630798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9427	1716232630798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232630821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232631800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232631800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9429	1716232631800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232631813	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232632802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232632802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9429	1716232632802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232632823	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232633803	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232633803	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9429	1716232633803	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232633825	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232634805	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232634805	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9422000000000001	1716232634805	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232634819	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232635807	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232635807	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9422000000000001	1716232635807	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232635829	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232636833	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232637832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232638833	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232639828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232640836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232641838	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232642840	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232643843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232644846	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232645850	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232646851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232647853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232648856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232649848	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232650857	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232651861	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232652862	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232653863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232654862	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232655871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232656869	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232657874	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232658873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232659866	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232660880	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232661881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232662880	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232663882	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232664878	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232665879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232666891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232667891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232668894	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232669896	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232670899	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232671893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232672901	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232673897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232674905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232675907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232676902	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232677911	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232678913	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232679908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232680921	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232681911	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232682922	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232683923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232684917	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232685926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232686920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232687929	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232688934	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232689933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232938412	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232939402	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232940406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232941416	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232942409	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232943418	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232944413	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232945422	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232946423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232947429	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232636808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232636808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9422000000000001	1716232636808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232637810	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232637810	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.944	1716232637810	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232638812	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232638812	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.944	1716232638812	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232639814	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232639814	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.944	1716232639814	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232640816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232640816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9405999999999999	1716232640816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232641818	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232641818	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9405999999999999	1716232641818	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232642820	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232642820	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9405999999999999	1716232642820	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232643821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232643821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9433	1716232643821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232644825	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232644825	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9433	1716232644825	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232645826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232645826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9433	1716232645826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232646828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232646828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9445	1716232646828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232647830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.699999999999999	1716232647830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9445	1716232647830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232648832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.499999999999999	1716232648832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9445	1716232648832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232649834	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232649834	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.945	1716232649834	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232650836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232650836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.945	1716232650836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232651838	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232651838	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.945	1716232651838	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232652840	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232652840	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9442000000000002	1716232652840	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232653841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232653841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9442000000000002	1716232653841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232654843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232654843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9442000000000002	1716232654843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232655845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232655845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.946	1716232655845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232656847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232656847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.946	1716232656847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232657849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232657849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.946	1716232657849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232658851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232658851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9450999999999998	1716232658851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232659853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232659853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9450999999999998	1716232659853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232660856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232660856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9450999999999998	1716232660856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232661858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232661858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9430999999999998	1716232661858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232662860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232662860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9430999999999998	1716232662860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232663861	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232663861	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9430999999999998	1716232663861	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232664863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232664863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9447999999999999	1716232664863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232665865	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232665865	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9447999999999999	1716232665865	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232666868	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232666868	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9447999999999999	1716232666868	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232667870	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232667870	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9459000000000002	1716232667870	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232668871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232668871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9459000000000002	1716232668871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232669874	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232669874	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9459000000000002	1716232669874	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232670877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232670877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9449	1716232670877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232671879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232671879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9449	1716232671879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232672881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232672881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9449	1716232672881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232673883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232673883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9473	1716232673883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232674885	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232674885	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9473	1716232674885	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232675887	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232675887	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9473	1716232675887	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232676889	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232676889	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9459000000000002	1716232676889	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232677890	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716232677890	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9459000000000002	1716232677890	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232678892	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232678892	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9459000000000002	1716232678892	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232679894	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232679894	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9479000000000002	1716232679894	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232680896	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232680896	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9479000000000002	1716232680896	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232681898	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232681898	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9479000000000002	1716232681898	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232682900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232682900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.944	1716232682900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232683901	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232683901	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.944	1716232683901	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232684903	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232684903	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.944	1716232684903	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232685905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232685905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9443	1716232685905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232686907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232686907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9443	1716232686907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232687909	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232687909	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9443	1716232687909	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232688912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232688912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9455	1716232688912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232689914	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232689914	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9455	1716232689914	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232690916	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232690916	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9455	1716232690916	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232690939	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232691918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232691918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9467	1716232691918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232691934	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232692920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232692920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9467	1716232692920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232692943	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232693921	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232693921	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9467	1716232693921	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232693946	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232694923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232694923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9482000000000002	1716232694923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232694938	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232695925	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232695925	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9482000000000002	1716232695925	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232695946	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232696927	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232696927	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9482000000000002	1716232696927	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232696940	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232697929	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232697929	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9473	1716232697929	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232698931	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232698931	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9473	1716232698931	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232699933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232699933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9473	1716232699933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232700935	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232700935	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9475	1716232700935	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232701936	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232701936	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9475	1716232701936	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232702938	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232702938	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9475	1716232702938	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232703940	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232703940	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9495	1716232703940	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232704941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232704941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9495	1716232704941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232705944	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232705944	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9495	1716232705944	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232706946	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232706946	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9463	1716232706946	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232707948	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232707948	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9463	1716232707948	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232708950	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232708950	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9463	1716232708950	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232709951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232709951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9459000000000002	1716232709951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232710953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232710953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9459000000000002	1716232710953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232711956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232711956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9459000000000002	1716232711956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232712958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232712958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.946	1716232712958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232713960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232713960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.946	1716232713960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232714961	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232714961	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.946	1716232714961	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232715963	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232715963	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9493	1716232715963	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232716965	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232716965	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9493	1716232716965	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232717967	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232717967	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9493	1716232717967	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232718969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232718969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9492	1716232718969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232697950	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232698952	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232699948	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232700955	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232701949	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232702959	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232703962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232704954	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232705968	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232706960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232707968	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232708963	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232709972	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232710967	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232711969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232712981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232713981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232714987	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232715977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232716978	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232717990	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232718989	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232719995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232720995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232721990	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232722998	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232724001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232724996	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232726006	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232727000	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232728008	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232729010	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232730004	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232731012	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232732014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232733017	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232734018	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232735020	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232736022	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232737026	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232738028	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232739029	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232740023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232741029	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232742033	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232743035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232744038	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232745032	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232746041	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232747044	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232748046	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232749048	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232750042	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232751051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232752053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232753056	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232754059	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232755051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232756061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232757062	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232758068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232759068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232760061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232761072	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232762071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232719971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232719971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9492	1716232719971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232720972	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232720972	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9492	1716232720972	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232721975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232721975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9496	1716232721975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232722977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232722977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9496	1716232722977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232723979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232723979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9496	1716232723979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232724981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232724981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9497	1716232724981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232725983	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232725983	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9497	1716232725983	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232726985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232726985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9497	1716232726985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232727986	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232727986	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9477	1716232727986	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232728988	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232728988	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9477	1716232728988	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232729990	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232729990	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9477	1716232729990	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232730992	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232730992	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9473	1716232730992	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232731994	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232731994	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9473	1716232731994	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232732996	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232732996	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9473	1716232732996	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232733998	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232733998	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9502000000000002	1716232733998	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232734999	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232734999	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9502000000000002	1716232734999	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232736001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232736001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9502000000000002	1716232736001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232737003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232737003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9506	1716232737003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232738005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232738005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9506	1716232738005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232739007	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232739007	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9506	1716232739007	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232740009	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232740009	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9496	1716232740009	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232741011	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232741011	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9496	1716232741011	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232742013	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232742013	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9497	1716232742013	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232743014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232743014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9497	1716232743014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232744016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232744016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9497	1716232744016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232745018	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232745018	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9499000000000002	1716232745018	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232746020	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232746020	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9499000000000002	1716232746020	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232747022	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232747022	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9499000000000002	1716232747022	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232748025	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	2.9	1716232748025	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9445	1716232748025	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232749027	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232749027	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9445	1716232749027	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232750029	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232750029	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9445	1716232750029	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232751031	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232751031	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9487	1716232751031	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232752032	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232752032	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9487	1716232752032	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232753034	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232753034	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9487	1716232753034	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232754036	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232754036	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9487999999999999	1716232754036	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232755038	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232755038	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9487999999999999	1716232755038	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232756040	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232756040	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9487999999999999	1716232756040	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232757041	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232757041	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9494	1716232757041	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232758043	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232758043	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9494	1716232758043	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232759045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232759045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9494	1716232759045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232760047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232760047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9506	1716232760047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232761048	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232761048	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9506	1716232761048	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232762050	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232762050	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9506	1716232762050	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232763051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232763051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9524000000000001	1716232763051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232764053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232764053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9524000000000001	1716232764053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232765055	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.6	1716232765055	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9524000000000001	1716232765055	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232766057	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232766057	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9512	1716232766057	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232767059	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716232767059	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9512	1716232767059	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232768061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232768061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9512	1716232768061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232769062	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232769062	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9485999999999999	1716232769062	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232770064	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232770064	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9485999999999999	1716232770064	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232771066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232771066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9485999999999999	1716232771066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232772068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232772068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9499000000000002	1716232772068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232773070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232773070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9499000000000002	1716232773070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232774071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232774071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9499000000000002	1716232774071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232775075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232775075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9501	1716232775075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232776077	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232776077	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9501	1716232776077	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232777078	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232777078	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9501	1716232777078	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232778080	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232778080	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.951	1716232778080	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232779081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232779081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.951	1716232779081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232780083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232780083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.951	1716232780083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232781085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232781085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9497	1716232781085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232782087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232782087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9497	1716232782087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232783089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232783089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9497	1716232783089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232763075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232764075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232765076	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232766080	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232767079	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232768084	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232769085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232770078	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232771086	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232772089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232773092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232774092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232775093	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232776101	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232777101	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232778103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232779097	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232780107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232781108	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232782108	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232783112	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232784113	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232785107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232786118	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232787112	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232788119	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232789113	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232790116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232791124	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232792127	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232793128	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232794132	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232795129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232796134	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232797137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232798138	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232799141	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232800137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232801145	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232802149	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232803144	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232804151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232805148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232806156	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232807161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232808155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232809162	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232939390	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232939390	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9617	1716232939390	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232940391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232940391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9609	1716232940391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232941393	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232941393	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9609	1716232941393	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232942395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716232942395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9609	1716232942395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232943397	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232943397	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.96	1716232943397	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232944399	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232944399	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.96	1716232944399	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232784091	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232784091	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9509	1716232784091	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232785092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232785092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9509	1716232785092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232786094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232786094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9509	1716232786094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232787096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232787096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9526	1716232787096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232788098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232788098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9526	1716232788098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232789100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232789100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9526	1716232789100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232790101	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232790101	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9541	1716232790101	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232791103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232791103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9541	1716232791103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232792105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232792105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9541	1716232792105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232793107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232793107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9515	1716232793107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232794109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232794109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9515	1716232794109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232795111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232795111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9515	1716232795111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232796112	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232796112	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9515	1716232796112	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232797114	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232797114	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9515	1716232797114	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232798116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232798116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9515	1716232798116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232799119	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232799119	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9534	1716232799119	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232800123	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232800123	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9534	1716232800123	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232801125	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232801125	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9534	1716232801125	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232802128	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232802128	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9529	1716232802128	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232803130	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232803130	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9529	1716232803130	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232804131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232804131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9529	1716232804131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232805133	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232805133	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9532	1716232805133	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232806135	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232806135	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9532	1716232806135	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232807137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232807137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9532	1716232807137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232808139	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232808139	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9545	1716232808139	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232809141	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232809141	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9545	1716232809141	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232810143	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232810143	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9545	1716232810143	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232810157	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232811146	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232811146	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9558	1716232811146	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232811166	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232812148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232812148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9558	1716232812148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232812171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232813150	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232813150	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9558	1716232813150	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232813172	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232814152	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232814152	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.952	1716232814152	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232814176	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232815154	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232815154	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.952	1716232815154	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232815167	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232816156	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232816156	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.952	1716232816156	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232816180	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232817158	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232817158	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9527	1716232817158	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232817179	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232818159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232818159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9527	1716232818159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232818184	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232819161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232819161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9527	1716232819161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232819183	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232820163	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232820163	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9545	1716232820163	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232820176	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232821165	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232821165	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9545	1716232821165	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232821186	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232822168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232822168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9545	1716232822168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232823170	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232823170	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9550999999999998	1716232823170	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232824171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232824171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9550999999999998	1716232824171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232825173	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232825173	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9550999999999998	1716232825173	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232826175	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232826175	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9545	1716232826175	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232827177	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232827177	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9545	1716232827177	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232828179	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716232828179	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9545	1716232828179	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232829181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232829181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9544000000000001	1716232829181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232830183	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232830183	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9544000000000001	1716232830183	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232831184	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232831184	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9544000000000001	1716232831184	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232832186	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232832186	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9570999999999998	1716232832186	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232833188	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232833188	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9570999999999998	1716232833188	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232834190	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232834190	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9570999999999998	1716232834190	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232835191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232835191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9558	1716232835191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232836193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232836193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9558	1716232836193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232837195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232837195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9558	1716232837195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232838197	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232838197	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9499000000000002	1716232838197	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232839199	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232839199	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9499000000000002	1716232839199	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232840201	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232840201	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9499000000000002	1716232840201	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232841203	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232841203	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9555	1716232841203	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232842205	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232842205	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9555	1716232842205	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232843206	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232843206	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9555	1716232843206	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232822188	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232823182	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232824193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232825194	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232826196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232827198	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232828201	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232829203	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232830200	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232831208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232832209	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232833213	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232834212	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232835208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232836214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232837216	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232838214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232839214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232840214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232841225	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232842227	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232843230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232844229	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232845225	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232846237	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232847235	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232848241	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232849235	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232850235	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232851243	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232852253	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232853249	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232854249	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232855251	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232856253	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232857248	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232858257	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232859257	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232860256	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232861263	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232862267	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232863266	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232864271	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232865260	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232866273	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232867277	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232868269	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232869273	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232870272	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232871280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232872284	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232873285	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232874280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232875290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232876282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232877291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232878296	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232879291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232880297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232881300	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232882303	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232883297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232884301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232885306	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232886310	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232844208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232844208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9557	1716232844208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232845210	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232845210	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9557	1716232845210	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232846212	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232846212	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9557	1716232846212	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232847214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232847214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9556	1716232847214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232848216	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232848216	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9556	1716232848216	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232849218	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232849218	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9556	1716232849218	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232850220	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232850220	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9564000000000001	1716232850220	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232851221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232851221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9564000000000001	1716232851221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232852223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232852223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9564000000000001	1716232852223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232853225	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232853225	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.958	1716232853225	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232854227	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232854227	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.958	1716232854227	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232855229	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232855229	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.958	1716232855229	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232856231	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232856231	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9577	1716232856231	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232857232	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232857232	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9577	1716232857232	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232858234	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232858234	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9577	1716232858234	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232859236	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232859236	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9559000000000002	1716232859236	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232860238	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232860238	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9559000000000002	1716232860238	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232861240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232861240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9559000000000002	1716232861240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232862242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232862242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9507	1716232862242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232863244	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232863244	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9507	1716232863244	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232864245	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232864245	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9507	1716232864245	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232865247	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232865247	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9546	1716232865247	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232866249	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232866249	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9546	1716232866249	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232867251	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232867251	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9546	1716232867251	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232868253	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232868253	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9567	1716232868253	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232869255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232869255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9567	1716232869255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232870256	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232870256	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9567	1716232870256	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232871258	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232871258	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9589	1716232871258	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232872262	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232872262	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9589	1716232872262	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232873263	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232873263	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9589	1716232873263	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232874265	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232874265	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.961	1716232874265	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232875267	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232875267	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.961	1716232875267	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232876269	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232876269	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.961	1716232876269	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232877271	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232877271	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9585	1716232877271	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232878273	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232878273	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9585	1716232878273	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232879275	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232879275	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9585	1716232879275	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232880277	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232880277	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9587	1716232880277	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232881278	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232881278	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9587	1716232881278	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232882280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232882280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9587	1716232882280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232883282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716232883282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9537	1716232883282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232884284	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232884284	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9537	1716232884284	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232885286	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232885286	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9537	1716232885286	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232886288	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232886288	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9543	1716232886288	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232887290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232887290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9543	1716232887290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232888292	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232888292	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9543	1716232888292	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232889293	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232889293	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9537	1716232889293	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232890295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232890295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9537	1716232890295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232891298	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232891298	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9537	1716232891298	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232892299	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232892299	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9563	1716232892299	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232893302	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232893302	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9563	1716232893302	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232894303	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232894303	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9563	1716232894303	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232895305	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232895305	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9555	1716232895305	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232896308	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232896308	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9555	1716232896308	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232897309	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232897309	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9555	1716232897309	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232898311	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232898311	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9563	1716232898311	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232899313	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232899313	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9563	1716232899313	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232900314	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232900314	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9563	1716232900314	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232901316	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232901316	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9576	1716232901316	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232902318	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.7	1716232902318	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9576	1716232902318	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232903320	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.9	1716232903320	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9576	1716232903320	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232904321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232904321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9583	1716232904321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232905323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232905323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9583	1716232905323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232906325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232906325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9583	1716232906325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232907327	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232907327	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9573	1716232907327	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232887313	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232888312	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232889317	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232890309	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232891321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232892320	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232893315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232894324	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232895320	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232896330	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232897330	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232898325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232899336	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232900337	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232901338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232902340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232903335	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232904345	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232905339	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232906337	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232907350	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232908344	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232909352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232910349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232911356	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232912357	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232913352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232914363	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232915364	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232916367	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232917373	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232918365	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232919372	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232920369	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232921381	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232922382	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232923376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232924384	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232925380	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232926391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232927391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232928391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232929385	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232945401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232945401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.96	1716232945401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232946403	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232946403	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9625	1716232946403	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232947406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232947406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9625	1716232947406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232948407	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232948407	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9625	1716232948407	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232949409	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232949409	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9617	1716232949409	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232950411	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232950411	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9617	1716232950411	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232951413	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232951413	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9617	1716232951413	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232952415	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232908329	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232908329	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9573	1716232908329	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232909331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232909331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9573	1716232909331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232910333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232910333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9578	1716232910333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232911334	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232911334	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9578	1716232911334	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232912336	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232912336	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9578	1716232912336	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232913338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232913338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9567999999999999	1716232913338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232914340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232914340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9567999999999999	1716232914340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232915343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232915343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9567999999999999	1716232915343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232916346	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232916346	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9587999999999999	1716232916346	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232917348	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232917348	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9587999999999999	1716232917348	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232918350	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232918350	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9587999999999999	1716232918350	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232919352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232919352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9610999999999998	1716232919352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232920354	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232920354	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9610999999999998	1716232920354	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232921357	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232921357	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9610999999999998	1716232921357	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232922359	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232922359	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9606	1716232922359	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232923361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232923361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9606	1716232923361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232924362	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232924362	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9606	1716232924362	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716232925364	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232925364	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9622	1716232925364	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232926366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232926366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9622	1716232926366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232927368	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232927368	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9622	1716232927368	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232928370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232928370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9555	1716232928370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232929372	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232929372	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9555	1716232929372	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232948429	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232949425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232950425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232951435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232952415	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9605	1716232952415	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232952437	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232953416	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232953416	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9605	1716232953416	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232953439	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232954418	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232954418	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9605	1716232954418	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232954439	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232955420	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232955420	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9597	1716232955420	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232955433	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232956422	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232956422	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9597	1716232956422	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232956443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232957424	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232957424	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9597	1716232957424	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232957445	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232958426	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232958426	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9635	1716232958426	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232958446	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232959427	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232959427	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9635	1716232959427	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232959449	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232960429	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232960429	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9635	1716232960429	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232960452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232961431	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232961431	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9627999999999999	1716232961431	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232961452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232962433	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232962433	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9627999999999999	1716232962433	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232962454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232963435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232963435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9627999999999999	1716232963435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232963459	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232964437	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232964437	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9653	1716232964437	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232964458	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232965439	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232965439	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9653	1716232965439	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232965460	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232966440	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232966440	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9653	1716232966440	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232966455	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232967464	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232968466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232969458	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232970463	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232971466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232972468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232973474	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232974467	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232975478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232976482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232977483	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232978485	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232979486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232980482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232981492	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232982493	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232983498	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232984492	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232985490	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232986500	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232987504	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232988504	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232989497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232990511	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232991509	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232992510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232993511	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232994506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232995514	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232996517	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232997520	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232998521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716232999514	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233000518	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233001527	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233002533	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233003532	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233004528	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233005536	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233006536	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233007539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233008540	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233009536	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233010546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233011546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233012548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233013550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233014546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233015548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233016552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233017556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233018561	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233019558	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233020566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233021569	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233022569	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233023563	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233024566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233025575	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233026577	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233027580	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233028580	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233029577	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233030588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232967441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232967441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9643	1716232967441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232968443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232968443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9643	1716232968443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232969445	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232969445	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9643	1716232969445	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232970447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232970447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9603	1716232970447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232971449	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232971449	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9603	1716232971449	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232972451	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232972451	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9603	1716232972451	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232973452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232973452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9618	1716232973452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232974454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232974454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9618	1716232974454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232975456	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232975456	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9618	1716232975456	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232976458	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232976458	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9606	1716232976458	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232977460	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232977460	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9606	1716232977460	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232978461	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232978461	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9606	1716232978461	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232979463	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232979463	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9624000000000001	1716232979463	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232980466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232980466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9624000000000001	1716232980466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232981468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232981468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9624000000000001	1716232981468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232982471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232982471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9629	1716232982471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232983473	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232983473	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9629	1716232983473	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232984475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232984475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9629	1716232984475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232985477	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232985477	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.964	1716232985477	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232986478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232986478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.964	1716232986478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232987480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232987480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.964	1716232987480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232988482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232988482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9617	1716232988482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232989483	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232989483	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9617	1716232989483	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232990485	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232990485	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9617	1716232990485	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232991486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232991486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9615	1716232991486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232992488	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232992488	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9615	1716232992488	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232993490	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232993490	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9615	1716232993490	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232994492	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232994492	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9627999999999999	1716232994492	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716232995494	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232995494	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9627999999999999	1716232995494	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716232996496	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232996496	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9627999999999999	1716232996496	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716232997497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232997497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9639000000000002	1716232997497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716232998499	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716232998499	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9639000000000002	1716232998499	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716232999501	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716232999501	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9639000000000002	1716232999501	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233000505	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233000505	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9649	1716233000505	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233001506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233001506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9649	1716233001506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233002508	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233002508	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9649	1716233002508	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233003510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233003510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9661	1716233003510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233004512	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233004512	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9661	1716233004512	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233005514	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233005514	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9661	1716233005514	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233006516	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233006516	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9644000000000001	1716233006516	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233007518	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233007518	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9644000000000001	1716233007518	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233008520	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233008520	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9644000000000001	1716233008520	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233009521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233009521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9647000000000001	1716233009521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233010523	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233010523	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9647000000000001	1716233010523	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233011525	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233011525	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9647000000000001	1716233011525	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233012527	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233012527	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9630999999999998	1716233012527	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233013530	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233013530	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9630999999999998	1716233013530	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233014531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233014531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9630999999999998	1716233014531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233015534	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233015534	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9634	1716233015534	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233016536	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233016536	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9634	1716233016536	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233017539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233017539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9634	1716233017539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233018541	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233018541	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9653	1716233018541	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233019543	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233019543	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9653	1716233019543	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233020545	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233020545	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9653	1716233020545	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233021546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233021546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9669	1716233021546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233022548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233022548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9669	1716233022548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233023550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233023550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9669	1716233023550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233024552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233024552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9670999999999998	1716233024552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233025554	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233025554	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9670999999999998	1716233025554	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233026556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233026556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9670999999999998	1716233026556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233027558	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8	1716233027558	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9663	1716233027558	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233028560	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6	1716233028560	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9663	1716233028560	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233029562	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233029562	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9663	1716233029562	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233030564	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233030564	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9670999999999998	1716233030564	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233031566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233031566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9670999999999998	1716233031566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233032568	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233032568	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9670999999999998	1716233032568	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233033570	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233033570	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9654	1716233033570	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233034572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233034572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9654	1716233034572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233035574	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233035574	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9654	1716233035574	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233036576	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233036576	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9635	1716233036576	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233037578	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233037578	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9635	1716233037578	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233038579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233038579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9635	1716233038579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233039581	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233039581	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9647000000000001	1716233039581	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233040584	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233040584	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9647000000000001	1716233040584	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233041586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233041586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9647000000000001	1716233041586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233042588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233042588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9683	1716233042588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233043590	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233043590	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9683	1716233043590	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233044592	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233044592	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9683	1716233044592	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233045594	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233045594	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9694	1716233045594	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233046596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233046596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9694	1716233046596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233047597	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233047597	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9694	1716233047597	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233048599	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233048599	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9684000000000001	1716233048599	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233049601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233049601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9684000000000001	1716233049601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233410284	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233410284	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.988	1716233410284	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233411286	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233411286	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.988	1716233411286	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233412288	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233031590	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233032591	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233033590	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233034585	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233035595	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233036598	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233037600	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233038603	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233039599	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233040603	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233041607	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233042612	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233043611	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233044617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233045610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233046618	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233047622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233048622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233049618	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233050603	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233050603	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9684000000000001	1716233050603	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233050629	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233051605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233051605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.969	1716233051605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233051630	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233052606	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233052606	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.969	1716233052606	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233052627	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233053608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233053608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.969	1716233053608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233053622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233054610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233054610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9647000000000001	1716233054610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233054633	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233055611	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233055611	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9647000000000001	1716233055611	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233055630	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233056613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233056613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9647000000000001	1716233056613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233056634	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233057615	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233057615	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9662	1716233057615	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233057636	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233058617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233058617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9662	1716233058617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233058631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233059618	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233059618	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9662	1716233059618	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233059632	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233060620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233060620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9632	1716233060620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233060633	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233061622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233061622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9632	1716233061622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233062624	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233062624	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9632	1716233062624	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233063626	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233063626	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9657	1716233063626	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233064628	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233064628	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9657	1716233064628	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233065629	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233065629	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9657	1716233065629	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233066632	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233066632	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9665	1716233066632	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233067635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233067635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9665	1716233067635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233068636	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233068636	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9665	1716233068636	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233069638	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233069638	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9673	1716233069638	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233070640	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233070640	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9673	1716233070640	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233071642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233071642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9673	1716233071642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233072644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233072644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9658	1716233072644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233073645	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233073645	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9658	1716233073645	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233074648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233074648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9658	1716233074648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233075649	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233075649	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9670999999999998	1716233075649	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233076651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233076651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9670999999999998	1716233076651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233077653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233077653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9670999999999998	1716233077653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233078656	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233078656	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9681	1716233078656	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233079658	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.9	1716233079658	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9681	1716233079658	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233080660	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233080660	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9681	1716233080660	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233081661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233081661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9687000000000001	1716233081661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233082664	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233082664	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9687000000000001	1716233082664	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233061637	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233062639	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233063642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233064649	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233065650	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233066653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233067655	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233068659	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233069651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233070656	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233071665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233072665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233073667	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233074668	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233075667	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233076673	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233077676	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233078677	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233079671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233080681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233081682	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233082688	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233083689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233084682	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233085690	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233086692	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233087694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233088697	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233089693	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233090700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233091702	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233092704	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233093710	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233094704	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233095713	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233096715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233097715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233098717	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233099718	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233100715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233101725	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233102719	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233103730	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233104733	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233105724	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233106734	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233107737	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233108737	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233109734	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233110737	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233111736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233112748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233113749	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233114748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233115744	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233116752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233117754	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233118756	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233119760	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233120756	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233121756	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233122765	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233123757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233124773	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233125775	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233083666	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233083666	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9687000000000001	1716233083666	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233084668	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233084668	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9678	1716233084668	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233085670	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233085670	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9678	1716233085670	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233086671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233086671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9678	1716233086671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233087673	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233087673	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9692	1716233087673	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233088675	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233088675	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9692	1716233088675	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233089678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233089678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9692	1716233089678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233090680	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233090680	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9693	1716233090680	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233091682	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233091682	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9693	1716233091682	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233092684	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233092684	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9693	1716233092684	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233093687	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233093687	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.97	1716233093687	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233094689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233094689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.97	1716233094689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233095691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233095691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.97	1716233095691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233096693	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233096693	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.97	1716233096693	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233097694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233097694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.97	1716233097694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233098696	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233098696	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.97	1716233098696	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233099698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233099698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9698	1716233099698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233100700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233100700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9698	1716233100700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233101702	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233101702	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9698	1716233101702	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233102705	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233102705	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.969	1716233102705	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	99	1716233103707	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233103707	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.969	1716233103707	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233104709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233104709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.969	1716233104709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233105711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233105711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9694	1716233105711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233106712	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233106712	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9694	1716233106712	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233107715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233107715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9694	1716233107715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233108717	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233108717	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.972	1716233108717	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233109719	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233109719	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.972	1716233109719	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233110721	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233110721	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.972	1716233110721	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233111722	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233111722	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.97	1716233111722	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233112724	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233112724	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.97	1716233112724	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233113726	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233113726	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.97	1716233113726	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233114728	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233114728	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9718	1716233114728	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233115730	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233115730	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9718	1716233115730	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233116732	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233116732	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9718	1716233116732	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233117734	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233117734	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9735	1716233117734	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233118736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233118736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9735	1716233118736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233119737	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233119737	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9735	1716233119737	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233120739	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233120739	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9730999999999999	1716233120739	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233121741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233121741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9730999999999999	1716233121741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233122743	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233122743	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9730999999999999	1716233122743	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233123745	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233123745	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9679	1716233123745	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233124746	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233124746	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9679	1716233124746	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233125748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233125748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9679	1716233125748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233126750	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233126750	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9697	1716233126750	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233127752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233127752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9697	1716233127752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233128754	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233128754	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9697	1716233128754	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233129756	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233129756	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9716	1716233129756	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233130757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233130757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9716	1716233130757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233131759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233131759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9716	1716233131759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233132761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233132761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9722	1716233132761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233133763	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233133763	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9722	1716233133763	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233134765	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233134765	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9722	1716233134765	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233135767	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233135767	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9744000000000002	1716233135767	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233136769	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233136769	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9744000000000002	1716233136769	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233137771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233137771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9744000000000002	1716233137771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233138772	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233138772	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9727000000000001	1716233138772	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233139774	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233139774	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9727000000000001	1716233139774	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233140777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233140777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9727000000000001	1716233140777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233141779	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233141779	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9732	1716233141779	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233142781	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233142781	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9732	1716233142781	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233143783	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233143783	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9732	1716233143783	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233144785	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233144785	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.973	1716233144785	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233145786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233145786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.973	1716233145786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233146788	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233146788	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.973	1716233146788	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233126771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233127775	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233128775	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233129771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233130780	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233131781	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233132782	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233133787	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233134778	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233135790	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233136791	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233137793	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233138795	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233139790	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233140802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233141803	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233142807	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233143805	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233144799	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233145805	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233146809	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233147812	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233148814	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233149807	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233150818	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233151813	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233152822	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233153824	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233154825	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233155826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233156828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233157832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233158832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233159827	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233160836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233161837	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233162840	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233163842	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233164840	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233165846	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233166849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233167851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233168852	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233169846	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233410299	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233411300	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233412309	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233413312	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233414306	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233415319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233416308	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233417319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233418320	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233419315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233420315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233421326	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233422330	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233423335	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233424325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233425333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233426332	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233427338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233428340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233429340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233430335	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233147790	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233147790	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9713	1716233147790	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233148792	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233148792	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9713	1716233148792	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233149794	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233149794	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9713	1716233149794	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233150796	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233150796	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9714	1716233150796	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233151798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233151798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9714	1716233151798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233152800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233152800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9714	1716233152800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233153801	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233153801	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9739	1716233153801	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233154803	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233154803	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9739	1716233154803	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233155805	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.8999999999999995	1716233155805	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9739	1716233155805	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233156807	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.1	1716233156807	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9743	1716233156807	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233157809	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233157809	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9743	1716233157809	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233158811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233158811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9743	1716233158811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233159813	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233159813	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9732	1716233159813	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233160815	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233160815	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9732	1716233160815	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233161816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233161816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9732	1716233161816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233162819	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233162819	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9750999999999999	1716233162819	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233163821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233163821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9750999999999999	1716233163821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233164823	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233164823	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9750999999999999	1716233164823	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233165825	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233165825	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9750999999999999	1716233165825	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233166826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233166826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9750999999999999	1716233166826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233167828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233167828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9750999999999999	1716233167828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233168830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233168830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9742	1716233168830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233169832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233169832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9742	1716233169832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233170834	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233170834	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9742	1716233170834	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233170856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233171836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233171836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9722	1716233171836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233171858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233172838	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233172838	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9722	1716233172838	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233172863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233173840	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233173840	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9722	1716233173840	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233173863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233174841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233174841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9735	1716233174841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233174857	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233175843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233175843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9735	1716233175843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233175867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233176845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233176845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9735	1716233176845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233176866	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233177847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233177847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9764000000000002	1716233177847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233177868	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233178849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233178849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9764000000000002	1716233178849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233178873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233179851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233179851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9764000000000002	1716233179851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233179865	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716233180853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233180853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9749	1716233180853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233180874	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233181854	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233181854	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9749	1716233181854	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233181877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233182856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233182856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9749	1716233182856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233182877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233183858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233183858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9753	1716233183858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233183879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233184860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233184860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9753	1716233184860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233184876	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233185877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233186884	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233187888	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233188887	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233189883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233190885	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233191897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233192897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233193899	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233194892	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233195895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233196905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233197905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233198908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233199903	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233200908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233201917	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233202919	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233203921	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233204913	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233205923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233206926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233207926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233208920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233209923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233210931	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233211936	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233212935	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233213937	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233214931	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233215932	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233216941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233217945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233218945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233219939	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233220948	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233221953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233222953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233223956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233224950	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233225963	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233226963	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233227965	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233228966	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233229960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233230972	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233231972	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233232975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233233975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233234970	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233235979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233236983	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233237987	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233238977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233239980	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233240991	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233241990	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233242992	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233243996	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233244989	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233246003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233247001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233248002	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233249003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233185861	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233185861	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9753	1716233185861	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233186863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233186863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9757	1716233186863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233187865	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233187865	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9757	1716233187865	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233188867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233188867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9757	1716233188867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233189870	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233189870	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9755	1716233189870	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233190871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233190871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9755	1716233190871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233191873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233191873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9755	1716233191873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233192875	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233192875	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.952	1716233192875	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233193877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233193877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.952	1716233193877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233194879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233194879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.952	1716233194879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233195881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233195881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9716	1716233195881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233196883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233196883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9716	1716233196883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233197884	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233197884	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9716	1716233197884	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233198886	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233198886	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.973	1716233198886	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233199889	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233199889	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.973	1716233199889	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233200891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233200891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.973	1716233200891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233201893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233201893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.974	1716233201893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233202895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233202895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.974	1716233202895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233203897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233203897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.974	1716233203897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233204899	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233204899	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9744000000000002	1716233204899	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233205901	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233205901	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9744000000000002	1716233205901	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233206903	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233206903	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9744000000000002	1716233206903	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233207905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233207905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9755999999999998	1716233207905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233208907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233208907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9755999999999998	1716233208907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233209908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233209908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9755999999999998	1716233209908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233210910	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233210910	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9754	1716233210910	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233211911	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233211911	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9754	1716233211911	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233212913	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233212913	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9754	1716233212913	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233213915	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233213915	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9774	1716233213915	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233214917	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233214917	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9774	1716233214917	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233215919	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233215919	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9774	1716233215919	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233216921	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233216921	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9759	1716233216921	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233217923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233217923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9759	1716233217923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233218924	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233218924	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9759	1716233218924	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233219926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233219926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.977	1716233219926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233220928	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233220928	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.977	1716233220928	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233221930	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233221930	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.977	1716233221930	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233222932	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233222932	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9768	1716233222932	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716233223934	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233223934	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9768	1716233223934	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233224937	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233224937	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9768	1716233224937	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233225939	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233225939	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9764000000000002	1716233225939	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233226941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233226941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9764000000000002	1716233226941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233227942	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233227942	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9764000000000002	1716233227942	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233228944	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233228944	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9786	1716233228944	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233229946	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233229946	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9786	1716233229946	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233230948	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233230948	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9786	1716233230948	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233231950	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233231950	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9781	1716233231950	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233232953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233232953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9781	1716233232953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233233954	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233233954	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9781	1716233233954	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233234956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233234956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.977	1716233234956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233235958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233235958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.977	1716233235958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233236960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233236960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.977	1716233236960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233237962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233237962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9723	1716233237962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233238964	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233238964	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9723	1716233238964	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233239965	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233239965	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9723	1716233239965	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233240968	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233240968	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9775999999999998	1716233240968	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233241969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233241969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9775999999999998	1716233241969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233242971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233242971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9775999999999998	1716233242971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233243973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233243973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9777	1716233243973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233244975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233244975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9777	1716233244975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233245977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233245977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9777	1716233245977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233246979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233246979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9786	1716233246979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233247981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233247981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9786	1716233247981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233248983	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233248983	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9786	1716233248983	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233249985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233249985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9792	1716233249985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233250986	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233250986	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9792	1716233250986	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233251988	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233251988	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9792	1716233251988	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233252990	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233252990	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9808	1716233252990	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233253992	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233253992	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9808	1716233253992	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233254994	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233254994	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9808	1716233254994	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233255996	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233255996	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9794	1716233255996	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233256998	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233256998	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9794	1716233256998	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233257999	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233257999	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9794	1716233257999	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233259002	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233259002	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9732	1716233259002	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233260003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233260003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9732	1716233260003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233261005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233261005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9732	1716233261005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233262006	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233262006	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9764000000000002	1716233262006	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233263008	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233263008	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9764000000000002	1716233263008	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233264010	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233264010	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9764000000000002	1716233264010	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233265011	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233265011	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9775	1716233265011	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233266013	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233266013	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9775	1716233266013	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233267015	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233267015	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9775	1716233267015	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233268017	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233268017	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9784000000000002	1716233268017	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233269019	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233269019	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9784000000000002	1716233269019	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233270021	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233270021	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9784000000000002	1716233270021	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233271023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233249997	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233251007	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233252012	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233253013	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233254005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233255008	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233256016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233257018	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233258014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233259026	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233260016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233261024	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233262027	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233263033	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233264032	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233265034	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233266034	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233267030	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233268039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233269039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233270042	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233271044	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233272047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233273047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233274042	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233275051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233276054	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233277051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233278060	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233279060	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233280054	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233281056	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233282057	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233283059	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233284061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233285064	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233286073	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233287075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233288068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233289084	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233290081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233412288	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9862	1716233412288	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233413290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233413290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9862	1716233413290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233414291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233414291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9862	1716233414291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233415293	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233415293	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9918	1716233415293	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233416295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233416295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9918	1716233416295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233417297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233417297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9918	1716233417297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233418299	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233418299	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9919	1716233418299	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233419300	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233419300	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9919	1716233419300	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233420302	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233271023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9788	1716233271023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233272024	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233272024	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9788	1716233272024	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233273026	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233273026	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9788	1716233273026	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233274028	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233274028	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9784000000000002	1716233274028	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233275030	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233275030	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9784000000000002	1716233275030	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233276032	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233276032	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9784000000000002	1716233276032	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233277034	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233277034	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9799	1716233277034	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233278035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233278035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9799	1716233278035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233279037	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233279037	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9799	1716233279037	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233280039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233280039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9792	1716233280039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233281041	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233281041	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9792	1716233281041	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233282043	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233282043	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9792	1716233282043	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233283045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233283045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9763	1716233283045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233284047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233284047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9763	1716233284047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233285049	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233285049	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9763	1716233285049	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233286051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233286051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9777	1716233286051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233287053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233287053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9777	1716233287053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233288054	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233288054	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9777	1716233288054	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233289058	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233289058	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9779	1716233289058	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233290061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233290061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9779	1716233290061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716233291063	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233291063	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9779	1716233291063	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233291084	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233292065	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233292065	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9775	1716233292065	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233293066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233293066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9775	1716233293066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233294068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233294068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9775	1716233294068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233295070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233295070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9807000000000001	1716233295070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233296072	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233296072	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9807000000000001	1716233296072	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233297074	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233297074	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9807000000000001	1716233297074	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233298076	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233298076	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9824000000000002	1716233298076	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233299077	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233299077	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9824000000000002	1716233299077	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233300079	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233300079	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9824000000000002	1716233300079	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233301081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233301081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.982	1716233301081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233302083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233302083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.982	1716233302083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233303085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233303085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.982	1716233303085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233304087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233304087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9789	1716233304087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233305089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233305089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9789	1716233305089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233306090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.999999999999999	1716233306090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9789	1716233306090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233307092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.199999999999999	1716233307092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9807000000000001	1716233307092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233308094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233308094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9807000000000001	1716233308094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233309096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233309096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9807000000000001	1716233309096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233310098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233310098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9812	1716233310098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233311100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233311100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9812	1716233311100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233312101	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233312101	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9812	1716233312101	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233313103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233313103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233292085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233293089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233294090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233295085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233296093	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233297095	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233298098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233299091	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233300092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233301102	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233302105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233303098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233304108	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233305112	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233306113	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233307113	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233308115	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233309117	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233310112	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233311121	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233312123	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233313123	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233314126	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233315121	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233316131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233317133	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233318128	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233319128	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233320138	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233321140	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233322142	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233323145	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233324145	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233325142	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233326143	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233327153	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233328154	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233329149	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233330151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233331159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233332160	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233333164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233334164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233335164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233336171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233337166	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233338174	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233339174	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233340169	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233341178	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233342176	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233343183	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233344180	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233345179	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233346184	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233347183	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233348185	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233349193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233350196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233351190	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233352192	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233353196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233354205	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233355199	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233356207	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9823	1716233313103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233314105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233314105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9823	1716233314105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233315107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233315107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9823	1716233315107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233316109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233316109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9827000000000001	1716233316109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233317111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233317111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9827000000000001	1716233317111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233318113	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233318113	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9827000000000001	1716233318113	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233319115	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233319115	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9817	1716233319115	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233320116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233320116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9817	1716233320116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233321118	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233321118	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9817	1716233321118	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233322120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233322120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9812	1716233322120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233323122	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233323122	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9812	1716233323122	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233324124	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233324124	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9812	1716233324124	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233325126	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233325126	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9806	1716233325126	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233326128	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233326128	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9806	1716233326128	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233327129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233327129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9806	1716233327129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233328131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233328131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9815999999999998	1716233328131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233329133	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233329133	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9815999999999998	1716233329133	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233330135	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233330135	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9815999999999998	1716233330135	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233331137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233331137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9801	1716233331137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233332139	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233332139	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9801	1716233332139	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233333141	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233333141	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9801	1716233333141	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233334143	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233334143	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9818	1716233334143	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233335145	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233335145	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9818	1716233335145	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233336147	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233336147	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9818	1716233336147	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233337149	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233337149	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9834	1716233337149	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233338151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233338151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9834	1716233338151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233339153	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233339153	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9834	1716233339153	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233340155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233340155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9838	1716233340155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233341157	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233341157	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9838	1716233341157	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233342159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233342159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9838	1716233342159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233343161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233343161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9844000000000002	1716233343161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233344163	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233344163	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9844000000000002	1716233344163	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233345165	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233345165	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9844000000000002	1716233345165	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233346167	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233346167	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9857	1716233346167	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233347169	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233347169	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9857	1716233347169	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233348171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233348171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9857	1716233348171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233349172	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233349172	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9823	1716233349172	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233350174	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233350174	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9823	1716233350174	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233351176	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233351176	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9823	1716233351176	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233352178	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233352178	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9853	1716233352178	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233353180	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233353180	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9853	1716233353180	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233354181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233354181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9853	1716233354181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233355183	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233355183	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.987	1716233355183	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233356185	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233356185	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.987	1716233356185	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233357187	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233357187	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.987	1716233357187	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233358189	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233358189	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9874	1716233358189	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233359191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233359191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9874	1716233359191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233360193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233360193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9874	1716233360193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233361195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233361195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9858	1716233361195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233362196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233362196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9858	1716233362196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233363198	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233363198	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9858	1716233363198	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233364200	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233364200	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9859	1716233364200	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233365201	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233365201	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9859	1716233365201	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233366203	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233366203	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9859	1716233366203	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233367206	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233367206	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9864000000000002	1716233367206	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233368208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233368208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9864000000000002	1716233368208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233369210	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233369210	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9864000000000002	1716233369210	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233370212	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233370212	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9823	1716233370212	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233371214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233371214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9823	1716233371214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233372215	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233372215	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9823	1716233372215	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233373217	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233373217	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.986	1716233373217	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233374219	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233374219	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.986	1716233374219	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233375221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233375221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.986	1716233375221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233376223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233376223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9872	1716233376223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233377225	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233377225	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233357215	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233358212	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233359213	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233360208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233361215	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233362219	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233363221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233364218	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233365223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233366224	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233367229	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233368231	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233369230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233370225	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233371236	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233372237	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233373241	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233374234	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233375236	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233376244	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233377245	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233378250	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233379243	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233380250	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233381254	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233382255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233383258	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233384258	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233385254	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233386256	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233387264	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233388267	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233389272	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233390261	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233391271	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233392273	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233393274	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233394277	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233395280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233396280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233397282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233398284	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233399285	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233400280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233401291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233402291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233403292	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233404295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233405290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233406297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233407300	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233408301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233409295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233420302	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9919	1716233420302	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233421304	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233421304	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9922	1716233421304	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233422306	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233422306	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9922	1716233422306	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233423308	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233423308	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9922	1716233423308	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233424310	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9872	1716233377225	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233378226	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233378226	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9872	1716233378226	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233379228	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233379228	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9874	1716233379228	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233380230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233380230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9874	1716233380230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233381231	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233381231	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9874	1716233381231	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233382233	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233382233	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9855	1716233382233	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233383235	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233383235	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9855	1716233383235	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233384237	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233384237	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9855	1716233384237	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233385239	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233385239	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9865	1716233385239	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233386240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233386240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9865	1716233386240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233387242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233387242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9865	1716233387242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233388244	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233388244	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9881	1716233388244	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233389246	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233389246	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9881	1716233389246	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233390248	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233390248	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9881	1716233390248	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233391250	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233391250	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9847000000000001	1716233391250	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233392252	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233392252	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9847000000000001	1716233392252	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233393254	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233393254	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9847000000000001	1716233393254	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233394255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233394255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9859	1716233394255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233395257	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233395257	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9859	1716233395257	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233396259	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233396259	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9859	1716233396259	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233397261	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233397261	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9882	1716233397261	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233398263	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233398263	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9882	1716233398263	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233399265	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233399265	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9882	1716233399265	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233400267	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233400267	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9890999999999999	1716233400267	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233401268	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233401268	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9890999999999999	1716233401268	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233402270	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233402270	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9890999999999999	1716233402270	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233403271	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233403271	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9872	1716233403271	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233404273	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233404273	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9872	1716233404273	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233405275	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233405275	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9872	1716233405275	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233406277	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233406277	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9875	1716233406277	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233407279	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233407279	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9875	1716233407279	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233408280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.1	1716233408280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9875	1716233408280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233409282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.3	1716233409282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.988	1716233409282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233424310	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9910999999999999	1716233424310	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233425311	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233425311	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9910999999999999	1716233425311	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233426313	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233426313	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9910999999999999	1716233426313	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233427315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233427315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9934	1716233427315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233428317	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233428317	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9934	1716233428317	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233429319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233429319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9934	1716233429319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233430321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233430321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9932999999999998	1716233430321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233431323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233431323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9932999999999998	1716233431323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233431344	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233432325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233432325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9932999999999998	1716233432325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233432349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233433326	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233433326	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9915	1716233433326	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233433348	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233434349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233435343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233436345	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233437356	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233438358	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233439352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233440363	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233441364	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233442364	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233443366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233444360	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233445369	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233446365	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233447373	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233448374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233449370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233450373	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233451375	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233452384	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233453388	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233454379	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233455390	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233456385	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233457393	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233458396	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233459398	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233460392	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233461394	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233462404	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233463397	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233464405	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233465400	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233466402	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233467412	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233468413	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233469408	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234010411	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234010411	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0808	1716234010411	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234011413	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234011413	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0808	1716234011413	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234012415	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234012415	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0801999999999996	1716234012415	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234013417	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234013417	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0801999999999996	1716234013417	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234014419	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234014419	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0801999999999996	1716234014419	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234015421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234015421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0757	1716234015421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234016423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234016423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0757	1716234016423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234017425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234017425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0757	1716234017425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234018427	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234018427	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0774	1716234018427	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234019428	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233434328	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233434328	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9915	1716233434328	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233435330	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233435330	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9915	1716233435330	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233436331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233436331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9954	1716233436331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233437334	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233437334	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9954	1716233437334	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233438336	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233438336	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9954	1716233438336	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233439338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233439338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9919	1716233439338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233440340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233440340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9919	1716233440340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233441341	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233441341	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9919	1716233441341	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233442343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233442343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.994	1716233442343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233443345	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233443345	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.994	1716233443345	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233444347	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233444347	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.994	1716233444347	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233445349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233445349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9943	1716233445349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233446350	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233446350	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9943	1716233446350	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233447352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233447352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9943	1716233447352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233448354	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233448354	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9935999999999998	1716233448354	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233449356	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233449356	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9935999999999998	1716233449356	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233450359	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233450359	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9935999999999998	1716233450359	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233451361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233451361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9950999999999999	1716233451361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233452363	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233452363	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9950999999999999	1716233452363	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233453364	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233453364	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9950999999999999	1716233453364	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233454366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233454366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9895	1716233454366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233455368	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233455368	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9895	1716233455368	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233456370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233456370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9895	1716233456370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233457372	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233457372	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9912	1716233457372	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233458374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233458374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9912	1716233458374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233459376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233459376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9912	1716233459376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233460378	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233460378	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9921	1716233460378	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233461379	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233461379	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9921	1716233461379	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233462381	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233462381	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9921	1716233462381	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233463383	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233463383	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9926	1716233463383	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233464385	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233464385	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9926	1716233464385	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233465387	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233465387	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9926	1716233465387	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233466389	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233466389	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.967	1716233466389	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233467391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.3	1716233467391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.967	1716233467391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233468393	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233468393	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.967	1716233468393	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233469395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233469395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9743	1716233469395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233470398	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233470398	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9743	1716233470398	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233470413	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233471400	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233471400	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9743	1716233471400	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233471418	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233472401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233472401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9810999999999999	1716233472401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233472424	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233473403	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233473403	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9810999999999999	1716233473403	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233473424	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233474405	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233474405	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9810999999999999	1716233474405	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233474419	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233475407	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233475407	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9892999999999998	1716233475407	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233476408	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233476408	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9892999999999998	1716233476408	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233477410	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233477410	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9892999999999998	1716233477410	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233478412	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233478412	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9906	1716233478412	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233479414	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233479414	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9906	1716233479414	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233480417	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233480417	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9906	1716233480417	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233481419	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233481419	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9949000000000001	1716233481419	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233482421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233482421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9949000000000001	1716233482421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233483423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233483423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9949000000000001	1716233483423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233484425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233484425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9963	1716233484425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233485428	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233485428	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9963	1716233485428	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233486430	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233486430	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9963	1716233486430	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233487432	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233487432	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9944000000000002	1716233487432	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233488435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233488435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9944000000000002	1716233488435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233489437	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233489437	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9944000000000002	1716233489437	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233490439	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233490439	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9946	1716233490439	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233491441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233491441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9946	1716233491441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233492444	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233492444	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9946	1716233492444	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233493446	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233493446	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9945	1716233493446	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233494448	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233494448	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9945	1716233494448	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233495450	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233495450	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9945	1716233495450	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233496451	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233475420	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233476427	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233477431	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233478435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233479430	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233480444	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233481434	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233482442	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233483446	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233484437	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233485448	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233486443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233487452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233488457	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233489462	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233490453	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233491454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233492466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233493468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233494469	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233495463	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233496468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233497477	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233498479	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233499471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233500480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233501474	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233502484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233503485	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233504480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233505490	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233506487	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233507496	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233508498	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233509494	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233510500	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233511493	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233512503	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233513504	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233514503	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233515513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233516506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233517516	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233518516	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233519518	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233520512	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233521513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233522521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233523527	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233524526	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233525520	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233526522	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233527531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233528534	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233529536	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233530541	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233531534	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233532541	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233533542	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233534537	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233535546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233536542	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233537552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233538552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233539548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233496451	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9906	1716233496451	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233497453	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233497453	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9906	1716233497453	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233498455	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233498455	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9906	1716233498455	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233499457	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233499457	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9952	1716233499457	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233500459	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233500459	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9952	1716233500459	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233501460	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233501460	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9952	1716233501460	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233502462	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233502462	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9994	1716233502462	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233503464	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233503464	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9994	1716233503464	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233504466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233504466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9994	1716233504466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233505468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233505468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9999	1716233505468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233506470	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233506470	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9999	1716233506470	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233507472	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233507472	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9999	1716233507472	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233508474	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233508474	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0002999999999997	1716233508474	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233509476	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233509476	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0002999999999997	1716233509476	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233510478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233510478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0002999999999997	1716233510478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233511480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233511480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0007	1716233511480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233512482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233512482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0007	1716233512482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233513484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233513484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0007	1716233513484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233514486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233514486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0004	1716233514486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233515489	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233515489	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0004	1716233515489	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233516491	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233516491	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0004	1716233516491	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233517492	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233517492	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9972	1716233517492	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233518494	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233518494	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9972	1716233518494	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233519495	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233519495	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9972	1716233519495	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233520497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233520497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.997	1716233520497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233521499	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233521499	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.997	1716233521499	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233522501	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233522501	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.997	1716233522501	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233523503	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233523503	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0005	1716233523503	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233524505	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233524505	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0005	1716233524505	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233525507	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233525507	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0005	1716233525507	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233526509	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233526509	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0029	1716233526509	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233527510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233527510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0029	1716233527510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233528512	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233528512	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0029	1716233528512	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233529514	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233529514	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9998	1716233529514	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233530516	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233530516	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9998	1716233530516	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233531518	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233531518	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9998	1716233531518	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233532520	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233532520	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0031	1716233532520	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233533522	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233533522	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0031	1716233533522	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233534524	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233534524	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0031	1716233534524	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233535525	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233535525	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0021	1716233535525	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233536527	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233536527	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0021	1716233536527	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233537529	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233537529	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0021	1716233537529	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233538531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233538531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0000999999999998	1716233538531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233539533	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233539533	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0000999999999998	1716233539533	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233540535	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233540535	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0000999999999998	1716233540535	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233541537	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233541537	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9795	1716233541537	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233542539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233542539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9795	1716233542539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233543541	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233543541	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9795	1716233543541	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233544543	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233544543	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9815999999999998	1716233544543	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233545545	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233545545	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9815999999999998	1716233545545	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233546546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233546546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9815999999999998	1716233546546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233547548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233547548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9821	1716233547548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233548550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233548550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9821	1716233548550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233549552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233549552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9821	1716233549552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233550554	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233550554	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9838	1716233550554	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233551556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233551556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9838	1716233551556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233552557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233552557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9838	1716233552557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233553559	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233553559	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9849	1716233553559	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233554561	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233554561	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9849	1716233554561	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233555563	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233555563	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9849	1716233555563	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233556565	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233556565	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9881	1716233556565	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233557567	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233557567	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9881	1716233557567	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233558569	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233558569	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9881	1716233558569	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233559571	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233559571	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9869	1716233559571	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233560572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233540556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233541550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233542559	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233543564	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233544557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233545569	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233546560	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233547567	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233548572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233549565	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233550576	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233551569	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233552579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233553580	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233554575	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233555586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233556579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233557589	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233558595	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233559592	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233560586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233561588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233562600	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233563593	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233564600	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233565595	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233566596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233567605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233568606	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233569611	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233570611	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233571604	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233572614	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233573616	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233574614	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233575617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233576613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233577623	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233578625	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233579620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233580630	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233581622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233582627	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233583638	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233584628	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233585637	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233586631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233587641	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233588643	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233589638	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233590648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233591640	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233592642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233593652	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233594654	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233595648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233596649	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233597659	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233598663	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233599667	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233600658	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233601661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233602671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233603672	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233604672	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233560572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9869	1716233560572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233561574	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233561574	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9869	1716233561574	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233562576	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233562576	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9883	1716233562576	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233563578	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233563578	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9883	1716233563578	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233564580	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233564580	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9883	1716233564580	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233565581	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233565581	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.99	1716233565581	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233566583	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233566583	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.99	1716233566583	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233567585	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233567585	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.99	1716233567585	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233568586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.200000000000001	1716233568586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.989	1716233568586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233569588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.4	1716233569588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.989	1716233569588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233570589	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233570589	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.989	1716233570589	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233571591	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233571591	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9883	1716233571591	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233572593	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233572593	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9883	1716233572593	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233573595	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233573595	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9883	1716233573595	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233574597	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233574597	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9895	1716233574597	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233575599	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233575599	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9895	1716233575599	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233576601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233576601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9895	1716233576601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233577602	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233577602	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9904000000000002	1716233577602	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233578604	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233578604	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9904000000000002	1716233578604	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233579606	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233579606	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9904000000000002	1716233579606	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233580608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233580608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9908	1716233580608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233581610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233581610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9908	1716233581610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233582611	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233582611	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9908	1716233582611	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233583613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233583613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9910999999999999	1716233583613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233584615	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233584615	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9910999999999999	1716233584615	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233585617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233585617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9910999999999999	1716233585617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233586619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233586619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9946	1716233586619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233587620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233587620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9946	1716233587620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233588622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233588622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9946	1716233588622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233589624	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233589624	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9972999999999999	1716233589624	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233590626	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233590626	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9972999999999999	1716233590626	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233591628	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233591628	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9972999999999999	1716233591628	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233592630	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233592630	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9990999999999999	1716233592630	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233593631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233593631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9990999999999999	1716233593631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233594633	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233594633	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9990999999999999	1716233594633	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233595635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233595635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9999	1716233595635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233596637	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233596637	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9999	1716233596637	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233597639	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233597639	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9999	1716233597639	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233598641	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233598641	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.001	1716233598641	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233599642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233599642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.001	1716233599642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233600644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233600644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.001	1716233600644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233601646	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233601646	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9997	1716233601646	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233602648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233602648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9997	1716233602648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233603650	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233603650	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9997	1716233603650	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233604651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233604651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0008	1716233604651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233605653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233605653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0008	1716233605653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233606655	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233606655	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0008	1716233606655	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233607657	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233607657	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0025999999999997	1716233607657	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233608659	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233608659	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0025999999999997	1716233608659	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233609660	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716233609660	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0025999999999997	1716233609660	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233610661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233610661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9995999999999998	1716233610661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233611663	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233611663	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9995999999999998	1716233611663	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233612665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233612665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9995999999999998	1716233612665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233613667	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233613667	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0014000000000003	1716233613667	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233614669	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233614669	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0014000000000003	1716233614669	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233615670	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233615670	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0014000000000003	1716233615670	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233616672	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233616672	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0004	1716233616672	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233617674	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233617674	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0004	1716233617674	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233618676	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233618676	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0004	1716233618676	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233619678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233619678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0019	1716233619678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233620680	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233620680	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0019	1716233620680	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233621681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233621681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0019	1716233621681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233622683	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233622683	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9992	1716233622683	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233623685	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233623685	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9992	1716233623685	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233624687	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233605671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233606674	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233607677	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233608679	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233609682	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233610675	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233611683	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233612686	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233613687	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233614690	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233615684	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233616694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233617697	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233618697	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233619698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233620702	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233621704	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233622709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233623706	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233624708	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233625703	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233626711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233627713	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233628715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233629718	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233630712	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233631722	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233632723	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233633723	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233634718	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233635720	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233636729	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233637731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233638733	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233639729	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233640729	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233641744	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233642741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233643742	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233644738	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233645747	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233646753	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233647752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233648752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233649748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234010426	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234011436	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234012436	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234013438	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234014433	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234015438	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234016446	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234017446	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234018448	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234019444	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234020456	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234021456	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234022458	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234023457	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234024455	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234025454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234026463	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234027463	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234028465	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234029460	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233624687	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	1.9992	1716233624687	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233625689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233625689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0013	1716233625689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233626691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233626691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0013	1716233626691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233627693	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233627693	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0013	1716233627693	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233628694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233628694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0022	1716233628694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233629696	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233629696	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0022	1716233629696	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233630698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233630698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0022	1716233630698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233631700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233631700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0045	1716233631700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233632702	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233632702	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0045	1716233632702	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233633703	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233633703	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0045	1716233633703	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233634705	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233634705	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0047	1716233634705	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233635706	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233635706	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0047	1716233635706	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233636708	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233636708	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0047	1716233636708	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233637710	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233637710	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0055	1716233637710	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233638712	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233638712	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0055	1716233638712	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233639714	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233639714	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0055	1716233639714	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233640716	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233640716	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0046	1716233640716	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233641718	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233641718	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0046	1716233641718	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233642719	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233642719	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0046	1716233642719	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233643721	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233643721	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0072	1716233643721	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233644723	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233644723	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0072	1716233644723	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233645725	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.5	1716233645725	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0072	1716233645725	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233646727	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.3	1716233646727	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0082999999999998	1716233646727	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233647729	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233647729	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0082999999999998	1716233647729	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233648731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233648731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0082999999999998	1716233648731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233649733	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233649733	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0082	1716233649733	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233650735	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233650735	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0082	1716233650735	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233650759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233651736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233651736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0082	1716233651736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233651758	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233652738	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233652738	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0091	1716233652738	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233652761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233653740	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233653740	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0091	1716233653740	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233653763	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233654741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233654741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0091	1716233654741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233654756	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233655742	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233655742	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0085	1716233655742	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233655756	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233656744	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233656744	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0085	1716233656744	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233656767	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233657746	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233657746	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0085	1716233657746	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233657769	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233658748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233658748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0078	1716233658748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233658769	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233659750	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233659750	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0078	1716233659750	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233659772	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233660751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233660751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0078	1716233660751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233660765	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233661753	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233661753	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0099	1716233661753	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233661774	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233662755	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233662755	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0099	1716233662755	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233662776	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233663781	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233664773	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233665774	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233666783	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233667787	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233668787	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233669783	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233670795	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233671793	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233672798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233673798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233674792	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233675803	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233676803	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233677808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233678811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233679801	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233680809	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233681812	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233682812	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233683816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233684808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233685817	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233686821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233687822	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233688823	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233689819	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233690832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233691830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233692833	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233693833	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233694835	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233695838	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233696841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233697842	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233698845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233699840	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233700849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233701851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233702853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233703855	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233704847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233705857	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233706860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233707857	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233708863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233709864	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233710867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233711868	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233712868	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233713869	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233714864	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233715873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233716875	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233717878	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233718883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233719874	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233720888	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233721884	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233722887	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233723888	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233724893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233725894	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233726896	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233663757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233663757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0099	1716233663757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233664759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233664759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0116	1716233664759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233665761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233665761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0116	1716233665761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233666762	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233666762	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0116	1716233666762	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233667764	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233667764	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0094000000000003	1716233667764	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233668766	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233668766	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0094000000000003	1716233668766	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233669768	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233669768	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0094000000000003	1716233669768	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233670770	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233670770	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0094000000000003	1716233670770	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233671771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233671771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0094000000000003	1716233671771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233672773	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233672773	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0094000000000003	1716233672773	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233673775	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233673775	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.01	1716233673775	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233674777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233674777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.01	1716233674777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233675778	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233675778	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.01	1716233675778	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233676780	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233676780	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0116	1716233676780	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233677782	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233677782	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0116	1716233677782	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233678784	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233678784	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0116	1716233678784	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233679786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233679786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0093	1716233679786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233680788	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233680788	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0093	1716233680788	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233681790	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233681790	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0093	1716233681790	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233682791	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233682791	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0118	1716233682791	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233683793	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233683793	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0118	1716233683793	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233684795	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233684795	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0118	1716233684795	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233685797	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233685797	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0134000000000003	1716233685797	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233686799	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233686799	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0134000000000003	1716233686799	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233687800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233687800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0134000000000003	1716233687800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233688802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233688802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0097	1716233688802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233689804	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233689804	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0097	1716233689804	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233690806	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233690806	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0097	1716233690806	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233691808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233691808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.011	1716233691808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233692811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233692811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.011	1716233692811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233693813	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233693813	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.011	1716233693813	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233694815	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233694815	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0131	1716233694815	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233695817	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233695817	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0131	1716233695817	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233696819	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233696819	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0131	1716233696819	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233697821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233697821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0143	1716233697821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233698822	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233698822	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0143	1716233698822	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233699824	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233699824	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0143	1716233699824	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233700826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233700826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0158	1716233700826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233701828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233701828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0158	1716233701828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233702830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233702830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0158	1716233702830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233703832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233703832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0156	1716233703832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233704834	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233704834	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0156	1716233704834	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233705835	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233705835	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0156	1716233705835	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233706837	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233706837	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0137	1716233706837	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233707839	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233707839	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0137	1716233707839	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233708841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233708841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0137	1716233708841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233709843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233709843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0088	1716233709843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233710845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233710845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0088	1716233710845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233711847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233711847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0088	1716233711847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233712848	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233712848	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.012	1716233712848	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233713849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233713849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.012	1716233713849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233714851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233714851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.012	1716233714851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716233715853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233715853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.011	1716233715853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233716854	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233716854	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.011	1716233716854	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233717856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233717856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.011	1716233717856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233718858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233718858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0131	1716233718858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233719860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233719860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0131	1716233719860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233720862	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233720862	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0131	1716233720862	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233721864	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233721864	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0145999999999997	1716233721864	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233722866	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233722866	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0145999999999997	1716233722866	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233723867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233723867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0145999999999997	1716233723867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233724870	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233724870	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0157	1716233724870	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233725871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233725871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0157	1716233725871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233726873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716233726873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0157	1716233726873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233727875	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233727875	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0155	1716233727875	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233728877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233728877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0155	1716233728877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233729879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233729879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0155	1716233729879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233730881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233730881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0125	1716233730881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233731883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233731883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0125	1716233731883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233732885	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233732885	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0125	1716233732885	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233733886	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233733886	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0135	1716233733886	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233734888	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233734888	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0135	1716233734888	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233735890	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233735890	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0135	1716233735890	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233736891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233736891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0155	1716233736891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233737893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233737893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0155	1716233737893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233738895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233738895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0155	1716233738895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233739897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233739897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0162	1716233739897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233740899	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233740899	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0162	1716233740899	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233741900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233741900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0162	1716233741900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233742902	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233742902	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0148	1716233742902	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233743905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233743905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0148	1716233743905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233744907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233744907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0148	1716233744907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233745909	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233745909	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0169	1716233745909	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233746911	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233746911	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0169	1716233746911	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233747912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233747912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0169	1716233747912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233748914	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233727897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233728897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233729894	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233730901	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233731908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233732908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233733905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233734903	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233735910	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233736912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233737907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233738915	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233739918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233740921	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233741914	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233742925	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233743928	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233744922	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233745930	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233746934	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233747933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233748936	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233749932	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233750941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233751944	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233752937	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233753944	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233754945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233755948	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233756950	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233757945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233758953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233759949	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233760957	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233761959	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233762956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233763963	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233764958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233765958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233766961	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233767962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233768973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233769974	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233770975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233771977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233772971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233773981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233774977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233775989	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233776987	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233777981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233778992	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233779985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233780995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233781995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233782991	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233784000	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233785001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233786004	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233787007	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233788003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233789011	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233790006	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233791006	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233792016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233748914	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0161	1716233748914	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233749916	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233749916	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0161	1716233749916	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233750918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233750918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0161	1716233750918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233751920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233751920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0129	1716233751920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233752922	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233752922	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0129	1716233752922	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233753924	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233753924	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0129	1716233753924	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233754925	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233754925	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0196	1716233754925	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233755927	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233755927	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0196	1716233755927	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233756929	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233756929	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0196	1716233756929	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233757931	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233757931	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0176	1716233757931	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233758933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233758933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0176	1716233758933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233759935	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233759935	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0176	1716233759935	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233760937	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233760937	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0185999999999997	1716233760937	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233761938	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233761938	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0185999999999997	1716233761938	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233762940	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233762940	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0185999999999997	1716233762940	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233763941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233763941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0178	1716233763941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233764943	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233764943	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0178	1716233764943	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233765945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233765945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0178	1716233765945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233766947	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233766947	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0292	1716233766947	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233767949	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233767949	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0292	1716233767949	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233768951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233768951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0292	1716233768951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233769952	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233769952	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0316	1716233769952	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233770954	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233770954	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0316	1716233770954	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233771956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233771956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0316	1716233771956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233772958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233772958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0184	1716233772958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233773960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233773960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0184	1716233773960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233774962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233774962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0184	1716233774962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233775964	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233775964	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0476	1716233775964	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233776965	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233776965	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0476	1716233776965	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233777967	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233777967	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0476	1716233777967	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233778969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233778969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0505999999999998	1716233778969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233779971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233779971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0505999999999998	1716233779971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233780973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233780973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0505999999999998	1716233780973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233781975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233781975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0496	1716233781975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233782977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233782977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0496	1716233782977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233783979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233783979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0496	1716233783979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233784980	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233784980	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0501	1716233784980	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233785982	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233785982	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0501	1716233785982	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233786984	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233786984	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0501	1716233786984	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233787987	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233787987	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0435	1716233787987	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233788988	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233788988	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0435	1716233788988	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233789991	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233789991	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0435	1716233789991	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233790993	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233790993	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0456	1716233790993	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233791995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233791995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0456	1716233791995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233792997	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233792997	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0456	1716233792997	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233793998	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233793998	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0490999999999997	1716233793998	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233795000	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233795000	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0490999999999997	1716233795000	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233796001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.4	1716233796001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0490999999999997	1716233796001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233797003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.6	1716233797003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.05	1716233797003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233798005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233798005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.05	1716233798005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233799007	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233799007	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.05	1716233799007	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233800009	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233800009	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0505999999999998	1716233800009	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233801012	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233801012	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0505999999999998	1716233801012	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233802014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233802014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0523000000000002	1716233802014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233803015	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233803015	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0523000000000002	1716233803015	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233804017	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233804017	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0523000000000002	1716233804017	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233805019	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233805019	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0514	1716233805019	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233806021	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233806021	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0514	1716233806021	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233807023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233807023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0514	1716233807023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233808025	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233808025	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0517	1716233808025	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233809027	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233809027	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0517	1716233809027	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233810028	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233810028	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0517	1716233810028	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233811030	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233811030	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.052	1716233811030	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233812033	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233812033	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.052	1716233812033	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233813035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233793012	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233794021	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233795014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233796019	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233797024	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233798022	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233799033	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233800034	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233801035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233802036	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233803030	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233804039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233805034	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233806042	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233807045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233808039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233809048	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233810049	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233811053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233812054	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233813058	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233814058	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233815059	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233816063	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233817057	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233818067	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233819067	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233820064	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233821077	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233822078	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233823078	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233824080	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233825075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233826081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233827082	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233828085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233829079	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233830090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234019428	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0774	1716234019428	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234020430	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234020430	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0774	1716234020430	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234021432	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234021432	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.07	1716234021432	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234022434	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234022434	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.07	1716234022434	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234023436	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234023436	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.07	1716234023436	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234024438	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234024438	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0763000000000003	1716234024438	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234025440	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234025440	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0763000000000003	1716234025440	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234026441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234026441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0763000000000003	1716234026441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234027443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234027443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0772	1716234027443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234028445	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233813035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.052	1716233813035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233814037	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233814037	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0519000000000003	1716233814037	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233815039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233815039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0519000000000003	1716233815039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233816041	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233816041	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0519000000000003	1716233816041	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233817043	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233817043	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0525	1716233817043	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233818045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233818045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0525	1716233818045	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233819047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233819047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0525	1716233819047	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233820050	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233820050	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0507	1716233820050	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233821053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233821053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0507	1716233821053	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233822055	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233822055	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0507	1716233822055	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233823057	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233823057	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0532	1716233823057	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233824058	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233824058	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0532	1716233824058	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233825061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233825061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0532	1716233825061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233826061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716233826061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0528000000000004	1716233826061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233827062	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233827062	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0528000000000004	1716233827062	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233828064	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233828064	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0528000000000004	1716233828064	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233829066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233829066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0529	1716233829066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233830068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233830068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0529	1716233830068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233831070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233831070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0529	1716233831070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233831091	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233832071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233832071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0515	1716233832071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233832094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233833073	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233833073	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0515	1716233833073	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233833095	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233834092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233835100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233836102	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233837106	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233838105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233839100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233840100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233841109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233842112	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233843116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233844109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233845120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233846120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233847121	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233848122	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233849124	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233850120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233851129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233852129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233853132	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233854131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233855130	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233856137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233857139	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233858144	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233859138	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233860147	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233861146	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233862148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233863153	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233864152	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233865156	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233866158	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233867158	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233868159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233869162	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233870160	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233871166	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233872168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233873162	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233874175	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233875165	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233876179	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233877176	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233878177	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233879182	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233880176	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233881185	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233882185	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233883187	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233884188	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233885182	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233886196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233887196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233888198	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233889190	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233890206	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233891203	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233892204	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233893209	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233894210	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233895204	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233896212	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233897214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233834075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233834075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0515	1716233834075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233835077	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233835077	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0522	1716233835077	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233836079	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233836079	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0522	1716233836079	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233837081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233837081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0522	1716233837081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233838083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233838083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0525	1716233838083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233839085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233839085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0525	1716233839085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233840087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233840087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0525	1716233840087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233841089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233841089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0496	1716233841089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233842090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233842090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0496	1716233842090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233843093	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233843093	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0496	1716233843093	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233844094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233844094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0505999999999998	1716233844094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233845096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233845096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0505999999999998	1716233845096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233846098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233846098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0505999999999998	1716233846098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233847100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233847100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0542	1716233847100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233848102	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233848102	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0542	1716233848102	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233849103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233849103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0542	1716233849103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233850105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233850105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0526999999999997	1716233850105	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233851106	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233851106	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0526999999999997	1716233851106	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233852108	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233852108	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0526999999999997	1716233852108	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233853110	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233853110	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0524	1716233853110	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233854111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233854111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0524	1716233854111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233855113	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233855113	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0524	1716233855113	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233856115	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233856115	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0536999999999996	1716233856115	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233857117	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233857117	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0536999999999996	1716233857117	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233858119	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233858119	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0536999999999996	1716233858119	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233859121	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233859121	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0529	1716233859121	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233860123	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233860123	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0529	1716233860123	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233861125	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233861125	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0529	1716233861125	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233862127	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233862127	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0536999999999996	1716233862127	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233863129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233863129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0536999999999996	1716233863129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233864131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233864131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0536999999999996	1716233864131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233865132	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233865132	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0553000000000003	1716233865132	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233866134	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233866134	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0553000000000003	1716233866134	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233867136	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233867136	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0553000000000003	1716233867136	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233868138	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233868138	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0555	1716233868138	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233869140	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233869140	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0555	1716233869140	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233870142	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233870142	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0555	1716233870142	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233871144	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233871144	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0606999999999998	1716233871144	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233872146	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233872146	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0606999999999998	1716233872146	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233873148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233873148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0606999999999998	1716233873148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233874150	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233874150	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0628	1716233874150	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233875151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233875151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0628	1716233875151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233876154	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233876154	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0628	1716233876154	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233877155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233877155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0665999999999998	1716233877155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233878157	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233878157	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0665999999999998	1716233878157	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233879159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233879159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0665999999999998	1716233879159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233880161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233880161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0736	1716233880161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233881162	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233881162	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0736	1716233881162	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233882164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233882164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0736	1716233882164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233883166	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233883166	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0711	1716233883166	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233884168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233884168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0711	1716233884168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233885170	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233885170	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0711	1716233885170	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233886172	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233886172	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0723000000000003	1716233886172	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233887174	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233887174	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0723000000000003	1716233887174	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233888176	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233888176	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0723000000000003	1716233888176	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233889178	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233889178	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0733	1716233889178	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233890180	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233890180	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0733	1716233890180	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233891181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233891181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0733	1716233891181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233892184	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233892184	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0761	1716233892184	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233893186	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233893186	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0761	1716233893186	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233894188	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233894188	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0761	1716233894188	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233895190	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233895190	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0745999999999998	1716233895190	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233896191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233896191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0745999999999998	1716233896191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233897193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233897193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0745999999999998	1716233897193	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233898195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233898195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0751999999999997	1716233898195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233899197	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233899197	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0751999999999997	1716233899197	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233900199	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233900199	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0751999999999997	1716233900199	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233901201	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233901201	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0756	1716233901201	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233902202	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233902202	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0756	1716233902202	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233903206	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233903206	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0756	1716233903206	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233904208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233904208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0717	1716233904208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	99	1716233905210	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233905210	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0717	1716233905210	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233906211	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233906211	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0717	1716233906211	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233907213	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233907213	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0765	1716233907213	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233908215	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233908215	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0765	1716233908215	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233909217	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233909217	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0765	1716233909217	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233910219	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233910219	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0759000000000003	1716233910219	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233911221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233911221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0759000000000003	1716233911221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233912223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233912223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0759000000000003	1716233912223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233913224	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233913224	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0785	1716233913224	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233914226	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233914226	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0785	1716233914226	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233915228	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233915228	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0785	1716233915228	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233916230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233916230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0776	1716233916230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233917232	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233917232	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0776	1716233917232	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233918234	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233918234	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0776	1716233918234	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233919236	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233898218	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233899211	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233900214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233901222	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233902225	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233903226	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233904222	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233905231	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233906232	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233907234	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233908235	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233909237	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233910232	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233911242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233912243	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233913245	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233914246	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233915245	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233916252	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233917254	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233918255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233919252	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233920259	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233921261	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233922266	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233923266	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233924266	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233925262	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233926271	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233927273	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233928273	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233929276	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233930271	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233931280	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233932282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233933285	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233934278	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233935289	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233936289	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233937297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233938288	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233939295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233940290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233941298	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233942301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233943304	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233944305	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233945301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233946309	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233947312	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233948314	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233949319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233950315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233951321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233952322	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233953323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233954326	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233955320	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233956330	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233957332	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233958334	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233959327	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233960335	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233961342	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233962342	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233919236	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0674	1716233919236	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233920238	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233920238	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0674	1716233920238	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233921240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233921240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0674	1716233921240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233922242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233922242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0781	1716233922242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233923243	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233923243	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0781	1716233923243	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233924245	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716233924245	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0781	1716233924245	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233925247	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233925247	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0844	1716233925247	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233926249	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233926249	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0844	1716233926249	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233927251	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233927251	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0844	1716233927251	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233928253	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233928253	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0852	1716233928253	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233929255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233929255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0852	1716233929255	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233930257	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233930257	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0852	1716233930257	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233931259	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233931259	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0853	1716233931259	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233932261	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233932261	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0853	1716233932261	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233933263	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233933263	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0853	1716233933263	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233934265	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233934265	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.086	1716233934265	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233935267	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233935267	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.086	1716233935267	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233936268	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233936268	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.086	1716233936268	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233937270	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233937270	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0876	1716233937270	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233938272	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233938272	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0876	1716233938272	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233939274	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233939274	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0876	1716233939274	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233940276	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233940276	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0692	1716233940276	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233941278	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233941278	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0692	1716233941278	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233942279	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233942279	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0692	1716233942279	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233943281	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233943281	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0711999999999997	1716233943281	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233944283	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233944283	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0711999999999997	1716233944283	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233945285	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233945285	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0711999999999997	1716233945285	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233946288	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233946288	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.075	1716233946288	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233947290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.5	1716233947290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.075	1716233947290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233948291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.699999999999999	1716233948291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.075	1716233948291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233949293	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233949293	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0686999999999998	1716233949293	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233950295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233950295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0686999999999998	1716233950295	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233951297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233951297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0686999999999998	1716233951297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233952299	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233952299	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0705999999999998	1716233952299	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233953301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233953301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0705999999999998	1716233953301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233954302	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233954302	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0705999999999998	1716233954302	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233955304	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233955304	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0719000000000003	1716233955304	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233956306	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233956306	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0719000000000003	1716233956306	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233957309	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233957309	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0719000000000003	1716233957309	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233958311	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233958311	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0724	1716233958311	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233959313	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233959313	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0724	1716233959313	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233960315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233960315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0724	1716233960315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233961317	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233961317	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0674	1716233961317	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233962319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233962319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0674	1716233962319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233963321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233963321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0674	1716233963321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233964322	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233964322	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0692	1716233964322	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233965325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233965325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0692	1716233965325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233966327	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233966327	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0692	1716233966327	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233967329	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233967329	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.071	1716233967329	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233968331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233968331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.071	1716233968331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233969333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233969333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.071	1716233969333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233970334	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233970334	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0711999999999997	1716233970334	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233971336	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233971336	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0711999999999997	1716233971336	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233972338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233972338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0711999999999997	1716233972338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233973340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233973340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0730999999999997	1716233973340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233974342	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233974342	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0730999999999997	1716233974342	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233975344	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233975344	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0730999999999997	1716233975344	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233976346	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233976346	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0745999999999998	1716233976346	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716233977348	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233977348	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0745999999999998	1716233977348	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233978349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233978349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0745999999999998	1716233978349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233979351	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233979351	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0770999999999997	1716233979351	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233980353	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233980353	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0770999999999997	1716233980353	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233981355	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233981355	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0770999999999997	1716233981355	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233982357	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233982357	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0785	1716233982357	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233983359	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233963343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233964342	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233965346	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233966348	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233967350	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233968351	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233969346	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233970357	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233971358	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233972360	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233973360	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233974357	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233975358	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233976367	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233977369	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233978372	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233979372	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233980374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233981375	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233982377	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233983380	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233984376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233985378	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233986387	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233987381	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233988390	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233989392	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233990387	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233991395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233992401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233993399	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233994401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233995406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233996409	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233997407	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233998411	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716233999413	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234000418	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234001417	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234002421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234003419	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234004422	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234005418	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234006428	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234007427	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234008422	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234009426	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234028445	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0772	1716234028445	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234029447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234029447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0772	1716234029447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234030449	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234030449	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.077	1716234030449	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234031450	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234031450	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.077	1716234031450	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234032453	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234032453	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.077	1716234032453	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234033455	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234033455	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0745	1716234033455	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234034457	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233983359	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0785	1716233983359	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233984361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233984361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0785	1716233984361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233985362	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233985362	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0786	1716233985362	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233986365	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233986365	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0786	1716233986365	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233987367	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233987367	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0786	1716233987367	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233988369	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233988369	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0774	1716233988369	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233989371	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233989371	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0774	1716233989371	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716233990373	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233990373	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0774	1716233990373	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233991375	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233991375	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0783	1716233991375	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233992377	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233992377	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0783	1716233992377	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233993379	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233993379	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0783	1716233993379	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233994380	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233994380	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0774	1716233994380	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233995382	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233995382	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0774	1716233995382	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233996384	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233996384	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0774	1716233996384	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716233997386	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233997386	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0781	1716233997386	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716233998388	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716233998388	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0781	1716233998388	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716233999390	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716233999390	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0781	1716233999390	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234000392	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234000392	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0781	1716234000392	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234001394	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234001394	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0781	1716234001394	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234002396	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234002396	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0781	1716234002396	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234003397	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234003397	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.077	1716234003397	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234004399	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234004399	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.077	1716234004399	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234005401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234005401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.077	1716234005401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234006404	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234006404	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0794	1716234006404	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234007406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234007406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0794	1716234007406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234008408	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234008408	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0794	1716234008408	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234009409	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234009409	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0808	1716234009409	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234030462	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234031472	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234032474	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234033476	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234034457	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0745	1716234034457	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234034470	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234035459	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234035459	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0745	1716234035459	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234035480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234036461	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	3.9	1716234036461	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0757	1716234036461	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234036474	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234037462	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234037462	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0757	1716234037462	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234037483	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234038464	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234038464	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0757	1716234038464	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234038486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234039466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234039466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0768	1716234039466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234039487	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234040468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234040468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0768	1716234040468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234040493	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716234041470	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234041470	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0768	1716234041470	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234041492	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234042471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234042471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0788	1716234042471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234042494	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716234043473	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234043473	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0788	1716234043473	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234043494	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234044475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234044475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0788	1716234044475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234044488	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234045477	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234045477	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0795	1716234045477	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234046479	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234046479	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0795	1716234046479	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234047481	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234047481	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0795	1716234047481	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234048483	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234048483	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0822	1716234048483	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234049484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234049484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0822	1716234049484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234050488	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234050488	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0822	1716234050488	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234051490	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234051490	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0824000000000003	1716234051490	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234052493	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234052493	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0824000000000003	1716234052493	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234053495	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234053495	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0824000000000003	1716234053495	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234054496	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234054496	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0831999999999997	1716234054496	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234055498	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234055498	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0831999999999997	1716234055498	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234056502	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234056502	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0831999999999997	1716234056502	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234057504	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234057504	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0815	1716234057504	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234058506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234058506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0815	1716234058506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234059508	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234059508	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0815	1716234059508	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234060510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234060510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0808	1716234060510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234061511	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234061511	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0808	1716234061511	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234062513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234062513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0808	1716234062513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234063515	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234063515	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0810999999999997	1716234063515	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234064517	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234064517	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0810999999999997	1716234064517	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234065519	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234065519	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0810999999999997	1716234065519	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234066521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234066521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234045491	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234046502	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234047506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234048506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234049501	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234050503	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234051514	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234052514	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234053520	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234054513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234055513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234056516	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234057527	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234058531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234059524	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234060528	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234061532	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234062534	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234063537	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234064530	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234065534	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234066543	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234067544	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234068546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234069540	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234070543	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234071554	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234072556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234073556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234074552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234075553	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234076562	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234077563	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234078564	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234079559	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234080568	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234081573	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234082572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234083580	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234084569	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234085569	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234086579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234087581	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234088583	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234089577	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234090580	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234091589	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234092589	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234093592	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234094588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234095596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234096597	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234097599	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234098602	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234099596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234100609	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234101613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234102610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234103611	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234104608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234105609	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234106620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234107619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234108622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234109615	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0826	1716234066521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234067523	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234067523	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0826	1716234067523	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234068525	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234068525	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0826	1716234068525	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234069527	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234069527	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0823	1716234069527	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234070529	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234070529	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0823	1716234070529	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234071531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234071531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0823	1716234071531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234072533	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234072533	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0834	1716234072533	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234073535	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234073535	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0834	1716234073535	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234074536	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234074536	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0834	1716234074536	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234075538	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234075538	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0826	1716234075538	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234076540	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234076540	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0826	1716234076540	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234077542	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234077542	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0826	1716234077542	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234078544	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234078544	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0796	1716234078544	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234079546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234079546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0796	1716234079546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234080547	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234080547	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0796	1716234080547	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234081549	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234081549	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0835	1716234081549	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234082551	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234082551	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0835	1716234082551	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234083553	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234083553	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0835	1716234083553	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234084555	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234084555	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0825	1716234084555	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234085557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234085557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0825	1716234085557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234086558	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234086558	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0825	1716234086558	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234087560	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234087560	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0825	1716234087560	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234088562	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234088562	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0825	1716234088562	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234089564	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234089564	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0825	1716234089564	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234090566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234090566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0822	1716234090566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234091568	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234091568	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0822	1716234091568	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234092570	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234092570	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0822	1716234092570	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234093572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234093572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0765	1716234093572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234094574	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.6	1716234094574	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0765	1716234094574	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234095575	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.8	1716234095575	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0765	1716234095575	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234096577	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234096577	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0819	1716234096577	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234097579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234097579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0819	1716234097579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234098581	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234098581	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0819	1716234098581	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234099583	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234099583	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0682	1716234099583	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234100586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234100586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0682	1716234100586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234101588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234101588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0682	1716234101588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234102590	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234102590	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0716	1716234102590	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234103591	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234103591	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0716	1716234103591	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234104593	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234104593	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0716	1716234104593	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234105595	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234105595	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0761	1716234105595	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234106597	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234106597	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0761	1716234106597	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234107599	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234107599	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0761	1716234107599	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234108600	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234108600	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0806999999999998	1716234108600	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234109602	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234109602	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0806999999999998	1716234109602	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234110605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234110605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0806999999999998	1716234110605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234111607	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234111607	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0816	1716234111607	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234112608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234112608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0816	1716234112608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234113610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234113610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0816	1716234113610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234114612	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234114612	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.086	1716234114612	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234115613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234115613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.086	1716234115613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234116615	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234116615	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.086	1716234116615	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234117617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234117617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0846	1716234117617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234118620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234118620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0846	1716234118620	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234119621	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234119621	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0846	1716234119621	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234120623	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234120623	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.085	1716234120623	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234121625	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234121625	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.085	1716234121625	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234122627	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234122627	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.085	1716234122627	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234123629	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234123629	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0838	1716234123629	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234124631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234124631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0838	1716234124631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234125632	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234125632	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0838	1716234125632	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234126634	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234126634	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.083	1716234126634	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234127636	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234127636	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.083	1716234127636	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234128638	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234128638	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.083	1716234128638	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234129640	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234129640	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0837	1716234129640	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234130642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234130642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234110619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234111627	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234112630	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234113631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234114625	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234115634	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234116637	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234117638	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234118643	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234119636	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234120637	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234121647	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234122651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234123649	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234124644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234125647	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234126655	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234127655	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234128660	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234129654	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234130666	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234131668	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234132669	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234133668	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234134663	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234135672	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234136677	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234137678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234138680	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234139673	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234140682	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234141684	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234142690	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234143688	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234144690	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234145692	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234146695	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234147698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234148697	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234149692	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234150698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234151704	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234152709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234153703	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234154705	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234155713	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234156715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234157710	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234158719	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234159721	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234160722	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234161724	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234162726	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234163731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234164730	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234165737	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234166738	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234167737	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234168741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234169742	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234170736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234171745	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234172747	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234173749	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234174751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0837	1716234130642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234131644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234131644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0837	1716234131644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234132645	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234132645	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0859	1716234132645	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234133647	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234133647	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0859	1716234133647	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234134649	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234134649	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0859	1716234134649	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234135651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234135651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0841	1716234135651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234136653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234136653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0841	1716234136653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234137656	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234137656	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0841	1716234137656	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234138658	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234138658	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0896999999999997	1716234138658	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234139659	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234139659	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0896999999999997	1716234139659	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234140661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234140661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0896999999999997	1716234140661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234141663	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234141663	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0905	1716234141663	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234142665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234142665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0905	1716234142665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234143667	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234143667	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0905	1716234143667	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234144669	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234144669	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0911999999999997	1716234144669	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234145671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234145671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0911999999999997	1716234145671	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234146672	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234146672	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0911999999999997	1716234146672	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234147674	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234147674	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0904000000000003	1716234147674	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234148676	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234148676	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0904000000000003	1716234148676	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234149678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234149678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0904000000000003	1716234149678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234150681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	5.8	1716234150681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0917	1716234150681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234151683	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234151683	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0917	1716234151683	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234152687	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234152687	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0917	1716234152687	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234153689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234153689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0914	1716234153689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234154691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234154691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0914	1716234154691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234155692	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234155692	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0914	1716234155692	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234156694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234156694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0938000000000003	1716234156694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234157696	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234157696	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0938000000000003	1716234157696	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234158698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234158698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0938000000000003	1716234158698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234159700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234159700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0936	1716234159700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234160701	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234160701	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0936	1716234160701	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234161703	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234161703	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0936	1716234161703	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234162705	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234162705	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0923000000000003	1716234162705	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234163707	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234163707	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0923000000000003	1716234163707	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234164709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234164709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0923000000000003	1716234164709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234165711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234165711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0808	1716234165711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234166713	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234166713	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0808	1716234166713	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234167714	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234167714	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0808	1716234167714	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234168718	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234168718	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0838	1716234168718	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234169720	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234169720	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0838	1716234169720	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234170721	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234170721	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0838	1716234170721	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234171723	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234171723	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0849	1716234171723	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234172725	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234172725	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0849	1716234172725	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234173727	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234173727	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0849	1716234173727	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234174729	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234174729	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0766999999999998	1716234174729	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234175731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234175731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0766999999999998	1716234175731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234176732	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234176732	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0766999999999998	1716234176732	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234177734	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234177734	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0804	1716234177734	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234178736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234178736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0804	1716234178736	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234179738	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234179738	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0804	1716234179738	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234180740	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234180740	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0824000000000003	1716234180740	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234181741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234181741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0824000000000003	1716234181741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234182743	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234182743	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0824000000000003	1716234182743	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234183745	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234183745	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.084	1716234183745	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234184747	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234184747	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.084	1716234184747	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234185749	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234185749	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.084	1716234185749	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234186751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234186751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0839000000000003	1716234186751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234187752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234187752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0839000000000003	1716234187752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234188754	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234188754	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0839000000000003	1716234188754	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234189757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234189757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.086	1716234189757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234190759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234190759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.086	1716234190759	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234191761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234191761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.086	1716234191761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234192763	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234192763	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0892	1716234192763	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234193765	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234193765	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0892	1716234193765	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234194767	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234194767	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234175753	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234176753	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234177755	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234178758	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234179752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234180764	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234181766	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234182766	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234183761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234184768	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234185770	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234186771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234187766	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234188776	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234189772	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234190780	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234191784	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234192785	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234193786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234194784	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234195790	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234196791	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234197795	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234198796	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234199790	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234200801	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234201802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234202805	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234203805	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234204799	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234205812	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234206815	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234207814	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234208817	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234209820	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234210812	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234211816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234212821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234213825	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234214828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234215824	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234216830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234217837	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234218838	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234219836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234220839	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234221841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234222843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234223846	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234224841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234225842	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234226850	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234227853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234228854	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234229849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234230859	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234231861	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234232863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234233864	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234234859	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234235868	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234236872	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234237872	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234238874	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234239867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0892	1716234194767	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234195769	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234195769	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0966	1716234195769	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234196771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234196771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0966	1716234196771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234197772	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234197772	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0966	1716234197772	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234198774	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234198774	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0936999999999997	1716234198774	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234199776	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234199776	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0936999999999997	1716234199776	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234200778	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234200778	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0936999999999997	1716234200778	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234201780	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234201780	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0979	1716234201780	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234202782	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234202782	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0979	1716234202782	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234203784	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234203784	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0979	1716234203784	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234204786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234204786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0972	1716234204786	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234205787	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234205787	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0972	1716234205787	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234206789	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234206789	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0972	1716234206789	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234207793	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234207793	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0972	1716234207793	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234208795	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234208795	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0972	1716234208795	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234209797	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234209797	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0972	1716234209797	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234210798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234210798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.099	1716234210798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234211800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234211800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.099	1716234211800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234212802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234212802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.099	1716234212802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234213804	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234213804	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0991999999999997	1716234213804	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234214806	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234214806	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0991999999999997	1716234214806	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234215808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234215808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0991999999999997	1716234215808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234216810	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234216810	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0995	1716234216810	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234217811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234217811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0995	1716234217811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234218813	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234218813	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0995	1716234218813	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234219816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234219816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0993000000000004	1716234219816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234220818	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234220818	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0993000000000004	1716234220818	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234221820	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234221820	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0993000000000004	1716234221820	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234222822	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234222822	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1	1716234222822	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234223824	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234223824	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1	1716234223824	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234224826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234224826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1	1716234224826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234225828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234225828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1006	1716234225828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234226829	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234226829	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1006	1716234226829	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234227831	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234227831	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1006	1716234227831	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234228833	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234228833	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0983	1716234228833	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234229835	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234229835	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0983	1716234229835	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234230837	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234230837	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0983	1716234230837	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234231839	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234231839	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1	1716234231839	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234232841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234232841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1	1716234232841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716234233843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234233843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1	1716234233843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234234844	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234234844	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0999	1716234234844	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234235846	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234235846	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0999	1716234235846	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234236848	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234236848	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0999	1716234236848	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234237850	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234237850	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0986	1716234237850	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234238852	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234238852	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0986	1716234238852	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234239853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234239853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0986	1716234239853	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234240855	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234240855	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1016	1716234240855	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234241857	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234241857	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1016	1716234241857	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234242859	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234242859	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1016	1716234242859	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234243861	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234243861	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1004	1716234243861	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234244863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234244863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1004	1716234244863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234245865	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234245865	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1004	1716234245865	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234246867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.700000000000001	1716234246867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0981	1716234246867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234247868	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	6.9	1716234247868	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0981	1716234247868	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234248871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234248871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0981	1716234248871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234249873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234249873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0983	1716234249873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234730783	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234730783	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1311	1716234730783	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234731785	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234731785	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1311	1716234731785	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234732787	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234732787	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1311	1716234732787	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234733789	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234733789	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1319	1716234733789	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234734791	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234734791	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1319	1716234734791	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234735792	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234735792	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1319	1716234735792	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234736794	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234736794	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1335	1716234736794	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234737796	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234737796	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1335	1716234737796	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234738798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234738798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234240869	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234241877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234242881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234243884	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234244883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234245878	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234246881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234247889	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234248892	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234249887	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234250875	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234250875	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0983	1716234250875	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234250890	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234251877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234251877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0983	1716234251877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234251900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234252879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234252879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1015	1716234252879	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234252901	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234253881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234253881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1015	1716234253881	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234253904	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234254883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234254883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1015	1716234254883	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234254898	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234255885	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234255885	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.103	1716234255885	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234255908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234256886	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234256886	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.103	1716234256886	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234256908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234257888	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234257888	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.103	1716234257888	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234257910	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234258890	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234258890	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.103	1716234258890	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234258912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234259891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234259891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.103	1716234259891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234259905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234260893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234260893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.103	1716234260893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234260915	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234261895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234261895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1047	1716234261895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234261918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234262897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234262897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1047	1716234262897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234262917	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234263898	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234263898	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1047	1716234263898	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234264900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234264900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1039	1716234264900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234265902	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234265902	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1039	1716234265902	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234266904	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234266904	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1039	1716234266904	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234267907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234267907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1031	1716234267907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234268908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234268908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1031	1716234268908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234269910	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234269910	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1031	1716234269910	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234270912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234270912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1035999999999997	1716234270912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234271914	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234271914	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1035999999999997	1716234271914	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234272916	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234272916	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1035999999999997	1716234272916	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234273918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234273918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1016	1716234273918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234274920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234274920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1016	1716234274920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234275922	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234275922	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1016	1716234275922	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234276923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234276923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1025	1716234276923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234277925	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234277925	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1025	1716234277925	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234278926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234278926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1025	1716234278926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234279928	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234279928	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1026	1716234279928	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234280930	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234280930	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1026	1716234280930	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234281931	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234281931	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1026	1716234281931	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234282933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234282933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1035999999999997	1716234282933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234283935	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234283935	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1035999999999997	1716234283935	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234284936	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234284936	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1035999999999997	1716234284936	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234263920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234264923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234265925	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234266926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234267928	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234268931	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234269926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234270933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234271936	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234272937	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234273940	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234274934	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234275943	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234276945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234277947	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234278948	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234279951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234280953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234281953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234282953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234283956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234284951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234285958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234286961	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234287962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234288964	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234289959	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234290968	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234291971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234292971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234293973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234294979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234295979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234296985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234297982	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234298988	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234299979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234300979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234301982	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234302994	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234303996	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234304989	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234305990	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234306999	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234308000	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234308995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234310005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234310998	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234312008	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234313010	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234314011	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234315009	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234316009	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234317020	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234318019	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234319025	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234320017	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234321019	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234322028	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234323023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234324024	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234325033	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234326028	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234327039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234328042	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234285938	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234285938	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1031999999999997	1716234285938	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234286940	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234286940	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1031999999999997	1716234286940	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234287941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234287941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1031999999999997	1716234287941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234288943	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234288943	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.103	1716234288943	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234289945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234289945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.103	1716234289945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234290947	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234290947	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.103	1716234290947	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234291949	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234291949	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1039	1716234291949	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234292951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234292951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1039	1716234292951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234293952	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234293952	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1039	1716234293952	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234294956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234294956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0988	1716234294956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234295958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234295958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0988	1716234295958	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234296960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234296960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.0988	1716234296960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234297962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234297962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.102	1716234297962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234298963	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234298963	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.102	1716234298963	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234299965	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234299965	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.102	1716234299965	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234300967	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234300967	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1041	1716234300967	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234301969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234301969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1041	1716234301969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234302971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234302971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1041	1716234302971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234303973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234303973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1055	1716234303973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234304975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234304975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1055	1716234304975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234305977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234305977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1055	1716234305977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234306978	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234306978	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1053	1716234306978	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234307980	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234307980	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1053	1716234307980	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234308982	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234308982	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1053	1716234308982	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234309984	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234309984	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1075999999999997	1716234309984	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234310985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234310985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1075999999999997	1716234310985	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234311987	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234311987	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1075999999999997	1716234311987	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234312989	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234312989	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1069	1716234312989	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234313991	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234313991	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1069	1716234313991	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234314993	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234314993	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1069	1716234314993	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234315995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234315995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1054	1716234315995	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234316997	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234316997	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1054	1716234316997	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234317999	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234317999	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1054	1716234317999	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234319001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234319001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1034	1716234319001	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234320003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234320003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1034	1716234320003	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234321005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234321005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1034	1716234321005	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234322007	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.799999999999999	1716234322007	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1050999999999997	1716234322007	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234323008	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234323008	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1050999999999997	1716234323008	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234324010	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234324010	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1050999999999997	1716234324010	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234325012	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234325012	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1067	1716234325012	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234326014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234326014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1067	1716234326014	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234327016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234327016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1067	1716234327016	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234328018	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234328018	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1081	1716234328018	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234329020	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234329020	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1081	1716234329020	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234330021	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234330021	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1081	1716234330021	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234331023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234331023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1081	1716234331023	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234332025	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234332025	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1081	1716234332025	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234333028	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234333028	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1081	1716234333028	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234334030	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234334030	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1083000000000003	1716234334030	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234335031	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234335031	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1083000000000003	1716234335031	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234336033	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234336033	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1083000000000003	1716234336033	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234337035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234337035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1066	1716234337035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234338037	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234338037	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1066	1716234338037	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234339039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234339039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1066	1716234339039	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234340040	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234340040	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1050999999999997	1716234340040	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234341042	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234341042	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1050999999999997	1716234341042	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234342044	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234342044	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1050999999999997	1716234342044	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234343046	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234343046	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1071999999999997	1716234343046	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234344048	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234344048	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1071999999999997	1716234344048	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234345050	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234345050	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1071999999999997	1716234345050	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234346052	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234346052	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1058000000000003	1716234346052	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234347054	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234347054	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1058000000000003	1716234347054	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234348056	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234348056	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1058000000000003	1716234348056	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234349058	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234349058	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1071	1716234349058	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234329042	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234330035	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234331036	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234332046	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234333050	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234334055	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234335051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234336055	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234337056	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234338055	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234339051	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234340064	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234341066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234342071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234343070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234344070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234345069	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234346075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234347075	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234348079	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234349081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234350073	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234351083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234352086	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234353087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234354081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234355091	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234356094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234357096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234358097	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234359094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234360101	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234361103	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234362104	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234363106	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234364109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234365110	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234366111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234367115	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234368116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234369109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234370118	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234371122	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234372124	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234373121	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234374127	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234375123	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234376131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234377132	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234378135	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234379136	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234380137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234381138	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234382141	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234383143	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234384137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234385147	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234386149	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234387151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234388152	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234389154	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234390149	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234391158	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234392159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234393163	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234350060	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234350060	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1071	1716234350060	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234351061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234351061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1071	1716234351061	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234352065	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234352065	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1086	1716234352065	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234353066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234353066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1086	1716234353066	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234354068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234354068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1086	1716234354068	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234355070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234355070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1083000000000003	1716234355070	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234356071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234356071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1083000000000003	1716234356071	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234357074	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234357074	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1083000000000003	1716234357074	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234358076	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234358076	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1087	1716234358076	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234359078	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234359078	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1087	1716234359078	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234360080	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234360080	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1087	1716234360080	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234361081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234361081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1041	1716234361081	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234362083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234362083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1041	1716234362083	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234363085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234363085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1041	1716234363085	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234364087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234364087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1041	1716234364087	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234365089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234365089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1041	1716234365089	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234366090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234366090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1041	1716234366090	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234367092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234367092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.107	1716234367092	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234368094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234368094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.107	1716234368094	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234369096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234369096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.107	1716234369096	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234370098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234370098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1074	1716234370098	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234371100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234371100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1074	1716234371100	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234372102	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234372102	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1074	1716234372102	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234373104	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234373104	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1073000000000004	1716234373104	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234374106	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234374106	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1073000000000004	1716234374106	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234375107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234375107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1073000000000004	1716234375107	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234376109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234376109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1073000000000004	1716234376109	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234377111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234377111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1073000000000004	1716234377111	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234378113	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234378113	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1073000000000004	1716234378113	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234379115	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234379115	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1061	1716234379115	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234380116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234380116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1061	1716234380116	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234381118	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234381118	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1061	1716234381118	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234382120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234382120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1078	1716234382120	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234383122	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234383122	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1078	1716234383122	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234384124	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234384124	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1078	1716234384124	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234385126	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234385126	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1089	1716234385126	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234386128	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234386128	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1089	1716234386128	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234387129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234387129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1089	1716234387129	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234388131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234388131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1086	1716234388131	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234389133	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234389133	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1086	1716234389133	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234390135	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7	1716234390135	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1086	1716234390135	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234391137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.8	1716234391137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.109	1716234391137	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234392139	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234392139	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.109	1716234392139	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234393141	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234393141	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.109	1716234393141	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234394143	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234394143	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1086	1716234394143	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234395144	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234395144	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1086	1716234395144	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234396146	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234396146	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1086	1716234396146	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234397148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234397148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1092	1716234397148	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234398150	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234398150	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1092	1716234398150	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234399151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234399151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1092	1716234399151	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234400153	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234400153	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1096999999999997	1716234400153	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234401155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234401155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1096999999999997	1716234401155	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234402157	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234402157	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1096999999999997	1716234402157	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	99	1716234403159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234403159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1074	1716234403159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234404161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234404161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1074	1716234404161	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234405163	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234405163	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1074	1716234405163	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234406164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234406164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1071999999999997	1716234406164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234407166	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234407166	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1071999999999997	1716234407166	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234408168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234408168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1071999999999997	1716234408168	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234409170	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234409170	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1085	1716234409170	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234410171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234410171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1085	1716234410171	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234411173	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234411173	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1085	1716234411173	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234412175	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234412175	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1103	1716234412175	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234413177	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234413177	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1103	1716234413177	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234394164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234395158	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234396159	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234397172	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234398173	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234399164	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234400174	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234401176	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234402178	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234403178	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234404181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234405176	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234406189	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234407188	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234408190	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234409191	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234410187	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234411195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234412195	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234413202	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234414202	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234415201	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234416203	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234417205	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234418207	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234419209	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234420205	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234421214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234422207	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234423218	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234424220	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234425220	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234426223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234427227	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234428228	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234429230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234430231	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234431233	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234432239	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234433238	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234434241	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234435238	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234436242	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234437244	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234438247	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234439250	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234440244	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234441245	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234442249	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234443257	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234444257	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234445251	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234446262	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234447264	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234448269	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234449273	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234450267	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234451278	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234452279	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234453278	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234454281	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234455278	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234456284	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234457288	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234458291	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234414179	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234414179	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1103	1716234414179	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234415181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234415181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1094	1716234415181	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234416182	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234416182	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1094	1716234416182	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234417184	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234417184	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1094	1716234417184	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234418186	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234418186	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1092	1716234418186	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234419188	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234419188	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1092	1716234419188	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234420190	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234420190	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1092	1716234420190	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234421192	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234421192	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1079	1716234421192	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234422194	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234422194	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1079	1716234422194	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234423196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234423196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1079	1716234423196	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234424198	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234424198	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1061	1716234424198	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234425200	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234425200	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1061	1716234425200	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234426202	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234426202	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1061	1716234426202	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234427204	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.5	1716234427204	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1085	1716234427204	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234428206	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234428206	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1085	1716234428206	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234429208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234429208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1085	1716234429208	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234430211	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234430211	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1111	1716234430211	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234431212	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234431212	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1111	1716234431212	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234432214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234432214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1111	1716234432214	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234433216	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234433216	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1083000000000003	1716234433216	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234434218	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234434218	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1083000000000003	1716234434218	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234435220	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234435220	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1083000000000003	1716234435220	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234436221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234436221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1114	1716234436221	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234437223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234437223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1114	1716234437223	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234438225	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234438225	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1114	1716234438225	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234439227	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234439227	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1119	1716234439227	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234440229	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234440229	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1119	1716234440229	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234441230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234441230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1119	1716234441230	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234442233	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234442233	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1132	1716234442233	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234443235	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234443235	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1132	1716234443235	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234444236	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234444236	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1132	1716234444236	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234445238	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234445238	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1108000000000002	1716234445238	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234446240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234446240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1108000000000002	1716234446240	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234447243	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234447243	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1108000000000002	1716234447243	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234448247	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234448247	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1114	1716234448247	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234449250	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234449250	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1114	1716234449250	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234450252	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234450252	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1114	1716234450252	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234451254	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234451254	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1115999999999997	1716234451254	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234452256	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234452256	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1115999999999997	1716234452256	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234453258	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234453258	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1115999999999997	1716234453258	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234454260	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234454260	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1125	1716234454260	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234455262	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234455262	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1125	1716234455262	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234456264	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234456264	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1125	1716234456264	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234457266	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234457266	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1113000000000004	1716234457266	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234458268	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234458268	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1113000000000004	1716234458268	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234459270	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234459270	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1113000000000004	1716234459270	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234460272	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234460272	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1121999999999996	1716234460272	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234461274	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234461274	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1121999999999996	1716234461274	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234462275	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234462275	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1121999999999996	1716234462275	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234463277	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234463277	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1114	1716234463277	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234464279	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234464279	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1114	1716234464279	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234465281	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234465281	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1114	1716234465281	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234466283	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234466283	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1075	1716234466283	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234467285	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234467285	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1075	1716234467285	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234468287	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234468287	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1075	1716234468287	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234469289	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234469289	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1111	1716234469289	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234470290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234470290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1111	1716234470290	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234471292	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234471292	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1111	1716234471292	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234472294	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234472294	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.112	1716234472294	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234473296	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234473296	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.112	1716234473296	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234474298	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234474298	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.112	1716234474298	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234475300	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234475300	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1124	1716234475300	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234476301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234476301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1124	1716234476301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234477303	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234477303	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1124	1716234477303	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234459282	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234460287	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234461287	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234462297	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234463298	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234464292	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234465304	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234466300	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234467298	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234468312	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234469301	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234470314	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234471313	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234472317	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234473319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234474321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234475315	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234476323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234477325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234478326	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234479319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234480322	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234481331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234482333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234483335	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234484338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234485331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234486341	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234487342	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234488344	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234489347	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234490343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234730798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234731807	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234732809	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234733810	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234734811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234735806	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234736816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234737822	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234738821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234739814	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234740818	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234741828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234742828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234743821	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234744834	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234745833	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234746836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234747838	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234748840	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.132	1716234749820	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234749836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234750822	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234750822	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.132	1716234750822	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234750845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234751824	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234751824	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1336	1716234751824	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234751847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234752826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234752826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1336	1716234752826	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234752847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234478305	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234478305	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1132	1716234478305	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234479307	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234479307	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1132	1716234479307	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234480308	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234480308	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1132	1716234480308	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234481310	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234481310	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1126	1716234481310	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234482312	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234482312	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1126	1716234482312	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234483314	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234483314	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1126	1716234483314	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234484316	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	4.2	1716234484316	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1123000000000003	1716234484316	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234485318	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234485318	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1123000000000003	1716234485318	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234486319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234486319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1123000000000003	1716234486319	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234487321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234487321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1133	1716234487321	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234488323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234488323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1133	1716234488323	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234489325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234489325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1133	1716234489325	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234490327	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234490327	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.112	1716234490327	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234491329	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234491329	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.112	1716234491329	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234491350	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234492331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234492331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.112	1716234492331	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234492354	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234493333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234493333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1148000000000002	1716234493333	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234493355	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234494334	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234494334	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1148000000000002	1716234494334	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234494357	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234495336	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234495336	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1148000000000002	1716234495336	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234495350	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234496338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234496338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.115	1716234496338	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234496361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234497340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234497340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.115	1716234497340	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234498341	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234498341	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.115	1716234498341	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234499343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234499343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1149	1716234499343	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234500345	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234500345	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1149	1716234500345	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234501347	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234501347	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1149	1716234501347	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234502349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	8.9	1716234502349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1167	1716234502349	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234503351	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.1	1716234503351	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1167	1716234503351	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234504352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234504352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1167	1716234504352	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234505354	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234505354	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1228000000000002	1716234505354	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234506356	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234506356	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1228000000000002	1716234506356	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234507358	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234507358	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1228000000000002	1716234507358	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234508361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234508361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.121	1716234508361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234509363	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234509363	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.121	1716234509363	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234510365	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234510365	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.121	1716234510365	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234511366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234511366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1185	1716234511366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	99	1716234512368	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234512368	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1185	1716234512368	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234513370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234513370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1185	1716234513370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234514372	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234514372	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1198	1716234514372	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234515374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234515374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1198	1716234515374	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234516376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234516376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1198	1716234516376	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234517378	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234517378	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1195999999999997	1716234517378	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234518380	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234518380	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234497362	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234498361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234499364	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234500361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234501361	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234502370	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234503371	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234504366	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234505367	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234506377	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234507381	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234508382	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234509377	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234510386	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234511387	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234512391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234513392	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234514386	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234515395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234516399	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234517391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234518401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234519405	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234520400	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234521406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234522401	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234523410	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234524412	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234525407	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234526416	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234527410	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234528412	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234529422	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234530417	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234531428	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234532430	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234533429	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234534432	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234535424	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234536434	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234537436	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234538432	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234539434	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234540444	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234541443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234542445	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234543439	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234544442	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234545452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234546452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234547453	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234548456	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234549451	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234550453	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234551461	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234552464	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234553459	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234554469	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234555465	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234556471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234557478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234558479	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234559481	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234560472	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234561483	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1195999999999997	1716234518380	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234519382	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234519382	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1195999999999997	1716234519382	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234520384	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234520384	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1216	1716234520384	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234521385	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234521385	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1216	1716234521385	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234522387	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234522387	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1216	1716234522387	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234523389	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234523389	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1195999999999997	1716234523389	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234524391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234524391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1195999999999997	1716234524391	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	105	1716234525393	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.4	1716234525393	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1195999999999997	1716234525393	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234526395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234526395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.12	1716234526395	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234527397	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234527397	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.12	1716234527397	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234528398	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234528398	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.12	1716234528398	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234529400	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234529400	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1189	1716234529400	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234530402	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234530402	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1189	1716234530402	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234531404	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234531404	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1189	1716234531404	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234532406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234532406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1191999999999998	1716234532406	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234533408	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234533408	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1191999999999998	1716234533408	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234534410	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234534410	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1191999999999998	1716234534410	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234535411	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234535411	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1188000000000002	1716234535411	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234536413	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234536413	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1188000000000002	1716234536413	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234537415	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234537415	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1188000000000002	1716234537415	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234538417	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234538417	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.12	1716234538417	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234539419	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234539419	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.12	1716234539419	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234540421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234540421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.12	1716234540421	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234541423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234541423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1199	1716234541423	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234542425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234542425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1199	1716234542425	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234543426	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234543426	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1199	1716234543426	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234544428	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234544428	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.121	1716234544428	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234545430	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234545430	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.121	1716234545430	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234546431	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234546431	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.121	1716234546431	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234547433	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234547433	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1214	1716234547433	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234548435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234548435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1214	1716234548435	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234549437	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234549437	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1214	1716234549437	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234550439	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234550439	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1243000000000003	1716234550439	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234551441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234551441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1243000000000003	1716234551441	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234552443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234552443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1243000000000003	1716234552443	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234553444	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234553444	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1191	1716234553444	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234554447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234554447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1191	1716234554447	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234555448	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234555448	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1191	1716234555448	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234556450	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234556450	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1209000000000002	1716234556450	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234557452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234557452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1209000000000002	1716234557452	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234558454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234558454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1209000000000002	1716234558454	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234559457	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9	1716234559457	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1213	1716234559457	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234560459	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.199999999999999	1716234560459	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1213	1716234560459	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234561461	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234561461	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1213	1716234561461	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234562462	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234562462	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1206	1716234562462	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234563464	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234563464	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1206	1716234563464	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234564466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234564466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1206	1716234564466	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234565468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234565468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1231	1716234565468	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234566470	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234566470	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1231	1716234566470	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234567471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234567471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1231	1716234567471	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234568473	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234568473	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1238	1716234568473	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234569475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234569475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1238	1716234569475	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234570476	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234570476	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1238	1716234570476	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234571478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234571478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1219	1716234571478	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234572480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234572480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1219	1716234572480	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234573482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234573482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1219	1716234573482	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234574484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234574484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1207	1716234574484	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234575486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234575486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1207	1716234575486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234576488	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234576488	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1207	1716234576488	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234577489	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234577489	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1216999999999997	1716234577489	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234578491	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234578491	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1216999999999997	1716234578491	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234579493	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234579493	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1216999999999997	1716234579493	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234580495	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234580495	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1231	1716234580495	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234581497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234581497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1231	1716234581497	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234582499	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234582499	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234562483	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234563486	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234564487	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234565488	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234566491	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234567492	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234568495	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234569496	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234570490	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234571500	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234572501	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234573495	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234574506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234575503	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234576509	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234577512	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234578512	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234579515	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234580516	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234581518	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234582524	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234583524	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234584524	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234585520	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234586530	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234587530	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234588532	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234589533	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234590528	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234591539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234592533	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234593540	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234594544	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234595538	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234596550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234597549	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234598550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234599552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234600547	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234601556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234602557	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234603560	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234604563	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234605556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234606565	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234607568	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234608570	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234609565	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234610574	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234611577	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234612580	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234613579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234614574	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234615582	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234616586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234617594	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234618585	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234619586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234620588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234621596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234622600	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234623601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234624596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234625605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234626606	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1231	1716234582499	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234583501	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234583501	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1253	1716234583501	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234584503	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234584503	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1253	1716234584503	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234585506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234585506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1253	1716234585506	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234586508	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234586508	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1245	1716234586508	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234587510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234587510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1245	1716234587510	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234588511	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234588511	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1245	1716234588511	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234589513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234589513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1252	1716234589513	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234590515	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234590515	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1252	1716234590515	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234591517	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234591517	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1252	1716234591517	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234592519	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234592519	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.12	1716234592519	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234593521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234593521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.12	1716234593521	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234594523	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234594523	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.12	1716234594523	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234595524	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234595524	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1205	1716234595524	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234596526	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234596526	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1205	1716234596526	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234597528	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234597528	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1205	1716234597528	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234598530	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234598530	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1249000000000002	1716234598530	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234599531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234599531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1249000000000002	1716234599531	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234600533	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234600533	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1249000000000002	1716234600533	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234601535	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234601535	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1266	1716234601535	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234602537	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234602537	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1266	1716234602537	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234603539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234603539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1266	1716234603539	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234604541	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234604541	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1265	1716234604541	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234605543	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234605543	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1265	1716234605543	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234606545	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234606545	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1265	1716234606545	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234607546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234607546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1256	1716234607546	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234608548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234608548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1256	1716234608548	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234609550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234609550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1256	1716234609550	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234610552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234610552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.127	1716234610552	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234611554	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234611554	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.127	1716234611554	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234612556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.700000000000001	1716234612556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.127	1716234612556	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234613558	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234613558	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1221	1716234613558	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234614559	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234614559	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1221	1716234614559	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234615561	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234615561	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1221	1716234615561	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234616563	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234616563	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1245	1716234616563	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234617566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234617566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1245	1716234617566	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234618568	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234618568	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1245	1716234618568	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234619572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234619572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1254	1716234619572	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234620573	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234620573	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1254	1716234620573	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234621575	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234621575	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1254	1716234621575	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234622577	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234622577	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1254	1716234622577	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234623579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234623579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1254	1716234623579	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234624580	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234624580	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1254	1716234624580	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234625582	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234625582	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1259	1716234625582	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234626584	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234626584	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1259	1716234626584	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234627586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234627586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1259	1716234627586	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234628588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234628588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1281999999999996	1716234628588	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234629590	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234629590	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1281999999999996	1716234629590	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234630592	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234630592	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1281999999999996	1716234630592	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234631594	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234631594	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.126	1716234631594	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234632596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.1	1716234632596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.126	1716234632596	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234633598	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234633598	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.126	1716234633598	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234634600	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234634600	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1255	1716234634600	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234635601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234635601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1255	1716234635601	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234636603	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234636603	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1255	1716234636603	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234637605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234637605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1219	1716234637605	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234638607	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234638607	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1219	1716234638607	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234639608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234639608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1219	1716234639608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234640610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234640610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1229	1716234640610	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234641614	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234641614	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1229	1716234641614	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234642616	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234642616	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1229	1716234642616	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234643618	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234643618	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1225	1716234643618	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234644619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234644619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1225	1716234644619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234645621	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234645621	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1225	1716234645621	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234646623	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234646623	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234627608	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234628609	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234629604	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234630613	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234631617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234632617	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234633619	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234634614	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234635622	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234636626	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234637625	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234638628	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234639630	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234640631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234641627	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234642639	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234643642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234644640	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234645635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234646644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234647648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234648648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234649652	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234650645	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234651656	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234652656	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234653664	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234654655	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234655665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234656665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234657669	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234658670	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234659665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234660673	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234661674	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234662676	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234663678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234664681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234665682	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234666684	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234667684	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234668692	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234669692	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234670683	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234671691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234672694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234673699	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234674692	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234675700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234676701	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234677703	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234678704	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234679701	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234680709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234681709	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234682711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234683712	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234684717	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234685719	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234686719	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234687726	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234688723	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234689721	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234690721	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234691730	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1249000000000002	1716234646623	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234647625	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234647625	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1249000000000002	1716234647625	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234648627	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234648627	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1249000000000002	1716234648627	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234649629	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234649629	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.126	1716234649629	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234650631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234650631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.126	1716234650631	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234651634	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234651634	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.126	1716234651634	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234652635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234652635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1295	1716234652635	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234653637	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234653637	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1295	1716234653637	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234654639	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234654639	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1295	1716234654639	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234655642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234655642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1258000000000004	1716234655642	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234656644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234656644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1258000000000004	1716234656644	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234657646	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234657646	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1258000000000004	1716234657646	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234658648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234658648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1268000000000002	1716234658648	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234659650	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234659650	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1268000000000002	1716234659650	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234660651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234660651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1268000000000002	1716234660651	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234661653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234661653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1273	1716234661653	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234662655	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234662655	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1273	1716234662655	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234663656	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234663656	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1273	1716234663656	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234664658	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234664658	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1273	1716234664658	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234665660	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234665660	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1273	1716234665660	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234666661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234666661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1273	1716234666661	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234667663	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234667663	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1271999999999998	1716234667663	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234668665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234668665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1271999999999998	1716234668665	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234669666	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234669666	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1271999999999998	1716234669666	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234670668	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234670668	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1285	1716234670668	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234671670	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234671670	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1285	1716234671670	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234672672	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234672672	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1285	1716234672672	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234673674	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234673674	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1278	1716234673674	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234674676	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234674676	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1278	1716234674676	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234675678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234675678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1278	1716234675678	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234676679	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234676679	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1226	1716234676679	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234677681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234677681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1226	1716234677681	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234678683	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234678683	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1226	1716234678683	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234679685	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234679685	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1286	1716234679685	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234680687	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234680687	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1286	1716234680687	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234681689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234681689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1286	1716234681689	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234682691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.300000000000001	1716234682691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1255	1716234682691	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234683692	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.100000000000001	1716234683692	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1255	1716234683692	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234684694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234684694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1255	1716234684694	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234685697	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234685697	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1252	1716234685697	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234686698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234686698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1252	1716234686698	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234687700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234687700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1252	1716234687700	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234688701	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234688701	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1284	1716234688701	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234689704	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234689704	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1284	1716234689704	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234690706	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234690706	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1284	1716234690706	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234691708	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234691708	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1278	1716234691708	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234692710	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234692710	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1278	1716234692710	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234693711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234693711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1278	1716234693711	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234694713	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234694713	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1288	1716234694713	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234695715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234695715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1288	1716234695715	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234696716	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234696716	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1288	1716234696716	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234697719	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234697719	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1146	1716234697719	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234698720	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234698720	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1146	1716234698720	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234699722	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234699722	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1146	1716234699722	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234700724	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234700724	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1246	1716234700724	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234701726	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234701726	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1246	1716234701726	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234702728	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234702728	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1246	1716234702728	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234703730	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234703730	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1266	1716234703730	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234704731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234704731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1266	1716234704731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234705733	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234705733	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1266	1716234705733	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234706735	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234706735	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1292	1716234706735	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234707737	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234707737	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1292	1716234707737	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234708739	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.800000000000001	1716234708739	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1292	1716234708739	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234709741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234709741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1295	1716234709741	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234710742	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234710742	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234692731	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234693725	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234694727	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234695739	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234696738	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234697740	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234698744	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234699738	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234700745	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234701752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234702752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234703747	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234704748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234705755	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234706756	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234707757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234708752	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234709756	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234710761	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234711767	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234712767	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234713760	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234714763	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234715772	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234716774	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234717776	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234718770	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234719782	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234720777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234721785	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234722787	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234723782	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234724793	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234725787	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234726798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234727802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234728800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234729806	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1335	1716234738798	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234739800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234739800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1327	1716234739800	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234740802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234740802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1327	1716234740802	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234741804	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234741804	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1327	1716234741804	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234742806	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234742806	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1153000000000004	1716234742806	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234743808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234743808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1153000000000004	1716234743808	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234744811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234744811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1153000000000004	1716234744811	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234745812	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234745812	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1327	1716234745812	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234746814	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234746814	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1327	1716234746814	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234747816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234747816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1295	1716234710742	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234711744	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234711744	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1295	1716234711744	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234712746	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234712746	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1299	1716234712746	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234713748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234713748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1299	1716234713748	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234714750	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234714750	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1299	1716234714750	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234715751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234715751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1307	1716234715751	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234716753	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234716753	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1307	1716234716753	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234717755	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234717755	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1307	1716234717755	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234718757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234718757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1309	1716234718757	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234719760	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234719760	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1309	1716234719760	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234720762	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234720762	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1309	1716234720762	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234721764	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234721764	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1258000000000004	1716234721764	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234722766	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234722766	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1258000000000004	1716234722766	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234723768	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234723768	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1258000000000004	1716234723768	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234724771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234724771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1286	1716234724771	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234725774	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234725774	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1286	1716234725774	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234726776	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234726776	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1286	1716234726776	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234727777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234727777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1295	1716234727777	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234728779	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234728779	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1295	1716234728779	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234729781	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234729781	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1295	1716234729781	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1327	1716234747816	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234748818	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234748818	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.132	1716234748818	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234749820	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234749820	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234753828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234753828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1336	1716234753828	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234754830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234754830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1343	1716234754830	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234755832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234755832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1343	1716234755832	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234756834	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234756834	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1343	1716234756834	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234757836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234757836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1341	1716234757836	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234758837	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234758837	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1341	1716234758837	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234759839	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234759839	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1341	1716234759839	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234760841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234760841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1351999999999998	1716234760841	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234761843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234761843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1351999999999998	1716234761843	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234762845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234762845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1351999999999998	1716234762845	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234763847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234763847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1355999999999997	1716234763847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234764849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234764849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1355999999999997	1716234764849	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234765851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234765851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1355999999999997	1716234765851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234766852	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234766852	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1304000000000003	1716234766852	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234767854	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234767854	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1304000000000003	1716234767854	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234768856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234768856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1304000000000003	1716234768856	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234769858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234769858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1311	1716234769858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234770860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234770860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1311	1716234770860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234771862	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234771862	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1311	1716234771862	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234772863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234772863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1339	1716234772863	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234773865	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234773865	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1339	1716234773865	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234774867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234753852	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234754847	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234755857	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234756857	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234757859	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234758851	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234759860	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234760861	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234761858	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234762866	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234763869	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234764862	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234765872	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234766867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234767876	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234768877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234769880	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234770882	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234771877	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234772885	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234773886	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234774888	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234775891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234776895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234777894	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234778891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234779891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234780899	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234781902	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234782905	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234783908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234784900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234785910	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234786915	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234787913	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234788908	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234789916	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234774867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1339	1716234774867	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234775869	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234775869	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1355	1716234775869	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234776871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234776871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1355	1716234776871	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234777873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234777873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1355	1716234777873	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234778875	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234778875	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1336999999999997	1716234778875	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234779876	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234779876	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1336999999999997	1716234779876	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234780878	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234780878	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1336999999999997	1716234780878	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234781880	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234781880	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1327	1716234781880	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234782882	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234782882	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1327	1716234782882	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234783884	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234783884	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1327	1716234783884	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234784886	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234784886	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1349	1716234784886	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234785888	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234785888	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1349	1716234785888	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234786890	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234786890	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1349	1716234786890	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234787891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234787891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1344000000000003	1716234787891	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234788893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234788893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1344000000000003	1716234788893	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234789895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234789895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1344000000000003	1716234789895	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234790897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234790897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1342	1716234790897	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234790918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234791898	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234791898	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1342	1716234791898	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234791919	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234792900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234792900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1342	1716234792900	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234792923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234793902	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234793902	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1346	1716234793902	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234793923	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234794904	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234794904	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1346	1716234794904	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234795907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234795907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1346	1716234795907	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234796909	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234796909	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1364	1716234796909	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234797910	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234797910	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1364	1716234797910	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234798912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234798912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1364	1716234798912	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234799914	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234799914	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1376	1716234799914	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234800916	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234800916	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1376	1716234800916	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234801918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234801918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1376	1716234801918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234802920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234802920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1381	1716234802920	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234803922	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234803922	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1381	1716234803922	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234804924	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234804924	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1381	1716234804924	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234805926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234805926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1376999999999997	1716234805926	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234806928	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234806928	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1376999999999997	1716234806928	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234807930	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.600000000000001	1716234807930	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1376999999999997	1716234807930	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234808932	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234808932	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1391	1716234808932	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234809933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234809933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1391	1716234809933	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234810936	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234810936	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1391	1716234810936	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234811937	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234811937	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1328	1716234811937	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234812939	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234812939	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1328	1716234812939	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234813941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234813941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1328	1716234813941	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234814944	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234814944	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1344000000000003	1716234814944	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234815945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234815945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234794918	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234795930	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234796929	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234797931	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234798937	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234799927	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234800938	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234801940	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234802942	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234803935	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234804945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234805950	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234806953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234807952	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234808956	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234809948	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234810961	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234811960	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234812962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234813967	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234814959	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234815969	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234816970	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234817973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234818966	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234819974	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234820979	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234821981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234822981	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234823983	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234824976	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234825989	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234826988	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234827990	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234828992	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234829986	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234830994	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234831997	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Swap Memory GB	0.0003	1716234833002	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1344000000000003	1716234815945	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234816947	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234816947	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1344000000000003	1716234816947	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234817949	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.200000000000001	1716234817949	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1346	1716234817949	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234818951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.4	1716234818951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1346	1716234818951	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234819953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.3	1716234819953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1346	1716234819953	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234820955	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.5	1716234820955	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1375	1716234820955	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234821957	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.3	1716234821957	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1375	1716234821957	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	100	1716234822959	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.5	1716234822959	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1375	1716234822959	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234823961	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.5	1716234823961	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1376999999999997	1716234823961	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234824962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.3	1716234824962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1376999999999997	1716234824962	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234825964	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.5	1716234825964	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1376999999999997	1716234825964	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234826966	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.3	1716234826966	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1375	1716234826966	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234827968	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.5	1716234827968	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1375	1716234827968	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234828970	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.3	1716234828970	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1375	1716234828970	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	101	1716234829971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.5	1716234829971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1385	1716234829971	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	104	1716234830973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.3	1716234830973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1385	1716234830973	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	102	1716234831975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	7.5	1716234831975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1385	1716234831975	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - CPU Utilization	103	1716234832977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Utilization	9.3	1716234832977	436b0fe0581b40b39a3b1162534bcede	0	f
TOP - Memory Usage GB	2.1369000000000002	1716234832977	436b0fe0581b40b39a3b1162534bcede	0	f
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
letter	0	5809e15b445842df8ecd1ecea6f12025
workload	0	5809e15b445842df8ecd1ecea6f12025
listeners	smi+top+dcgmi	5809e15b445842df8ecd1ecea6f12025
params	'"-"'	5809e15b445842df8ecd1ecea6f12025
file	cifar10.py	5809e15b445842df8ecd1ecea6f12025
workload_listener	''	5809e15b445842df8ecd1ecea6f12025
letter	0	436b0fe0581b40b39a3b1162534bcede
workload	0	436b0fe0581b40b39a3b1162534bcede
listeners	smi+top+dcgmi	436b0fe0581b40b39a3b1162534bcede
params	'"-"'	436b0fe0581b40b39a3b1162534bcede
file	cifar10.py	436b0fe0581b40b39a3b1162534bcede
workload_listener	''	436b0fe0581b40b39a3b1162534bcede
model	cifar10.py	436b0fe0581b40b39a3b1162534bcede
manual	False	436b0fe0581b40b39a3b1162534bcede
max_epoch	5	436b0fe0581b40b39a3b1162534bcede
max_time	172800	436b0fe0581b40b39a3b1162534bcede
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
5809e15b445842df8ecd1ecea6f12025	illustrious-vole-602	UNKNOWN			daga	FAILED	1716231967318	1716232099441		active	s3://mlflow-storage/0/5809e15b445842df8ecd1ecea6f12025/artifacts	0	\N
436b0fe0581b40b39a3b1162534bcede	(0 0) exultant-trout-705	UNKNOWN			daga	FINISHED	1716232188954	1716234833921		active	s3://mlflow-storage/0/436b0fe0581b40b39a3b1162534bcede/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	5809e15b445842df8ecd1ecea6f12025
mlflow.source.name	file:///home/daga/radt#examples/pytorch	5809e15b445842df8ecd1ecea6f12025
mlflow.source.type	PROJECT	5809e15b445842df8ecd1ecea6f12025
mlflow.project.entryPoint	main	5809e15b445842df8ecd1ecea6f12025
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	5809e15b445842df8ecd1ecea6f12025
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	5809e15b445842df8ecd1ecea6f12025
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	5809e15b445842df8ecd1ecea6f12025
mlflow.runName	illustrious-vole-602	5809e15b445842df8ecd1ecea6f12025
mlflow.project.env	conda	5809e15b445842df8ecd1ecea6f12025
mlflow.project.backend	local	5809e15b445842df8ecd1ecea6f12025
mlflow.user	daga	436b0fe0581b40b39a3b1162534bcede
mlflow.source.name	file:///home/daga/radt#examples/pytorch	436b0fe0581b40b39a3b1162534bcede
mlflow.source.type	PROJECT	436b0fe0581b40b39a3b1162534bcede
mlflow.project.entryPoint	main	436b0fe0581b40b39a3b1162534bcede
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	436b0fe0581b40b39a3b1162534bcede
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	436b0fe0581b40b39a3b1162534bcede
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	436b0fe0581b40b39a3b1162534bcede
mlflow.project.env	conda	436b0fe0581b40b39a3b1162534bcede
mlflow.project.backend	local	436b0fe0581b40b39a3b1162534bcede
mlflow.runName	(0 0) exultant-trout-705	436b0fe0581b40b39a3b1162534bcede
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

