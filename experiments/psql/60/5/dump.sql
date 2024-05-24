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
0	Default	s3://mlflow-storage/0	active	1716296055573	1716296055573
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
SMI - Power Draw	15.81	1716296187988	0	f	09452534b65d4220852ca51ceb0f1b1f
SMI - Timestamp	1716296187.974	1716296187988	0	f	09452534b65d4220852ca51ceb0f1b1f
SMI - GPU Util	0	1716296187988	0	f	09452534b65d4220852ca51ceb0f1b1f
SMI - Mem Util	0	1716296187988	0	f	09452534b65d4220852ca51ceb0f1b1f
SMI - Mem Used	0	1716296187988	0	f	09452534b65d4220852ca51ceb0f1b1f
SMI - Performance State	0	1716296187988	0	f	09452534b65d4220852ca51ceb0f1b1f
TOP - CPU Utilization	101	1716297515583	0	f	09452534b65d4220852ca51ceb0f1b1f
TOP - Memory Usage GB	1.9694	1716297515583	0	f	09452534b65d4220852ca51ceb0f1b1f
TOP - Memory Utilization	6.6	1716297515583	0	f	09452534b65d4220852ca51ceb0f1b1f
TOP - Swap Memory GB	0.0005	1716297515606	0	f	09452534b65d4220852ca51ceb0f1b1f
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	15.81	1716296187988	09452534b65d4220852ca51ceb0f1b1f	0	f
SMI - Timestamp	1716296187.974	1716296187988	09452534b65d4220852ca51ceb0f1b1f	0	f
SMI - GPU Util	0	1716296187988	09452534b65d4220852ca51ceb0f1b1f	0	f
SMI - Mem Util	0	1716296187988	09452534b65d4220852ca51ceb0f1b1f	0	f
SMI - Mem Used	0	1716296187988	09452534b65d4220852ca51ceb0f1b1f	0	f
SMI - Performance State	0	1716296187988	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	0	1716296188051	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	0	1716296188051	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.2410999999999999	1716296188051	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296188065	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	143.79999999999998	1716296189052	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	9	1716296189052	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.2410999999999999	1716296189052	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296189067	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296190054	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	2.5	1716296190054	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.2410999999999999	1716296190054	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296190068	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296191056	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.3	1716296191056	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4717	1716296191056	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296191070	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296192058	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296192058	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4717	1716296192058	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296192079	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296193060	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.3	1716296193060	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4717	1716296193060	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296193074	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296194062	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296194062	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4719	1716296194062	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296194083	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	105	1716296195064	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.3	1716296195064	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4719	1716296195064	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296195086	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	105	1716296196066	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296196066	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4719	1716296196066	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296196087	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296197068	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.3	1716296197068	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.472	1716296197068	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296197082	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296198070	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296198070	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.472	1716296198070	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296198091	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296199072	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296199072	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.472	1716296199072	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296199086	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296200074	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296200074	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4714	1716296200074	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296200094	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296201075	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.3	1716296201075	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4714	1716296201075	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296201098	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296202078	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296202078	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4714	1716296202078	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296202099	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296203101	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296204103	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296205105	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296206099	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296207108	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296208111	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296209112	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296210105	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296211116	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296212110	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296213120	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296214114	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296215119	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296216119	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296217127	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296218121	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296219133	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296220134	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296221128	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296222138	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296223138	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296224142	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296225135	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296226139	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296227145	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296228147	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296229149	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296230155	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296231145	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296232147	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296233159	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296234159	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296235162	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296236157	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296237163	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296238167	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296239168	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296240173	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296241166	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296242173	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296243176	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296244177	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296245180	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296246182	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296247188	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296248188	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296249188	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296250191	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296251192	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296252196	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296253196	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296254200	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296255199	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296496641	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296496641	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9117	1716296496641	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296497643	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296497643	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9089	1716296497643	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296498645	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296498645	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9089	1716296498645	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296499648	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296499648	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	106	1716296203079	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.3	1716296203079	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.471	1716296203079	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296204081	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296204081	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.471	1716296204081	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296205083	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.3	1716296205083	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.471	1716296205083	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	106	1716296206085	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296206085	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4707999999999999	1716296206085	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	105	1716296207087	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.300000000000001	1716296207087	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4707999999999999	1716296207087	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296208089	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296208089	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4707999999999999	1716296208089	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296209091	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.3	1716296209091	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4727000000000001	1716296209091	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296210093	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296210093	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4727000000000001	1716296210093	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296211095	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.3	1716296211095	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.4727000000000001	1716296211095	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296212097	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296212097	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8402	1716296212097	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296213098	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.3	1716296213098	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8402	1716296213098	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296214100	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296214100	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8402	1716296214100	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296215102	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.3	1716296215102	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8809	1716296215102	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296216104	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.6	1716296216104	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8809	1716296216104	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296217106	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296217106	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8809	1716296217106	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296218108	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296218108	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8889	1716296218108	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296219109	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296219109	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8889	1716296219109	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296220111	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296220111	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8889	1716296220111	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296221113	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296221113	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8905999999999998	1716296221113	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296222115	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296222115	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8905999999999998	1716296222115	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296223117	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296223117	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8905999999999998	1716296223117	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296224118	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296224118	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.89	1716296224118	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296225120	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296225120	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.89	1716296225120	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296226122	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296226122	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.89	1716296226122	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296227124	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296227124	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8927	1716296227124	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296228126	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296228126	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8927	1716296228126	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296229127	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296229127	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8927	1716296229127	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296230129	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296230129	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.894	1716296230129	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296231131	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296231131	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.894	1716296231131	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296232133	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296232133	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.894	1716296232133	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296233135	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296233135	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8815	1716296233135	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296234137	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296234137	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8815	1716296234137	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296235139	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296235139	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8815	1716296235139	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296236141	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296236141	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8854000000000002	1716296236141	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296237143	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296237143	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8854000000000002	1716296237143	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296238144	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	2.6	1716296238144	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8854000000000002	1716296238144	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296239146	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296239146	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8862	1716296239146	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296240148	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296240148	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8862	1716296240148	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296241150	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296241150	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8862	1716296241150	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296242152	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296242152	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8860999999999999	1716296242152	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296243154	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296243154	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8860999999999999	1716296243154	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296244156	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296244156	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8860999999999999	1716296244156	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296245158	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296245158	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8851	1716296245158	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296246161	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296246161	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8851	1716296246161	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296247163	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296247163	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8851	1716296247163	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296248165	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296248165	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8859000000000001	1716296248165	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296249167	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296249167	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8859000000000001	1716296249167	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296250169	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296250169	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8859000000000001	1716296250169	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296251171	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296251171	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.888	1716296251171	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296252173	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296252173	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.888	1716296252173	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296253174	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296253174	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.888	1716296253174	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296254176	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296254176	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8860999999999999	1716296254176	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296255178	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296255178	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8860999999999999	1716296255178	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296256180	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296256180	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8860999999999999	1716296256180	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296256195	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296257182	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296257182	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8831	1716296257182	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296257206	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296258184	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296258184	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8831	1716296258184	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296258198	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296259186	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296259186	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8831	1716296259186	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296259207	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296260188	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296260188	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8833	1716296260188	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296260209	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296261190	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296261190	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8833	1716296261190	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296261205	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296262191	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296262191	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8833	1716296262191	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296262212	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296263193	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296263193	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8849	1716296263193	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296263215	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296264195	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296264195	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8849	1716296264195	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296265197	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296265197	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8849	1716296265197	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296266199	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296266199	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8865999999999998	1716296266199	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296267201	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296267201	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8865999999999998	1716296267201	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296268202	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296268202	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8865999999999998	1716296268202	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296269204	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296269204	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.886	1716296269204	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296270206	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296270206	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.886	1716296270206	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296271208	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296271208	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.886	1716296271208	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296272210	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296272210	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8862999999999999	1716296272210	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296273212	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296273212	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8862999999999999	1716296273212	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296274214	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296274214	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8862999999999999	1716296274214	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296275216	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296275216	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8879000000000001	1716296275216	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296276218	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296276218	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8879000000000001	1716296276218	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296277220	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296277220	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8879000000000001	1716296277220	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296278221	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296278221	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8862	1716296278221	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296279223	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296279223	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8862	1716296279223	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296280225	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296280225	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8862	1716296280225	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296281228	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296281228	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8878	1716296281228	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	105	1716296282230	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296282230	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8878	1716296282230	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296283232	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296283232	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8878	1716296283232	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296284234	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296284234	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8894000000000002	1716296284234	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296285236	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296285236	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296264219	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296265218	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296266215	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296267224	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296268226	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296269227	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296270220	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296271223	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296272232	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296273233	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296274235	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296275230	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296276239	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296277243	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296278244	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296279247	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296280239	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296281249	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296282253	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296283256	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296284259	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296285249	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296286251	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296287262	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296288266	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296289264	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296290263	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296291271	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296292264	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296293274	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296294279	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296295277	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296296279	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296297281	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296298288	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296299285	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296300288	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296301281	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296302284	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296303292	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296304296	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296305297	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296306291	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296307301	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296308362	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296309303	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296310297	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296311307	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296312309	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296313303	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296314313	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296315307	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296496657	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296497657	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296498666	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296499670	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296500664	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296501666	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296502670	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296503670	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296504673	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296505673	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296506685	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296507686	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296508690	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8894000000000002	1716296285236	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296286238	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296286238	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8894000000000002	1716296286238	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296287240	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296287240	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8898	1716296287240	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296288241	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296288241	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8898	1716296288241	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296289243	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296289243	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8898	1716296289243	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296290247	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296290247	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8928	1716296290247	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296291249	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296291249	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8928	1716296291249	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296292251	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296292251	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8928	1716296292251	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296293253	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296293253	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8958	1716296293253	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296294254	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296294254	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8958	1716296294254	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296295256	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296295256	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8958	1716296295256	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296296258	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296296258	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8972	1716296296258	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296297260	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296297260	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8972	1716296297260	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296298262	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296298262	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8972	1716296298262	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296299264	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296299264	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8954000000000002	1716296299264	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296300265	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296300265	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8954000000000002	1716296300265	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296301267	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296301267	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8954000000000002	1716296301267	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296302269	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296302269	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8958	1716296302269	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296303271	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296303271	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8958	1716296303271	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296304273	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296304273	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8958	1716296304273	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296305275	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296305275	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8985999999999998	1716296305275	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296306277	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296306277	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8985999999999998	1716296306277	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296307278	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296307278	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8985999999999998	1716296307278	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296308280	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296308280	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8976	1716296308280	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296309282	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296309282	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8976	1716296309282	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	107	1716296310284	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296310284	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8976	1716296310284	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296311286	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296311286	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8975	1716296311286	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296312287	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296312287	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8975	1716296312287	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296313289	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296313289	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8975	1716296313289	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296314291	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296314291	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9009	1716296314291	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296315293	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296315293	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9009	1716296315293	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296316295	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296316295	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9009	1716296316295	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296316312	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296317296	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296317296	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9027	1716296317296	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296317322	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296318298	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296318298	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9027	1716296318298	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296318312	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296319300	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296319300	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9027	1716296319300	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296319321	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296320302	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296320302	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9028	1716296320302	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296320314	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296321304	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296321304	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9028	1716296321304	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296321326	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296322305	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296322305	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9028	1716296322305	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296322332	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296323307	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296323307	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8992	1716296323307	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296323330	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296324309	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296324309	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8992	1716296324309	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296324330	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296325311	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296325311	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8992	1716296325311	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296326313	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296326313	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.902	1716296326313	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296327315	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296327315	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.902	1716296327315	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296328317	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296328317	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.902	1716296328317	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296329319	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296329319	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9021	1716296329319	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296330320	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296330320	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9021	1716296330320	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296331322	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296331322	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9021	1716296331322	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296332324	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296332324	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9033	1716296332324	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296333326	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.800000000000001	1716296333326	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9033	1716296333326	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296334328	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296334328	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9033	1716296334328	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296335330	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296335330	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9048	1716296335330	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296336332	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296336332	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9048	1716296336332	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296337334	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296337334	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9048	1716296337334	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296338335	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296338335	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9031	1716296338335	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296339337	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.4	1716296339337	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9031	1716296339337	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296340339	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296340339	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9031	1716296340339	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	107	1716296341341	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.5	1716296341341	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9044	1716296341341	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296342343	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296342343	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9044	1716296342343	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296343345	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.7	1716296343345	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9044	1716296343345	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296344348	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296344348	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9005999999999998	1716296344348	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296345350	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296345350	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9005999999999998	1716296345350	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296346352	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296346352	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296325330	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296326327	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296327337	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296328340	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296329339	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296330345	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296331337	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296332347	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296333350	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296334350	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296335348	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296336354	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296337358	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296338361	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296339405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296340355	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296341363	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296342364	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296343366	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296344370	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296345365	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296346369	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296347375	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296348379	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296349381	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296350375	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296351386	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296352386	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296353389	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296354392	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296355384	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296356395	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296357394	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296358397	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296359398	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296360393	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296361402	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296362406	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296363406	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296364409	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296365405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296366406	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296367414	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296368417	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296369417	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296370412	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296371422	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296372423	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296373426	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296374429	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296375424	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9089	1716296499648	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296500650	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296500650	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9116	1716296500650	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296501652	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296501652	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9116	1716296501652	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296502654	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296502654	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9116	1716296502654	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296503656	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296503656	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9113	1716296503656	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296504658	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9005999999999998	1716296346352	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296347354	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296347354	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9009	1716296347354	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296348357	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296348357	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9009	1716296348357	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296349359	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296349359	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9009	1716296349359	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296350361	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296350361	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9009	1716296350361	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296351363	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296351363	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9009	1716296351363	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296352365	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296352365	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9009	1716296352365	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296353367	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296353367	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9022000000000001	1716296353367	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296354368	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296354368	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9022000000000001	1716296354368	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296355370	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296355370	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9022000000000001	1716296355370	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296356372	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296356372	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9042000000000001	1716296356372	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296357374	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296357374	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9042000000000001	1716296357374	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296358375	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296358375	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9042000000000001	1716296358375	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296359377	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296359377	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9029	1716296359377	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296360379	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296360379	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9029	1716296360379	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296361381	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296361381	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9029	1716296361381	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296362383	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296362383	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9054	1716296362383	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296363385	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296363385	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9054	1716296363385	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296364387	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296364387	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9054	1716296364387	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296365389	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296365389	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8988	1716296365389	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296366391	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296366391	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8988	1716296366391	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296367393	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296367393	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8988	1716296367393	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296368395	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296368395	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.901	1716296368395	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296369396	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296369396	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.901	1716296369396	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296370398	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296370398	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.901	1716296370398	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296371400	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296371400	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9007	1716296371400	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296372402	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296372402	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9007	1716296372402	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296373404	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296373404	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9007	1716296373404	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296374405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296374405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9008	1716296374405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296375407	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296375407	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9008	1716296375407	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296376409	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296376409	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9008	1716296376409	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296376431	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296377411	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296377411	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9017	1716296377411	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296377436	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296378413	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296378413	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9017	1716296378413	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296378434	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296379415	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296379415	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9017	1716296379415	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296379437	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296380418	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296380418	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9022999999999999	1716296380418	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296380444	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296381420	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296381420	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9022999999999999	1716296381420	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296381434	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296382422	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296382422	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9022999999999999	1716296382422	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296382443	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296383424	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296383424	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9035	1716296383424	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296383445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296384425	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296384425	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9035	1716296384425	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296384449	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296385427	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296385427	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9035	1716296385427	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296385441	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296386429	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296386429	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8957	1716296386429	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296387431	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296387431	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8957	1716296387431	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296388433	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296388433	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8957	1716296388433	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296389435	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296389435	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8984	1716296389435	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296390437	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296390437	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8984	1716296390437	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296391438	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296391438	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8984	1716296391438	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296392440	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296392440	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8989	1716296392440	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296393442	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296393442	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8989	1716296393442	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296394444	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296394444	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8989	1716296394444	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296395445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296395445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9012	1716296395445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296396447	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296396447	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9012	1716296396447	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296397449	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296397449	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9012	1716296397449	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296398451	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296398451	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9001	1716296398451	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296399453	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296399453	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9001	1716296399453	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296400455	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296400455	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9001	1716296400455	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296401457	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296401457	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.903	1716296401457	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296402458	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296402458	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.903	1716296402458	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296403460	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296403460	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.903	1716296403460	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296404462	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296404462	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9041	1716296404462	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296405464	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296405464	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9041	1716296405464	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296406465	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296406465	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9041	1716296406465	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296407468	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296386446	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296387456	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296388447	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296389457	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296390459	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296391460	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296392465	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296393465	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296394464	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296395466	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296396463	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296397474	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296398474	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296399468	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296400477	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296401474	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296402479	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296403483	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296404475	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296405485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296406480	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296407494	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296408492	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296409493	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296410497	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296411491	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296412501	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296413502	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296414495	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296415508	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296416501	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296417509	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296418503	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296419513	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296420515	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296421511	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296422512	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296423514	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296424524	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296425525	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296426519	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296427531	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296428531	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296429535	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296430527	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296431532	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296432538	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296433540	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296434542	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296435549	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296504658	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9113	1716296504658	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296505660	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296505660	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9113	1716296505660	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296506661	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296506661	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9116	1716296506661	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296507663	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296507663	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9116	1716296507663	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296508665	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296508665	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9116	1716296508665	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296509667	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296407468	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9018	1716296407468	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296408470	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296408470	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9018	1716296408470	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296409472	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296409472	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9018	1716296409472	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296410474	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296410474	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8999000000000001	1716296410474	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296411476	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296411476	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8999000000000001	1716296411476	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296412478	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296412478	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.8999000000000001	1716296412478	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296413479	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296413479	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9016	1716296413479	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296414482	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296414482	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9016	1716296414482	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296415484	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296415484	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9016	1716296415484	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296416485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296416485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9017	1716296416485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296417487	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296417487	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9017	1716296417487	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296418489	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296418489	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9017	1716296418489	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296419491	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296419491	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9033	1716296419491	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296420493	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296420493	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9033	1716296420493	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296421495	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296421495	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9033	1716296421495	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296422497	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.000000000000002	1716296422497	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9045	1716296422497	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296423500	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296423500	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9045	1716296423500	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296424502	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296424502	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9045	1716296424502	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296425504	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296425504	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9042999999999999	1716296425504	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296426506	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296426506	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9042999999999999	1716296426506	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296427507	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296427507	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9042999999999999	1716296427507	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296428510	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296428510	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.905	1716296428510	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296429512	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296429512	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.905	1716296429512	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296430513	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296430513	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.905	1716296430513	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296431516	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296431516	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9035	1716296431516	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296432518	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296432518	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9035	1716296432518	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296433519	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296433519	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9035	1716296433519	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296434521	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296434521	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9045	1716296434521	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296435524	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296435524	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9045	1716296435524	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296436526	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296436526	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9045	1716296436526	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296436548	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296437528	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296437528	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9069	1716296437528	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296437549	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296438530	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296438530	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9069	1716296438530	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296438552	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296439531	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296439531	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9069	1716296439531	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296439555	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296440533	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296440533	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9047	1716296440533	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296440547	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296441535	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296441535	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9047	1716296441535	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296441549	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296442537	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296442537	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9047	1716296442537	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296442559	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296443539	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296443539	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9047	1716296443539	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296443563	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296444541	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296444541	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9047	1716296444541	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296444554	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296445543	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296445543	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9047	1716296445543	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296445566	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296446545	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296446545	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9078	1716296446545	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296447547	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296447547	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9078	1716296447547	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296448548	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296448548	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9078	1716296448548	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296449550	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296449550	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9061	1716296449550	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296450552	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296450552	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9061	1716296450552	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296451554	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296451554	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9061	1716296451554	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296452556	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296452556	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9049	1716296452556	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296453558	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296453558	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9049	1716296453558	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296454560	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296454560	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9049	1716296454560	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296455562	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296455562	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9064	1716296455562	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296456565	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296456565	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9064	1716296456565	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296457567	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296457567	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9064	1716296457567	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296458569	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296458569	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9052	1716296458569	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296459571	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296459571	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9052	1716296459571	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296460573	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296460573	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9052	1716296460573	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296461574	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296461574	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9033	1716296461574	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296462576	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296462576	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9033	1716296462576	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296463578	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296463578	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9033	1716296463578	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296464580	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296464580	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9059000000000001	1716296464580	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296465582	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296465582	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9059000000000001	1716296465582	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296466584	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296466584	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9059000000000001	1716296466584	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296467586	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296467586	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9065	1716296467586	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296446560	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296447571	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296448563	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296449567	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296450568	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296451569	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296452578	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296453572	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296454577	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296455576	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296456581	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296457581	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296458587	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296459586	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296460596	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296461595	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296462601	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296463591	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296464603	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296465610	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296466599	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296467601	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296468606	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296469604	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296470614	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296471610	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296472619	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296473622	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296474615	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296475623	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296476618	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296477628	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296478622	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296479630	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296480632	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296481634	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296482637	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296483637	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296484639	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296485640	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296486634	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296487638	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296488641	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296489643	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296490651	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296491645	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296492655	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296493651	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296494658	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296495659	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296509667	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9121	1716296509667	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296510668	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296510668	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9121	1716296510668	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296511670	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296511670	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9121	1716296511670	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296512672	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296512672	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9138	1716296512672	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296513674	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296513674	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9138	1716296513674	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296514676	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296468588	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296468588	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9065	1716296468588	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296469590	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296469590	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9065	1716296469590	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296470591	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296470591	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9041	1716296470591	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296471593	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296471593	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9041	1716296471593	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296472596	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296472596	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9041	1716296472596	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296473598	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296473598	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9017	1716296473598	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296474599	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296474599	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9017	1716296474599	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296475601	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296475601	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9017	1716296475601	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296476603	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296476603	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9041	1716296476603	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296477605	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296477605	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9041	1716296477605	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296478607	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296478607	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9041	1716296478607	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296479609	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296479609	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9069	1716296479609	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296480611	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296480611	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9069	1716296480611	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296481613	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296481613	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9069	1716296481613	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296482614	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296482614	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9068	1716296482614	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296483616	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.800000000000001	1716296483616	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9068	1716296483616	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296484618	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.6000000000000005	1716296484618	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9068	1716296484618	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296485620	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296485620	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9059000000000001	1716296485620	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296486622	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296486622	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9059000000000001	1716296486622	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296487624	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296487624	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9059000000000001	1716296487624	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296488626	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296488626	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296488626	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296489627	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296489627	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296489627	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296490629	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296490629	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296490629	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296491631	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296491631	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9109	1716296491631	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296492633	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296492633	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9109	1716296492633	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296493635	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296493635	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9109	1716296493635	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296494637	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296494637	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9117	1716296494637	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296495639	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296495639	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9117	1716296495639	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296509690	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296510689	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296511691	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296512693	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296513695	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296514676	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9138	1716296514676	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296514697	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296515677	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296515677	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9117	1716296515677	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296515692	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296516679	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296516679	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9117	1716296516679	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296516701	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296517681	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296517681	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9117	1716296517681	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296517695	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296518683	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296518683	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9077	1716296518683	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296518705	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296519684	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296519684	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9077	1716296519684	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296519707	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296520686	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296520686	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9077	1716296520686	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296520702	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296521688	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296521688	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9132	1716296521688	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296521710	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296522690	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296522690	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9132	1716296522690	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296522712	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296523693	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296523693	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9132	1716296523693	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296523709	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296524695	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296524695	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9132	1716296524695	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296525697	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296525697	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9132	1716296525697	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296526699	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296526699	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9132	1716296526699	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296527701	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296527701	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9150999999999998	1716296527701	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296528703	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296528703	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9150999999999998	1716296528703	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296529705	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296529705	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9150999999999998	1716296529705	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296530707	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296530707	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9145999999999999	1716296530707	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296531708	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296531708	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9145999999999999	1716296531708	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296532710	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296532710	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9145999999999999	1716296532710	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296533712	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296533712	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9136	1716296533712	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296534714	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296534714	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9136	1716296534714	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296535715	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296535715	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9136	1716296535715	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296536717	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296536717	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9153	1716296536717	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296537719	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296537719	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9153	1716296537719	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296538721	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296538721	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9153	1716296538721	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296539723	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296539723	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9154	1716296539723	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296540725	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296540725	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9154	1716296540725	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296541727	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296541727	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9154	1716296541727	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296542728	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296542728	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125999999999999	1716296542728	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296543730	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296543730	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125999999999999	1716296543730	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296544732	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296544732	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125999999999999	1716296544732	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296545733	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296524719	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296525721	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296526721	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296527725	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296528724	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296529727	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296530723	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296531729	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296532732	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296533733	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296534736	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296535730	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296536739	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296537740	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296538742	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296539746	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296540748	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296541751	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296542742	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296543755	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296544756	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296545756	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296546749	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296547758	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296548761	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296549762	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296550763	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296551759	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296552768	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296553770	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296554772	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296555773	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296916437	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296916437	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9292	1716296916437	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296917439	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296917439	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9292	1716296917439	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296918441	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296918441	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9321	1716296918441	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296919443	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296919443	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9321	1716296919443	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296920445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296920445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9321	1716296920445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296921447	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296921447	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9309	1716296921447	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296922450	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296922450	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9309	1716296922450	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296923452	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296923452	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9309	1716296923452	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296924454	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296924454	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9312	1716296924454	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296925456	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296925456	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9312	1716296925456	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296926458	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296926458	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9312	1716296926458	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296545733	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296545733	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296546735	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296546735	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296546735	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296547737	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296547737	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296547737	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296548739	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296548739	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296548739	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296549741	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296549741	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296549741	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296550743	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296550743	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296550743	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296551745	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296551745	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9149	1716296551745	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296552746	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296552746	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9149	1716296552746	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296553748	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296553748	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9149	1716296553748	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296554750	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296554750	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9161	1716296554750	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296555752	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296555752	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9161	1716296555752	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296556754	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296556754	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9161	1716296556754	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296556774	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296557757	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296557757	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9138	1716296557757	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296557771	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296558759	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296558759	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9138	1716296558759	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296558780	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296559761	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296559761	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9138	1716296559761	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296559782	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296560763	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296560763	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9156	1716296560763	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296560777	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296561765	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296561765	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9156	1716296561765	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296561788	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296562767	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296562767	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9156	1716296562767	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296562793	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296563768	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296563768	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9072	1716296563768	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296563790	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296564771	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296564771	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9072	1716296564771	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296565773	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296565773	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9072	1716296565773	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296566775	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296566775	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9079000000000002	1716296566775	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296567776	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296567776	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9079000000000002	1716296567776	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296568778	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296568778	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9079000000000002	1716296568778	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296569781	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296569781	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9087	1716296569781	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296570785	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296570785	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9087	1716296570785	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296571786	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296571786	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9087	1716296571786	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296572788	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296572788	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9089	1716296572788	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296573790	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296573790	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9089	1716296573790	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296574792	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296574792	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9089	1716296574792	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296575794	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296575794	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296575794	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296576796	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296576796	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296576796	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296577798	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296577798	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296577798	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296578800	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296578800	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296578800	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296579802	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296579802	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296579802	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296580804	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296580804	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296580804	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296581805	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296581805	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9127	1716296581805	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296582807	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296582807	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9127	1716296582807	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296583809	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296583809	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9127	1716296583809	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296584811	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296584811	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9107	1716296584811	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296585813	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296564792	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296565788	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296566788	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296567798	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296568799	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296569803	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296570806	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296571801	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296572804	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296573805	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296574808	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296575809	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296576815	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296577819	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296578821	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296579825	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296580817	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296581831	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296582829	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296583831	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296584834	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296585836	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296586836	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296587838	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296588839	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296589842	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296590844	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296591845	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296592848	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296593842	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296594852	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296595854	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296596855	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296597857	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296598863	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296599860	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296600863	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296601865	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296602869	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296603868	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296604873	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296605865	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296606879	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296607877	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296608878	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296609881	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296610873	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296611883	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296612888	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296613889	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296614891	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296615885	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296916456	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296917458	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296918463	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296919465	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296920460	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296921471	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296922473	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296923475	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296924468	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296925471	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296926484	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296927483	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296928483	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296585813	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9107	1716296585813	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296586815	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296586815	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9107	1716296586815	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296587817	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296587817	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9135	1716296587817	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296588818	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296588818	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9135	1716296588818	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296589820	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296589820	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9135	1716296589820	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296590822	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296590822	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.914	1716296590822	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296591824	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.3	1716296591824	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.914	1716296591824	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296592825	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296592825	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.914	1716296592825	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296593827	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296593827	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9134	1716296593827	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296594829	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296594829	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9134	1716296594829	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296595831	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296595831	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9134	1716296595831	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296596833	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296596833	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9162000000000001	1716296596833	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296597835	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296597835	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9162000000000001	1716296597835	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296598837	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296598837	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9162000000000001	1716296598837	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296599839	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296599839	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9144	1716296599839	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296600840	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296600840	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9144	1716296600840	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296601843	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296601843	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9144	1716296601843	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296602844	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296602844	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.915	1716296602844	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296603847	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296603847	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.915	1716296603847	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296604849	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296604849	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.915	1716296604849	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296605851	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296605851	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9155	1716296605851	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296606853	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296606853	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9155	1716296606853	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296607854	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296607854	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9155	1716296607854	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296608856	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296608856	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.91	1716296608856	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296609858	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296609858	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.91	1716296609858	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296610860	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296610860	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.91	1716296610860	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296611862	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296611862	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.914	1716296611862	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296612864	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296612864	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.914	1716296612864	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296613866	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296613866	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.914	1716296613866	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296614868	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296614868	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296614868	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296615870	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296615870	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296615870	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296616871	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296616871	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9125	1716296616871	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296616892	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296617873	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296617873	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.913	1716296617873	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296617895	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296618876	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296618876	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.913	1716296618876	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296618898	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296619878	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296619878	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.913	1716296619878	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296619900	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296620880	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296620880	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9141	1716296620880	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296620895	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296621883	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296621883	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9141	1716296621883	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296621905	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296622884	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296622884	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9141	1716296622884	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296622905	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296623886	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296623886	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9153	1716296623886	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296623907	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296624888	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	5.9	1716296624888	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9153	1716296624888	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296624908	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296625890	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.7	1716296625890	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9153	1716296625890	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296626892	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296626892	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9181	1716296626892	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296627894	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296627894	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9181	1716296627894	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296628896	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296628896	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9181	1716296628896	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296629898	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296629898	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9105999999999999	1716296629898	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296630899	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296630899	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9105999999999999	1716296630899	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296631902	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296631902	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9105999999999999	1716296631902	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296632904	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296632904	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9129	1716296632904	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296633906	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296633906	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9129	1716296633906	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296634908	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296634908	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9129	1716296634908	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296635909	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296635909	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9110999999999998	1716296635909	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296636911	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296636911	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9110999999999998	1716296636911	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296637913	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296637913	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9110999999999998	1716296637913	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296638915	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296638915	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.916	1716296638915	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296639917	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296639917	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.916	1716296639917	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296640918	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296640918	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.916	1716296640918	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296641920	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296641920	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9154	1716296641920	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296642922	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296642922	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9154	1716296642922	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296643923	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296643923	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9154	1716296643923	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296644925	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296644925	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9155	1716296644925	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296645927	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296645927	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9155	1716296645927	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296646928	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296625907	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296626913	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296627916	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296628917	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296629912	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296630913	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296631925	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296632925	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296633929	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296634929	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296635923	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296636925	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296637935	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296638938	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296639938	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296640939	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296641934	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296642943	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296643943	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296644947	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296645949	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296646951	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296647952	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296648948	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296649960	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296650958	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296651953	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296652963	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296653964	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296654967	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296655969	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296656963	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296657973	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296658973	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296659971	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296660978	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296661980	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296662982	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296663982	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296664985	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296665988	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296666982	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296667986	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296668995	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296669996	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296670994	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296671990	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296673001	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296674001	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296674995	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296675998	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296927460	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296927460	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9344000000000001	1716296927460	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296928462	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296928462	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9344000000000001	1716296928462	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296929464	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296929464	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9344000000000001	1716296929464	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296930466	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296930466	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.934	1716296930466	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296931468	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296931468	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296646928	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9155	1716296646928	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296647930	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296647930	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9154	1716296647930	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296648933	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296648933	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9154	1716296648933	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296649935	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296649935	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9154	1716296649935	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296650937	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296650937	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9156	1716296650937	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296651938	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296651938	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9156	1716296651938	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296652940	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	4.7	1716296652940	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9156	1716296652940	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296653943	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296653943	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9137	1716296653943	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296654945	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296654945	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9137	1716296654945	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296655947	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296655947	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9137	1716296655947	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296656948	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296656948	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.916	1716296656948	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296657950	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296657950	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.916	1716296657950	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296658952	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296658952	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.916	1716296658952	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296659954	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296659954	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9154	1716296659954	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296660956	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296660956	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9154	1716296660956	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296661958	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296661958	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9154	1716296661958	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296662960	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296662960	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9158	1716296662960	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296663961	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296663961	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9158	1716296663961	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296664963	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296664963	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9158	1716296664963	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296665965	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296665965	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9155	1716296665965	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296666967	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296666967	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9155	1716296666967	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296667968	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296667968	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9155	1716296667968	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296668970	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296668970	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9165	1716296668970	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296669972	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296669972	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9165	1716296669972	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296670974	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296670974	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9165	1716296670974	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296671975	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296671975	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9173	1716296671975	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296672977	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296672977	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9173	1716296672977	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296673979	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296673979	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9173	1716296673979	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296674981	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296674981	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9189	1716296674981	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296675983	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296675983	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9189	1716296675983	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296676985	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296676985	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9189	1716296676985	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296677008	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296677987	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296677987	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9189	1716296677987	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296678012	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296678988	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296678988	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9189	1716296678988	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296679010	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296679990	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296679990	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9189	1716296679990	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296680014	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296680992	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296680992	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9196	1716296680992	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296681006	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296681993	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296681993	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9196	1716296681993	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296682016	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296682995	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296682995	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9196	1716296682995	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296683020	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296683997	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296683997	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9207	1716296683997	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296684020	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296684998	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296684998	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9207	1716296684998	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296685019	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296686000	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296686000	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9207	1716296686000	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296686015	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296687023	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296688026	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296689028	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296690028	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296691031	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296692034	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296693036	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296694040	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296695040	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296696035	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296697041	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296698045	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296699047	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296700049	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296701041	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296702058	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296703053	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296704054	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296705056	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296706059	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296707061	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296708066	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296709057	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296710068	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296711063	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296712072	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296713073	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296714075	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296715076	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296716073	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296717072	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296718083	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296719087	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296720088	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296721088	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296722090	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296723092	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296724094	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296725097	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296726090	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296727100	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296728103	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296729105	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296730106	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296731100	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296732108	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296733112	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296734113	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296735118	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296736110	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296737112	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296738122	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296739123	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296740127	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296741121	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296742130	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296743125	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296744137	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296745135	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296746131	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296747131	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296748141	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296749145	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296750145	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296687002	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296687002	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9194	1716296687002	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296688004	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296688004	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9194	1716296688004	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296689005	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296689005	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9194	1716296689005	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296690007	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296690007	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9183	1716296690007	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296691009	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296691009	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9183	1716296691009	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296692011	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296692011	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9183	1716296692011	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296693013	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296693013	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9203	1716296693013	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296694015	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296694015	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9203	1716296694015	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296695017	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296695017	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9203	1716296695017	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296696018	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296696018	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9148	1716296696018	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296697020	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296697020	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9148	1716296697020	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296698022	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296698022	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9148	1716296698022	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296699024	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296699024	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9201	1716296699024	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296700026	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296700026	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9201	1716296700026	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296701028	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296701028	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9201	1716296701028	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296702030	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296702030	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9214	1716296702030	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296703031	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296703031	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9214	1716296703031	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296704033	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296704033	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9214	1716296704033	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296705035	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296705035	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9205	1716296705035	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296706037	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296706037	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9205	1716296706037	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296707039	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296707039	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9205	1716296707039	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296708042	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296708042	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9193	1716296708042	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296709044	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296709044	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9193	1716296709044	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296710046	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296710046	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9193	1716296710046	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296711048	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296711048	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9223	1716296711048	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296712050	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296712050	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9223	1716296712050	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296713052	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296713052	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9223	1716296713052	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296714053	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296714053	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.922	1716296714053	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296715055	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296715055	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.922	1716296715055	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296716057	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296716057	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.922	1716296716057	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296717059	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296717059	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9194	1716296717059	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296718061	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296718061	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9194	1716296718061	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296719063	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296719063	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9194	1716296719063	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296720065	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296720065	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9201	1716296720065	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296721067	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296721067	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9201	1716296721067	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296722069	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296722069	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9201	1716296722069	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	105	1716296723071	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296723071	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9227	1716296723071	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296724073	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296724073	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9227	1716296724073	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296725074	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296725074	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9227	1716296725074	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296726076	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296726076	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9245	1716296726076	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296727078	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296727078	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9245	1716296727078	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296728080	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296728080	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9245	1716296728080	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296729082	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296729082	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9222000000000001	1716296729082	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296730084	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296730084	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9222000000000001	1716296730084	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296731086	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296731086	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9222000000000001	1716296731086	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296732088	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296732088	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.924	1716296732088	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296733090	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296733090	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.924	1716296733090	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296734092	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296734092	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.924	1716296734092	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296735094	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296735094	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9230999999999998	1716296735094	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296736096	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296736096	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9230999999999998	1716296736096	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296737098	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296737098	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9230999999999998	1716296737098	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296738099	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296738099	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9241	1716296738099	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296739101	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296739101	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9241	1716296739101	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296740104	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296740104	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9241	1716296740104	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296741107	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296741107	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9209	1716296741107	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296742108	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296742108	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9209	1716296742108	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296743110	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296743110	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9209	1716296743110	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296744112	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296744112	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9205999999999999	1716296744112	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296745114	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296745114	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9205999999999999	1716296745114	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296746116	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296746116	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9205999999999999	1716296746116	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296747118	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296747118	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9241	1716296747118	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296748120	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296748120	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9241	1716296748120	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296749122	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296749122	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9241	1716296749122	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296750124	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296750124	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.924	1716296750124	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296751125	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296751125	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.924	1716296751125	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296752127	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296752127	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.924	1716296752127	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296753129	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296753129	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9228	1716296753129	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296754131	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296754131	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9228	1716296754131	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296755133	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6	1716296755133	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9228	1716296755133	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296756135	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8	1716296756135	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9243	1716296756135	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296757137	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296757137	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9243	1716296757137	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296758138	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296758138	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9243	1716296758138	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296759140	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296759140	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9261	1716296759140	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296760142	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296760142	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9261	1716296760142	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296761144	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296761144	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9261	1716296761144	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296762146	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296762146	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.918	1716296762146	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296763148	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296763148	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.918	1716296763148	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296764150	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296764150	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.918	1716296764150	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296765151	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296765151	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9233	1716296765151	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296766153	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296766153	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9233	1716296766153	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296767155	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296767155	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9233	1716296767155	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296768157	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296768157	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9239000000000002	1716296768157	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296769159	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296769159	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9239000000000002	1716296769159	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296770160	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296770160	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9239000000000002	1716296770160	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296771162	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296771162	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9232	1716296771162	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296772164	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296751145	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296752150	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296753144	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296754148	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296755148	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296756150	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296757159	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296758157	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296759164	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296760163	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296761157	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296762169	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296763171	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296764173	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296765165	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296766169	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296767177	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296768180	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296769180	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296770183	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296771177	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296772187	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296773184	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296774182	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296775185	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296776188	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296777187	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296778195	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296779198	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296780193	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296781205	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296782205	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296783207	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296784209	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296785203	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296786211	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296787215	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296788215	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296789217	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296790212	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296791221	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296792224	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296793222	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296794229	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296795221	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296929485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296930485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296931491	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296932492	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296933496	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296934494	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296935497	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296936492	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296937501	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296938504	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296939503	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.932	1716296940485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296940510	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296941486	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296941486	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.932	1716296941486	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296941503	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296942488	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296942488	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9342000000000001	1716296942488	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296772164	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9232	1716296772164	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296773166	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296773166	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9232	1716296773166	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296774168	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296774168	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9245	1716296774168	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296775170	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296775170	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9245	1716296775170	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296776172	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296776172	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9245	1716296776172	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296777174	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296777174	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9253	1716296777174	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296778176	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296778176	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9253	1716296778176	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296779178	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296779178	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9253	1716296779178	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	105	1716296780179	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296780179	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9247999999999998	1716296780179	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296781181	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296781181	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9247999999999998	1716296781181	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296782183	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716296782183	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9247999999999998	1716296782183	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296783185	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296783185	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9255	1716296783185	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296784187	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296784187	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9255	1716296784187	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296785188	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296785188	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9255	1716296785188	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296786190	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296786190	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9238	1716296786190	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296787192	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296787192	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9238	1716296787192	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296788194	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296788194	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9238	1716296788194	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296789196	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296789196	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9249	1716296789196	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296790197	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296790197	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9249	1716296790197	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296791199	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296791199	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9249	1716296791199	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296792201	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296792201	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.926	1716296792201	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296793203	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296793203	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.926	1716296793203	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296794205	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296794205	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.926	1716296794205	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296795207	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296795207	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9262000000000001	1716296795207	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296796208	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296796208	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9262000000000001	1716296796208	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296796223	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296797210	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296797210	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9262000000000001	1716296797210	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296797230	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296798212	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296798212	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9258	1716296798212	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296798233	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296799214	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296799214	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9258	1716296799214	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296799235	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296800215	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296800215	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9258	1716296800215	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296800237	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296801217	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296801217	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9233	1716296801217	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296801232	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296802219	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296802219	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9233	1716296802219	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296802242	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296803221	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296803221	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9233	1716296803221	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296803242	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296804223	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296804223	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.927	1716296804223	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296804247	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296805225	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296805225	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.927	1716296805225	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296805245	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296806227	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296806227	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.927	1716296806227	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296806240	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296807228	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296807228	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9239000000000002	1716296807228	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296807249	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296808230	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296808230	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9239000000000002	1716296808230	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296808253	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296809232	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296809232	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9239000000000002	1716296809232	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296809254	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296810234	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296810234	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9214	1716296810234	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296811236	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296811236	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9214	1716296811236	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296812239	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296812239	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9214	1716296812239	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296813241	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296813241	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9201	1716296813241	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296814243	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296814243	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9201	1716296814243	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296815245	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296815245	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9201	1716296815245	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296816246	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296816246	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9222000000000001	1716296816246	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296817248	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296817248	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9222000000000001	1716296817248	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296818250	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296818250	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9222000000000001	1716296818250	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296819252	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296819252	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9233	1716296819252	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296820254	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296820254	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9233	1716296820254	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296821255	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296821255	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9233	1716296821255	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296822257	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296822257	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9232	1716296822257	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296823259	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296823259	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9232	1716296823259	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296824261	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296824261	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9232	1716296824261	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296825263	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296825263	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9222000000000001	1716296825263	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296826265	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296826265	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9222000000000001	1716296826265	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296827267	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296827267	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9222000000000001	1716296827267	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296828268	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296828268	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.925	1716296828268	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296829271	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296829271	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.925	1716296829271	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296830273	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296830273	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.925	1716296830273	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296831275	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296831275	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296810247	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296811258	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296812260	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296813266	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296814264	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296815258	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296816268	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296817271	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296818273	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296819274	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296820267	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296821279	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296822278	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296823280	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296824283	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296825277	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296826286	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296827288	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296828289	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296829293	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296830295	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296831292	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296832299	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296833300	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296834304	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296835304	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296836298	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296837307	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296838310	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296839311	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296840306	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296841313	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296842315	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296843319	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296844322	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296845316	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296846326	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296847326	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296848327	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296849328	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296850323	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296851332	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296852334	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296853338	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296854338	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296855335	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296856342	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296857344	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296858348	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296859347	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296860349	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296861343	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296862352	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296863354	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296864350	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296865352	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296866352	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296867358	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296868364	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296869366	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296870361	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296871370	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296872364	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296873374	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296874382	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9245	1716296831275	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296832277	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296832277	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9245	1716296832277	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296833278	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296833278	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9245	1716296833278	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296834279	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296834279	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9253	1716296834279	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296835281	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296835281	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9253	1716296835281	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296836283	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296836283	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9253	1716296836283	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296837285	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296837285	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9270999999999998	1716296837285	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296838287	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296838287	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9270999999999998	1716296838287	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296839288	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296839288	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9270999999999998	1716296839288	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296840290	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296840290	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9267999999999998	1716296840290	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296841292	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296841292	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9267999999999998	1716296841292	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296842294	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296842294	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9267999999999998	1716296842294	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296843296	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296843296	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9274	1716296843296	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296844298	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296844298	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9274	1716296844298	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296845299	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296845299	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9274	1716296845299	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296846301	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296846301	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9269	1716296846301	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296847303	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296847303	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9269	1716296847303	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296848305	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296848305	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9269	1716296848305	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296849307	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296849307	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9272	1716296849307	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296850309	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296850309	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9272	1716296850309	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296851311	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296851311	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9272	1716296851311	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296852313	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296852313	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9269	1716296852313	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296853315	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296853315	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9269	1716296853315	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296854317	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296854317	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9269	1716296854317	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296855318	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296855318	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9269	1716296855318	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296856320	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296856320	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9269	1716296856320	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296857322	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296857322	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9269	1716296857322	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296858324	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296858324	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.929	1716296858324	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296859325	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296859325	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.929	1716296859325	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296860328	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296860328	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.929	1716296860328	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296861330	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296861330	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9287	1716296861330	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296862331	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296862331	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9287	1716296862331	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296863333	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296863333	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9287	1716296863333	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296864336	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296864336	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9294	1716296864336	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296865338	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296865338	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9294	1716296865338	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296866339	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296866339	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9294	1716296866339	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296867341	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296867341	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9301	1716296867341	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296868343	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296868343	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9301	1716296868343	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296869345	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296869345	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9301	1716296869345	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296870347	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296870347	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9322000000000001	1716296870347	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296871348	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296871348	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9322000000000001	1716296871348	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296872350	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296872350	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9322000000000001	1716296872350	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296873352	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296873352	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9304000000000001	1716296873352	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296874354	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296874354	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9304000000000001	1716296874354	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296875357	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296875357	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9304000000000001	1716296875357	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296876359	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296876359	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9278	1716296876359	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296877362	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296877362	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9278	1716296877362	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296878364	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296878364	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9278	1716296878364	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296879366	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296879366	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.929	1716296879366	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296880368	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296880368	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.929	1716296880368	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296881370	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296881370	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.929	1716296881370	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296882372	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296882372	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9314	1716296882372	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296883373	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296883373	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9314	1716296883373	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296884375	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296884375	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9314	1716296884375	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296885377	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296885377	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9305	1716296885377	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296886379	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296886379	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9305	1716296886379	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296887382	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296887382	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9305	1716296887382	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296888384	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296888384	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9309	1716296888384	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296889385	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.1	1716296889385	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9309	1716296889385	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296890387	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7.8999999999999995	1716296890387	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9309	1716296890387	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296891388	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296891388	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9301	1716296891388	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296892391	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296892391	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9301	1716296892391	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296893393	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296893393	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9301	1716296893393	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296894395	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296894395	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9245	1716296894395	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296895397	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296895397	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296875373	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296876380	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296877384	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296878385	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296879382	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296880381	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296881391	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296882392	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296883388	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296884390	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296885399	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296886405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296887403	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296888409	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296889410	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296890400	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296891409	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296892407	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296893410	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296894409	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296895419	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296896421	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296897424	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296898417	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296899426	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296900430	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296901430	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296902431	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296903426	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296904435	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296905431	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296906441	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296907443	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296908443	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296909445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296910442	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296911449	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296912455	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296913445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296914458	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296915449	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.934	1716296931468	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296932470	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296932470	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.934	1716296932470	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296933471	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296933471	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9329	1716296933471	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296934473	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296934473	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9329	1716296934473	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296935475	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296935475	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9329	1716296935475	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296936477	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296936477	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9336	1716296936477	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296937479	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296937479	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9336	1716296937479	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296938481	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296938481	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9336	1716296938481	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296939483	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296939483	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9245	1716296895397	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296896399	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296896399	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9245	1716296896399	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296897401	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296897401	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9273	1716296897401	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296898403	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296898403	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9273	1716296898403	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296899405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296899405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9273	1716296899405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296900407	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296900407	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9299000000000002	1716296900407	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296901408	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296901408	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9299000000000002	1716296901408	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296902410	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296902410	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9299000000000002	1716296902410	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296903412	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296903412	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9295	1716296903412	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296904414	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296904414	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9295	1716296904414	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296905416	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296905416	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9295	1716296905416	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296906419	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296906419	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9293	1716296906419	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296907420	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296907420	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9293	1716296907420	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296908422	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296908422	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9293	1716296908422	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296909424	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296909424	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9327999999999999	1716296909424	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296910426	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296910426	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9327999999999999	1716296910426	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296911428	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296911428	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9327999999999999	1716296911428	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296912430	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296912430	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9330999999999998	1716296912430	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296913432	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296913432	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9330999999999998	1716296913432	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296914434	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296914434	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9330999999999998	1716296914434	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296915436	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296915436	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9292	1716296915436	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.932	1716296939483	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296940485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296940485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296942509	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296943505	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296944507	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296945517	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296946517	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296947512	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296948523	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296949517	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296950524	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296951519	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296952528	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296953530	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296954524	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296955536	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296956529	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296957540	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296958541	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296959534	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296960535	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296961545	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296962539	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296963548	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296964543	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296965547	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296966555	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296967558	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296968559	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296969553	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296970554	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296971566	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296972564	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296973559	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296974562	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296975566	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296976576	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296977569	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296978578	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296979573	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296980581	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296981575	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296982583	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296983587	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296984581	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296985592	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296986586	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296987593	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296988599	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296989591	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296990601	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296991604	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296992603	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296993605	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296994599	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296995609	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296996604	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296997614	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296998618	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716296999610	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297000620	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297001614	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297002624	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297003626	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297004623	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297005622	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297006624	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296943490	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296943490	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9342000000000001	1716296943490	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296944492	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296944492	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9342000000000001	1716296944492	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296945494	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296945494	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9358	1716296945494	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296946496	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296946496	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9358	1716296946496	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296947497	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296947497	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9358	1716296947497	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296948499	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296948499	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9362000000000001	1716296948499	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296949501	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296949501	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9362000000000001	1716296949501	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296950503	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296950503	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9362000000000001	1716296950503	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296951505	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296951505	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9379000000000002	1716296951505	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296952507	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296952507	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9379000000000002	1716296952507	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296953508	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296953508	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9379000000000002	1716296953508	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296954510	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296954510	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9387	1716296954510	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296955512	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296955512	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9387	1716296955512	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296956514	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296956514	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9387	1716296956514	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296957516	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296957516	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9356	1716296957516	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296958518	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296958518	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9356	1716296958518	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296959520	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296959520	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9356	1716296959520	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296960522	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296960522	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9335	1716296960522	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296961524	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296961524	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9335	1716296961524	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296962525	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296962525	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9335	1716296962525	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296963527	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296963527	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9332	1716296963527	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296964529	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296964529	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9332	1716296964529	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296965531	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296965531	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9332	1716296965531	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296966533	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296966533	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9345	1716296966533	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296967535	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296967535	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9345	1716296967535	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296968537	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296968537	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9345	1716296968537	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296969538	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296969538	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9387	1716296969538	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296970540	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296970540	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9387	1716296970540	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296971542	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296971542	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9387	1716296971542	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296972544	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296972544	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9381	1716296972544	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296973545	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296973545	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9381	1716296973545	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296974547	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296974547	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9381	1716296974547	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	105	1716296975550	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716296975550	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9365999999999999	1716296975550	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296976551	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296976551	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9365999999999999	1716296976551	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296977553	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296977553	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9365999999999999	1716296977553	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296978555	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296978555	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9313	1716296978555	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296979557	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296979557	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9313	1716296979557	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296980559	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296980559	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9313	1716296980559	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296981561	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296981561	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9343	1716296981561	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716296982563	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296982563	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9343	1716296982563	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716296983565	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296983565	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9343	1716296983565	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296984566	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296984566	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9345	1716296984566	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296985568	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296985568	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9345	1716296985568	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296986570	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296986570	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9345	1716296986570	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296987572	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296987572	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9362000000000001	1716296987572	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296988574	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296988574	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9362000000000001	1716296988574	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296989576	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296989576	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9362000000000001	1716296989576	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296990578	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296990578	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9347	1716296990578	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296991580	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296991580	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9347	1716296991580	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296992582	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296992582	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9347	1716296992582	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296993584	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296993584	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9332	1716296993584	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716296994585	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296994585	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9332	1716296994585	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716296995587	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296995587	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9332	1716296995587	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296996590	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296996590	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.939	1716296996590	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296997592	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296997592	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.939	1716296997592	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296998594	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716296998594	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.939	1716296998594	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716296999596	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716296999596	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9385999999999999	1716296999596	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297000597	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716297000597	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9385999999999999	1716297000597	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297001599	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716297001599	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9385999999999999	1716297001599	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297002601	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716297002601	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9373	1716297002601	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297003604	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716297003604	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9373	1716297003604	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297004606	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716297004606	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9373	1716297004606	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297005608	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716297005608	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9338	1716297005608	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297006609	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716297006609	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9338	1716297006609	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297007611	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716297007611	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9338	1716297007611	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297008613	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716297008613	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.937	1716297008613	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297009615	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716297009615	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.937	1716297009615	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297010617	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716297010617	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.937	1716297010617	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297011619	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.2	1716297011619	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9374	1716297011619	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297012621	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8	1716297012621	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9374	1716297012621	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297013623	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297013623	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9374	1716297013623	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297014625	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297014625	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9378	1716297014625	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297015627	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297015627	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9378	1716297015627	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297016629	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297016629	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9378	1716297016629	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297017631	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297017631	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9379000000000002	1716297017631	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297018633	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297018633	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9379000000000002	1716297018633	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297019635	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297019635	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9379000000000002	1716297019635	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297020637	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297020637	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9390999999999998	1716297020637	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297021639	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297021639	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9390999999999998	1716297021639	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297022641	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297022641	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9390999999999998	1716297022641	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297023643	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297023643	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9382000000000001	1716297023643	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297024645	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297024645	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9382000000000001	1716297024645	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297025646	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297025646	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9382000000000001	1716297025646	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297026648	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297026648	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9395	1716297026648	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297027652	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297027652	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9395	1716297027652	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297028653	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297007625	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297008635	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297009629	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297010634	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297011637	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297012645	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297013645	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297014643	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297015644	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297016650	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297017652	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297018658	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297019650	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297020652	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297021654	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297022655	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297023664	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297024660	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297025661	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297026672	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297027676	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297028675	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297029669	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297030673	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297031682	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297032682	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297033683	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297034678	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297035682	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297396356	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297396356	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9615	1716297396356	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297397357	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297397357	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9615	1716297397357	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297398359	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297398359	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9614	1716297398359	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297399361	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297399361	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9614	1716297399361	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297400363	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297400363	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9614	1716297400363	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297401365	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297401365	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9637	1716297401365	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297402367	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297402367	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9637	1716297402367	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297403369	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297403369	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9637	1716297403369	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297404371	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297404371	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9642	1716297404371	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297405373	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297405373	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9642	1716297405373	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297406375	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297406375	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9642	1716297406375	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297407377	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297407377	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9602	1716297407377	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297028653	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9395	1716297028653	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297029655	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297029655	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.939	1716297029655	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297030657	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297030657	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.939	1716297030657	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297031659	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297031659	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.939	1716297031659	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297032661	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297032661	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9395	1716297032661	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297033663	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297033663	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9395	1716297033663	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297034665	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297034665	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9395	1716297034665	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297035666	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297035666	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9373	1716297035666	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297036668	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297036668	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9373	1716297036668	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297036686	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297037670	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297037670	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9373	1716297037670	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297037693	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297038672	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297038672	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9425999999999999	1716297038672	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297038694	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297039674	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297039674	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9425999999999999	1716297039674	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297039689	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297040676	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297040676	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9425999999999999	1716297040676	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297040699	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297041677	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297041677	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9430999999999998	1716297041677	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297041692	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297042679	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297042679	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9430999999999998	1716297042679	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297042701	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297043681	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297043681	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9430999999999998	1716297043681	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297043704	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297044683	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297044683	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9387999999999999	1716297044683	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297044699	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297045686	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297045686	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9387999999999999	1716297045686	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297045699	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297046688	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297046688	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9387999999999999	1716297046688	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297047690	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297047690	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9412	1716297047690	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297048692	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297048692	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9412	1716297048692	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297049693	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297049693	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9412	1716297049693	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297050695	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297050695	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9415	1716297050695	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297051699	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297051699	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9415	1716297051699	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297052700	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297052700	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9415	1716297052700	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297053702	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297053702	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9399000000000002	1716297053702	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297054704	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297054704	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9399000000000002	1716297054704	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297055706	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297055706	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9399000000000002	1716297055706	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297056708	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297056708	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9421	1716297056708	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297057710	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297057710	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9421	1716297057710	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297058712	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297058712	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9421	1716297058712	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297059714	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297059714	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9407	1716297059714	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297060715	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297060715	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9407	1716297060715	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297061717	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297061717	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9407	1716297061717	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297062719	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297062719	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.942	1716297062719	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297063721	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297063721	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.942	1716297063721	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297064723	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.1	1716297064723	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.942	1716297064723	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297065725	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297065725	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9407999999999999	1716297065725	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297066728	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297066728	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9407999999999999	1716297066728	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297067730	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297067730	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297046705	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297047711	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297048713	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297049707	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297050710	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297051714	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297052715	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297053720	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297054718	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297055721	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297056729	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297057731	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297058734	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297059729	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297060729	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297061739	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297062742	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297063743	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297064739	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297065744	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297066744	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297067757	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297068754	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297069749	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297070751	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297071761	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297072763	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297073762	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297074760	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297075760	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297076770	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297077770	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297078773	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297079766	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297080777	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297081780	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297082781	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297083782	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297084778	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297085780	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297086792	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297087793	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297088795	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297089787	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297090790	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297091799	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297092801	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297093805	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297094797	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297095807	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297096805	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297097811	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297098810	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297099810	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297100810	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297101822	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297102822	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297103824	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297104817	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297105819	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297106821	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297107823	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297108832	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297109826	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297110830	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9407999999999999	1716297067730	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297068732	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297068732	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9438	1716297068732	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297069734	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297069734	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9438	1716297069734	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297070736	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297070736	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9438	1716297070736	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297071738	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297071738	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9444000000000001	1716297071738	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297072740	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297072740	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9444000000000001	1716297072740	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297073742	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297073742	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9444000000000001	1716297073742	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297074743	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297074743	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9437	1716297074743	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297075745	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297075745	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9437	1716297075745	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297076747	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297076747	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9437	1716297076747	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297077749	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297077749	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9456	1716297077749	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297078751	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297078751	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9456	1716297078751	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297079753	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297079753	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9456	1716297079753	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297080755	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297080755	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9455	1716297080755	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297081757	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297081757	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9455	1716297081757	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297082759	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297082759	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9455	1716297082759	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297083760	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297083760	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9444000000000001	1716297083760	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297084762	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297084762	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9444000000000001	1716297084762	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297085765	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297085765	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9444000000000001	1716297085765	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297086768	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297086768	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9407	1716297086768	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297087770	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297087770	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9407	1716297087770	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297088772	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297088772	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9407	1716297088772	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297089774	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297089774	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9425999999999999	1716297089774	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297090775	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297090775	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9425999999999999	1716297090775	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297091777	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297091777	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9425999999999999	1716297091777	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297092779	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297092779	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9462000000000002	1716297092779	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297093781	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297093781	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9462000000000002	1716297093781	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297094783	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297094783	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9462000000000002	1716297094783	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297095785	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297095785	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9427	1716297095785	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297096787	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297096787	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9427	1716297096787	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297097790	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297097790	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9427	1716297097790	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297098792	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297098792	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9452	1716297098792	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297099794	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297099794	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9452	1716297099794	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297100796	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297100796	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9452	1716297100796	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297101798	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297101798	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9422000000000001	1716297101798	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297102799	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297102799	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9422000000000001	1716297102799	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297103801	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297103801	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9422000000000001	1716297103801	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297104803	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297104803	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9417	1716297104803	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297105805	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297105805	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9417	1716297105805	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297106807	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297106807	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9417	1716297106807	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297107808	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297107808	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9425	1716297107808	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297108810	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297108810	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9425	1716297108810	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297109812	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297109812	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9425	1716297109812	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297110814	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297110814	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9424000000000001	1716297110814	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297111816	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297111816	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9424000000000001	1716297111816	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297112817	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297112817	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9424000000000001	1716297112817	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297113819	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297113819	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9432	1716297113819	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297114821	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297114821	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9432	1716297114821	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297115823	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297115823	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9432	1716297115823	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297116825	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297116825	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9445	1716297116825	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297117827	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297117827	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9445	1716297117827	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297118829	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297118829	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9445	1716297118829	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297119830	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297119830	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9445999999999999	1716297119830	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297120832	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297120832	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9445999999999999	1716297120832	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297121835	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.300000000000001	1716297121835	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9445999999999999	1716297121835	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297122837	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297122837	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9443	1716297122837	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297123838	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.700000000000001	1716297123838	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9443	1716297123838	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297124840	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.100000000000001	1716297124840	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9443	1716297124840	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297125842	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297125842	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9443	1716297125842	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297126844	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297126844	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9443	1716297126844	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297127845	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297127845	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9443	1716297127845	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297128847	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297128847	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9434	1716297128847	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297129849	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297129849	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9434	1716297129849	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	105	1716297130854	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297130854	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9434	1716297130854	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297131856	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297131856	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297111831	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297112835	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297113840	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297114843	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297115837	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297116842	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297117842	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297118850	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297119852	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297120848	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297121857	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297122859	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297123859	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297124853	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297125858	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297126860	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297127860	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297128862	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297129873	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297130869	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297131880	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297132880	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297133881	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297134884	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297135881	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297136889	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297137890	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297138893	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297139897	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297140895	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297141899	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297142899	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297143904	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297144903	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297145897	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297146907	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297147910	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297148909	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297149911	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297150909	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297151916	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297152920	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297153922	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297154924	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297155921	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297396369	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297397370	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297398381	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297399382	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297400384	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297401379	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297402388	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297403390	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297404394	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297405398	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297406389	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297407399	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297408403	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297409406	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297410405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297411406	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297412408	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297413409	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297414405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297415408	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9470999999999998	1716297131856	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297132858	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297132858	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9470999999999998	1716297132858	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297133860	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297133860	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9470999999999998	1716297133860	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297134863	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297134863	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9462000000000002	1716297134863	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297135865	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297135865	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9462000000000002	1716297135865	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297136867	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297136867	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9462000000000002	1716297136867	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297137868	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297137868	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9474	1716297137868	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297138870	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297138870	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9474	1716297138870	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297139872	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297139872	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9474	1716297139872	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297140874	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297140874	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485	1716297140874	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297141876	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297141876	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485	1716297141876	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297142877	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297142877	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485	1716297142877	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297143879	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297143879	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485999999999999	1716297143879	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297144881	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297144881	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485999999999999	1716297144881	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297145883	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297145883	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485999999999999	1716297145883	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297146885	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297146885	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9484000000000001	1716297146885	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297147887	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297147887	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9484000000000001	1716297147887	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297148888	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297148888	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9484000000000001	1716297148888	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297149890	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297149890	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9467	1716297149890	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297150892	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297150892	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9467	1716297150892	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297151894	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297151894	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9467	1716297151894	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297152896	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297152896	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9472	1716297152896	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297153898	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297153898	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9472	1716297153898	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297154900	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297154900	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9472	1716297154900	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297155902	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297155902	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9457	1716297155902	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297156904	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297156904	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9457	1716297156904	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297156925	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297157906	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297157906	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9457	1716297157906	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297157931	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297158907	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297158907	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9475	1716297158907	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297158921	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297159909	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297159909	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9475	1716297159909	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297159930	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297160911	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297160911	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9475	1716297160911	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297160927	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297161913	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297161913	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9472	1716297161913	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297161935	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297162915	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297162915	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9472	1716297162915	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297162936	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297163917	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297163917	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9472	1716297163917	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297163939	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297164918	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297164918	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9472	1716297164918	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297164941	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297165920	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297165920	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9472	1716297165920	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297165934	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297166922	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297166922	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9472	1716297166922	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297166944	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297167924	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297167924	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9497	1716297167924	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297167947	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297168926	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297168926	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9497	1716297168926	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297168947	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297169928	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297169928	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9497	1716297169928	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297169949	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297170952	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297171954	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297172955	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297173959	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297174960	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297175954	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297176963	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297177965	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297178969	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297179969	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297180963	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297181972	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297182976	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297183976	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297184980	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297185974	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297186984	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297187984	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297188987	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297189988	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297190983	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297191996	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297192985	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297193995	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297194991	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297195991	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297197001	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297198004	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297199008	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297200006	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297201011	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297202011	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297203016	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297204014	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297205012	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297206009	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297207019	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297208020	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297209024	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297210026	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297211020	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297212030	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297213031	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297214032	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297215034	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297216036	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297217038	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297218039	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297219041	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297220044	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297221038	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297222048	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297223051	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297224052	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297225054	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297226049	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297227057	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297228060	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297229061	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297230061	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297231063	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297232066	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297233066	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297234070	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297170930	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297170930	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9487	1716297170930	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297171932	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297171932	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9487	1716297171932	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297172934	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297172934	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9487	1716297172934	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297173935	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297173935	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9484000000000001	1716297173935	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297174937	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297174937	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9484000000000001	1716297174937	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297175939	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297175939	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9484000000000001	1716297175939	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297176941	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297176941	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9498	1716297176941	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297177943	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297177943	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9498	1716297177943	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297178945	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297178945	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9498	1716297178945	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297179947	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297179947	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9499000000000002	1716297179947	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297180949	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297180949	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9499000000000002	1716297180949	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297181951	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297181951	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9499000000000002	1716297181951	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297182953	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297182953	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9507	1716297182953	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297183955	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297183955	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9507	1716297183955	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297184957	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297184957	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9507	1716297184957	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297185959	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297185959	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9469	1716297185959	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297186961	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297186961	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9469	1716297186961	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297187963	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297187963	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9469	1716297187963	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297188964	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297188964	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9493	1716297188964	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297189966	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297189966	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9493	1716297189966	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297190968	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297190968	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9493	1716297190968	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297191970	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297191970	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9452	1716297191970	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297192972	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297192972	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9452	1716297192972	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297193974	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297193974	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9452	1716297193974	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297194976	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297194976	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485999999999999	1716297194976	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297195977	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297195977	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485999999999999	1716297195977	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297196979	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297196979	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485999999999999	1716297196979	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297197981	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297197981	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9469	1716297197981	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297198983	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297198983	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9469	1716297198983	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297199984	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297199984	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9469	1716297199984	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297200986	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297200986	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9483	1716297200986	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297201988	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297201988	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9483	1716297201988	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297202990	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297202990	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9483	1716297202990	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297203992	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297203992	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9495	1716297203992	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297204994	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297204994	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9495	1716297204994	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297205996	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297205996	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9495	1716297205996	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297206997	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297206997	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9487	1716297206997	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297207999	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297207999	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9487	1716297207999	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297209001	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297209001	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9487	1716297209001	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297210003	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297210003	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9516	1716297210003	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297211005	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297211005	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9516	1716297211005	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297212007	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297212007	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9516	1716297212007	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297213009	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297213009	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9516	1716297213009	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297214011	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297214011	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9516	1716297214011	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297215012	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297215012	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9516	1716297215012	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297216014	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297216014	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9510999999999998	1716297216014	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297217016	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297217016	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9510999999999998	1716297217016	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297218018	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297218018	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9513	1716297218018	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	105	1716297219020	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.600000000000001	1716297219020	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9513	1716297219020	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	99	1716297220022	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297220022	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9513	1716297220022	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297221024	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297221024	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9462000000000002	1716297221024	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297222025	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297222025	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9462000000000002	1716297222025	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297223027	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297223027	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9462000000000002	1716297223027	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297224030	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297224030	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9472	1716297224030	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297225031	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297225031	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9472	1716297225031	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297226033	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297226033	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9472	1716297226033	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297227035	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297227035	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9493	1716297227035	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297228037	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297228037	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9493	1716297228037	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297229038	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297229038	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9493	1716297229038	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297230040	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297230040	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9505	1716297230040	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297231042	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297231042	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9505	1716297231042	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297232044	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297232044	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9505	1716297232044	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297233045	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297233045	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.949	1716297233045	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297234047	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297234047	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.949	1716297234047	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297235049	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297235049	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.949	1716297235049	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297236051	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297236051	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9498	1716297236051	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297237053	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297237053	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9498	1716297237053	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297238055	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297238055	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9498	1716297238055	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297239057	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297239057	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.951	1716297239057	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297240058	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297240058	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.951	1716297240058	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297241060	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297241060	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.951	1716297241060	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297242062	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297242062	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9444000000000001	1716297242062	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297243064	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297243064	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9444000000000001	1716297243064	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297244066	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297244066	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9444000000000001	1716297244066	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297245068	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297245068	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485	1716297245068	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297246069	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297246069	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485	1716297246069	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297247071	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297247071	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485	1716297247071	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297248073	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297248073	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485999999999999	1716297248073	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297249075	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297249075	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485999999999999	1716297249075	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297250077	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297250077	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9485999999999999	1716297250077	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297251079	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297251079	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9502000000000002	1716297251079	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297252081	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297252081	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9502000000000002	1716297252081	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297253082	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297253082	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9502000000000002	1716297253082	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297254084	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297254084	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9516	1716297254084	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297255086	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297255086	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9516	1716297255086	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297256088	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297235071	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297236065	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297237077	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297238075	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297239079	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297240080	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297241074	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297242083	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297243085	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297244088	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297245083	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297246096	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297247093	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297248097	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297249098	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297250099	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297251093	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297252103	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297253109	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297254106	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297255107	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297256105	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297257113	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297258114	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297259117	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297260120	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297261113	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297262119	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297263127	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297264124	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297265128	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297266131	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297267134	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297268133	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297269136	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297270130	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297271141	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297272142	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297273142	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297274145	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297275138	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297276148	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297408378	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297408378	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9602	1716297408378	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297409380	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297409380	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9602	1716297409380	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297410382	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297410382	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9612	1716297410382	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297411384	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297411384	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9612	1716297411384	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297412386	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297412386	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9612	1716297412386	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297413388	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297413388	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9605	1716297413388	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297414390	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297414390	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9605	1716297414390	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297415391	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297415391	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297256088	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9516	1716297256088	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297257090	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297257090	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9522	1716297257090	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297258092	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297258092	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9522	1716297258092	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297259094	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297259094	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9522	1716297259094	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297260096	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297260096	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9524000000000001	1716297260096	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297261098	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297261098	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9524000000000001	1716297261098	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297262100	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297262100	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9524000000000001	1716297262100	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297263102	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297263102	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9464000000000001	1716297263102	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297264103	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297264103	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9464000000000001	1716297264103	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297265105	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297265105	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9464000000000001	1716297265105	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297266107	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297266107	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9510999999999998	1716297266107	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297267109	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297267109	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9510999999999998	1716297267109	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297268111	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297268111	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9510999999999998	1716297268111	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297269113	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297269113	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9521	1716297269113	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297270115	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297270115	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9521	1716297270115	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297271117	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297271117	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9521	1716297271117	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297272119	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297272119	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9514	1716297272119	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297273121	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297273121	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9514	1716297273121	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297274122	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297274122	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9514	1716297274122	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297275124	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297275124	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9536	1716297275124	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297276126	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297276126	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9536	1716297276126	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297277128	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297277128	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9536	1716297277128	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297277152	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297278130	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297278130	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.954	1716297278130	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297278152	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297279132	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297279132	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.954	1716297279132	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297279154	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297280134	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297280134	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.954	1716297280134	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297280156	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297281136	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297281136	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9521	1716297281136	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297281152	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297282138	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297282138	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9521	1716297282138	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297282163	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297283140	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297283140	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9521	1716297283140	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297283161	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297284142	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297284142	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9484000000000001	1716297284142	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297284158	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297285144	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.4	1716297285144	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9484000000000001	1716297285144	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297285169	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297286146	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.200000000000001	1716297286146	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9484000000000001	1716297286146	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297286160	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297287148	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297287148	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9519000000000002	1716297287148	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297287172	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297288149	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297288149	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9519000000000002	1716297288149	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297288171	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297289151	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297289151	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9519000000000002	1716297289151	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297289176	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297290153	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297290153	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9514	1716297290153	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297290165	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297291155	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297291155	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9514	1716297291155	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297291178	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297292157	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297292157	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9514	1716297292157	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297292171	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297293159	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297293159	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9527999999999999	1716297293159	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297294161	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297294161	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9527999999999999	1716297294161	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297295162	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297295162	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9527999999999999	1716297295162	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297296164	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297296164	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9549	1716297296164	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297297166	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297297166	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9549	1716297297166	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297298168	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297298168	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9549	1716297298168	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297299170	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297299170	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9547999999999999	1716297299170	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297300172	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297300172	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9547999999999999	1716297300172	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297301174	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297301174	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9547999999999999	1716297301174	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297302176	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297302176	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9555	1716297302176	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297303178	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297303178	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9555	1716297303178	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297304180	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297304180	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9555	1716297304180	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297305182	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297305182	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.954	1716297305182	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297306183	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297306183	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.954	1716297306183	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297307185	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297307185	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.954	1716297307185	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297308187	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297308187	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9525	1716297308187	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297309189	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297309189	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9525	1716297309189	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297310191	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297310191	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9525	1716297310191	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297311194	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297311194	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9519000000000002	1716297311194	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297312196	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297312196	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9519000000000002	1716297312196	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297313198	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297313198	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9519000000000002	1716297313198	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297314200	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297314200	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9515	1716297314200	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297293173	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297294181	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297295176	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297296186	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297297187	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297298190	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297299183	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297300186	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297301196	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297302199	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297303199	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297304202	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297305196	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297306205	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297307200	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297308202	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297309211	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297310212	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297311208	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297312216	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297313222	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297314215	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297315225	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297316220	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297317228	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297318230	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297319230	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297320234	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297321234	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297322229	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297323234	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297324242	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297325242	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297326239	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297327249	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297328250	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297329251	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297330254	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297331252	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297332255	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297333251	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297334261	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297335253	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297336261	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297337266	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297338270	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297339271	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297340266	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297341274	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297342277	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297343277	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297344273	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297345277	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297346285	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297347278	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297348290	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297349289	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297350290	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297351293	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297352289	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297353292	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297354302	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297355302	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297356296	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297357301	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297315202	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297315202	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9515	1716297315202	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297316204	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297316204	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9515	1716297316204	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297317205	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297317205	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9534	1716297317205	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297318207	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297318207	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9534	1716297318207	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297319209	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297319209	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9534	1716297319209	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297320211	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297320211	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9541	1716297320211	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297321213	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297321213	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9541	1716297321213	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297322215	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297322215	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9541	1716297322215	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297323217	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297323217	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9521	1716297323217	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297324219	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297324219	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9521	1716297324219	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297325220	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297325220	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9521	1716297325220	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297326222	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297326222	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9544000000000001	1716297326222	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297327225	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297327225	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9544000000000001	1716297327225	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297328227	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297328227	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9544000000000001	1716297328227	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297329229	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297329229	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9514	1716297329229	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297330231	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297330231	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9514	1716297330231	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297331233	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297331233	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9514	1716297331233	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297332235	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297332235	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9573	1716297332235	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297333237	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297333237	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9573	1716297333237	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297334238	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297334238	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9573	1716297334238	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297335240	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297335240	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9556	1716297335240	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297336242	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297336242	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9556	1716297336242	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297337245	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297337245	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9556	1716297337245	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297338247	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297338247	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9562	1716297338247	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297339249	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297339249	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9562	1716297339249	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297340251	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297340251	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9562	1716297340251	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297341253	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297341253	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9575	1716297341253	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297342255	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297342255	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9575	1716297342255	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297343256	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297343256	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9575	1716297343256	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297344258	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.700000000000001	1716297344258	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9576	1716297344258	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297345260	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297345260	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9576	1716297345260	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297346262	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297346262	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9576	1716297346262	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297347264	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297347264	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9586	1716297347264	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297348266	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297348266	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9586	1716297348266	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297349268	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297349268	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9586	1716297349268	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297350270	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297350270	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9475	1716297350270	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	99	1716297351272	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297351272	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9475	1716297351272	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297352274	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297352274	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9475	1716297352274	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297353276	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297353276	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9545	1716297353276	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297354279	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297354279	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9545	1716297354279	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297355281	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297355281	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9545	1716297355281	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297356283	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297356283	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9555	1716297356283	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297357285	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297357285	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9555	1716297357285	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297358286	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297358286	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9555	1716297358286	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297359288	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297359288	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9543	1716297359288	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297360290	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297360290	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9543	1716297360290	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297361292	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297361292	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9543	1716297361292	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297362293	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297362293	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9584000000000001	1716297362293	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297363295	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297363295	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9584000000000001	1716297363295	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297364297	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297364297	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9584000000000001	1716297364297	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297365298	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297365298	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9590999999999998	1716297365298	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297366300	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297366300	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9590999999999998	1716297366300	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297367302	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297367302	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9590999999999998	1716297367302	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297368304	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297368304	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9603	1716297368304	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297369305	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297369305	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9603	1716297369305	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297370307	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297370307	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9603	1716297370307	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297371310	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297371310	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9557	1716297371310	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297372311	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297372311	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9557	1716297372311	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297373313	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297373313	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9557	1716297373313	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297374315	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297374315	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.957	1716297374315	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297375317	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297375317	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.957	1716297375317	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297376319	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297376319	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.957	1716297376319	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297377321	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297377321	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9574	1716297377321	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297378323	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297378323	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9574	1716297378323	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297358309	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297359305	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297360311	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297361308	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297362306	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297363317	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297364318	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297365311	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297366322	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297367315	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297368319	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297369329	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297370323	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297371330	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297372325	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297373334	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297374338	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297375334	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297376340	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297377343	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297378344	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297379345	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297380340	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297381350	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297382344	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297383344	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297384348	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297385351	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297386359	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297387360	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297388362	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297389364	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297390361	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297391370	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297392369	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297393363	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297394373	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297395367	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9605	1716297415391	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297416393	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297416393	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9646	1716297416393	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297417395	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297417395	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9646	1716297417395	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297418397	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297418397	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9646	1716297418397	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297419399	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297419399	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9657	1716297419399	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297420401	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297420401	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9657	1716297420401	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297421403	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297421403	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9657	1716297421403	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297422405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297422405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9656	1716297422405	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297423407	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297423407	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9656	1716297423407	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297424408	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297424408	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297379324	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297379324	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9574	1716297379324	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297380326	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297380326	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9606	1716297380326	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297381328	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297381328	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9606	1716297381328	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297382330	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297382330	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9606	1716297382330	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297383332	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297383332	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9603	1716297383332	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297384334	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297384334	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9603	1716297384334	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297385335	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297385335	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9603	1716297385335	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297386337	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297386337	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9602	1716297386337	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297387339	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297387339	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9602	1716297387339	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297388341	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297388341	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9602	1716297388341	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297389343	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297389343	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9601	1716297389343	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297390345	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297390345	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9601	1716297390345	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297391347	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297391347	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9601	1716297391347	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297392348	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.3	1716297392348	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9577	1716297392348	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297393350	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.5	1716297393350	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9577	1716297393350	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297394352	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297394352	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9577	1716297394352	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297395354	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297395354	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9615	1716297395354	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297416406	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297417419	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297418421	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297419424	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297420415	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297421424	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297422428	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297423423	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9656	1716297424408	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297424430	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297425410	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297425410	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9634	1716297425410	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297425430	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297426433	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297427427	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297428437	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297429433	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297430435	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297431442	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297432445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297433450	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297434449	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297435446	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297436445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297437454	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297438448	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297439459	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297440462	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297441463	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297442464	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297443463	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297444467	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297445468	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297446463	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297447465	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297448469	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297449476	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297450478	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297451476	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297452482	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297453485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297454485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297455487	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297426412	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297426412	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9634	1716297426412	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297427414	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297427414	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9634	1716297427414	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297428416	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297428416	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9647000000000001	1716297428416	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297429418	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297429418	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9647000000000001	1716297429418	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	105	1716297430419	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297430419	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9647000000000001	1716297430419	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297431421	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297431421	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9530999999999998	1716297431421	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297432423	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297432423	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9530999999999998	1716297432423	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297433425	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297433425	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9530999999999998	1716297433425	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297434427	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297434427	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9627999999999999	1716297434427	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297435429	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297435429	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9627999999999999	1716297435429	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297436431	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297436431	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9627999999999999	1716297436431	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297437433	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297437433	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9638	1716297437433	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297438435	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297438435	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9638	1716297438435	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297439437	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	7	1716297439437	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9638	1716297439437	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297440438	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297440438	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9626	1716297440438	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297441440	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297441440	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9626	1716297441440	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297442442	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297442442	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9626	1716297442442	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297443443	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297443443	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9639000000000002	1716297443443	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297444445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297444445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9639000000000002	1716297444445	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297445447	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297445447	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9639000000000002	1716297445447	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297446449	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297446449	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9658	1716297446449	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297447451	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297447451	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9658	1716297447451	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297448453	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297448453	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9658	1716297448453	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297449455	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297449455	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9641	1716297449455	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297450456	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297450456	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9641	1716297450456	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297451458	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297451458	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9641	1716297451458	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297452460	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297452460	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9664000000000001	1716297452460	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297453462	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297453462	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9664000000000001	1716297453462	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297454464	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297454464	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9664000000000001	1716297454464	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297455466	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297455466	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9633	1716297455466	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297456468	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297456468	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9633	1716297456468	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297456482	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297457469	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297457469	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9633	1716297457469	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297457491	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297458471	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297458471	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9650999999999998	1716297458471	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297458496	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297459473	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297459473	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9650999999999998	1716297459473	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297459495	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297460475	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297460475	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9650999999999998	1716297460475	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297460497	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297461477	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297461477	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9644000000000001	1716297461477	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297461491	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297462479	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297462479	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9644000000000001	1716297462479	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297462505	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297463481	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297463481	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9644000000000001	1716297463481	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297463503	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297464483	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297464483	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9664000000000001	1716297464483	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297464504	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297465485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297465485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9664000000000001	1716297465485	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297466487	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297466487	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9664000000000001	1716297466487	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297467489	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297467489	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9641	1716297467489	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297468491	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297468491	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9641	1716297468491	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297469493	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297469493	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9641	1716297469493	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297470495	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297470495	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9655	1716297470495	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297471496	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297471496	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9655	1716297471496	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297472498	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297472498	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9655	1716297472498	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297473500	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297473500	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9646	1716297473500	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297474502	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297474502	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9646	1716297474502	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297475503	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297475503	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9646	1716297475503	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297476505	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297476505	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.967	1716297476505	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297477507	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297477507	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.967	1716297477507	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297478509	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297478509	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.967	1716297478509	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297479511	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297479511	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9675	1716297479511	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297480513	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297480513	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9675	1716297480513	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297481515	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297481515	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9675	1716297481515	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297482517	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297482517	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9673	1716297482517	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297483518	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297483518	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9673	1716297483518	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297484520	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297484520	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9673	1716297484520	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297485522	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297485522	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9669	1716297485522	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297486524	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297486524	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9669	1716297486524	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297465499	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297466501	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297467510	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297468504	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297469514	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297470518	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297471519	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297472519	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297473521	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297474521	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297475520	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297476521	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297477530	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297478531	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297479532	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297480526	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297481538	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297482537	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297483541	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297484534	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297485543	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297486547	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297487549	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297488550	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297489545	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297490547	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297491556	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297492557	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297493561	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297494563	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297495558	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297496567	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297497569	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297498571	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297499572	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297500567	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297501569	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297502578	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297503580	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297504582	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297505587	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297506585	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297507587	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297508589	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297509591	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297510586	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297511591	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297512599	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297513601	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297514605	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Swap Memory GB	0.0005	1716297515606	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297487526	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297487526	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9669	1716297487526	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297488529	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297488529	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9676	1716297488529	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297489530	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297489530	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9676	1716297489530	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297490532	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297490532	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9676	1716297490532	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297491534	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297491534	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9672	1716297491534	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297492536	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297492536	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9672	1716297492536	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297493538	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297493538	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9672	1716297493538	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297494540	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297494540	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9670999999999998	1716297494540	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297495542	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297495542	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9670999999999998	1716297495542	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297496544	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297496544	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9670999999999998	1716297496544	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297497546	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297497546	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9643	1716297497546	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297498549	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297498549	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9643	1716297498549	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	104	1716297499551	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297499551	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9643	1716297499551	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	100	1716297500553	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297500553	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9639000000000002	1716297500553	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297501555	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297501555	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9639000000000002	1716297501555	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297502557	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297502557	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9639000000000002	1716297502557	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297503559	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297503559	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9643	1716297503559	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297504560	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297504560	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9643	1716297504560	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297505562	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297505562	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9643	1716297505562	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297506564	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297506564	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9655	1716297506564	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297507566	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297507566	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9655	1716297507566	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297508568	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297508568	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9655	1716297508568	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297509570	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297509570	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9649	1716297509570	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297510572	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297510572	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9649	1716297510572	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297511574	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297511574	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9649	1716297511574	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297512576	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297512576	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9678	1716297512576	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	102	1716297513579	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	8.4	1716297513579	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9678	1716297513579	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	103	1716297514581	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297514581	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9678	1716297514581	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - CPU Utilization	101	1716297515583	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Utilization	6.6	1716297515583	09452534b65d4220852ca51ceb0f1b1f	0	f
TOP - Memory Usage GB	1.9694	1716297515583	09452534b65d4220852ca51ceb0f1b1f	0	f
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
letter	0	d55aeb55480742ba90b8213daffc30c9
workload	0	d55aeb55480742ba90b8213daffc30c9
listeners	smi+top+dcgmi	d55aeb55480742ba90b8213daffc30c9
params	'"-"'	d55aeb55480742ba90b8213daffc30c9
file	cifar10.py	d55aeb55480742ba90b8213daffc30c9
workload_listener	''	d55aeb55480742ba90b8213daffc30c9
letter	0	09452534b65d4220852ca51ceb0f1b1f
workload	0	09452534b65d4220852ca51ceb0f1b1f
listeners	smi+top+dcgmi	09452534b65d4220852ca51ceb0f1b1f
params	'"-"'	09452534b65d4220852ca51ceb0f1b1f
file	cifar10.py	09452534b65d4220852ca51ceb0f1b1f
workload_listener	''	09452534b65d4220852ca51ceb0f1b1f
model	cifar10.py	09452534b65d4220852ca51ceb0f1b1f
manual	False	09452534b65d4220852ca51ceb0f1b1f
max_epoch	5	09452534b65d4220852ca51ceb0f1b1f
max_time	172800	09452534b65d4220852ca51ceb0f1b1f
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
d55aeb55480742ba90b8213daffc30c9	rumbling-loon-196	UNKNOWN			daga	FAILED	1716296091410	1716296134957		active	s3://mlflow-storage/0/d55aeb55480742ba90b8213daffc30c9/artifacts	0	\N
09452534b65d4220852ca51ceb0f1b1f	(0 0) sneaky-donkey-597	UNKNOWN			daga	FINISHED	1716296180902	1716297517370		active	s3://mlflow-storage/0/09452534b65d4220852ca51ceb0f1b1f/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	d55aeb55480742ba90b8213daffc30c9
mlflow.source.name	file:///home/daga/radt#examples/pytorch	d55aeb55480742ba90b8213daffc30c9
mlflow.source.type	PROJECT	d55aeb55480742ba90b8213daffc30c9
mlflow.project.entryPoint	main	d55aeb55480742ba90b8213daffc30c9
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	d55aeb55480742ba90b8213daffc30c9
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	d55aeb55480742ba90b8213daffc30c9
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	d55aeb55480742ba90b8213daffc30c9
mlflow.runName	rumbling-loon-196	d55aeb55480742ba90b8213daffc30c9
mlflow.project.env	conda	d55aeb55480742ba90b8213daffc30c9
mlflow.project.backend	local	d55aeb55480742ba90b8213daffc30c9
mlflow.user	daga	09452534b65d4220852ca51ceb0f1b1f
mlflow.source.name	file:///home/daga/radt#examples/pytorch	09452534b65d4220852ca51ceb0f1b1f
mlflow.source.type	PROJECT	09452534b65d4220852ca51ceb0f1b1f
mlflow.project.entryPoint	main	09452534b65d4220852ca51ceb0f1b1f
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	09452534b65d4220852ca51ceb0f1b1f
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	09452534b65d4220852ca51ceb0f1b1f
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	09452534b65d4220852ca51ceb0f1b1f
mlflow.project.env	conda	09452534b65d4220852ca51ceb0f1b1f
mlflow.project.backend	local	09452534b65d4220852ca51ceb0f1b1f
mlflow.runName	(0 0) sneaky-donkey-597	09452534b65d4220852ca51ceb0f1b1f
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

