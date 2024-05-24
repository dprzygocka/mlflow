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
0	Default	s3://mlflow-storage/0	active	1716210302119	1716210302119
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
SMI - Power Draw	15.47	1716211561147	0	f	5275bcd90fa945bc9b551c01849ed128
SMI - Timestamp	1716211561.132	1716211561147	0	f	5275bcd90fa945bc9b551c01849ed128
SMI - GPU Util	0	1716211561147	0	f	5275bcd90fa945bc9b551c01849ed128
SMI - Mem Util	0	1716211561147	0	f	5275bcd90fa945bc9b551c01849ed128
SMI - Mem Used	0	1716211561147	0	f	5275bcd90fa945bc9b551c01849ed128
SMI - Performance State	0	1716211561147	0	f	5275bcd90fa945bc9b551c01849ed128
TOP - CPU Utilization	102	1716214281479	0	f	5275bcd90fa945bc9b551c01849ed128
TOP - Memory Usage GB	2.1335	1716214281479	0	f	5275bcd90fa945bc9b551c01849ed128
TOP - Memory Utilization	9.4	1716214281479	0	f	5275bcd90fa945bc9b551c01849ed128
TOP - Swap Memory GB	0.0174	1716214281501	0	f	5275bcd90fa945bc9b551c01849ed128
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	15.47	1716211561147	5275bcd90fa945bc9b551c01849ed128	0	f
SMI - Timestamp	1716211561.132	1716211561147	5275bcd90fa945bc9b551c01849ed128	0	f
SMI - GPU Util	0	1716211561147	5275bcd90fa945bc9b551c01849ed128	0	f
SMI - Mem Util	0	1716211561147	5275bcd90fa945bc9b551c01849ed128	0	f
SMI - Mem Used	0	1716211561147	5275bcd90fa945bc9b551c01849ed128	0	f
SMI - Performance State	0	1716211561147	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	0	1716211561210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	0	1716211561210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.2504000000000002	1716211561210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211561224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	143.79999999999998	1716211562212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716211562212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.2504000000000002	1716211562212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211562228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211563214	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716211563214	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.2504000000000002	1716211563214	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211563227	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211564216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3	1716211564216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4790999999999999	1716211564216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211564237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211565218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716211565218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4790999999999999	1716211565218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211565239	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211566220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3	1716211566220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4790999999999999	1716211566220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211566234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211567222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716211567222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4794	1716211567222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211567246	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	105	1716211568224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3	1716211568224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4794	1716211568224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211568245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211569226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716211569226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4794	1716211569226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211569247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211570228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3	1716211570228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4795	1716211570228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211570248	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211571230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716211571230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4795	1716211571230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211571251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211572232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716211572232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4795	1716211572232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211572253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211573233	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3	1716211573233	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4795999999999998	1716211573233	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211573255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211574235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716211574235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4795999999999998	1716211574235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211574258	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211575237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716211575237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4795999999999998	1716211575237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211575258	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211576261	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211577263	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211578265	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211579266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211580268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211581270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211582272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211583273	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211584275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211585278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211586279	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211587281	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211588285	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211589288	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211590286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211591289	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211592291	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211593293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211594295	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211595296	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211596298	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211597302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211598302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211599304	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211600307	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211601301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211602309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211603312	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211604315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211605316	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211606318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211607321	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211608323	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211609325	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211610325	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211611322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211612330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211613331	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211913898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211913898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9457	1716211913898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211914900	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211914900	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9457	1716211914900	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211915902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211915902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9441	1716211915902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211916904	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211916904	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9441	1716211916904	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211917906	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211917906	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9441	1716211917906	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211918908	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211918908	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9404000000000001	1716211918908	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211919910	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211919910	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9404000000000001	1716211919910	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211920912	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211920912	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9404000000000001	1716211920912	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211921913	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211921913	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211576239	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3	1716211576239	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4806	1716211576239	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211577241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716211577241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4806	1716211577241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211578243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3	1716211578243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4806	1716211578243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211579245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716211579245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4802	1716211579245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211580247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3	1716211580247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4802	1716211580247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211581249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716211581249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4802	1716211581249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211582251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3	1716211582251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4805	1716211582251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211583253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716211583253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4805	1716211583253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211584255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3	1716211584255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4805	1716211584255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211585257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716211585257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4804000000000002	1716211585257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211586259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211586259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4804000000000002	1716211586259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211587260	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211587260	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4804000000000002	1716211587260	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211588262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211588262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4807000000000001	1716211588262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211589264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211589264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4807000000000001	1716211589264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211590266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211590266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4807000000000001	1716211590266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211591268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211591268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.481	1716211591268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211592270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211592270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.481	1716211592270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211593272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211593272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.481	1716211593272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211594274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211594274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4806	1716211594274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211595275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211595275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4806	1716211595275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211596277	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211596277	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4806	1716211596277	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211597279	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211597279	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4808	1716211597279	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211598281	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211598281	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4808	1716211598281	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211599283	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211599283	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4808	1716211599283	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	105	1716211600285	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211600285	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.481	1716211600285	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211601287	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211601287	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.481	1716211601287	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211602289	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211602289	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.481	1716211602289	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211603291	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211603291	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.481	1716211603291	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211604293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211604293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.481	1716211604293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211605295	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211605295	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.481	1716211605295	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211606297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211606297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4794	1716211606297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211607299	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211607299	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4794	1716211607299	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211608301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211608301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4794	1716211608301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211609303	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211609303	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4783	1716211609303	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211610305	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211610305	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4783	1716211610305	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211611307	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211611307	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4783	1716211611307	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211612309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211612309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4783	1716211612309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211613311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211613311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4783	1716211613311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211614313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	2.5	1716211614313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4783	1716211614313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211614334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211615315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211615315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.478	1716211615315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211615335	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211616317	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211616317	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.478	1716211616317	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211616337	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211617318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716211617318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.478	1716211617318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211618320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211618320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4779	1716211618320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211619322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211619322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4779	1716211619322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211620324	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211620324	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4779	1716211620324	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211621326	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211621326	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4783	1716211621326	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211622328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211622328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4783	1716211622328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211623330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	4.3	1716211623330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4783	1716211623330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211624332	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211624332	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.478	1716211624332	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211625334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211625334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.478	1716211625334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211626336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211626336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.478	1716211626336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211627338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211627338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4803	1716211627338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211628340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211628340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4803	1716211628340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211629342	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211629342	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.4803	1716211629342	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211630344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211630344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.7738	1716211630344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211631346	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211631346	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.7738	1716211631346	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211632348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211632348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.7738	1716211632348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211633351	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211633351	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9946	1716211633351	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211634353	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211634353	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9946	1716211634353	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211635355	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211635355	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9946	1716211635355	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211636357	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211636357	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9982	1716211636357	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211637358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211637358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9982	1716211637358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211638360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211638360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9982	1716211638360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211617340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211618341	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211619344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211620337	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211621347	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211622351	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211623352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211624354	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211625348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211626358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211627359	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211628361	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0101	1716211629363	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211630364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211631358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211632369	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211633366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211634367	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211635377	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211636379	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211637380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211638375	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211639376	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211640385	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211641387	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211642389	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211643391	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211644396	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211645398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211646389	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211647395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211648395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211649401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211650401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211651411	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211652404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211653404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211654408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211655420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211656421	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211657422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211658422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211659425	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211660427	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211661428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211662431	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211663426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211664435	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211665436	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211666439	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211667441	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211668435	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211669437	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211670447	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211671449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211672451	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211673446	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211913911	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211914922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211915926	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211916926	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211917921	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211918923	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211919931	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211920935	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211639362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211639362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9994	1716211639362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211640364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211640364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9994	1716211640364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211641366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211641366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9994	1716211641366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211642368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211642368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9999	1716211642368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211643370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211643370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9999	1716211643370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211644372	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211644372	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9999	1716211644372	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211645374	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716211645374	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0014000000000003	1716211645374	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211646376	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211646376	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0014000000000003	1716211646376	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211647378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211647378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0014000000000003	1716211647378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211648381	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211648381	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0014000000000003	1716211648381	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211649384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211649384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0014000000000003	1716211649384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211650386	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211650386	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0014000000000003	1716211650386	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211651388	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211651388	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9994	1716211651388	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211652390	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211652390	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9994	1716211652390	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	99	1716211653392	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211653392	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9994	1716211653392	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211654394	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211654394	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9237	1716211654394	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211655395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211655395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9237	1716211655395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211656397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211656397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9237	1716211656397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211657399	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211657399	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9263	1716211657399	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211658401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211658401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9263	1716211658401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211659403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211659403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9263	1716211659403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211660405	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211660405	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9293	1716211660405	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211661408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211661408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9293	1716211661408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211662410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211662410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9293	1716211662410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211663412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211663412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9297	1716211663412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211664414	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211664414	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9297	1716211664414	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211665416	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211665416	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9297	1716211665416	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211666418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211666418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9307999999999998	1716211666418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211667419	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211667419	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9307999999999998	1716211667419	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211668421	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211668421	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9307999999999998	1716211668421	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211669423	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211669423	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9318	1716211669423	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211670426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211670426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9318	1716211670426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211671428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211671428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9318	1716211671428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211672430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211672430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9307	1716211672430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211673432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211673432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9307	1716211673432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211674434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211674434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9307	1716211674434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211674455	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211675436	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211675436	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.929	1716211675436	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211675457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211676438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211676438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.929	1716211676438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211676461	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211677439	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211677439	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.929	1716211677439	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211677462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211678441	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.6	1716211678441	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9273	1716211678441	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211678459	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211679445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.3999999999999995	1716211679445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9273	1716211679445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211679466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211680459	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211681577	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211682475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211683466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211684469	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211685477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211686479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211687481	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211688475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211689485	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211690486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211691489	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211692492	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211693485	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211694493	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211695497	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211696499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211697500	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211698497	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211699497	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211700507	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211701508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211702509	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211703513	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211704505	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211705514	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211706519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211707520	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211708520	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211709515	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211710525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211711526	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211712529	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211713533	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211714527	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211715539	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211716538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211717541	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211718535	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211719544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211720548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211721550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211722545	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211723547	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211724553	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211725555	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211726558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211727561	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211728554	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211729564	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211730567	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211731567	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211732568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211733572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9385	1716211921913	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211922915	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211922915	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9385	1716211922915	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211923917	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211923917	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9385	1716211923917	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211924918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211924918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9402000000000001	1716211924918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211680446	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211680446	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9273	1716211680446	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211681449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211681449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9297	1716211681449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211682450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211682450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9297	1716211682450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	110.9	1716211683452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211683452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9297	1716211683452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211684454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211684454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9284000000000001	1716211684454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211685456	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211685456	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9284000000000001	1716211685456	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211686458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211686458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9284000000000001	1716211686458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211687460	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211687460	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9283	1716211687460	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211688462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211688462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9283	1716211688462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211689463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211689463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9283	1716211689463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211690465	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211690465	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9301	1716211690465	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211691467	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211691467	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9301	1716211691467	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211692469	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211692469	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9301	1716211692469	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211693471	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211693471	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9304000000000001	1716211693471	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211694473	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211694473	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9304000000000001	1716211694473	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211695475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211695475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9304000000000001	1716211695475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211696477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211696477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9272	1716211696477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211697479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211697479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9272	1716211697479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211698481	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211698481	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9272	1716211698481	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211699483	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211699483	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9294	1716211699483	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211700485	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211700485	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9294	1716211700485	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211701486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211701486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9294	1716211701486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211702488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211702488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9315	1716211702488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211703490	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211703490	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9315	1716211703490	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211704492	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211704492	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9315	1716211704492	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211705494	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211705494	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9310999999999998	1716211705494	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211706496	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211706496	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9310999999999998	1716211706496	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211707498	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211707498	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9310999999999998	1716211707498	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211708499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211708499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9325	1716211708499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211709501	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211709501	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9325	1716211709501	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211710503	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211710503	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9325	1716211710503	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211711505	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211711505	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.935	1716211711505	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211712507	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211712507	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.935	1716211712507	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	107	1716211713510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211713510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.935	1716211713510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211714512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211714512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9355	1716211714512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211715515	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211715515	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9355	1716211715515	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211716517	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211716517	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9355	1716211716517	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211717519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211717519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9347999999999999	1716211717519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211718521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211718521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9347999999999999	1716211718521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211719523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211719523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9347999999999999	1716211719523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211720525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211720525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9321	1716211720525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211721527	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211721527	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9321	1716211721527	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211722529	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211722529	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9321	1716211722529	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211723531	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211723531	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9313	1716211723531	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211724532	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211724532	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9313	1716211724532	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211725534	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211725534	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9313	1716211725534	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211726536	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211726536	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9329	1716211726536	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211727538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211727538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9329	1716211727538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211728540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211728540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9329	1716211728540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211729542	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211729542	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9343	1716211729542	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211730544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211730544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9343	1716211730544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211731546	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211731546	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9343	1716211731546	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211732548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211732548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9332	1716211732548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211733550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211733550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9332	1716211733550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211734552	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211734552	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9332	1716211734552	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211734574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211735554	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211735554	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9349	1716211735554	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211735577	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211736556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211736556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9349	1716211736556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211736579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211737558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211737558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9349	1716211737558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211737581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211738560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211738560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9355	1716211738560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211738576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211739561	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.9	1716211739561	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9355	1716211739561	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211739583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211740563	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211740563	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9355	1716211740563	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211740584	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211741565	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211741565	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9314	1716211741565	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211742567	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211742567	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9314	1716211742567	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211743568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211743568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9314	1716211743568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211744570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211744570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9330999999999998	1716211744570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211745572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211745572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9330999999999998	1716211745572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211746574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211746574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9330999999999998	1716211746574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211747576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211747576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.932	1716211747576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211748577	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211748577	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.932	1716211748577	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211749579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211749579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.932	1716211749579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211750581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211750581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9342000000000001	1716211750581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211751583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211751583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9342000000000001	1716211751583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211752585	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211752585	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9342000000000001	1716211752585	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211753587	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211753587	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.934	1716211753587	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211754589	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211754589	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.934	1716211754589	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211755591	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211755591	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.934	1716211755591	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211756593	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211756593	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9337	1716211756593	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211757595	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211757595	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9337	1716211757595	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211758597	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211758597	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9337	1716211758597	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211759599	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211759599	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9343	1716211759599	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211760601	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211760601	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9343	1716211760601	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211761603	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211761603	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9343	1716211761603	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211762605	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211762605	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.933	1716211762605	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211741587	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211742588	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211743584	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211744584	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211745593	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211746596	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211747597	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211748591	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211749601	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211750605	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211751606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211752607	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211753601	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211754611	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211755616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211756610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211757617	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211758612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211759622	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211760623	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211761625	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211762618	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211763627	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211764631	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211765631	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211766634	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211767637	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211768633	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211769640	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211770643	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211771638	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211772647	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211773640	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211774651	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211775654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211776656	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211777659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211778662	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211779662	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211780663	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211781665	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211782669	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211783665	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211784672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211785665	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211786674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211787674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211788673	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211789678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211790675	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211791682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211792684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211793685	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211921939	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211922930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211923943	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211924941	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211925942	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211926946	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211927938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211928947	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211929949	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211930954	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211931953	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211932954	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211763606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211763606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.933	1716211763606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211764608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211764608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.933	1716211764608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211765610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211765610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9352	1716211765610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211766612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211766612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9352	1716211766612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211767614	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211767614	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9352	1716211767614	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211768616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211768616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9350999999999998	1716211768616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211769618	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211769618	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9350999999999998	1716211769618	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	105	1716211770621	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211770621	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9350999999999998	1716211770621	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211771623	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211771623	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.934	1716211771623	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211772625	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211772625	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.934	1716211772625	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211773626	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211773626	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.934	1716211773626	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211774628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211774628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9369	1716211774628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211775630	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211775630	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9369	1716211775630	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211776632	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211776632	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9369	1716211776632	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211777634	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211777634	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9352	1716211777634	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211778636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211778636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9352	1716211778636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211779638	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211779638	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9352	1716211779638	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211780640	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211780640	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9365999999999999	1716211780640	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211781642	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211781642	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9365999999999999	1716211781642	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211782644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211782644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9365999999999999	1716211782644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211783646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211783646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9364000000000001	1716211783646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211784648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211784648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9364000000000001	1716211784648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211785649	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211785649	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9364000000000001	1716211785649	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211786651	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211786651	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9361	1716211786651	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211787653	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211787653	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9361	1716211787653	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211788655	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211788655	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9361	1716211788655	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211789657	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211789657	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9355	1716211789657	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211790658	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211790658	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9355	1716211790658	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211791660	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211791660	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9355	1716211791660	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211792662	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211792662	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9396	1716211792662	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211793664	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211793664	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9396	1716211793664	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211794666	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211794666	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9396	1716211794666	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211794688	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211795668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211795668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9387	1716211795668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211795689	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211796670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211796670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9387	1716211796670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211796691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211797672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211797672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9387	1716211797672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211797687	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211798674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211798674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.939	1716211798674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211798688	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211799676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211799676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.939	1716211799676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211799697	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211800679	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211800679	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.939	1716211800679	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211800701	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211801680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211801680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9372	1716211801680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211801698	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211802682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211802682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9372	1716211802682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211802704	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211803701	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211804709	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211805703	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211806713	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211807711	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211808709	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211809719	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211810720	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211811721	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211812723	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211813717	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211814727	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211815728	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211816723	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211817731	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211818733	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211819731	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211820731	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211821739	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211822735	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211823746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211824746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211825748	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211826748	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211827752	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211828746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211829755	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211830760	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211831760	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211832760	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211833759	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211834764	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211835761	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211836770	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211837772	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211838772	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211839775	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211840778	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211841781	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211842780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211843775	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211844788	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211845787	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211846788	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211847789	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211848786	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211849786	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211850789	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211851798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211852799	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211925920	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211925920	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9402000000000001	1716211925920	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211926922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211926922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9402000000000001	1716211926922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211927924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211927924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9437	1716211927924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211928926	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211928926	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9437	1716211928926	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211929928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211929928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211803684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211803684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9372	1716211803684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211804687	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716211804687	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9355	1716211804687	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211805689	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716211805689	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9355	1716211805689	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211806690	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211806690	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9355	1716211806690	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211807693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211807693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9365	1716211807693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211808694	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211808694	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9365	1716211808694	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211809696	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211809696	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9365	1716211809696	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211810698	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211810698	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9373	1716211810698	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211811700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211811700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9373	1716211811700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211812702	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211812702	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9373	1716211812702	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211813704	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211813704	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9383	1716211813704	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211814705	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211814705	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9383	1716211814705	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211815707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211815707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9383	1716211815707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211816708	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211816708	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9395	1716211816708	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211817710	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211817710	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9395	1716211817710	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211818712	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211818712	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9395	1716211818712	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211819714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211819714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9405999999999999	1716211819714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211820716	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211820716	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9405999999999999	1716211820716	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211821718	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211821718	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9405999999999999	1716211821718	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211822720	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211822720	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9387	1716211822720	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211823722	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211823722	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9387	1716211823722	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211824723	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211824723	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9387	1716211824723	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211825725	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211825725	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9390999999999998	1716211825725	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211826727	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211826727	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9390999999999998	1716211826727	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211827730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211827730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9390999999999998	1716211827730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211828732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211828732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9370999999999998	1716211828732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211829733	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211829733	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9370999999999998	1716211829733	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211830735	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211830735	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9370999999999998	1716211830735	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211831737	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211831737	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9376	1716211831737	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211832739	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211832739	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9376	1716211832739	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211833741	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211833741	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9376	1716211833741	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211834743	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211834743	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9405999999999999	1716211834743	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211835745	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211835745	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9405999999999999	1716211835745	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211836746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.000000000000002	1716211836746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9405999999999999	1716211836746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211837749	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211837749	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9423	1716211837749	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211838750	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211838750	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9423	1716211838750	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211839752	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211839752	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9423	1716211839752	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211840754	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211840754	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.943	1716211840754	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211841758	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211841758	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.943	1716211841758	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211842759	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211842759	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.943	1716211842759	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211843761	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211843761	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9438	1716211843761	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211844763	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211844763	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9438	1716211844763	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211845765	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211845765	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9438	1716211845765	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211846767	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211846767	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9430999999999998	1716211846767	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211847768	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211847768	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9430999999999998	1716211847768	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211848771	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211848771	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9430999999999998	1716211848771	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211849773	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211849773	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9397	1716211849773	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211850774	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211850774	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9397	1716211850774	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211851776	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211851776	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9397	1716211851776	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211852778	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211852778	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9390999999999998	1716211852778	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211853780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211853780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9390999999999998	1716211853780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211853802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211854782	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211854782	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9390999999999998	1716211854782	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211854804	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211855784	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211855784	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9404000000000001	1716211855784	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211855809	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211856786	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211856786	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9404000000000001	1716211856786	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211856811	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211857788	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211857788	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9404000000000001	1716211857788	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211857809	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211858790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211858790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9397	1716211858790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211858803	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211859791	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211859791	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9397	1716211859791	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211859812	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211860793	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211860793	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9397	1716211860793	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211860815	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211861795	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211861795	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9397	1716211861795	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211861820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211862797	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211862797	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9397	1716211862797	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211862821	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211863799	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211863799	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9397	1716211863799	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211864802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211864802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9397	1716211864802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211865804	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211865804	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9397	1716211865804	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211866806	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211866806	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9397	1716211866806	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211867808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211867808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9399000000000002	1716211867808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211868811	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211868811	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9399000000000002	1716211868811	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211869814	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211869814	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9399000000000002	1716211869814	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211870816	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211870816	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9404000000000001	1716211870816	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211871818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211871818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9404000000000001	1716211871818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211872820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211872820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9404000000000001	1716211872820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211873822	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211873822	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9398	1716211873822	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211874824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211874824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9398	1716211874824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211875826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211875826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9398	1716211875826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211876827	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211876827	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9405999999999999	1716211876827	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211877829	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211877829	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9405999999999999	1716211877829	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211878831	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211878831	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9405999999999999	1716211878831	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211879833	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211879833	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9415	1716211879833	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211880835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211880835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9415	1716211880835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211881837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211881837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9415	1716211881837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211882838	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211882838	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.939	1716211882838	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211883841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211883841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.939	1716211883841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211884842	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211884842	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.939	1716211884842	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211863815	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211864824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211865819	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211866827	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211867823	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211868833	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211869828	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211870837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211871839	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211872834	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211873844	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211874845	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211875841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211876853	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211877843	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211878857	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211879857	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211880848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211881859	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211882863	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211883864	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211884863	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211885867	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211886867	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211887862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211888872	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211889874	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211890876	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211891877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211892873	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211893876	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211894886	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211895887	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211896882	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211897883	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211898892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211899892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211900897	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211901897	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211902900	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211903896	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211904905	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211905905	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211906909	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211907910	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211908910	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211909915	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211910914	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211911917	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211912918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9437	1716211929928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211930930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211930930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9429	1716211930930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211931932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211931932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9429	1716211931932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211932933	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211932933	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9429	1716211932933	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211933936	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211933936	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9435	1716211933936	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211934937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211934937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211885844	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211885844	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9421	1716211885844	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211886846	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	4.5	1716211886846	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9421	1716211886846	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211887848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211887848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9421	1716211887848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211888850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211888850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9427	1716211888850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211889852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211889852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9427	1716211889852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211890854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211890854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9427	1716211890854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211891856	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211891856	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9433	1716211891856	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211892858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211892858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9433	1716211892858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211893860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211893860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9433	1716211893860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211894862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211894862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9404000000000001	1716211894862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211895864	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211895864	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9404000000000001	1716211895864	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211896866	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211896866	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9404000000000001	1716211896866	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211897868	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211897868	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9435	1716211897868	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211898869	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211898869	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9435	1716211898869	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211899871	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211899871	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9435	1716211899871	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211900873	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211900873	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9444000000000001	1716211900873	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211901875	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211901875	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9444000000000001	1716211901875	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211902877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211902877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9444000000000001	1716211902877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211903879	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211903879	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9439000000000002	1716211903879	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211904881	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211904881	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9439000000000002	1716211904881	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211905882	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211905882	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9439000000000002	1716211905882	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211906884	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211906884	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9462000000000002	1716211906884	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211907886	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211907886	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9462000000000002	1716211907886	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211908889	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211908889	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9462000000000002	1716211908889	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211909890	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211909890	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9457	1716211909890	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211910892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211910892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9457	1716211910892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211911894	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211911894	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9457	1716211911894	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211912896	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211912896	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9457	1716211912896	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211933955	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9435	1716211934937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211934959	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211935938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211935938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9435	1716211935938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211935960	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211936940	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211936940	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.942	1716211936940	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211936961	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211937942	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211937942	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.942	1716211937942	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211937961	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211938944	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211938944	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.942	1716211938944	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211938966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211939946	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211939946	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9441	1716211939946	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211939970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211940948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211940948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9441	1716211940948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211940970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211941951	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211941951	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9441	1716211941951	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211941974	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211942952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211942952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9455	1716211942952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211942976	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211943955	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716211943955	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9455	1716211943955	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211943977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211944956	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211944956	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9455	1716211944956	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211944978	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211945958	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211945958	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9479000000000002	1716211945958	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211946960	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211946960	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9479000000000002	1716211946960	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211947962	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211947962	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9479000000000002	1716211947962	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211948964	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.6000000000000005	1716211948964	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9473	1716211948964	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211949966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.800000000000001	1716211949966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9473	1716211949966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211950968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211950968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9473	1716211950968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211951970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211951970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9459000000000002	1716211951970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211952972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211952972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9459000000000002	1716211952972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211953973	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211953973	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9459000000000002	1716211953973	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211954975	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211954975	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9477	1716211954975	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211955977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211955977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9477	1716211955977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211956979	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211956979	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9477	1716211956979	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211957981	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211957981	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9481	1716211957981	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211958983	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211958983	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9481	1716211958983	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211959985	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211959985	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9481	1716211959985	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211960986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211960986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.947	1716211960986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211961988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211961988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.947	1716211961988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211962990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211962990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.947	1716211962990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211963992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211963992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9474	1716211963992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211964994	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211964994	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9474	1716211964994	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211965996	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211965996	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9474	1716211965996	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211966999	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211966999	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211945982	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211946984	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211947976	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211948985	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211949984	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211950989	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211951992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211952991	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211953994	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211954997	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211956003	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211956993	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211958005	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211959004	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211960006	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211961012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211962013	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211963010	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211964015	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211965018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211966017	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211967022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211968018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211969024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211970026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211971029	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211972032	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211973027	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212334721	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212334721	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9813	1716212334721	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212335723	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212335723	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9813	1716212335723	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212336724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212336724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9802	1716212336724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212337726	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212337726	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9802	1716212337726	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212338728	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212338728	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9802	1716212338728	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212339730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212339730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9789	1716212339730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212340732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212340732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9789	1716212340732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212341734	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212341734	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9789	1716212341734	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212342736	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6000000000000005	1716212342736	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9782	1716212342736	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212343738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212343738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9782	1716212343738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212344740	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212344740	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9782	1716212344740	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212345741	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212345741	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9801	1716212345741	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212346743	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9485999999999999	1716211966999	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211968001	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211968001	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9485999999999999	1716211968001	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211969003	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211969003	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9485999999999999	1716211969003	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211970005	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211970005	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9507	1716211970005	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211971006	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211971006	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9507	1716211971006	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211972008	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211972008	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9507	1716211972008	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211973011	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211973011	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.947	1716211973011	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211974012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211974012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.947	1716211974012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211974027	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211975014	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211975014	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.947	1716211975014	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211975040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211976016	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211976016	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9467	1716211976016	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211976041	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211977018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211977018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9467	1716211977018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211977039	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716211978020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211978020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9467	1716211978020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211978044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716211979022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211979022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.947	1716211979022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211979038	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211980024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211980024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.947	1716211980024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211980046	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211981026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211981026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.947	1716211981026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211981052	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211982028	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211982028	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9452	1716211982028	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211982052	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211983030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211983030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9452	1716211983030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211983044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211984032	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211984032	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9452	1716211984032	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211984047	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211985033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211985033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9430999999999998	1716211985033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211986036	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211986036	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9430999999999998	1716211986036	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211987038	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211987038	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9430999999999998	1716211987038	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211988040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211988040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9445	1716211988040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211989042	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211989042	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9445	1716211989042	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211990044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211990044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9445	1716211990044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211991046	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211991046	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9494	1716211991046	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211992048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211992048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9494	1716211992048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211993050	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211993050	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9494	1716211993050	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716211994051	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211994051	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9498	1716211994051	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211995053	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211995053	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9498	1716211995053	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211996055	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211996055	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9498	1716211996055	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716211997057	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211997057	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9527	1716211997057	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211998058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716211998058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9527	1716211998058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716211999060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716211999060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9527	1716211999060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212000062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212000062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9534	1716212000062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212001064	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212001064	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9534	1716212001064	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212002066	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212002066	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9534	1716212002066	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212003068	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212003068	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9525	1716212003068	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212004070	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212004070	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9525	1716212004070	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	99	1716212005072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212005072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9525	1716212005072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212006073	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212006073	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211985056	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211986058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211987061	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211988064	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211989066	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211990065	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211991066	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211992069	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211993063	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211994074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211995074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211996078	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211997080	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211998072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716211999082	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212000087	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212001086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212002086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212003089	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212004093	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212005095	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212006096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212007099	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212008098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212009103	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212010102	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212011106	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212012107	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212013107	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212014113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212015117	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212016115	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212017108	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212018110	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212019122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212020123	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212021124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212022128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212023121	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212024129	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212025126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212026134	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212027137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212028132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212029140	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212030142	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212031144	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212032147	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212033150	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212334744	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212335743	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212336746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212337747	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212338742	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212339754	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212340756	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212341758	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212342750	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212343754	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212344763	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212345764	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212346767	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212347760	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212348768	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212349763	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9532	1716212006073	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212007075	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212007075	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9532	1716212007075	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212008077	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212008077	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9532	1716212008077	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212009078	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212009078	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9512	1716212009078	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212010081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212010081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9512	1716212010081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212011083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212011083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9512	1716212011083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212012084	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212012084	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9530999999999998	1716212012084	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212013086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212013086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9530999999999998	1716212013086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212014089	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212014089	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9530999999999998	1716212014089	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212015091	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212015091	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9539000000000002	1716212015091	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212016092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212016092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9539000000000002	1716212016092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212017094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212017094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9539000000000002	1716212017094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212018096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212018096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9558	1716212018096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212019098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212019098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9558	1716212019098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212020101	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212020101	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9558	1716212020101	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212021103	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212021103	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9547	1716212021103	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212022105	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212022105	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9547	1716212022105	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212023107	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212023107	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9547	1716212023107	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212024109	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212024109	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9562	1716212024109	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212025111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212025111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9562	1716212025111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212026112	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212026112	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9562	1716212026112	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212027114	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212027114	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9509	1716212027114	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212028116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212028116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9509	1716212028116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212029118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212029118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9509	1716212029118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212030120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212030120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9538	1716212030120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212031122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212031122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9538	1716212031122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212032124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212032124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9538	1716212032124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212033126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212033126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9526	1716212033126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212034128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212034128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9526	1716212034128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212034149	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212035129	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212035129	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9526	1716212035129	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212035152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212036131	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212036131	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9567999999999999	1716212036131	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212036153	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212037133	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212037133	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9567999999999999	1716212037133	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212037148	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212038135	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212038135	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9567999999999999	1716212038135	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212038149	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212039137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212039137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9564000000000001	1716212039137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212039159	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212040139	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212040139	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9564000000000001	1716212040139	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212040155	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212041141	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212041141	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9564000000000001	1716212041141	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212041162	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212042143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212042143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9563	1716212042143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212042164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212043144	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212043144	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9563	1716212043144	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212043158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212044146	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212044146	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9563	1716212044146	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212044173	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212045148	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212045148	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9567999999999999	1716212045148	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212046150	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212046150	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9567999999999999	1716212046150	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212047152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212047152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9567999999999999	1716212047152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212048154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212048154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9566	1716212048154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212049156	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212049156	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9566	1716212049156	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212050158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212050158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9566	1716212050158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212051159	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.3	1716212051159	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9572	1716212051159	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212052161	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212052161	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9572	1716212052161	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212053163	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212053163	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9572	1716212053163	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212054164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212054164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9606	1716212054164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212055166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212055166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9606	1716212055166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212056168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212056168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9606	1716212056168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212057172	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212057172	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9602	1716212057172	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212058174	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212058174	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9602	1716212058174	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212059175	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212059175	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9602	1716212059175	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212060177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212060177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9616	1716212060177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212061179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212061179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9616	1716212061179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212062181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212062181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9616	1716212062181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212063183	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212063183	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9618	1716212063183	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212064185	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212064185	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9618	1716212064185	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212065187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212065187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9618	1716212065187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212066188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212066188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.962	1716212066188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212045169	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212046176	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212047166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212048177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212049177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212050179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212051182	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212052176	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212053179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212054187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212055180	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212056189	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212057185	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212058187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212059197	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212060200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212061202	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212062195	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212063198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212064209	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212065208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212066206	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212067215	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212068207	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212069217	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212070209	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212071222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212072223	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212073215	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212074224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212075229	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212076233	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212077231	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212078237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212079236	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212080240	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212081238	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212082241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212083237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212084249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212085243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212086251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212087253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212088248	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212089250	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212090261	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212091263	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212092263	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212093265	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212346743	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9801	1716212346743	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212347745	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212347745	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9801	1716212347745	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212348747	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212348747	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9808	1716212348747	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212349749	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212349749	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9808	1716212349749	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212350751	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212350751	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9808	1716212350751	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212351753	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212351753	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212067190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212067190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.962	1716212067190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212068192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212068192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.962	1716212068192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212069194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212069194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9586	1716212069194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212070196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212070196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9586	1716212070196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212071198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212071198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9586	1716212071198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212072200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212072200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9590999999999998	1716212072200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212073202	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212073202	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9590999999999998	1716212073202	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212074203	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212074203	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9590999999999998	1716212074203	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212075205	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212075205	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.959	1716212075205	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212076208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212076208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.959	1716212076208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212077209	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212077209	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.959	1716212077209	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212078211	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212078211	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9609	1716212078211	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212079213	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212079213	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9609	1716212079213	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212080216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212080216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9609	1716212080216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212081217	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212081217	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9645	1716212081217	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212082220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212082220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9645	1716212082220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212083223	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.7	1716212083223	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9645	1716212083223	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212084226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.9	1716212084226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9649	1716212084226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212085228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212085228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9649	1716212085228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212086230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212086230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9649	1716212086230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212087232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212087232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.965	1716212087232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212088234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212088234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.965	1716212088234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212089235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212089235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.965	1716212089235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212090237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212090237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9610999999999998	1716212090237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212091240	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212091240	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9610999999999998	1716212091240	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212092242	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212092242	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9610999999999998	1716212092242	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212093244	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212093244	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9603	1716212093244	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212094246	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212094246	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9603	1716212094246	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212094269	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212095248	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212095248	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9603	1716212095248	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212095269	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212096250	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212096250	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9642	1716212096250	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212096272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212097252	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212097252	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9642	1716212097252	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212097274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212098254	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212098254	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9642	1716212098254	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212098270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212099255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212099255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9650999999999998	1716212099255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212099277	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212100257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212100257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9650999999999998	1716212100257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212100273	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212101258	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212101258	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9650999999999998	1716212101258	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212101281	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212102262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212102262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9656	1716212102262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212102285	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212103264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212103264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9656	1716212103264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212103278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212104266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212104266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9656	1716212104266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212104287	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212105269	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212105269	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9672	1716212105269	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212105291	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212106293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212107294	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212108289	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212109302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212110304	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212111305	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212112305	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212113301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212114312	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212115311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212116314	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212117316	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212118314	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212119315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212120322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212121324	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212122324	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212123328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212124329	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212125330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212126333	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212127334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212128330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212129339	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212130341	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212131344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212132346	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212133337	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212134348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212135350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212136354	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212137352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212138348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212139356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212140358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212141360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212142359	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212143356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212144366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212145370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212146373	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212147372	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212148370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212149369	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212150381	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212151382	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212152384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212153378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212154388	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212155388	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212156391	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212157393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212158391	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212159402	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212160393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212161398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212162407	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212163402	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212164411	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212165414	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212166415	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212167416	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212168411	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212169421	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212106271	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212106271	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9672	1716212106271	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212107273	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212107273	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9672	1716212107273	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212108276	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212108276	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9655	1716212108276	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212109279	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212109279	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9655	1716212109279	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212110281	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212110281	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9655	1716212110281	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212111282	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212111282	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9636	1716212111282	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212112284	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212112284	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9636	1716212112284	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212113286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212113286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9636	1716212113286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212114289	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212114289	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9661	1716212114289	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212115291	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212115291	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9661	1716212115291	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212116293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212116293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9661	1716212116293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212117294	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212117294	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9659	1716212117294	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212118296	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212118296	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9659	1716212118296	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212119298	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212119298	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9659	1716212119298	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212120300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212120300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9672	1716212120300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212121302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212121302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9672	1716212121302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212122304	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212122304	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9672	1716212122304	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212123306	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212123306	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9681	1716212123306	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212124307	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212124307	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9681	1716212124307	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212125309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212125309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9681	1716212125309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212126311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212126311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9665	1716212126311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212127312	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212127312	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9665	1716212127312	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212128314	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212128314	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9665	1716212128314	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212129316	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212129316	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9672	1716212129316	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212130318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212130318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9672	1716212130318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212131320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212131320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9672	1716212131320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	99	1716212132322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212132322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9629	1716212132322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212133323	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212133323	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9629	1716212133323	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212134325	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212134325	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9629	1716212134325	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212135327	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212135327	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9646	1716212135327	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212136329	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212136329	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9646	1716212136329	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212137331	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212137331	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9646	1716212137331	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212138333	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212138333	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9673	1716212138333	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212139335	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212139335	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9673	1716212139335	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212140337	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212140337	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9673	1716212140337	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212141338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212141338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.966	1716212141338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212142340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212142340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.966	1716212142340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212143342	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212143342	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.966	1716212143342	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212144344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212144344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.966	1716212144344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212145346	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212145346	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.966	1716212145346	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212146348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212146348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.966	1716212146348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212147350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212147350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9665	1716212147350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212148353	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212148353	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9665	1716212148353	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212149356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212149356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9665	1716212149356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212150358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212150358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9632	1716212150358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212151360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212151360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9632	1716212151360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212152362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212152362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9632	1716212152362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212153364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212153364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9634	1716212153364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212154366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	2.9	1716212154366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9634	1716212154366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212155368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212155368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9634	1716212155368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212156370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212156370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.966	1716212156370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212157371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212157371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.966	1716212157371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212158375	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212158375	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.966	1716212158375	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212159378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212159378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9677	1716212159378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212160380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212160380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9677	1716212160380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212161382	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212161382	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9677	1716212161382	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212162386	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212162386	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9669	1716212162386	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212163387	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212163387	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9669	1716212163387	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212164389	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212164389	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9669	1716212164389	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212165391	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212165391	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9642	1716212165391	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212166393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212166393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9642	1716212166393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212167395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212167395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9642	1716212167395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212168397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212168397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9667999999999999	1716212168397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212169398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212169398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9667999999999999	1716212169398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212170401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212170401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9667999999999999	1716212170401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212171403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212171403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9664000000000001	1716212171403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212172404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212172404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9664000000000001	1716212172404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212173406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212173406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9664000000000001	1716212173406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212174408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212174408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9659	1716212174408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212175410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212175410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9659	1716212175410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212176412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212176412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9659	1716212176412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212177414	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212177414	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9667999999999999	1716212177414	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212178416	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212178416	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9667999999999999	1716212178416	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212179418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212179418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9667999999999999	1716212179418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212180420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212180420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9683	1716212180420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212181422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212181422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9683	1716212181422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212182423	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.800000000000001	1716212182423	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9683	1716212182423	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212183425	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212183425	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9679	1716212183425	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212184427	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212184427	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9679	1716212184427	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212185428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212185428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9679	1716212185428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212186430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212186430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9679	1716212186430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212187432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212187432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9679	1716212187432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212188434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212188434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9679	1716212188434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212189436	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212189436	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9696	1716212189436	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212190438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212190438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9696	1716212190438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212191440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212170422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212171424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212172427	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212173422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212174431	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212175431	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212176434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212177436	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212178431	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212179439	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212180441	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212181435	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212182446	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212183450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212184448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212185450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212186453	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212187454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212188449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212189462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212190462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212191461	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212192466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212193458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212194467	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212195469	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212196472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212197466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212198477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212199479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212200479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212201480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212202476	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212203477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212204485	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212205489	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212206485	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212207487	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212208486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212209497	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212210497	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212211499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212212507	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212213503	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212350774	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212351774	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212352768	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212353771	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212354779	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212355784	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212356784	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212357780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212358789	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212359791	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212360794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9806	1716212361773	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212361794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212362774	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212362774	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9806	1716212362774	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212362798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212363776	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212363776	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9733	1716212363776	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212363798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212191440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9696	1716212191440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212192441	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212192441	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9696	1716212192441	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212193443	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212193443	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9696	1716212193443	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212194445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212194445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9696	1716212194445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212195447	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212195447	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.967	1716212195447	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212196449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212196449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.967	1716212196449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212197451	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212197451	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.967	1716212197451	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212198453	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212198453	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9692	1716212198453	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212199455	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212199455	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9692	1716212199455	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212200457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212200457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9692	1716212200457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212201459	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212201459	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9712	1716212201459	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212202461	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212202461	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9712	1716212202461	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212203463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212203463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9712	1716212203463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212204464	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212204464	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9706	1716212204464	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212205467	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212205467	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9706	1716212205467	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212206469	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212206469	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9706	1716212206469	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212207471	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212207471	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9709	1716212207471	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212208472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212208472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9709	1716212208472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212209474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212209474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9709	1716212209474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212210476	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212210476	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9699	1716212210476	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212211478	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212211478	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9699	1716212211478	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212212480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212212480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9699	1716212212480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212213482	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212213482	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9694	1716212213482	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212214484	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212214484	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9694	1716212214484	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212214509	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212215486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212215486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9694	1716212215486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212215510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212216488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212216488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9657	1716212216488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212216513	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212217491	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212217491	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9657	1716212217491	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212217512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212218493	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212218493	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9657	1716212218493	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212218506	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212219495	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212219495	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9666	1716212219495	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212219521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212220497	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212220497	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9666	1716212220497	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212220519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212221499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212221499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9666	1716212221499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212221514	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212222500	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212222500	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.967	1716212222500	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212222522	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212223502	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212223502	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.967	1716212223502	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212223519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212224504	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212224504	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.967	1716212224504	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212224519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212225506	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8	1716212225506	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9695	1716212225506	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212225520	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212226508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6	1716212226508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9695	1716212226508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212226529	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	105	1716212227510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212227510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9695	1716212227510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212227531	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212228512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212228512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9701	1716212228512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212228526	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212229513	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212229513	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9701	1716212229513	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212230515	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212230515	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9701	1716212230515	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212231517	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212231517	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9707000000000001	1716212231517	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212232519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212232519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9707000000000001	1716212232519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212233521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212233521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9707000000000001	1716212233521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212234523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212234523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9706	1716212234523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212235525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212235525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9706	1716212235525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212236527	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212236527	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9706	1716212236527	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212237530	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212237530	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9718	1716212237530	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212238532	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212238532	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9718	1716212238532	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212239534	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212239534	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9718	1716212239534	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212240536	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212240536	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9717	1716212240536	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212241538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212241538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9717	1716212241538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212242540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212242540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9717	1716212242540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212243541	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212243541	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9724000000000002	1716212243541	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212244543	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212244543	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9724000000000002	1716212244543	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212245545	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212245545	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9724000000000002	1716212245545	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212246547	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212246547	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9741	1716212246547	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212247548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212247548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9741	1716212247548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212248550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212248550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9741	1716212248550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212249552	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212249552	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9729	1716212249552	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212250555	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212229535	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212230541	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212231540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212232540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212233535	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212234546	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212235548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212236541	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212237553	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212238546	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212239557	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212240549	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212241559	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212242556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212243554	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212244564	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212245567	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212246570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212247571	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212248567	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212249574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212250578	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212251579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212252579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212253576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212254584	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212255586	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212256587	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212257581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212258594	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212259594	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212260596	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212261599	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212262592	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212263600	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212264605	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212265610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212266613	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212267605	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212268613	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212269615	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212270618	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212271620	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212272613	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212273623	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212274616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212275627	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212276628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212277630	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212278625	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212279636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212280628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212281630	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212282639	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212283633	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212284643	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212285646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212286639	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212287650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212288652	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212289653	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212290654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212291659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212292661	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212293656	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212250555	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9729	1716212250555	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212251557	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212251557	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9729	1716212251557	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212252558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212252558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9741	1716212252558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212253560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212253560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9741	1716212253560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212254562	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212254562	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9741	1716212254562	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212255564	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212255564	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9750999999999999	1716212255564	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212256566	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212256566	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9750999999999999	1716212256566	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212257568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212257568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9750999999999999	1716212257568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212258570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212258570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9754	1716212258570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212259572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212259572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9754	1716212259572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212260574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212260574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9754	1716212260574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212261576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212261576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9719	1716212261576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212262578	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212262578	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9719	1716212262578	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212263579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212263579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9719	1716212263579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212264581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212264581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9724000000000002	1716212264581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212265585	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212265585	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9724000000000002	1716212265585	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212266588	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212266588	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9724000000000002	1716212266588	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212267590	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212267590	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9727000000000001	1716212267590	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212268592	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212268592	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9727000000000001	1716212268592	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212269594	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212269594	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9727000000000001	1716212269594	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212270596	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212270596	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9785	1716212270596	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212271597	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212271597	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9785	1716212271597	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212272599	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212272599	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9785	1716212272599	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212273601	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212273601	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9804000000000002	1716212273601	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212274603	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212274603	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9804000000000002	1716212274603	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212275605	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212275605	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9804000000000002	1716212275605	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212276607	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212276607	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9807000000000001	1716212276607	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212277608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212277608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9807000000000001	1716212277608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212278610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212278610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9807000000000001	1716212278610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212279612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212279612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9684000000000001	1716212279612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212280614	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212280614	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9684000000000001	1716212280614	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212281616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212281616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9684000000000001	1716212281616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212282618	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212282618	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.972	1716212282618	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212283619	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212283619	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.972	1716212283619	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212284621	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212284621	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.972	1716212284621	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212285623	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212285623	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9745	1716212285623	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212286624	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212286624	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9745	1716212286624	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212287628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212287628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9745	1716212287628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212288629	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212288629	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9755999999999998	1716212288629	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212289631	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212289631	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9755999999999998	1716212289631	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212290633	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.9	1716212290633	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9755999999999998	1716212290633	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212291636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212291636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9707999999999999	1716212291636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212292639	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212292639	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9707999999999999	1716212292639	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212293641	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212293641	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9707999999999999	1716212293641	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212294643	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212294643	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9727000000000001	1716212294643	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212295645	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212295645	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9727000000000001	1716212295645	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212296646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212296646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9727000000000001	1716212296646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212297648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212297648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.975	1716212297648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212298650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212298650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.975	1716212298650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212299652	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212299652	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.975	1716212299652	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212300654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212300654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9769	1716212300654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212301656	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212301656	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9769	1716212301656	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212302658	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212302658	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9769	1716212302658	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212303659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212303659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9752	1716212303659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212304661	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212304661	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9752	1716212304661	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212305663	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212305663	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9752	1716212305663	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212306665	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212306665	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9785	1716212306665	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212307667	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212307667	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9785	1716212307667	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212308669	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212308669	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9785	1716212308669	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212309670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212309670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9788	1716212309670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212310672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212310672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9788	1716212310672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212311674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212311674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9788	1716212311674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212312676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212312676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9798	1716212312676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212313678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212313678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9798	1716212313678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212314680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212294664	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212295666	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212296667	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212297671	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212298666	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212299677	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212300675	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212301678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212302671	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212303680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212304682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212305684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212306685	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212307689	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212308693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212309691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212310695	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212311698	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212312700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212313701	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212314704	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212315695	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212316698	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212317708	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212318709	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212319712	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212320714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212321719	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212322714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212323714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212324723	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212325726	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212326730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212327729	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212328724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212329733	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212330735	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212331736	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212332738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212333742	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9824000000000002	1716212351753	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212352755	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212352755	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9824000000000002	1716212352755	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212353757	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212353757	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9824000000000002	1716212353757	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212354759	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212354759	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9763	1716212354759	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212355761	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212355761	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9763	1716212355761	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212356763	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212356763	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9763	1716212356763	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212357764	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212357764	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9818	1716212357764	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212358766	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212358766	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9818	1716212358766	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212359769	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212359769	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9818	1716212359769	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212314680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9798	1716212314680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212315682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212315682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9757	1716212315682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212316683	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212316683	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9757	1716212316683	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212317685	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212317685	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9757	1716212317685	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212318688	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.8999999999999995	1716212318688	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9757	1716212318688	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212319691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212319691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9757	1716212319691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212320693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.1	1716212320693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9757	1716212320693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212321695	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212321695	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9787000000000001	1716212321695	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212322697	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212322697	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9787000000000001	1716212322697	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212323699	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212323699	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9787000000000001	1716212323699	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212324702	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212324702	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9795	1716212324702	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212325704	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212325704	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9795	1716212325704	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212326706	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212326706	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9795	1716212326706	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212327708	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212327708	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9784000000000002	1716212327708	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212328709	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212328709	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9784000000000002	1716212328709	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212329711	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212329711	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9784000000000002	1716212329711	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212330713	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212330713	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9785	1716212330713	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212331715	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212331715	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9785	1716212331715	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212332717	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212332717	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9785	1716212332717	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212333719	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212333719	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9813	1716212333719	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212360771	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212360771	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9806	1716212360771	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212361773	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212361773	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212364778	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212364778	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9733	1716212364778	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212365780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212365780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9733	1716212365780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212366782	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212366782	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9778	1716212366782	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212367784	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212367784	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9778	1716212367784	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212368786	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212368786	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9778	1716212368786	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212369787	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212369787	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9806	1716212369787	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212370788	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212370788	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9806	1716212370788	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212371790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212371790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9806	1716212371790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212372792	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212372792	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9682	1716212372792	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212373794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212373794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9682	1716212373794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212374796	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212374796	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9682	1716212374796	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212375798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212375798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9797	1716212375798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212376800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212376800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9797	1716212376800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212377802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212377802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9797	1716212377802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212378803	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212378803	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9821	1716212378803	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212379805	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212379805	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9821	1716212379805	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212380807	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212380807	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9821	1716212380807	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212381808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212381808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9815999999999998	1716212381808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212382810	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212382810	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9815999999999998	1716212382810	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212383812	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212383812	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9815999999999998	1716212383812	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212384814	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212384814	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9824000000000002	1716212384814	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212385816	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212364800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212365802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212366805	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212367804	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212368800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212369804	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212370808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212371811	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212372806	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212373808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212374810	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212375819	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212376821	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212377824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212378825	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212379826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212380829	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212381830	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212382832	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212383826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212384835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212385836	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212386839	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212387837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212388835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212389837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212390846	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212391849	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212392850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212393851	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212394847	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212395858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212396860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212397861	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212398854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212399864	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212400865	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212401870	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212402873	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212403867	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212404877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212405881	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212406872	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212407884	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212408883	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212409885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212410887	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212411892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212412892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212413886	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212414896	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212415897	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212416901	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212417901	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212418895	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212419905	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212420907	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212421902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212422910	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212423912	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212424914	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212425916	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212426917	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212427911	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212428916	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212385816	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9824000000000002	1716212385816	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212386818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212386818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9824000000000002	1716212386818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212387820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212387820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9825	1716212387820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212388822	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212388822	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9825	1716212388822	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212389824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212389824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9825	1716212389824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212390826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212390826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9835	1716212390826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212391827	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212391827	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9835	1716212391827	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212392828	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212392828	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9835	1716212392828	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212393830	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212393830	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9843	1716212393830	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212394834	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212394834	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9843	1716212394834	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212395835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212395835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9843	1716212395835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212396837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212396837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9824000000000002	1716212396837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212397839	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212397839	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9824000000000002	1716212397839	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212398841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212398841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9824000000000002	1716212398841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212399843	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212399843	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9839	1716212399843	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212400844	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212400844	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9839	1716212400844	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212401848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212401848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9839	1716212401848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212402852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212402852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9835	1716212402852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212403853	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212403853	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9835	1716212403853	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212404855	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212404855	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9835	1716212404855	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212405857	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212405857	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9857	1716212405857	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212406858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212406858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9857	1716212406858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212407860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212407860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9857	1716212407860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212408862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212408862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.983	1716212408862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212409864	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212409864	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.983	1716212409864	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212410866	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212410866	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.983	1716212410866	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212411868	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212411868	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9849	1716212411868	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212412870	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212412870	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9849	1716212412870	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212413872	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212413872	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9849	1716212413872	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212414874	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212414874	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9859	1716212414874	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212415875	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212415875	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9859	1716212415875	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212416877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212416877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9859	1716212416877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212417878	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212417878	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9802	1716212417878	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212418880	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212418880	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9802	1716212418880	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212419882	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212419882	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9802	1716212419882	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212420885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212420885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9853	1716212420885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212421887	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212421887	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9853	1716212421887	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212422888	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212422888	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9853	1716212422888	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212423890	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212423890	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9866	1716212423890	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212424892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212424892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9866	1716212424892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212425894	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212425894	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9866	1716212425894	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212426896	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212426896	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9942	1716212426896	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212427898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212427898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9942	1716212427898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212428900	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212428900	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	1.9942	1716212428900	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212429902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212429902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0047	1716212429902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212430905	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212430905	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0047	1716212430905	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212431907	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212431907	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0047	1716212431907	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212432909	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212432909	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0073	1716212432909	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212433911	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212433911	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0073	1716212433911	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212434913	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212434913	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0073	1716212434913	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212435915	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212435915	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0142	1716212435915	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212436917	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212436917	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0142	1716212436917	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212437918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212437918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0142	1716212437918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212438920	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212438920	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0181	1716212438920	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212439922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212439922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0181	1716212439922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212440924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212440924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0181	1716212440924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212441928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212441928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0231	1716212441928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212442930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212442930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0231	1716212442930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212443932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212443932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0231	1716212443932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212444934	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212444934	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0327	1716212444934	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212445936	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212445936	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0327	1716212445936	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212446937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212446937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0327	1716212446937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212447939	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212447939	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0333	1716212447939	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212448942	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212448942	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0333	1716212448942	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212449944	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212429928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212430926	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212431929	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212432922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212433932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212434937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212435940	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212436939	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212437935	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212438941	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212439945	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212440948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212441951	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212442952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212443948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212444956	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212445958	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212446961	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212447962	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212448957	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212449971	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212450972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212451969	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212452971	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212814641	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212814641	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0477	1716212814641	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212815642	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212815642	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0477	1716212815642	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212816644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212816644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0423	1716212816644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212817646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212817646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0423	1716212817646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212818648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212818648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0423	1716212818648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212819650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212819650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0448	1716212819650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212820652	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212820652	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0448	1716212820652	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212821654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212821654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0448	1716212821654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212822656	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212822656	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0461	1716212822656	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212823658	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212823658	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0461	1716212823658	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212824659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212824659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0461	1716212824659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212825661	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212825661	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0483000000000002	1716212825661	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212826663	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212826663	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0483000000000002	1716212826663	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212827665	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212449944	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0333	1716212449944	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212450946	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212450946	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.03	1716212450946	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212451948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212451948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.03	1716212451948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212452949	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212452949	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.03	1716212452949	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212453951	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212453951	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0339	1716212453951	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212453966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212454953	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212454953	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0339	1716212454953	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212454976	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212455955	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212455955	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0339	1716212455955	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212455979	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212456957	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212456957	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0195	1716212456957	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212456979	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212457959	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212457959	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0195	1716212457959	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212457981	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212458961	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212458961	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0195	1716212458961	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212458976	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212459963	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212459963	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0236	1716212459963	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212459986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212460965	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212460965	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0236	1716212460965	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212460986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212461967	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212461967	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0236	1716212461967	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212461987	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212462969	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212462969	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0249	1716212462969	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212462992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212463971	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212463971	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0249	1716212463971	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212463985	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212464972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212464972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0249	1716212464972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212464993	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212465974	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212465974	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0258	1716212465974	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212465997	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212466976	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8	1716212466976	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0258	1716212466976	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212467978	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.2	1716212467978	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0258	1716212467978	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212468980	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212468980	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0268	1716212468980	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212469982	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212469982	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0268	1716212469982	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212470984	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212470984	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0268	1716212470984	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212471986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212471986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0286	1716212471986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212472988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212472988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0286	1716212472988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212473989	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212473989	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0286	1716212473989	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212474990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212474990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0263	1716212474990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212475992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212475992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0263	1716212475992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212476994	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212476994	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0263	1716212476994	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212477997	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212477997	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0201	1716212477997	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212478998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212478998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0201	1716212478998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212480000	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212480000	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0201	1716212480000	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212481002	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212481002	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0229	1716212481002	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212482004	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212482004	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0229	1716212482004	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212483006	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212483006	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0229	1716212483006	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212484008	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212484008	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0234	1716212484008	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212485010	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212485010	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0234	1716212485010	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212486012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212486012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0251	1716212486012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212487014	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212487014	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0251	1716212487014	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212488015	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212488015	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212466989	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212467991	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212469002	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212470003	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212470997	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212472006	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212473002	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212474011	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212475013	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212476015	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212477016	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212478010	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212479019	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212480024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212481026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212482028	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212483031	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212484023	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212485033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212486034	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212487035	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212488031	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212489037	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212490034	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212491043	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212492045	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212493039	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212494047	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212495049	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212496052	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212497055	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212498048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212499058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212500060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212501061	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212502063	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212503065	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212504060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212505060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212506072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212507078	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212508075	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212509069	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212510078	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212511079	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212512081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212513074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212514080	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212515087	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212516088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212517089	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212518091	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212519086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212520088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212521100	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212522101	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212523104	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212524101	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212525106	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212526112	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212527112	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212528115	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212529113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212530116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212531117	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0251	1716212488015	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212489017	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212489017	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0282	1716212489017	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212490018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212490018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0282	1716212490018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212491020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212491020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0282	1716212491020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212492022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212492022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0304	1716212492022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212493024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212493024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0304	1716212493024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212494026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212494026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0304	1716212494026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212495028	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212495028	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0305999999999997	1716212495028	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212496030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212496030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0305999999999997	1716212496030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212497032	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212497032	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0305999999999997	1716212497032	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212498034	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212498034	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0311	1716212498034	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212499036	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212499036	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0311	1716212499036	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212500038	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212500038	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0311	1716212500038	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212501040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212501040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0303	1716212501040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212502042	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212502042	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0303	1716212502042	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212503043	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212503043	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0303	1716212503043	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212504045	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212504045	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0314	1716212504045	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212505047	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212505047	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0314	1716212505047	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212506048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212506048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0314	1716212506048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212507050	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212507050	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0269	1716212507050	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	99	1716212508052	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212508052	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0269	1716212508052	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212509054	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212509054	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0269	1716212509054	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212510056	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212510056	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0299	1716212510056	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212511058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212511058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0299	1716212511058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212512060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212512060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0299	1716212512060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212513062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212513062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0315	1716212513062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212514063	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212514063	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0315	1716212514063	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212515065	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212515065	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0315	1716212515065	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212516067	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212516067	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0331	1716212516067	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212517068	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212517068	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0331	1716212517068	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212518070	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212518070	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0331	1716212518070	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212519072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212519072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0328	1716212519072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212520074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212520074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0328	1716212520074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212521077	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	3.2	1716212521077	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0328	1716212521077	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212522079	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212522079	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0341	1716212522079	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212523081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212523081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0341	1716212523081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212524083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212524083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0341	1716212524083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212525085	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212525085	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0337	1716212525085	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212526087	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212526087	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0337	1716212526087	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212527088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212527088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0337	1716212527088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212528090	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212528090	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0331	1716212528090	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212529092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212529092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0331	1716212529092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212530094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212530094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0331	1716212530094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212531096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212531096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0309	1716212531096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212532098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212532098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0309	1716212532098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212533100	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212533100	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0309	1716212533100	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212534102	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212534102	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0332	1716212534102	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212535104	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212535104	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0332	1716212535104	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212536106	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212536106	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0332	1716212536106	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212537108	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212537108	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0208	1716212537108	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212538111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212538111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0208	1716212538111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212539113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212539113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0208	1716212539113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212540115	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212540115	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0272	1716212540115	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212541116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212541116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0272	1716212541116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212542118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212542118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0272	1716212542118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212543120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212543120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0322999999999998	1716212543120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212544122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.700000000000001	1716212544122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0322999999999998	1716212544122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212545124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212545124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0322999999999998	1716212545124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212546126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212546126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0314	1716212546126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212547128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212547128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0314	1716212547128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212548130	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212548130	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0314	1716212548130	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212549131	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212549131	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0232	1716212549131	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212550133	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212550133	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0232	1716212550133	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212551137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212551137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0232	1716212551137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212552139	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212552139	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212532121	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212533114	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212534126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212535120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212536127	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212537133	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212538125	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212539132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212540137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212541138	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212542144	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212543142	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212544144	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212545147	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212546147	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212547152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212548152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212549144	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212550156	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212551158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212552160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212553162	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212554157	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212555166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212556168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212557169	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212558166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212559174	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212560176	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212561178	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212562180	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212563174	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212564183	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212565187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212566187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212567191	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212568186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212569187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212570188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212571198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212572199	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212573192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212814664	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212815663	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212816668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212817661	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212818672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212819672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212820673	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212821675	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212822668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212823679	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212824681	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212825683	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212826678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212827680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212828682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212829690	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212830691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212831693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212832695	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212833690	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212834700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212835701	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212836700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0257	1716212552139	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212553141	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212553141	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0257	1716212553141	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212554143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212554143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0257	1716212554143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212555144	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212555144	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0292	1716212555144	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212556146	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212556146	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0292	1716212556146	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212557148	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212557148	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0292	1716212557148	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212558150	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212558150	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0315	1716212558150	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212559152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212559152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0315	1716212559152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212560154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212560154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0315	1716212560154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212561156	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212561156	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0307	1716212561156	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212562158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212562158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0307	1716212562158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212563160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212563160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0307	1716212563160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212564162	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212564162	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0308	1716212564162	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212565164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212565164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0308	1716212565164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212566166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212566166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0308	1716212566166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212567168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212567168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.03	1716212567168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212568169	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212568169	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.03	1716212568169	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212569171	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212569171	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.03	1716212569171	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212570173	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212570173	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0327	1716212570173	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212571175	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212571175	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0327	1716212571175	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212572177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212572177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0327	1716212572177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212573179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212573179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0293	1716212573179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212574181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212574181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0293	1716212574181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212574203	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212575184	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212575184	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0293	1716212575184	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212575209	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212576186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212576186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0315	1716212576186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212576210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212577187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212577187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0315	1716212577187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212577210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212578188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212578188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0315	1716212578188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212578203	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212579190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212579190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0326	1716212579190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212579212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212580192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212580192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0326	1716212580192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212580213	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212581194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212581194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0326	1716212581194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212581214	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212582196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212582196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0314	1716212582196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212582211	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212583198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212583198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0314	1716212583198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212583212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212584200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212584200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0314	1716212584200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212584222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212585202	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212585202	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0319000000000003	1716212585202	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212585223	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212586204	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212586204	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0319000000000003	1716212586204	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212586228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212587206	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212587206	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0319000000000003	1716212587206	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212587229	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212588207	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212588207	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0312	1716212588207	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212588224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212589208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.100000000000001	1716212589208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0312	1716212589208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212589230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212590210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.300000000000001	1716212590210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0312	1716212590210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212591212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212591212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0338	1716212591212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212592214	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212592214	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0338	1716212592214	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212593216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212593216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0338	1716212593216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212594218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212594218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0331	1716212594218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212595220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212595220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0331	1716212595220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212596222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212596222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0331	1716212596222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212597224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212597224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0331	1716212597224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212598226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212598226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0331	1716212598226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212599228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212599228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0331	1716212599228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212600230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212600230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.034	1716212600230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212601232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212601232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.034	1716212601232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212602234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212602234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.034	1716212602234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212603236	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212603236	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0316	1716212603236	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212604239	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212604239	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0316	1716212604239	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212605241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212605241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0316	1716212605241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212606243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212606243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0314	1716212606243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212607245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212607245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0314	1716212607245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212608247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212608247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0314	1716212608247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212609249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212609249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0254000000000003	1716212609249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212610251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212610251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0254000000000003	1716212610251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212611253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212590231	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212591235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212592236	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212593232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212594240	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212595245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212596247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212597248	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212598243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212599252	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212600252	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212601246	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212602256	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212603262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212604264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212605265	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212606264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212607262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212608269	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212609270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212610274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212611274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212612275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212613280	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212614275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212615283	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212616283	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212617286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212618280	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212619291	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212620292	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212621294	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212622296	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212623290	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212624303	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212625294	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212626296	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212627300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212628302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212629311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212630312	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212631305	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212632316	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212633310	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212634321	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212635322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212636326	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212637326	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212638322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212639327	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212640334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212641327	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212642333	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212643336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212644338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212645340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212646344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212647343	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212648348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212649348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212650349	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212651353	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212652355	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212653351	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212654359	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212611253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0254000000000003	1716212611253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212612255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212612255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0302000000000002	1716212612255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212613257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212613257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0302000000000002	1716212613257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212614258	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212614258	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0302000000000002	1716212614258	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212615260	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212615260	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0307	1716212615260	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212616263	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212616263	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0307	1716212616263	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212617264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212617264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0307	1716212617264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212618266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212618266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0316	1716212618266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212619268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212619268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0316	1716212619268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212620270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212620270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0316	1716212620270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212621272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212621272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0256	1716212621272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212622274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212622274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0256	1716212622274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212623276	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212623276	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0256	1716212623276	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212624278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212624278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.027	1716212624278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212625280	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212625280	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.027	1716212625280	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212626282	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212626282	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.027	1716212626282	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212627284	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212627284	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0274	1716212627284	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212628286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212628286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0274	1716212628286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212629287	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212629287	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0274	1716212629287	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212630289	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212630289	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0305999999999997	1716212630289	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212631291	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212631291	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0305999999999997	1716212631291	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212632293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212632293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0305999999999997	1716212632293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212633295	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716212633295	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.032	1716212633295	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212634297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212634297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.032	1716212634297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212635298	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212635298	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.032	1716212635298	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212636300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212636300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0342000000000002	1716212636300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212637302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212637302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0342000000000002	1716212637302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212638304	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212638304	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0342000000000002	1716212638304	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212639306	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212639306	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0368	1716212639306	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212640309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212640309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0368	1716212640309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212641311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212641311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0368	1716212641311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212642313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212642313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0322999999999998	1716212642313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212643315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212643315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0322999999999998	1716212643315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212644317	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212644317	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0322999999999998	1716212644317	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212645318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212645318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0326	1716212645318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212646320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212646320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0326	1716212646320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212647322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212647322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0326	1716212647322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212648324	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212648324	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0329	1716212648324	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212649326	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212649326	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0329	1716212649326	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212650328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212650328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0329	1716212650328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212651330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212651330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0345999999999997	1716212651330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212652332	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212652332	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0345999999999997	1716212652332	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212653334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212653334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0345999999999997	1716212653334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212654336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212654336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0351	1716212654336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212655338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212655338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0351	1716212655338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212656340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212656340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0351	1716212656340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212657341	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212657341	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0352	1716212657341	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212658343	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212658343	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0352	1716212658343	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212659345	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212659345	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0352	1716212659345	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212660347	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212660347	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0356	1716212660347	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212661348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212661348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0356	1716212661348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212662350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212662350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0356	1716212662350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212663352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212663352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0339	1716212663352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212664354	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212664354	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0339	1716212664354	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212665356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212665356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0339	1716212665356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212666358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212666358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0347	1716212666358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212667359	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212667359	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0347	1716212667359	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212668360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212668360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0347	1716212668360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212669362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212669362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0357	1716212669362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212670364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212670364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0357	1716212670364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212671365	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212671365	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0357	1716212671365	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212672366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212672366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0354	1716212672366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212673368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212673368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0354	1716212673368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212674370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212674370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0354	1716212674370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212675372	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212655361	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212656355	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212657363	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212658365	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212659367	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212660372	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212661370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212662370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212663375	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212664380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212665380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212666381	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212667376	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212668376	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212669383	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212670385	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212671378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212672390	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212673383	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212674392	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212675386	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212676396	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212677399	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212678392	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212679403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212680406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212681406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212682409	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212683410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212684412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212685416	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212686416	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212687418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212688421	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212689414	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212690424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212691426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212692428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212693431	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212827665	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0483000000000002	1716212827665	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212828667	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212828667	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0493	1716212828667	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212829668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212829668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0493	1716212829668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212830670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716212830670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0493	1716212830670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212831672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212831672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.048	1716212831672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212832674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212832674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.048	1716212832674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212833676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212833676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.048	1716212833676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212834678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212834678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.049	1716212834678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212835680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212835680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.049	1716212835680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212675372	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0358	1716212675372	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212676374	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212676374	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0358	1716212676374	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212677376	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212677376	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0358	1716212677376	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212678378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212678378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0374	1716212678378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212679381	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212679381	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0374	1716212679381	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212680383	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212680383	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0374	1716212680383	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212681385	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212681385	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0286	1716212681385	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212682387	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212682387	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0286	1716212682387	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212683389	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212683389	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0286	1716212683389	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212684391	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212684391	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0313	1716212684391	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212685393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212685393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0313	1716212685393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212686395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212686395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0313	1716212686395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212687397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212687397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0357	1716212687397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212688398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212688398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0357	1716212688398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212689400	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212689400	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0357	1716212689400	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212690402	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212690402	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0351	1716212690402	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212691404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212691404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0351	1716212691404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212692406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212692406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0351	1716212692406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212693408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212693408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0316	1716212693408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212694410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212694410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0316	1716212694410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212694435	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212695412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212695412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0316	1716212695412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212695434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212696414	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212696414	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.032	1716212696414	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212697417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212697417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.032	1716212697417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212698418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212698418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.032	1716212698418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212699420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212699420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.035	1716212699420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212700422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212700422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.035	1716212700422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212701424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212701424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.035	1716212701424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212702426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212702426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0344	1716212702426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212703428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212703428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0344	1716212703428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212704430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212704430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0344	1716212704430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212705432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212705432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0348	1716212705432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212706434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212706434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0348	1716212706434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212707435	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212707435	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0348	1716212707435	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212708437	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212708437	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0365	1716212708437	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212709440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212709440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0365	1716212709440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212710442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212710442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0365	1716212710442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212711443	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212711443	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0396	1716212711443	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212712445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212712445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0396	1716212712445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212713447	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212713447	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0396	1716212713447	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212714448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212714448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0375	1716212714448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212715450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212715450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0375	1716212715450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212716452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212716452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0375	1716212716452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212717454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212696434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212697439	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212698432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212699442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212700443	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212701437	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212702450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212703442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212704443	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212705452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212706460	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212707457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212708452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212709463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212710462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212711465	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212712467	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212713461	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212714463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212715473	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212716472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212717475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212718471	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212719480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212720482	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212721484	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212722485	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212723487	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212724489	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212725491	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212726492	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212727495	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212728489	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212729501	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212730505	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212731502	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212732504	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212733499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212734508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212735504	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212736516	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212737518	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212738509	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212739521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212740520	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212741521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212742523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212743521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212744528	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212745534	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212746533	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212747533	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212748535	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212749536	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212750539	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212751542	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212752545	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212753538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212754540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212755550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212756556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212757555	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212758548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212759557	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212760561	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212717454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0381	1716212717454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212718457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212718457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0381	1716212718457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212719458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212719458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0381	1716212719458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212720460	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212720460	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0391	1716212720460	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212721462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212721462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0391	1716212721462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212722464	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212722464	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0391	1716212722464	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212723466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212723466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0405	1716212723466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212724468	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212724468	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0405	1716212724468	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212725470	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212725470	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0405	1716212725470	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212726472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212726472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0395	1716212726472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212727474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212727474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0395	1716212727474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212728475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.8	1716212728475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0395	1716212728475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212729477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212729477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0369	1716212729477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212730479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212730479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0369	1716212730479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212731481	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212731481	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0369	1716212731481	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212732483	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212732483	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0385	1716212732483	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212733485	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212733485	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0385	1716212733485	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212734487	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212734487	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0385	1716212734487	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212735489	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212735489	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0391	1716212735489	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212736491	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212736491	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0391	1716212736491	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212737493	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212737493	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0391	1716212737493	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212738495	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212738495	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0395	1716212738495	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212739496	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212739496	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0395	1716212739496	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212740498	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212740498	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0395	1716212740498	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212741500	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212741500	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0403	1716212741500	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212742502	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212742502	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0403	1716212742502	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212743504	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212743504	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0403	1716212743504	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212744506	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212744506	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0433	1716212744506	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212745508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212745508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0433	1716212745508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212746510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.200000000000001	1716212746510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0433	1716212746510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212747512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.4	1716212747512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0427	1716212747512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212748514	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212748514	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0427	1716212748514	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212749515	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212749515	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0427	1716212749515	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212750517	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212750517	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0395	1716212750517	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212751519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212751519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0395	1716212751519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212752522	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212752522	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0395	1716212752522	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212753523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212753523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0328	1716212753523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212754525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212754525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0328	1716212754525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212755527	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212755527	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0328	1716212755527	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212756528	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212756528	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0381	1716212756528	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212757531	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212757531	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0381	1716212757531	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212758533	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212758533	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0381	1716212758533	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212759535	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212759535	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0385	1716212759535	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212760537	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212760537	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0385	1716212760537	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212761539	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212761539	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0385	1716212761539	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212762541	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212762541	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0308	1716212762541	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212763543	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212763543	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0308	1716212763543	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212764544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212764544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0308	1716212764544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212765547	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212765547	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0353	1716212765547	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212766548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212766548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0353	1716212766548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212767550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212767550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0353	1716212767550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212768552	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212768552	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.038	1716212768552	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212769554	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212769554	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.038	1716212769554	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212770556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212770556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.038	1716212770556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212771558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212771558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0261	1716212771558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212772560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212772560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0261	1716212772560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212773563	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212773563	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0261	1716212773563	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212774564	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212774564	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0401	1716212774564	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212775566	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212775566	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0401	1716212775566	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212776568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212776568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0401	1716212776568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212777570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212777570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0410999999999997	1716212777570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212778572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212778572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0410999999999997	1716212778572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212779574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212779574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0410999999999997	1716212779574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212780576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212780576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0432	1716212780576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212781577	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212761560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212762562	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212763563	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212764568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212765569	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212766572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212767566	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212768573	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212769571	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212770579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212771582	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212772574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212773585	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212774588	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212775593	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212776589	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212777583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212778593	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212779597	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212780599	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212781599	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212782592	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212783602	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212784597	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212785606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212786609	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212787610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212788604	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212789614	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212790616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212791616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212792611	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212793614	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212794624	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212795626	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212796630	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212797629	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212798625	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212799633	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212800634	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212801636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212802639	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212803635	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212804643	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212805643	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212806645	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212807647	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212808645	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212809655	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212810646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212811654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212812654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212813659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212836682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212836682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.049	1716212836682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212837684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212837684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0495	1716212837684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212838686	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212838686	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0495	1716212838686	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212839687	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212839687	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0495	1716212839687	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212781577	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0432	1716212781577	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212782579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212782579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0432	1716212782579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212783581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212783581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0446	1716212783581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212784583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212784583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0446	1716212784583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212785585	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212785585	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0446	1716212785585	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212786587	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212786587	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0424	1716212786587	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212787588	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212787588	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0424	1716212787588	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212788590	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212788590	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0424	1716212788590	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212789592	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212789592	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0443	1716212789592	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212790594	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212790594	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0443	1716212790594	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212791596	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212791596	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0443	1716212791596	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212792598	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212792598	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0433	1716212792598	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212793600	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212793600	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0433	1716212793600	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212794602	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212794602	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0433	1716212794602	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212795604	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212795604	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0433	1716212795604	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212796606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212796606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0433	1716212796606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212797608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212797608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0433	1716212797608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212798610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212798610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0447	1716212798610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212799612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212799612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0447	1716212799612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212800613	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212800613	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0447	1716212800613	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212801615	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212801615	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0461	1716212801615	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212802617	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212802617	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0461	1716212802617	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212803619	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212803619	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0461	1716212803619	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212804620	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212804620	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0444	1716212804620	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212805622	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212805622	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0444	1716212805622	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212806624	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212806624	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0444	1716212806624	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212807626	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212807626	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0449	1716212807626	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212808628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212808628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0449	1716212808628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212809630	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212809630	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0449	1716212809630	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212810632	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212810632	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0447	1716212810632	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212811635	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212811635	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0447	1716212811635	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212812637	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212812637	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0447	1716212812637	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212813639	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212813639	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0477	1716212813639	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212837699	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212838700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212839708	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212840689	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212840689	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0465999999999998	1716212840689	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212840711	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212841691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212841691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0465999999999998	1716212841691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212841712	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212842693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212842693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0465999999999998	1716212842693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212842707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212843695	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212843695	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0485	1716212843695	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212843716	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212844697	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212844697	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0485	1716212844697	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212844720	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212845699	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212845699	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0485	1716212845699	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212845723	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212846701	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212846701	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0483000000000002	1716212846701	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212846723	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212847726	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212848719	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212849727	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212850730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212851733	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212852735	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212853730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212854738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212855743	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212856736	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212857745	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212858745	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212859749	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212860750	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212861751	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212862753	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212863749	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212864761	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212865760	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212866759	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212867764	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212868756	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212869764	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212870767	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212871769	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212872763	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212873776	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213414800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213414800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0923000000000003	1716213414800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213415802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213415802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0923000000000003	1716213415802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213416804	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213416804	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0923000000000003	1716213416804	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213417806	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213417806	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0942	1716213417806	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213418807	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213418807	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0942	1716213418807	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213419808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213419808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0942	1716213419808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213420810	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213420810	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213420810	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213421812	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213421812	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213421812	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213422814	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213422814	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213422814	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213423816	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213423816	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0972	1716213423816	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213424818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213424818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0972	1716213424818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213425820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213425820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0972	1716213425820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213426822	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212847703	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212847703	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0483000000000002	1716212847703	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212848705	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212848705	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0483000000000002	1716212848705	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212849707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212849707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0485	1716212849707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212850709	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212850709	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0485	1716212850709	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212851711	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212851711	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0485	1716212851711	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212852713	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212852713	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0484	1716212852713	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212853715	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212853715	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0484	1716212853715	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212854717	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212854717	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0484	1716212854717	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212855719	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212855719	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0511	1716212855719	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212856721	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212856721	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0511	1716212856721	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212857722	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212857722	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0511	1716212857722	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212858724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.5	1716212858724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0496	1716212858724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212859726	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.3	1716212859726	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0496	1716212859726	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212860728	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212860728	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0496	1716212860728	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212861730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212861730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0455	1716212861730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212862732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212862732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0455	1716212862732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212863734	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212863734	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0455	1716212863734	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212864736	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212864736	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0474	1716212864736	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212865738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212865738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0474	1716212865738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212866738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212866738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0474	1716212866738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212867740	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212867740	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0485	1716212867740	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212868742	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212868742	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0485	1716212868742	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212869744	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212869744	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0485	1716212869744	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212870746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212870746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.05	1716212870746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212871748	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212871748	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.05	1716212871748	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212872750	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212872750	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.05	1716212872750	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212873752	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212873752	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0504000000000002	1716212873752	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212874754	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212874754	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0504000000000002	1716212874754	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212874777	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212875755	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212875755	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0504000000000002	1716212875755	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212875777	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212876757	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212876757	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0493	1716212876757	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212876779	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212877759	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212877759	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0493	1716212877759	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212877774	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212878761	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212878761	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0493	1716212878761	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212878782	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212879763	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212879763	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0502	1716212879763	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212879784	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212880765	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212880765	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0502	1716212880765	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212880789	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212881767	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212881767	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0502	1716212881767	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212881791	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212882769	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212882769	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0472	1716212882769	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212882786	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212883771	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212883771	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0472	1716212883771	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212883793	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212884773	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212884773	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0472	1716212884773	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212884794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212885775	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212885775	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0494	1716212885775	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212885797	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212886791	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212887795	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212888804	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212889807	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212890809	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212891809	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212892811	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212893805	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212894815	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212895817	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212896821	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212897820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212898818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212899824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212900826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212901828	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212902823	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212903835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212904836	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212905837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212906841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212907840	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212908842	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212909844	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212910838	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212911848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212912850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212913845	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212914853	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212915854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212916851	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212917859	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212918860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212919862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212920869	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212921865	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212922861	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212923863	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212924866	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212925873	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212926875	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212927877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212928871	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212929881	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212930880	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212931885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212932886	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212933889	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212934891	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212935894	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212936893	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212937890	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212938898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212939892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212940903	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212941904	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212942899	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212943907	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212944909	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212945912	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212946913	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212947909	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212948916	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212949921	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212886777	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212886777	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0494	1716212886777	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212887780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212887780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0494	1716212887780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212888783	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212888783	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0486	1716212888783	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212889785	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212889785	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0486	1716212889785	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212890786	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212890786	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0486	1716212890786	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212891788	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212891788	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0494	1716212891788	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212892790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212892790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0494	1716212892790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212893792	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212893792	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0494	1716212893792	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212894794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212894794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0505	1716212894794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212895796	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212895796	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0505	1716212895796	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212896798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212896798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0505	1716212896798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212897800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212897800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0516	1716212897800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212898801	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212898801	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0516	1716212898801	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212899803	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212899803	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0516	1716212899803	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212900805	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212900805	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0526999999999997	1716212900805	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212901807	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212901807	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0526999999999997	1716212901807	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212902809	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212902809	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0526999999999997	1716212902809	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212903811	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212903811	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0528000000000004	1716212903811	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212904813	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212904813	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0528000000000004	1716212904813	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212905815	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212905815	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0528000000000004	1716212905815	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212906817	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212906817	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0501	1716212906817	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212907818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212907818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0501	1716212907818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212908820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212908820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0501	1716212908820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212909822	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212909822	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0503	1716212909822	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212910824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212910824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0503	1716212910824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212911826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716212911826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0503	1716212911826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212912828	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212912828	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.052	1716212912828	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212913830	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212913830	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.052	1716212913830	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212914832	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212914832	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.052	1716212914832	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212915834	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212915834	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0519000000000003	1716212915834	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212916835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212916835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0519000000000003	1716212916835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212917837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212917837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0519000000000003	1716212917837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212918839	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212918839	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0515	1716212918839	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212919841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212919841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0515	1716212919841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212920843	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212920843	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0515	1716212920843	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212921845	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212921845	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0496999999999996	1716212921845	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212922847	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212922847	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0496999999999996	1716212922847	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212923849	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212923849	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0496999999999996	1716212923849	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212924850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212924850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0501	1716212924850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212925852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212925852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0501	1716212925852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212926854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212926854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0501	1716212926854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212927856	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212927856	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0517	1716212927856	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212928858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716212928858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0517	1716212928858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212929860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212929860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0517	1716212929860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212930862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212930862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0514	1716212930862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212931863	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212931863	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0514	1716212931863	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212932865	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212932865	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0514	1716212932865	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212933867	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212933867	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0502	1716212933867	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212934869	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212934869	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0502	1716212934869	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212935871	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212935871	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0502	1716212935871	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212936873	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212936873	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0501	1716212936873	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212937875	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212937875	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0501	1716212937875	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212938876	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212938876	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0501	1716212938876	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212939878	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212939878	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0518	1716212939878	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212940880	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212940880	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0518	1716212940880	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212941882	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212941882	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0518	1716212941882	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212942884	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212942884	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0519000000000003	1716212942884	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212943886	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212943886	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0519000000000003	1716212943886	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212944888	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212944888	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0519000000000003	1716212944888	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212945890	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212945890	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0524	1716212945890	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212946892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212946892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0524	1716212946892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212947894	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212947894	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0524	1716212947894	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212948895	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212948895	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0518	1716212948895	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212949897	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212949897	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0518	1716212949897	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212950899	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212950899	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0518	1716212950899	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212951901	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212951901	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0519000000000003	1716212951901	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212952903	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212952903	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0519000000000003	1716212952903	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212953905	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212953905	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0519000000000003	1716212953905	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212954907	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212954907	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0516	1716212954907	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212955910	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212955910	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0516	1716212955910	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212956912	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212956912	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0516	1716212956912	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212957914	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212957914	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0523000000000002	1716212957914	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212958916	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212958916	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0523000000000002	1716212958916	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212959918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212959918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0523000000000002	1716212959918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212960920	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212960920	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0525	1716212960920	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212961922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212961922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0525	1716212961922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212962924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212962924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0525	1716212962924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212963926	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212963926	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0532	1716212963926	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212964928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212964928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0532	1716212964928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212965930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212965930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0532	1716212965930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212966932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212966932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0523000000000002	1716212966932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212967933	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212967933	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0523000000000002	1716212967933	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212968935	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212968935	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0523000000000002	1716212968935	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212969937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212969937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0542	1716212969937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212970938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212970938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0542	1716212970938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212971940	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212950920	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212951924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212952921	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212953921	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212954928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212955935	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212956934	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212957929	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212958938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212959939	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212960941	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212961943	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212962939	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212963947	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212964950	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212965952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212966956	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212967954	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212968952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212969958	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212970961	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212971962	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212972963	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212973960	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212974967	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212975970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212976972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212977966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212978976	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212979977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212980980	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212981981	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212982979	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212983984	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212984986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212985989	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212986989	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212987983	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212988994	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212989998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212990996	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212991999	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212992993	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212994002	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212994998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212996006	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212997010	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212998011	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716212999004	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213000013	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213001017	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213002015	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213003020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213004015	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213005030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213006026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213007032	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213008022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213009031	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213010033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213011035	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213012038	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213013033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213014044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213015044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212971940	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0542	1716212971940	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212972942	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212972942	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0504000000000002	1716212972942	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716212973944	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212973944	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0504000000000002	1716212973944	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212974946	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212974946	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0504000000000002	1716212974946	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212975948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212975948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0530999999999997	1716212975948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212976950	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212976950	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0530999999999997	1716212976950	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212977952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212977952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0530999999999997	1716212977952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212978953	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212978953	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0518	1716212978953	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716212979955	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	3.5	1716212979955	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0518	1716212979955	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212980957	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212980957	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0518	1716212980957	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212981959	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212981959	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0508	1716212981959	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212982961	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212982961	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0508	1716212982961	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212983963	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212983963	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0508	1716212983963	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212984964	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212984964	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0536999999999996	1716212984964	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212985966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212985966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0536999999999996	1716212985966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212986968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212986968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0536999999999996	1716212986968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212987970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212987970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0505	1716212987970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212988971	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212988971	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0505	1716212988971	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212989973	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212989973	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0505	1716212989973	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212990975	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212990975	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0503	1716212990975	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212991977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212991977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0503	1716212991977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212992979	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212992979	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0503	1716212992979	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212993981	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212993981	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0516	1716212993981	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716212994983	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212994983	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0516	1716212994983	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212995985	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212995985	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0516	1716212995985	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212996986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212996986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0561	1716212996986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716212997988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212997988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0561	1716212997988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212998990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716212998990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0561	1716212998990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716212999992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716212999992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0558	1716212999992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213000995	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	3.5	1716213000995	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0558	1716213000995	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213001997	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716213001997	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0558	1716213001997	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213002998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716213002998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0548	1716213002998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	105	1716213004000	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716213004000	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0548	1716213004000	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	99	1716213005003	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	3.5	1716213005003	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0548	1716213005003	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213006005	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716213006005	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0556	1716213006005	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213007007	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716213007007	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0556	1716213007007	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213008008	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716213008008	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0556	1716213008008	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213009010	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716213009010	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0563000000000002	1716213009010	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213010012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716213010012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0563000000000002	1716213010012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213011014	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.6	1716213011014	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0563000000000002	1716213011014	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213012016	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.4	1716213012016	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0566999999999998	1716213012016	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213013018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213013018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0566999999999998	1716213013018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213014020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213014020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0566999999999998	1716213014020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213015022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213015022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0523000000000002	1716213015022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213016024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213016024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0523000000000002	1716213016024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213017026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213017026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0523000000000002	1716213017026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213018028	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213018028	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0555	1716213018028	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213019029	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213019029	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0555	1716213019029	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213020031	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213020031	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0555	1716213020031	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213021033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213021033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0549	1716213021033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213022035	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213022035	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0549	1716213022035	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213023037	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213023037	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0549	1716213023037	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213024040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213024040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0556	1716213024040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213025042	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213025042	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0556	1716213025042	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213026044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213026044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0556	1716213026044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213027047	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213027047	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0556	1716213027047	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213028049	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213028049	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0556	1716213028049	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213029051	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213029051	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0556	1716213029051	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213030053	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213030053	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0569	1716213030053	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213031055	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213031055	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0569	1716213031055	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213032057	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213032057	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0569	1716213032057	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213033058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213033058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0575	1716213033058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213034060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213034060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0575	1716213034060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213035062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213035062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0575	1716213035062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213036064	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213016049	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213017048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213018042	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213019052	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213020055	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213021054	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213022059	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213023060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213024060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213025064	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213026067	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213027068	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213028066	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213029073	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213030074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213031076	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213032080	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213033072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213034083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213035083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213036086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213037088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213038083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213039092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213040095	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213041096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213042098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213043094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213044102	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213045103	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213046106	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213047108	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213048104	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213049112	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213050114	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213051116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213052118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213053119	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213414823	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213415826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213416818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213417820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213418823	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213419834	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213420831	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213421828	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213422835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213423832	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213424840	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213425835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213426838	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213427837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213428844	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213429851	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213430854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213431854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213432852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213433851	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213434859	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213435861	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213436865	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213437857	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213438859	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213439863	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213440870	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213036064	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0573	1716213036064	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213037067	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213037067	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0573	1716213037067	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213038069	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213038069	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0573	1716213038069	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213039071	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213039071	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0545999999999998	1716213039071	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213040073	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213040073	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0545999999999998	1716213040073	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213041075	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213041075	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0545999999999998	1716213041075	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213042077	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213042077	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0551999999999997	1716213042077	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213043079	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213043079	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0551999999999997	1716213043079	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213044081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213044081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0551999999999997	1716213044081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213045083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213045083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0557	1716213045083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213046085	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213046085	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0557	1716213046085	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213047086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213047086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0557	1716213047086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213048089	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213048089	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0565	1716213048089	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213049090	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213049090	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0565	1716213049090	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213050092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213050092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0565	1716213050092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213051094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213051094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0578000000000003	1716213051094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213052096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.4	1716213052096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0578000000000003	1716213052096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213053098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213053098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0578000000000003	1716213053098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213054100	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213054100	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0598	1716213054100	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213054113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213055102	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213055102	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0598	1716213055102	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213055128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213056104	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213056104	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0598	1716213056104	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213056124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213057127	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213058121	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213059131	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213060132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213061127	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213062137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213063135	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213064143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213065143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213066143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213067145	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213068139	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213069150	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213070156	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213071154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213072156	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213073150	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213074153	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213075164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213076157	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213077169	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213078160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213079170	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213080170	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213081172	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213082177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213083179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213084179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213085182	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213086183	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213087186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213088181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213089189	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213090192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213091186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213092194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213093189	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213094200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213095205	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213096208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213097207	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213098201	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213099209	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213100206	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213101216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213102208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213103218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213104214	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213105222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213106218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213107227	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213108229	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213109223	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213110225	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213111235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213112239	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213113230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213114234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213115236	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213116246	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213117246	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213118247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213119242	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213120253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213057105	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213057105	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.057	1716213057105	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213058106	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213058106	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.057	1716213058106	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213059108	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213059108	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.057	1716213059108	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213060111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213060111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0308	1716213060111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213061113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213061113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0308	1716213061113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213062115	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213062115	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0308	1716213062115	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213063117	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213063117	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0595	1716213063117	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213064119	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213064119	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0595	1716213064119	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213065120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213065120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0595	1716213065120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213066122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213066122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0605	1716213066122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213067124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213067124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0605	1716213067124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213068126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213068126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0605	1716213068126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213069128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213069128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0608	1716213069128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213070130	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213070130	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0608	1716213070130	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213071132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213071132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0608	1716213071132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213072134	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213072134	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0523000000000002	1716213072134	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213073136	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213073136	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0523000000000002	1716213073136	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213074138	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213074138	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0523000000000002	1716213074138	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213075140	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213075140	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0572	1716213075140	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213076142	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213076142	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0572	1716213076142	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213077143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213077143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0572	1716213077143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213078145	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213078145	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0578000000000003	1716213078145	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213079147	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213079147	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0578000000000003	1716213079147	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213080149	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213080149	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0578000000000003	1716213080149	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213081151	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213081151	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0579	1716213081151	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213082154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213082154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0579	1716213082154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213083157	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213083157	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0579	1716213083157	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213084158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213084158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0556	1716213084158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213085160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213085160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0556	1716213085160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213086162	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213086162	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0556	1716213086162	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213087164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213087164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0562	1716213087164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213088166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213088166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0562	1716213088166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213089168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213089168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0562	1716213089168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213090170	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213090170	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.056	1716213090170	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213091172	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213091172	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.056	1716213091172	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213092174	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213092174	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.056	1716213092174	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213093176	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213093176	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0557	1716213093176	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213094179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213094179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0557	1716213094179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213095182	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.7	1716213095182	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0557	1716213095182	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213096184	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.5	1716213096184	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0558	1716213096184	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213097186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213097186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0558	1716213097186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213098188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213098188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0558	1716213098188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213099190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213099190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.057	1716213099190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213100191	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213100191	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.057	1716213100191	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213101194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213101194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.057	1716213101194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213102195	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213102195	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0604	1716213102195	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213103197	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213103197	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0604	1716213103197	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213104199	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213104199	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0604	1716213104199	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213105201	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213105201	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0606	1716213105201	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213106203	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213106203	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0606	1716213106203	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213107205	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213107205	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0606	1716213107205	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213108207	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213108207	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0598	1716213108207	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213109208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213109208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0598	1716213109208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213110210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213110210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0598	1716213110210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213111212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213111212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0614	1716213111212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213112215	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213112215	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0614	1716213112215	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213113216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213113216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0614	1716213113216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213114218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213114218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0602	1716213114218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213115220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213115220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0602	1716213115220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213116222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213116222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0602	1716213116222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213117224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213117224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0631	1716213117224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213118226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213118226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0631	1716213118226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213119228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213119228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0631	1716213119228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213120229	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213120229	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0631999999999997	1716213120229	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213121231	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213121231	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0631999999999997	1716213121231	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213122233	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213122233	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0631999999999997	1716213122233	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213123235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213123235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0638	1716213123235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213124237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213124237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0638	1716213124237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213125239	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213125239	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0638	1716213125239	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213126241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213126241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0609	1716213126241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213127243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213127243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0609	1716213127243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213128245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213128245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0609	1716213128245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213129247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213129247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0574	1716213129247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213130248	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213130248	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0574	1716213130248	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213131250	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213131250	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0574	1716213131250	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213132252	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213132252	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0541	1716213132252	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213133254	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213133254	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0541	1716213133254	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213134256	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213134256	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0541	1716213134256	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213135259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213135259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.058	1716213135259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213136261	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213136261	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.058	1716213136261	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213137263	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213137263	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.058	1716213137263	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213138264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213138264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0593000000000004	1716213138264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213139266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213139266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0593000000000004	1716213139266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213140268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213140268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0593000000000004	1716213140268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213141270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213141270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0529	1716213141270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213142271	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213121246	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213122255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213123259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213124254	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213125253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213126262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213127265	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213128269	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213129268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213130270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213131274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213132278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213133269	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213134279	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213135283	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213136275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213137288	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213138279	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213139287	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213140281	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213141289	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213142293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213143298	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213144297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213145299	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213146300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213147303	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213148299	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213149308	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213150308	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213151304	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213152313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213153309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213154320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213155322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213156323	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213157323	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213158320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213159322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213160322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213161333	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213162332	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213163335	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213164329	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213165340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213166342	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213167342	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213168344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213169342	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213170339	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213171349	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213172352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213173353	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213174349	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213175358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213176364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213177362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213178355	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213179364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213180367	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213181369	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213182371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213183365	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213184375	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213185379	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213142271	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0529	1716213142271	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213143273	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213143273	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0529	1716213143273	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213144275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213144275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0578000000000003	1716213144275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213145277	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213145277	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0578000000000003	1716213145277	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213146279	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213146279	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0578000000000003	1716213146279	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213147281	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213147281	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0621	1716213147281	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213148283	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213148283	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0621	1716213148283	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213149285	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213149285	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0621	1716213149285	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213150287	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213150287	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0499	1716213150287	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213151288	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213151288	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0499	1716213151288	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213152290	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213152290	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0499	1716213152290	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213153293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.000000000000002	1716213153293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0610999999999997	1716213153293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213154296	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213154296	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0610999999999997	1716213154296	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213155298	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213155298	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0610999999999997	1716213155298	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213156300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213156300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0605	1716213156300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213157301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213157301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0605	1716213157301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213158303	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213158303	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0605	1716213158303	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213159305	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213159305	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0646	1716213159305	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213160307	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213160307	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0646	1716213160307	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213161309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213161309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0646	1716213161309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213162311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213162311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0646999999999998	1716213162311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213163313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213163313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0646999999999998	1716213163313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213164315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213164315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0646999999999998	1716213164315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213165317	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213165317	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0649	1716213165317	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213166319	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213166319	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0649	1716213166319	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213167321	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213167321	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0649	1716213167321	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213168322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213168322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0642	1716213168322	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213169324	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213169324	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0642	1716213169324	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213170326	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213170326	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0642	1716213170326	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213171328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213171328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0635	1716213171328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213172330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213172330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0635	1716213172330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	99	1716213173332	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213173332	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0635	1716213173332	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213174334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213174334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0636	1716213174334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213175336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213175336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0636	1716213175336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213176338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213176338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0636	1716213176338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213177340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213177340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0656	1716213177340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213178341	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213178341	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0656	1716213178341	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213179343	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213179343	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0656	1716213179343	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213180346	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213180346	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0661	1716213180346	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213181348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213181348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0661	1716213181348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213182350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213182350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0661	1716213182350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213183352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213183352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0663	1716213183352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213184353	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213184353	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0663	1716213184353	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213185355	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213185355	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0663	1716213185355	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213186357	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213186357	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0671999999999997	1716213186357	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213187358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213187358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0671999999999997	1716213187358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213188360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213188360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0671999999999997	1716213188360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213189362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213189362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0683000000000002	1716213189362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213190364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213190364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0683000000000002	1716213190364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213191368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213191368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0683000000000002	1716213191368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213192369	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213192369	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.068	1716213192369	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213193371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213193371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.068	1716213193371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213194374	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213194374	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.068	1716213194374	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213195376	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213195376	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0668	1716213195376	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213196378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213196378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0668	1716213196378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213197380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213197380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0668	1716213197380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213198382	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213198382	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.067	1716213198382	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213199384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213199384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.067	1716213199384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213200385	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213200385	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.067	1716213200385	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213201387	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213201387	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.066	1716213201387	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213202388	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213202388	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.066	1716213202388	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213203390	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213203390	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.066	1716213203390	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213204392	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213204392	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0591999999999997	1716213204392	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213205394	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213205394	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0591999999999997	1716213205394	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213206396	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213186381	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213187381	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213188375	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213189379	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213190389	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213191392	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213192394	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213193386	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213194397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213195397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213196401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213197401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213198398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213199406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213200410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213201409	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213202416	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213203411	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213204413	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213205417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213206417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213207419	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213208423	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213209427	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213210425	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213211421	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213212431	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213213432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213214435	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213215439	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213216440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213217435	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213218446	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213219439	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213220449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213221449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213222451	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213223444	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213224458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213225456	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213226459	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213227453	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213228455	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213229465	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213230471	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213231471	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213232473	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213233472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213426822	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.099	1716213426822	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213427824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213427824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.099	1716213427824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213428826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213428826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.099	1716213428826	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213429827	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213429827	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0976	1716213429827	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213430829	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213430829	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0976	1716213430829	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213431832	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213431832	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0976	1716213431832	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213206396	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0591999999999997	1716213206396	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213207398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213207398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0610999999999997	1716213207398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213208400	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213208400	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0610999999999997	1716213208400	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213209403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213209403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0610999999999997	1716213209403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213210404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213210404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0643000000000002	1716213210404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213211406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213211406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0643000000000002	1716213211406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213212408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213212408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0643000000000002	1716213212408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213213410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213213410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0652	1716213213410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213214413	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213214413	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0652	1716213214413	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213215415	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213215415	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0652	1716213215415	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213216418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213216418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0655	1716213216418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213217420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213217420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0655	1716213217420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213218422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213218422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0655	1716213218422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213219424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213219424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0641	1716213219424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213220426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213220426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0641	1716213220426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213221428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213221428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0641	1716213221428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213222429	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213222429	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0649	1716213222429	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213223431	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213223431	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0649	1716213223431	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213224434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213224434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0649	1716213224434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213225436	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213225436	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0664000000000002	1716213225436	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213226437	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213226437	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0664000000000002	1716213226437	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213227438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213227438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0664000000000002	1716213227438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213228440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213228440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0655	1716213228440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213229442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213229442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0655	1716213229442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213230444	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213230444	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0655	1716213230444	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213231446	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213231446	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0653	1716213231446	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213232448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213232448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0653	1716213232448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213233449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213233449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0653	1716213233449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213234452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213234452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0664000000000002	1716213234452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213234476	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213235454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213235454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0664000000000002	1716213235454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213235480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213236456	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213236456	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0664000000000002	1716213236456	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213236479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213237458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213237458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0663	1716213237458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213237480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213238459	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213238459	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0663	1716213238459	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213238473	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213239463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213239463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0663	1716213239463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213239486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	98	1716213240465	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213240465	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.066	1716213240465	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213240488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213241467	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213241467	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.066	1716213241467	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213241493	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213242469	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213242469	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.066	1716213242469	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213242484	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213243471	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213243471	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0663	1716213243471	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213243485	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213244473	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213244473	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0663	1716213244473	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213244489	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213245475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213245475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0663	1716213245475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213246476	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213246476	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0671999999999997	1716213246476	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213247478	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213247478	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0671999999999997	1716213247478	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213248480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213248480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0671999999999997	1716213248480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213249482	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213249482	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0684	1716213249482	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213250484	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213250484	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0684	1716213250484	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213251486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.600000000000001	1716213251486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0684	1716213251486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213252488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213252488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0681	1716213252488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213253490	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.800000000000001	1716213253490	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0681	1716213253490	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213254492	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.5	1716213254492	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0681	1716213254492	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213255494	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213255494	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0690999999999997	1716213255494	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213256495	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213256495	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0690999999999997	1716213256495	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213257497	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213257497	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0690999999999997	1716213257497	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213258499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213258499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0689	1716213258499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213259501	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213259501	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0689	1716213259501	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213260503	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213260503	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0689	1716213260503	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213261505	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213261505	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0652	1716213261505	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213262507	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213262507	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0652	1716213262507	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213263508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213263508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0652	1716213263508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213264510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213264510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0662	1716213264510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213265512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213265512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0662	1716213265512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213266514	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213266514	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213245503	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213246497	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213247501	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213248504	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213249499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213250508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213251508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213252510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213253503	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213254513	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213255515	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213256518	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213257511	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213258513	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213259522	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213260526	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213261533	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213262528	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213263523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213264526	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213265529	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213266529	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213267537	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213268533	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213269541	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213270543	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213271545	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213272545	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213273544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213274551	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213275552	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213276545	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213277556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213278556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213279560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213280562	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213281565	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213282566	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213283560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213284570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213285571	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213286574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213287568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213288570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213289581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213290585	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213291582	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213292585	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213293589	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213294583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213295583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213296586	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213297586	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213298588	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213299601	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213300590	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213301601	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213302595	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213303596	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213304607	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213305609	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213306604	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213307615	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213308609	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213309616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0662	1716213266514	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213267516	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213267516	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0659	1716213267516	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213268518	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213268518	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0659	1716213268518	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213269520	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213269520	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0659	1716213269520	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213270521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213270521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0662	1716213270521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213271523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213271523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0662	1716213271523	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213272525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213272525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0662	1716213272525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213273527	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213273527	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0690999999999997	1716213273527	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213274528	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213274528	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0690999999999997	1716213274528	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213275530	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213275530	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0690999999999997	1716213275530	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213276532	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213276532	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0690999999999997	1716213276532	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213277534	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213277534	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0690999999999997	1716213277534	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213278536	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213278536	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0690999999999997	1716213278536	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213279538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213279538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0683000000000002	1716213279538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213280540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213280540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0683000000000002	1716213280540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213281542	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213281542	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0683000000000002	1716213281542	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213282544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213282544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0662	1716213282544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213283546	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213283546	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0662	1716213283546	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213284548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213284548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0662	1716213284548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213285550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213285550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0673000000000004	1716213285550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213286552	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213286552	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0673000000000004	1716213286552	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213287554	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213287554	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0673000000000004	1716213287554	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213288556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213288556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0667	1716213288556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213289558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213289558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0667	1716213289558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213290559	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213290559	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0667	1716213290559	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213291561	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213291561	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0654	1716213291561	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213292563	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213292563	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0654	1716213292563	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213293565	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213293565	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0654	1716213293565	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213294567	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213294567	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0698000000000003	1716213294567	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213295568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213295568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0698000000000003	1716213295568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213296570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213296570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0698000000000003	1716213296570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213297572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213297572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0694	1716213297572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213298574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213298574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0694	1716213298574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213299576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213299576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0694	1716213299576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213300578	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213300578	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0688	1716213300578	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213301580	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213301580	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0688	1716213301580	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213302582	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213302582	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0688	1716213302582	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213303584	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213303584	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0681	1716213303584	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213304586	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213304586	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0681	1716213304586	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213305587	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213305587	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0681	1716213305587	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213306589	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213306589	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0674	1716213306589	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213307591	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213307591	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0674	1716213307591	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213308593	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213308593	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0674	1716213308593	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213309595	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213309595	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0705	1716213309595	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213310597	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213310597	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0705	1716213310597	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213311598	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213311598	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0705	1716213311598	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213312600	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213312600	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0686999999999998	1716213312600	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213313602	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213313602	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0686999999999998	1716213313602	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213314604	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213314604	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0686999999999998	1716213314604	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213315606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213315606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0779	1716213315606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213316608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213316608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0779	1716213316608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213317610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213317610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0779	1716213317610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213318612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213318612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.083	1716213318612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213319615	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213319615	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.083	1716213319615	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213320617	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213320617	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.083	1716213320617	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213321620	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213321620	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0837	1716213321620	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213322622	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213322622	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0837	1716213322622	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213323624	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213323624	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0837	1716213323624	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213324626	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213324626	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0821	1716213324626	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213325628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213325628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0821	1716213325628	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213326630	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213326630	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0821	1716213326630	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213327632	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213327632	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0773	1716213327632	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213328634	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213328634	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0773	1716213328634	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213329636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213329636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0773	1716213329636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213330639	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213330639	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213310612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213311614	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213312621	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213313618	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213314626	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213315629	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213316629	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213317632	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213318626	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213319641	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213320640	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213321643	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213322638	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213323638	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213324648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213325651	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213326650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213327656	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213328649	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213329659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213330660	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213331662	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213332664	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213333658	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213334670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213335670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213336668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213337673	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213338674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213339676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213340679	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213341680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213342684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213343678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213344686	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213345688	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213346690	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213347692	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213348687	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213349697	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213350700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213351700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213352701	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213353703	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213354704	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213355698	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213356707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213357709	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213358704	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213359716	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213360718	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213361718	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213362722	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213363714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213364725	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213365725	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213366727	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213367725	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213368729	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213369731	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213370734	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213371736	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213372730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213373740	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213374741	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0815	1716213330639	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213331640	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213331640	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0815	1716213331640	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213332642	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213332642	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0815	1716213332642	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213333644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213333644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0824000000000003	1716213333644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213334646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213334646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0824000000000003	1716213334646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213335648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213335648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0824000000000003	1716213335648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213336650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213336650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0826	1716213336650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213337652	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213337652	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0826	1716213337652	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213338654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213338654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0826	1716213338654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213339655	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	3.8	1716213339655	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0866	1716213339655	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213340657	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213340657	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0866	1716213340657	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213341659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213341659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0866	1716213341659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213342661	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213342661	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0889	1716213342661	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213343663	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213343663	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0889	1716213343663	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213344665	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213344665	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0889	1716213344665	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213345666	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213345666	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0896999999999997	1716213345666	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213346668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213346668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0896999999999997	1716213346668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213347670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213347670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0896999999999997	1716213347670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213348672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213348672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0879000000000003	1716213348672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213349674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213349674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0879000000000003	1716213349674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213350676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213350676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0879000000000003	1716213350676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213351678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213351678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.089	1716213351678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213352679	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213352679	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.089	1716213352679	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213353681	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213353681	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.089	1716213353681	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213354683	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213354683	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0878	1716213354683	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213355684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213355684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0878	1716213355684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213356686	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213356686	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0878	1716213356686	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213357688	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213357688	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0874	1716213357688	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213358690	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213358690	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0874	1716213358690	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213359692	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213359692	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0874	1716213359692	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213360694	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213360694	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0878	1716213360694	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213361696	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213361696	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0878	1716213361696	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213362698	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213362698	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0878	1716213362698	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213363700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213363700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0901	1716213363700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213364702	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213364702	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0901	1716213364702	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213365704	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213365704	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0901	1716213365704	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213366706	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213366706	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0908	1716213366706	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213367707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213367707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0908	1716213367707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213368708	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213368708	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0908	1716213368708	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213369710	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213369710	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0932	1716213369710	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213370712	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213370712	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0932	1716213370712	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	99	1716213371714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213371714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0932	1716213371714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213372716	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213372716	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0885	1716213372716	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213373718	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213373718	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0885	1716213373718	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213374720	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213374720	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0885	1716213374720	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213375722	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213375722	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0896999999999997	1716213375722	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213376724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213376724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0896999999999997	1716213376724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213377727	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213377727	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0896999999999997	1716213377727	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213378729	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213378729	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0907	1716213378729	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213379730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213379730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0907	1716213379730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213380732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213380732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0907	1716213380732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213381734	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213381734	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0911	1716213381734	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213382737	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213382737	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0911	1716213382737	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213383739	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213383739	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0911	1716213383739	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213384741	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213384741	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.092	1716213384741	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213385744	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213385744	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.092	1716213385744	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213386746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213386746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.092	1716213386746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213387748	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213387748	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0914	1716213387748	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213388751	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213388751	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0914	1716213388751	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213389753	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213389753	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0914	1716213389753	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213390755	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213390755	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213390755	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213391757	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213391757	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213391757	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213392758	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213392758	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213392758	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213393760	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213393760	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0916	1716213393760	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213394762	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213394762	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213375744	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213376746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213377742	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213378754	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213379751	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213380753	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213381755	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213382751	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213383763	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213384766	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213385767	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213386760	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213387770	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213388766	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213389774	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213390780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213391780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213392780	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213393778	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213394787	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213395790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213396790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213397792	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213398795	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213399794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213400798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213401797	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213402799	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213403795	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213404799	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213405807	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213406806	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213407813	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213408801	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213409814	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213410813	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213411815	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213412821	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213413811	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213432834	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213432834	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213432834	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213433835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213433835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213433835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213434837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213434837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213434837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213435839	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213435839	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0686999999999998	1716213435839	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213436841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213436841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0686999999999998	1716213436841	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213437843	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213437843	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0686999999999998	1716213437843	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213438845	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213438845	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0948	1716213438845	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213439847	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213439847	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0948	1716213439847	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213440848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213440848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0916	1716213394762	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213395764	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213395764	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0916	1716213395764	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213396766	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	6.9	1716213396766	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213396766	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213397768	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.700000000000001	1716213397768	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213397768	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213398770	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213398770	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213398770	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213399772	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213399772	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0959	1716213399772	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213400774	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213400774	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0959	1716213400774	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213401776	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213401776	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0959	1716213401776	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213402778	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213402778	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213402778	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213403779	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213403779	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213403779	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213404782	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213404782	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213404782	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213405783	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213405783	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0948	1716213405783	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213406785	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213406785	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0948	1716213406785	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213407787	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213407787	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0948	1716213407787	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213408789	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213408789	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0953000000000004	1716213408789	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213409790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213409790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0953000000000004	1716213409790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213410792	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213410792	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0953000000000004	1716213410792	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213411794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213411794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0941	1716213411794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213412796	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213412796	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0941	1716213412796	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213413798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213413798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0941	1716213413798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0948	1716213440848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213441850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213441850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.094	1716213441850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213441872	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213442852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213442852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.094	1716213442852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213443854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213443854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.094	1716213443854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213444856	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	5.7	1716213444856	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0948	1716213444856	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213445858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213445858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0948	1716213445858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213446860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213446860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0948	1716213446860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213447862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213447862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0919	1716213447862	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213448864	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213448864	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0919	1716213448864	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213449865	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213449865	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0919	1716213449865	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213450867	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213450867	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0963000000000003	1716213450867	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213451869	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213451869	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0963000000000003	1716213451869	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213452871	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213452871	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0963000000000003	1716213452871	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213453872	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213453872	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.098	1716213453872	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213454874	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213454874	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.098	1716213454874	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213455877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213455877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.098	1716213455877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213456879	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213456879	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0988	1716213456879	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213457880	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213457880	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0988	1716213457880	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213458883	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213458883	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0988	1716213458883	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213459885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213459885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0958	1716213459885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213460886	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213460886	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0958	1716213460886	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213461889	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213461889	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0958	1716213461889	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213462891	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213462891	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0965	1716213462891	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213463893	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213463893	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213442866	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213443877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213444877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213445879	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213446881	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213447881	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213448885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213449889	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213450888	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213451892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213452887	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213453898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213454897	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213455900	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213456900	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213457900	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213458908	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213459906	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213460909	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213461911	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213462916	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213463915	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213464918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213465918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213466922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213467924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213468918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213469928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213470933	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213471929	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213472927	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213473933	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214195307	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214195307	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1323000000000003	1716214195307	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214196309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214196309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.128	1716214196309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214197311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214197311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.128	1716214197311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214198313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214198313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.128	1716214198313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214199315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214199315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1293	1716214199315	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214200318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214200318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1293	1716214200318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214201319	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214201319	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1293	1716214201319	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214202321	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214202321	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1314	1716214202321	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214203323	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214203323	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1314	1716214203323	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214204325	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214204325	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1314	1716214204325	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214205327	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214205327	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.132	1716214205327	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0965	1716213463893	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213464895	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213464895	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0965	1716213464895	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213465897	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213465897	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0957	1716213465897	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213466898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213466898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0957	1716213466898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213467901	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213467901	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0957	1716213467901	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213468902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213468902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991	1716213468902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213469904	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716213469904	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991	1716213469904	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213470906	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213470906	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991	1716213470906	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213471908	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213471908	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0973	1716213471908	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213472910	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213472910	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0973	1716213472910	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213473912	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213473912	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0973	1716213473912	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213474914	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213474914	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0993000000000004	1716213474914	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213474929	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213475916	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213475916	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0993000000000004	1716213475916	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213475943	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213476918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213476918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0993000000000004	1716213476918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213476940	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213477920	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213477920	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1001	1716213477920	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213477934	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213478922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213478922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1001	1716213478922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213478943	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213479925	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213479925	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1001	1716213479925	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213479947	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213480927	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213480927	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.098	1716213480927	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213480948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213481930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213481930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.098	1716213481930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213481956	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213482932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213482932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.098	1716213482932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213483934	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213483934	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0984000000000003	1716213483934	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213484936	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213484936	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0984000000000003	1716213484936	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213485938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213485938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0984000000000003	1716213485938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213486941	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213486941	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991999999999997	1716213486941	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213487943	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213487943	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991999999999997	1716213487943	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213488945	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213488945	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991999999999997	1716213488945	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213489947	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213489947	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0998	1716213489947	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213490948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213490948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0998	1716213490948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213491950	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213491950	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0998	1716213491950	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213492952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213492952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995	1716213492952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213493954	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213493954	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995	1716213493954	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213494956	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213494956	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995	1716213494956	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213495958	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213495958	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991	1716213495958	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213496960	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213496960	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991	1716213496960	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213497962	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213497962	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991	1716213497962	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213498964	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213498964	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0999	1716213498964	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213499966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213499966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0999	1716213499966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213500968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213500968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0999	1716213500968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213501970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213501970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0961999999999996	1716213501970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213502972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213502972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0961999999999996	1716213502972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213503974	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213503974	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213482951	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213483955	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213484961	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213485963	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213486963	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213487957	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213488968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213489967	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213490970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213491967	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213492972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213493973	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213494978	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213495980	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213496983	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213497985	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213498987	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213499989	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213500990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213501991	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213502998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213503998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213504997	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213505999	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213506999	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213508000	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213509003	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213510005	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213510999	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213512011	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213513010	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213514012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213515017	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213516018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213517019	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213518023	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213519023	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213520025	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213521020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213522030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213523031	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213524027	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213525036	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213526031	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213527040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213528043	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213529036	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213530045	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213531049	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213532051	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213533051	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213534054	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213535055	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213536061	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213537059	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213538052	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213539065	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213540065	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213541058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213542074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213543062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213544073	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213545075	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213546076	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213547077	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0961999999999996	1716213503974	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213504975	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213504975	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991999999999997	1716213504975	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213505977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213505977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991999999999997	1716213505977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213506978	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213506978	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991999999999997	1716213506978	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213507980	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213507980	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0961999999999996	1716213507980	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213508982	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213508982	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0961999999999996	1716213508982	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213509984	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213509984	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0961999999999996	1716213509984	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213510986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213510986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0975	1716213510986	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213511988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213511988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0975	1716213511988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213512990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213512990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0975	1716213512990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213513991	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213513991	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991	1716213513991	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213514995	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213514995	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991	1716213514995	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213515997	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213515997	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991	1716213515997	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213516998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213516998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1009	1716213516998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213518000	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213518000	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1009	1716213518000	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213519002	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213519002	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1009	1716213519002	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213520004	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213520004	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1009	1716213520004	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213521006	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213521006	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1009	1716213521006	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213522008	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213522008	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1009	1716213522008	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213523010	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213523010	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1015	1716213523010	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213524012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213524012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1015	1716213524012	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213525014	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213525014	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1015	1716213525014	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213526016	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213526016	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0972	1716213526016	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213527018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213527018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0972	1716213527018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213528020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213528020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0972	1716213528020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213529022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213529022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0979	1716213529022	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213530024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213530024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0979	1716213530024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213531026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213531026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0979	1716213531026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213532028	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213532028	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.099	1716213532028	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213533030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213533030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.099	1716213533030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213534031	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213534031	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.099	1716213534031	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213535033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213535033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1008	1716213535033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213536035	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213536035	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1008	1716213536035	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213537037	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213537037	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1008	1716213537037	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213538038	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213538038	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0988	1716213538038	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213539040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213539040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0988	1716213539040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213540042	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213540042	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0988	1716213540042	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213541044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213541044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995	1716213541044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213542046	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213542046	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995	1716213542046	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213543048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213543048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995	1716213543048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213544051	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213544051	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1	1716213544051	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213545053	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213545053	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1	1716213545053	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213546055	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213546055	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1	1716213546055	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213547056	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213547056	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0997	1716213547056	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213548058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213548058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0997	1716213548058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213549060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213549060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0997	1716213549060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213550062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213550062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0953000000000004	1716213550062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213551064	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213551064	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0953000000000004	1716213551064	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213552066	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213552066	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0953000000000004	1716213552066	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213553068	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213553068	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0794	1716213553068	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213554070	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213554070	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0794	1716213554070	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213555072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213555072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0794	1716213555072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213556074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213556074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0789	1716213556074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213557076	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7	1716213557076	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0789	1716213557076	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213558078	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.8	1716213558078	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0789	1716213558078	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213559081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213559081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.081	1716213559081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213560083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213560083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.081	1716213560083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213561085	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213561085	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.081	1716213561085	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213562087	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213562087	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0751	1716213562087	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213563088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213563088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0751	1716213563088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213564090	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213564090	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0751	1716213564090	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213565092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213565092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0810999999999997	1716213565092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213566094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213566094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0810999999999997	1716213566094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213567096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213567096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0810999999999997	1716213567096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213568098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213568098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213548080	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213549083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213550086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213551087	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213552087	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213553083	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213554093	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213555094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213556088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213557097	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213558092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213559102	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213560099	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213561107	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213562108	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213563102	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213564111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213565113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213566115	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213567120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213568111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213569124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213570125	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213571124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213572131	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213573124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213574131	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213575134	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213576136	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213577139	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213578133	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213579137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213580144	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213581150	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213582148	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213583149	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213584143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213585152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213586157	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213587158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213588161	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213589154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213590157	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213591164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213592168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213593171	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213594173	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213595177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213596179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213597179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213598181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213599178	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213600185	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213601187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213602191	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213603192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213604187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213605197	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213606196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213607198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213608200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213609200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213610207	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213611207	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213612209	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0841	1716213568098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213569102	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213569102	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0841	1716213569102	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213570104	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213570104	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0841	1716213570104	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213571106	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213571106	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0837	1716213571106	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213572107	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213572107	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0837	1716213572107	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213573108	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213573108	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0837	1716213573108	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213574110	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213574110	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0816	1716213574110	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213575112	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213575112	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0816	1716213575112	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213576114	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213576114	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0816	1716213576114	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213577116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213577116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0826	1716213577116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213578118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213578118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0826	1716213578118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213579120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213579120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0826	1716213579120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213580122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213580122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0835	1716213580122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213581124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213581124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0835	1716213581124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213582126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213582126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0835	1716213582126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213583128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213583128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0859	1716213583128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213584130	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716213584130	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0859	1716213584130	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213585132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213585132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0859	1716213585132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213586134	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213586134	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856	1716213586134	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213587136	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213587136	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856	1716213587136	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213588138	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213588138	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856	1716213588138	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213589140	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213589140	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0855	1716213589140	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213590141	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213590141	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0855	1716213590141	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213591143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213591143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0855	1716213591143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213592147	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213592147	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.082	1716213592147	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213593149	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213593149	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.082	1716213593149	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213594152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213594152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.082	1716213594152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213595154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213595154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0836	1716213595154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213596156	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213596156	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0836	1716213596156	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213597158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213597158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0836	1716213597158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213598160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213598160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856	1716213598160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213599162	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213599162	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856	1716213599162	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213600164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213600164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856	1716213600164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213601166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213601166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856999999999997	1716213601166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213602168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213602168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856999999999997	1716213602168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213603170	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213603170	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856999999999997	1716213603170	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213604171	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213604171	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856999999999997	1716213604171	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213605173	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213605173	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856999999999997	1716213605173	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213606175	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213606175	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856999999999997	1716213606175	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213607177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213607177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0868	1716213607177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213608179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213608179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0868	1716213608179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213609181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213609181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0868	1716213609181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213610183	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213610183	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0865	1716213610183	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213611186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213611186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0865	1716213611186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213612188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213612188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0865	1716213612188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213613190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213613190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0833000000000004	1716213613190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	99	1716213614192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213614192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0833000000000004	1716213614192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213615194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213615194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0833000000000004	1716213615194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213616196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213616196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0858000000000003	1716213616196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213617198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213617198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0858000000000003	1716213617198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213618200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213618200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0858000000000003	1716213618200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213619202	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213619202	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0858000000000003	1716213619202	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213620204	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213620204	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0858000000000003	1716213620204	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213621206	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213621206	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0858000000000003	1716213621206	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213622208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213622208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0871	1716213622208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213623209	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213623209	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0871	1716213623209	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213624211	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213624211	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0871	1716213624211	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213625213	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213625213	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0798	1716213625213	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213626215	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213626215	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0798	1716213626215	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213627217	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213627217	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0798	1716213627217	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213628219	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213628219	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0823	1716213628219	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213629221	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213629221	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0823	1716213629221	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213630223	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213630223	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0823	1716213630223	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213631224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213631224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0844	1716213631224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213632228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213632228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213613207	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213614215	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213615215	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213616217	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213617221	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213618214	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213619224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213620218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213621228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213622229	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213623223	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213624226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213625234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213626238	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213627239	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213628233	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213629245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213630247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213631245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213632252	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213633244	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213634247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213635249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213636250	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213637259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213638260	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213639259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213640265	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213641267	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213642268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213643267	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213644272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213645276	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213646278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213647278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213648274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213649286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213650285	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213651285	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213652287	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213653283	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213654283	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213655293	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213656294	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213657297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213658301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213659292	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213660301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213661303	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213662298	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213663308	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213664302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213665311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213666314	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213667314	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213668316	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213669320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213670319	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213671321	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213672324	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213673318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213674329	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213675329	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213676331	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213677325	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0844	1716213632228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213633230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213633230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0844	1716213633230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213634232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213634232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0795	1716213634232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213635234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213635234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0795	1716213635234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213636236	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213636236	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0795	1716213636236	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213637238	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213637238	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0836	1716213637238	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213638240	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213638240	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0836	1716213638240	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213639241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213639241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0836	1716213639241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213640243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213640243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0858000000000003	1716213640243	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213641245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213641245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0858000000000003	1716213641245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213642247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213642247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0858000000000003	1716213642247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213643249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213643249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0873000000000004	1716213643249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213644251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213644251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0873000000000004	1716213644251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213645253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213645253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0873000000000004	1716213645253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213646255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213646255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.087	1716213646255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213647257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213647257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.087	1716213647257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213648259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213648259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.087	1716213648259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213649260	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213649260	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0873000000000004	1716213649260	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213650262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213650262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0873000000000004	1716213650262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213651264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213651264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0873000000000004	1716213651264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213652266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213652266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.086	1716213652266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213653268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213653268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.086	1716213653268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213654270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213654270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.086	1716213654270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213655272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213655272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0864000000000003	1716213655272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213656274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213656274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0864000000000003	1716213656274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213657275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213657275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0864000000000003	1716213657275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213658277	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213658277	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856	1716213658277	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213659278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213659278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856	1716213659278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213660280	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213660280	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856	1716213660280	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213661282	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213661282	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856999999999997	1716213661282	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213662284	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213662284	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856999999999997	1716213662284	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213663286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213663286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0856999999999997	1716213663286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213664288	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213664288	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0881999999999996	1716213664288	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213665290	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213665290	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0881999999999996	1716213665290	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213666292	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213666292	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0881999999999996	1716213666292	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213667294	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213667294	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0892	1716213667294	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213668296	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213668296	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0892	1716213668296	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213669297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213669297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0892	1716213669297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213670299	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213670299	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0902	1716213670299	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213671300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213671300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0902	1716213671300	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213672302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213672302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0902	1716213672302	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213673304	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213673304	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0907	1716213673304	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213674306	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213674306	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0907	1716213674306	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213675308	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213675308	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0907	1716213675308	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213676310	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213676310	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0908	1716213676310	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213677312	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213677312	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0908	1716213677312	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213678314	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213678314	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0908	1716213678314	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213679316	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213679316	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.09	1716213679316	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213680319	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213680319	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.09	1716213680319	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213681321	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213681321	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.09	1716213681321	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213682323	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213682323	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0894	1716213682323	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213683325	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213683325	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0894	1716213683325	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213684327	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213684327	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0894	1716213684327	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213685328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213685328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0874	1716213685328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213686330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213686330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0874	1716213686330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213687332	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213687332	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0874	1716213687332	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213688334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213688334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0877	1716213688334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213689335	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213689335	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0877	1716213689335	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213690337	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716213690337	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0877	1716213690337	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213691338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213691338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0904000000000003	1716213691338	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213692340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213692340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0904000000000003	1716213692340	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213693342	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213693342	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0904000000000003	1716213693342	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213694344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213694344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0799000000000003	1716213694344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213695346	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213695346	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0799000000000003	1716213695346	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213696348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213696348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213678329	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213679337	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213680345	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213681348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213682347	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213683355	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213684347	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213685351	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213686355	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213687354	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213688351	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213689358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213690362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213691360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213692354	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213693357	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213694368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213695369	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213696361	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213697372	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213698374	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213699375	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213700377	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213701385	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213702381	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213703376	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213704388	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213705389	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213706394	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213707393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213708388	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213709397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213710401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213711403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213712400	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213713404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214195320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214196330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214197335	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214198327	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214199339	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214200344	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214201341	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214202345	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214203336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214204349	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214205348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214206342	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214207351	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214208349	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214209358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214210360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214211363	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214212365	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214213368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214214361	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214215373	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214216372	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214217374	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214218371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214219372	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214220380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214221383	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214222383	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214223384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0799000000000003	1716213696348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213697350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213697350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.085	1716213697350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213698352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213698352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.085	1716213698352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213699354	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213699354	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.085	1716213699354	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213700356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213700356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0871999999999997	1716213700356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213701358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213701358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0871999999999997	1716213701358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213702360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213702360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0871999999999997	1716213702360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213703362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213703362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0893	1716213703362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213704364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213704364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0893	1716213704364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213705367	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213705367	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0893	1716213705367	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213706369	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213706369	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0829	1716213706369	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213707371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	8.9	1716213707371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0829	1716213707371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213708373	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.1	1716213708373	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0829	1716213708373	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213709375	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213709375	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0863	1716213709375	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213710377	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213710377	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0863	1716213710377	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213711378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213711378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0863	1716213711378	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213712380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213712380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0913000000000004	1716213712380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213713382	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213713382	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0913000000000004	1716213713382	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213714384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213714384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0913000000000004	1716213714384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213714398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213715386	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213715386	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0915	1716213715386	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213715407	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213716388	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213716388	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0915	1716213716388	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213716414	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213717390	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213717390	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0915	1716213717390	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213718392	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213718392	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0904000000000003	1716213718392	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213719393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213719393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0904000000000003	1716213719393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213720395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213720395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0904000000000003	1716213720395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213721399	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213721399	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0903	1716213721399	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213722401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213722401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0903	1716213722401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213723403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213723403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0903	1716213723403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213724405	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213724405	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0895	1716213724405	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213725407	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213725407	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0895	1716213725407	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213726408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213726408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0895	1716213726408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213727411	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213727411	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0893	1716213727411	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213728413	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213728413	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0893	1716213728413	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213729415	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213729415	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0893	1716213729415	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213730417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213730417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.093	1716213730417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213731419	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213731419	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.093	1716213731419	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213732420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213732420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.093	1716213732420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213733422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213733422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0935	1716213733422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213734424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213734424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0935	1716213734424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213735426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213735426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0935	1716213735426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213736428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213736428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0943	1716213736428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213737430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213737430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0943	1716213737430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213738433	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213717412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213718408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213719418	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213720416	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213721420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213722417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213723417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213724417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213725421	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213726424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213727433	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213728437	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213729436	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213730438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213731440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213732441	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213733437	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213734445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213735448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213736449	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213737445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213738447	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213739456	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213740459	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213741462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213742463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213743457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213744466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213745469	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213746470	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213747474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213748466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213749475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213750476	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213751480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213752479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213753474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213754485	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213755487	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213756480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213757489	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213758492	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213759493	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213760495	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213761497	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213762498	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213763493	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213764502	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213765504	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213766505	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213767507	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213768504	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213769510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213770514	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213771516	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213772520	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213773519	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213774513	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213775521	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213776525	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213777526	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213778528	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213779530	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213780533	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213781533	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213738433	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0943	1716213738433	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213739434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213739434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0955	1716213739434	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213740438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213740438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0955	1716213740438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213741440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213741440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0955	1716213741440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213742442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213742442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0942	1716213742442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213743443	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213743443	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0942	1716213743443	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213744445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213744445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0942	1716213744445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213745447	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213745447	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0961999999999996	1716213745447	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213746448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213746448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0961999999999996	1716213746448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213747450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213747450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0961999999999996	1716213747450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213748452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213748452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0946	1716213748452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213749454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213749454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0946	1716213749454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213750455	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213750455	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0946	1716213750455	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213751457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213751457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0917	1716213751457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213752458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213752458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0917	1716213752458	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213753460	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213753460	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0917	1716213753460	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213754462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213754462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0913000000000004	1716213754462	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213755464	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213755464	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0913000000000004	1716213755464	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213756466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213756466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0913000000000004	1716213756466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213757468	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213757468	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0934	1716213757468	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213758470	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213758470	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0934	1716213758470	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213759472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213759472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0934	1716213759472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213760474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213760474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0919	1716213760474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213761475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213761475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0919	1716213761475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213762477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213762477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0919	1716213762477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213763478	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213763478	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0928	1716213763478	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	105	1716213764480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213764480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0928	1716213764480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213765482	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213765482	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0928	1716213765482	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213766484	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213766484	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0844	1716213766484	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213767486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213767486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0844	1716213767486	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213768488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213768488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0844	1716213768488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213769490	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213769490	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0888	1716213769490	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213770492	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213770492	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0888	1716213770492	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213771494	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213771494	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0888	1716213771494	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213772496	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213772496	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0923000000000003	1716213772496	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213773498	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213773498	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0923000000000003	1716213773498	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213774499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213774499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0923000000000003	1716213774499	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213775500	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213775500	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0917	1716213775500	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213776502	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213776502	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0917	1716213776502	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213777506	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213777506	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0917	1716213777506	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213778507	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213778507	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0874	1716213778507	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213779508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213779508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0874	1716213779508	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213780510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213780510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0874	1716213780510	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213781512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213781512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.089	1716213781512	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213782514	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213782514	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.089	1716213782514	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213783516	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213783516	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.089	1716213783516	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213784518	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213784518	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0898000000000003	1716213784518	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213785520	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213785520	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0898000000000003	1716213785520	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213786522	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213786522	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0898000000000003	1716213786522	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213787524	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213787524	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0927	1716213787524	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213788526	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213788526	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0927	1716213788526	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213789528	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213789528	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0927	1716213789528	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213790530	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213790530	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0921999999999996	1716213790530	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213791531	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213791531	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0921999999999996	1716213791531	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213792533	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213792533	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0921999999999996	1716213792533	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213793535	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213793535	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0939	1716213793535	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213794537	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213794537	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0939	1716213794537	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213795538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213795538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0939	1716213795538	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213796540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213796540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0913000000000004	1716213796540	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213797542	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213797542	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0913000000000004	1716213797542	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213798544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213798544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0913000000000004	1716213798544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213799546	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213799546	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.094	1716213799546	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213800548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213800548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.094	1716213800548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213801550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213801550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.094	1716213801550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213802551	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213782535	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213783530	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213784539	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213785541	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213786534	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213787544	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213788548	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213789549	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213790550	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213791556	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213792555	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213793549	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213794559	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213795560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213796561	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213797565	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213798560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213799570	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213800571	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213801572	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213802564	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213803574	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213804576	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213805578	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213806580	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213807581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213808583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213809585	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213810589	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213811594	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213812593	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213813595	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213814599	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213815598	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213816604	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213817596	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213818603	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213819605	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213820609	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213821611	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213822604	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213823613	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213824618	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213825619	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213826620	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213827616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213828616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213829625	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213830629	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213831630	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213832625	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213833634	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213834635	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213835639	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213836641	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213837636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213838642	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213839644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213840646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213841649	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213842644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213843650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213844654	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213845655	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213846658	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213802551	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0945	1716213802551	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213803553	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213803553	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0945	1716213803553	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213804555	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213804555	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0945	1716213804555	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213805557	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.4	1716213805557	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.096	1716213805557	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213806558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213806558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.096	1716213806558	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213807560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213807560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.096	1716213807560	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213808562	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213808562	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0961	1716213808562	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213809564	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213809564	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0961	1716213809564	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213810566	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213810566	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0961	1716213810566	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213811568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213811568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213811568	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213812571	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213812571	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213812571	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213813573	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213813573	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951	1716213813573	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213814575	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213814575	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951999999999997	1716213814575	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213815577	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213815577	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951999999999997	1716213815577	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213816579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213816579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951999999999997	1716213816579	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213817581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213817581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0907	1716213817581	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213818583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213818583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0907	1716213818583	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213819584	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213819584	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0907	1716213819584	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213820586	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213820586	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0941	1716213820586	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213821588	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213821588	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0941	1716213821588	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213822590	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213822590	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0941	1716213822590	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213823592	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213823592	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951999999999997	1716213823592	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213824594	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213824594	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951999999999997	1716213824594	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213825596	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213825596	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0951999999999997	1716213825596	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213826599	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213826599	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0965	1716213826599	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	105	1716213827601	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213827601	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0965	1716213827601	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	99	1716213828603	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213828603	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0965	1716213828603	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213829605	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213829605	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0974	1716213829605	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213830606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213830606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0974	1716213830606	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213831608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213831608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0974	1716213831608	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213832610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213832610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0979	1716213832610	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213833612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213833612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0979	1716213833612	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213834614	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213834614	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0979	1716213834614	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213835616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213835616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0987	1716213835616	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213836617	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213836617	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0987	1716213836617	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213837620	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213837620	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0987	1716213837620	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213838621	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213838621	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0997	1716213838621	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213839623	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213839623	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0997	1716213839623	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213840625	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213840625	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0997	1716213840625	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213841627	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213841627	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0969	1716213841627	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213842629	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213842629	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0969	1716213842629	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213843631	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213843631	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0969	1716213843631	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213844632	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213844632	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0978000000000003	1716213844632	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213845634	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213845634	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0978000000000003	1716213845634	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213846636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213846636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0978000000000003	1716213846636	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213847638	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213847638	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0967	1716213847638	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213848640	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213848640	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0967	1716213848640	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213849642	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213849642	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0967	1716213849642	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213850644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213850644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0987	1716213850644	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213851646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213851646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0987	1716213851646	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213852648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213852648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0987	1716213852648	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213853650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213853650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1007	1716213853650	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213854652	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213854652	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1007	1716213854652	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213855653	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213855653	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1007	1716213855653	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213856655	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213856655	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.099	1716213856655	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213857657	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213857657	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.099	1716213857657	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213858659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213858659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.099	1716213858659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213859660	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213859660	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0984000000000003	1716213859660	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213860662	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213860662	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0984000000000003	1716213860662	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213861664	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9	1716213861664	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0984000000000003	1716213861664	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213862667	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.199999999999999	1716213862667	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0822	1716213862667	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213863668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213863668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0822	1716213863668	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213864670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213864670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0822	1716213864670	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213865672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213865672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0999	1716213865672	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213866674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213847653	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213848661	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213849663	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213850659	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213851667	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213852669	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213853664	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213854675	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213855677	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213856678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213857679	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213858675	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213859684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213860688	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213861687	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213862682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213863694	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213864691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213865693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213866696	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213867697	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213868691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213869695	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213870696	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213871705	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213872707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213873702	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213874712	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213875714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213876714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213877716	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213878718	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213879720	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213880721	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213881726	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213882724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213883720	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213884732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213885732	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213886734	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213887735	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213888730	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213889743	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213890743	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213891746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213892746	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213893747	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213894749	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213895749	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213896755	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213897753	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213898750	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213899758	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213900761	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213901762	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213902765	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213903760	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213904769	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213905770	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213906770	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213907765	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213908776	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213909777	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213910781	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213911781	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213866674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0999	1716213866674	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213867676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213867676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0999	1716213867676	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213868678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213868678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0985	1716213868678	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213869680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213869680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0985	1716213869680	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213870682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213870682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0985	1716213870682	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213871684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213871684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0993000000000004	1716213871684	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213872685	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213872685	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0993000000000004	1716213872685	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213873687	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213873687	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0993000000000004	1716213873687	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213874689	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213874689	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995	1716213874689	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213875691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213875691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995	1716213875691	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213876693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213876693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995	1716213876693	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213877695	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213877695	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1021	1716213877695	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213878697	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213878697	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1021	1716213878697	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213879698	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213879698	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1021	1716213879698	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213880700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213880700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1013	1716213880700	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213881702	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213881702	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1013	1716213881702	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213882703	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213882703	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1013	1716213882703	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213883707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213883707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0963000000000003	1716213883707	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213884709	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213884709	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0963000000000003	1716213884709	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213885711	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213885711	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0963000000000003	1716213885711	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213886712	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213886712	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0983	1716213886712	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213887714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213887714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0983	1716213887714	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213888716	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.1	1716213888716	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0983	1716213888716	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213889718	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213889718	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1005	1716213889718	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213890720	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213890720	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1005	1716213890720	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213891722	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213891722	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1005	1716213891722	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213892724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213892724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1004	1716213892724	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213893726	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213893726	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1004	1716213893726	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213894727	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213894727	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1004	1716213894727	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213895728	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.500000000000002	1716213895728	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1006	1716213895728	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213896731	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213896731	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1006	1716213896731	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213897733	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213897733	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1006	1716213897733	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213898735	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213898735	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0988	1716213898735	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213899737	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213899737	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0988	1716213899737	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213900738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213900738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0988	1716213900738	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213901740	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213901740	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1004	1716213901740	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213902743	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213902743	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1004	1716213902743	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213903745	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213903745	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1004	1716213903745	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213904747	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213904747	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1003000000000003	1716213904747	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213905749	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213905749	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1003000000000003	1716213905749	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213906750	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213906750	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1003000000000003	1716213906750	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213907752	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213907752	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1001	1716213907752	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213908754	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213908754	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1001	1716213908754	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213909756	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213909756	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1001	1716213909756	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213910758	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213910758	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1028000000000002	1716213910758	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213911760	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213911760	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1028000000000002	1716213911760	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213912762	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213912762	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1028000000000002	1716213912762	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213913764	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213913764	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1031999999999997	1716213913764	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213914766	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213914766	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1031999999999997	1716213914766	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213915767	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213915767	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1031999999999997	1716213915767	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213916769	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213916769	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1024000000000003	1716213916769	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213917771	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213917771	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1024000000000003	1716213917771	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213918773	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.1	1716213918773	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1024000000000003	1716213918773	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213919775	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213919775	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1019	1716213919775	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213920777	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213920777	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1019	1716213920777	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213921779	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213921779	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1019	1716213921779	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213922781	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213922781	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995999999999997	1716213922781	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213923783	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213923783	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995999999999997	1716213923783	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213924785	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213924785	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995999999999997	1716213924785	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213925787	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213925787	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991999999999997	1716213925787	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213926790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213926790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991999999999997	1716213926790	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213927792	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213927792	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991999999999997	1716213927792	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213928796	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213928796	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991	1716213928796	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213929797	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213929797	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991	1716213929797	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213930798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213912776	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213913784	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213914791	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213915791	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213916789	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213917785	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213918794	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213919797	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213920799	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213921802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213922795	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213923806	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213924808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213925808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213926811	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213927808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213928817	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213929819	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213930818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213931824	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213932816	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213933825	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213934829	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213935829	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213936832	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213937828	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213938835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213939838	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213940839	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213941840	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213942843	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213943837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213944846	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213945850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213946852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213947853	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213948847	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213949859	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213950858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213951860	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213952854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213953864	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214206328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214206328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.132	1716214206328	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214207330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214207330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.132	1716214207330	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214208334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214208334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1305	1716214208334	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214209336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214209336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1305	1716214209336	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214210339	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214210339	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1305	1716214210339	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214211341	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214211341	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1355999999999997	1716214211341	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716214212343	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214212343	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1355999999999997	1716214212343	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214213345	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214213345	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213930798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0991	1716213930798	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213931800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213931800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1018000000000003	1716213931800	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213932802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213932802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1018000000000003	1716213932802	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213933804	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213933804	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1018000000000003	1716213933804	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213934806	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213934806	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1033000000000004	1716213934806	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213935808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213935808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1033000000000004	1716213935808	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213936810	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213936810	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1033000000000004	1716213936810	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213937812	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213937812	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1023	1716213937812	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213938814	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213938814	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1023	1716213938814	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213939816	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213939816	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1023	1716213939816	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213940818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213940818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1013	1716213940818	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213941820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213941820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1013	1716213941820	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213942821	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213942821	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1013	1716213942821	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213943823	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213943823	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1024000000000003	1716213943823	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213944825	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213944825	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1024000000000003	1716213944825	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213945827	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213945827	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1024000000000003	1716213945827	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213946829	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213946829	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1031	1716213946829	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213947831	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213947831	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1031	1716213947831	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213948833	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213948833	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1031	1716213948833	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213949835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213949835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1031	1716213949835	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213950837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213950837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1031	1716213950837	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213951838	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213951838	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1031	1716213951838	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213952840	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213952840	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995	1716213952840	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213953842	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213953842	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995	1716213953842	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213954845	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213954845	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0995	1716213954845	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213954868	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213955846	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213955846	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0988	1716213955846	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213955867	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213956848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213956848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0988	1716213956848	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213956872	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213957850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213957850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.0988	1716213957850	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213957868	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213958852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213958852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.099	1716213958852	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213958873	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213959854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213959854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.099	1716213959854	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213959877	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213960856	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213960856	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.099	1716213960856	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213960869	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213961858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213961858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1024000000000003	1716213961858	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213961882	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213962861	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213962861	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1024000000000003	1716213962861	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213962878	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213963863	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213963863	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1024000000000003	1716213963863	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213963884	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213964865	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213964865	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1023	1716213964865	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213964885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213965867	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213965867	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1023	1716213965867	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213965892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213966868	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213966868	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1023	1716213966868	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213966889	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213967870	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213967870	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.102	1716213967870	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213967885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213968872	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213968872	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.102	1716213968872	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213969874	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213969874	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.102	1716213969874	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213970876	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213970876	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1043000000000003	1716213970876	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213971878	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213971878	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1043000000000003	1716213971878	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213972880	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213972880	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1043000000000003	1716213972880	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213973883	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213973883	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1039	1716213973883	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213974885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.1	1716213974885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1039	1716213974885	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213975887	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213975887	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1039	1716213975887	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213976888	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213976888	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1048	1716213976888	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716213977890	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213977890	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1048	1716213977890	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213978892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213978892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1048	1716213978892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213979894	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213979894	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.103	1716213979894	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213980896	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213980896	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.103	1716213980896	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213981898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213981898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.103	1716213981898	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213982900	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.700000000000001	1716213982900	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1044	1716213982900	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213983902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213983902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1044	1716213983902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213984904	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213984904	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1044	1716213984904	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213985906	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213985906	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.106	1716213985906	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213986907	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213986907	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.106	1716213986907	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213987909	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213987909	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.106	1716213987909	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213988911	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213988911	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1056999999999997	1716213988911	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213989913	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213989913	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213968892	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213969895	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213970899	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213971902	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213972901	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213973905	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213974909	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213975909	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213976912	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213977907	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213978915	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213979908	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213980917	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213981919	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213982926	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213983921	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213984930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213985926	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213986930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213987931	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213988927	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213989937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213990928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213991939	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213992941	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213993936	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213994945	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213995945	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213996950	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213997950	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213998948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716213999955	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214000957	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214001962	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214002959	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214003953	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214004967	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214005966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214006968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214007969	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214008964	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214009966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214010975	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214011977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214012979	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214013983	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214014988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214015977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214016989	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214017990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214018987	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214019990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214020988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214021996	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214022999	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214023994	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214024995	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214026005	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214027009	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214028009	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214029004	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214030004	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214031015	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214032016	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214033017	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1056999999999997	1716213989913	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213990915	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213990915	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1056999999999997	1716213990915	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213991917	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213991917	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.108	1716213991917	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213992918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213992918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.108	1716213992918	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213993921	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213993921	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.108	1716213993921	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213994922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213994922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1028000000000002	1716213994922	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716213995924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213995924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1028000000000002	1716213995924	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213996928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.100000000000001	1716213996928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1028000000000002	1716213996928	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716213997930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.300000000000001	1716213997930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.105	1716213997930	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716213998932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716213998932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.105	1716213998932	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716213999933	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716213999933	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.105	1716213999933	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214000935	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214000935	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1117	1716214000935	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214001937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214001937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1117	1716214001937	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214002938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214002938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1117	1716214002938	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214003940	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214003940	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1118	1716214003940	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214004942	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214004942	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1118	1716214004942	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214005944	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214005944	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1118	1716214005944	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214006946	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214006946	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1118	1716214006946	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214007948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214007948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1118	1716214007948	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214008950	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214008950	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1118	1716214008950	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214009952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214009952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1107	1716214009952	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214010954	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214010954	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1107	1716214010954	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214011956	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214011956	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1107	1716214011956	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214012958	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214012958	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.111	1716214012958	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214013960	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214013960	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.111	1716214013960	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716214014962	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214014962	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.111	1716214014962	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214015964	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214015964	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1071999999999997	1716214015964	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214016966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214016966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1071999999999997	1716214016966	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214017968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214017968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1071999999999997	1716214017968	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214018970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214018970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1102	1716214018970	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214019972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214019972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1102	1716214019972	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214020974	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214020974	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1102	1716214020974	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214021976	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214021976	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1102	1716214021976	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214022977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214022977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1102	1716214022977	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214023979	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214023979	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1102	1716214023979	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214024981	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214024981	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1111	1716214024981	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214025983	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214025983	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1111	1716214025983	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214026985	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214026985	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1111	1716214026985	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214027987	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214027987	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1121999999999996	1716214027987	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214028988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214028988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1121999999999996	1716214028988	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214029990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214029990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1121999999999996	1716214029990	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214030992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214030992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1168	1716214030992	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214031994	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214031994	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1168	1716214031994	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214032996	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214032996	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1168	1716214032996	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214033998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214033998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1170999999999998	1716214033998	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214035000	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214035000	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1170999999999998	1716214035000	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214036002	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214036002	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1170999999999998	1716214036002	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214037003	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214037003	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1164	1716214037003	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214038005	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214038005	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1164	1716214038005	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214039007	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214039007	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1164	1716214039007	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214040009	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214040009	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1118	1716214040009	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214041011	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214041011	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1118	1716214041011	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214042013	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.600000000000001	1716214042013	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1118	1716214042013	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214043015	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214043015	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1125	1716214043015	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214044017	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214044017	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1125	1716214044017	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214045018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214045018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1125	1716214045018	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214046020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214046020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1114	1716214046020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214047024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214047024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1114	1716214047024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214048026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214048026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1114	1716214048026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214049027	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214049027	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1145	1716214049027	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214050030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214050030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1145	1716214050030	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214051033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214051033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1145	1716214051033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214052036	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214052036	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1138000000000003	1716214052036	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214053037	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214053037	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1138000000000003	1716214053037	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214054039	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214054039	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214034020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214035013	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214036026	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214037024	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214038020	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214039031	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214040023	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214041033	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214042035	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214043035	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214044040	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214045034	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214046041	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214047044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214048041	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214049044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214050045	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214051055	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214052058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214053062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214054054	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214055054	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214056064	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214057066	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214058061	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214059062	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214060063	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214061071	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214062076	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214063071	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214064081	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214065073	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214066074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214067084	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214068080	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214069088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214070090	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214071091	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214072093	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214073095	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214074098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214075100	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214076105	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214077106	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214078099	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214079107	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214080110	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214081110	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214082113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214083108	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214084117	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214085118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214086120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214087123	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214088124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214089120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214090130	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214091130	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214092132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214093132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214094135	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214095138	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214096141	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214097133	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214098137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1138000000000003	1716214054039	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214055041	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214055041	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1142	1716214055041	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716214056043	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214056043	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1142	1716214056043	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214057044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214057044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1142	1716214057044	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214058046	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214058046	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1128	1716214058046	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214059048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214059048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1128	1716214059048	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214060050	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214060050	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1128	1716214060050	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214061052	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214061052	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1136	1716214061052	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716214062054	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214062054	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1136	1716214062054	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214063056	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214063056	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1136	1716214063056	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214064058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214064058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1176	1716214064058	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214065060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214065060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1176	1716214065060	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716214066061	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214066061	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1176	1716214066061	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214067063	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214067063	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1208	1716214067063	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214068065	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214068065	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1208	1716214068065	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214069067	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214069067	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1208	1716214069067	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214070068	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214070068	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1231999999999998	1716214070068	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214071070	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214071070	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1231999999999998	1716214071070	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214072072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214072072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1231999999999998	1716214072072	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214073074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214073074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.127	1716214073074	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214074076	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214074076	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.127	1716214074076	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214075078	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214075078	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.127	1716214075078	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214076080	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214076080	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1281	1716214076080	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214077082	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214077082	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1281	1716214077082	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214078084	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214078084	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1281	1716214078084	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214079086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214079086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1284	1716214079086	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214080088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214080088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1284	1716214080088	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214081090	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214081090	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1284	1716214081090	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214082092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214082092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1139	1716214082092	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214083094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214083094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1139	1716214083094	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716214084096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214084096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1139	1716214084096	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214085098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214085098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1253	1716214085098	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214086100	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214086100	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1253	1716214086100	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214087101	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214087101	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1253	1716214087101	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214088103	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214088103	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1269	1716214088103	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214089105	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214089105	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1269	1716214089105	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214090107	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214090107	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1269	1716214090107	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214091109	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214091109	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1290999999999998	1716214091109	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214092111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214092111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1290999999999998	1716214092111	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214093113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214093113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1290999999999998	1716214093113	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214094115	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214094115	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1283000000000003	1716214094115	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214095116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214095116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1283000000000003	1716214095116	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214096118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214096118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1283000000000003	1716214096118	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214097120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214097120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1281999999999996	1716214097120	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716214098122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214098122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1281999999999996	1716214098122	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214099124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214099124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1281999999999996	1716214099124	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214100126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214100126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1267	1716214100126	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214101128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214101128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1267	1716214101128	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214102131	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214102131	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1267	1716214102131	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214103132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214103132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1261	1716214103132	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214104134	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214104134	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1261	1716214104134	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214105135	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214105135	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1261	1716214105135	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214106137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214106137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1256	1716214106137	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214107139	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214107139	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1256	1716214107139	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214108141	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214108141	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1256	1716214108141	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214109143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214109143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1255	1716214109143	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214110145	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214110145	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1255	1716214110145	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214111147	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214111147	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1255	1716214111147	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214112148	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214112148	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1269	1716214112148	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214113150	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214113150	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1269	1716214113150	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214114152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214114152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1269	1716214114152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214115154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214115154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1268000000000002	1716214115154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214116158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214116158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1268000000000002	1716214116158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214117160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214117160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1268000000000002	1716214117160	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214118161	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214118161	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214099144	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214100146	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214101148	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214102153	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214103152	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214104158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214105155	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214106154	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214107157	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214108159	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214109158	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214110165	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214111169	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214112172	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214113177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214114173	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214115175	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214116180	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214117173	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214118183	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214119186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214120187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214121194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214122189	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214123187	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214124195	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214125199	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214126198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214127200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214128195	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214129196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214130206	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214131209	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214132211	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214133204	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214134214	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214135217	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214136217	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214137221	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214138220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214139216	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214140228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214141226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214142219	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214143229	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214144225	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214145232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214146227	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214147236	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214148240	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214149241	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214150245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214151244	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214152245	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214153240	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214154249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214155251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214156254	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214157250	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214158250	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214159259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214160259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214161263	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214162262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214163265	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1295	1716214118161	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214119164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214119164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1295	1716214119164	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214120166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214120166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1295	1716214120166	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214121168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214121168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1284	1716214121168	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214122170	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214122170	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1284	1716214122170	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214123172	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214123172	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1284	1716214123172	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214124174	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214124174	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1290999999999998	1716214124174	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214125176	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214125176	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1290999999999998	1716214125176	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214126177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214126177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1290999999999998	1716214126177	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214127179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214127179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1121999999999996	1716214127179	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214128181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214128181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1121999999999996	1716214128181	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	99	1716214129182	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214129182	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1121999999999996	1716214129182	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214130184	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214130184	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1271999999999998	1716214130184	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214131186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214131186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1271999999999998	1716214131186	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214132188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214132188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1271999999999998	1716214132188	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214133190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214133190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1264000000000003	1716214133190	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214134192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214134192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1264000000000003	1716214134192	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214135194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214135194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1264000000000003	1716214135194	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214136196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.4	1716214136196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1279	1716214136196	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214137197	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.200000000000001	1716214137197	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1279	1716214137197	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214138198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214138198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1279	1716214138198	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214139200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214139200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1292	1716214139200	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716214140202	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214140202	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1292	1716214140202	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214141204	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214141204	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1292	1716214141204	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214142206	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214142206	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1285	1716214142206	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214143208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214143208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1285	1716214143208	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214144210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214144210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1285	1716214144210	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214145212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214145212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1294	1716214145212	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214146213	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.700000000000001	1716214146213	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1294	1716214146213	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214147215	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214147215	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1294	1716214147215	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214148217	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214148217	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1286	1716214148217	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214149218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214149218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1286	1716214149218	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214150220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214150220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1286	1716214150220	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214151222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214151222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1245	1716214151222	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214152224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214152224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1245	1716214152224	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214153226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214153226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1245	1716214153226	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214154228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214154228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1277	1716214154228	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214155230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214155230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1277	1716214155230	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214156232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214156232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1277	1716214156232	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214157234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214157234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1304000000000003	1716214157234	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214158235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214158235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1304000000000003	1716214158235	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214159237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214159237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1304000000000003	1716214159237	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214160238	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214160238	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1299	1716214160238	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214161240	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214161240	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1299	1716214161240	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214162242	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214162242	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1299	1716214162242	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214163244	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214163244	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1303	1716214163244	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214164247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214164247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1303	1716214164247	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214165249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214165249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1303	1716214165249	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214166251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214166251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1302	1716214166251	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214167253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214167253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1302	1716214167253	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214168255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214168255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1302	1716214168255	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214169257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214169257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.132	1716214169257	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214170259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214170259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.132	1716214170259	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214171261	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214171261	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.132	1716214171261	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214172262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214172262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1318	1716214172262	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214173264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214173264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1318	1716214173264	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214174266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214174266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1318	1716214174266	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214175268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214175268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1292	1716214175268	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214176270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214176270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1292	1716214176270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214177272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214177272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1292	1716214177272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214178275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214178275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1306	1716214178275	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214179276	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214179276	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1306	1716214179276	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214180278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214180278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1306	1716214180278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214181280	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214181280	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1309	1716214181280	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214182282	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214182282	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214164270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214165270	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214166272	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214167274	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214168269	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214169279	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214170280	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214171282	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214172284	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214173278	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214174288	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214175290	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214176283	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214177296	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214178297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214179303	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214180301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214181301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214182305	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214183298	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214184309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214185308	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214186311	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214187313	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214188309	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214189317	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214190318	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214191320	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214192323	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214193325	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214194327	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1355999999999997	1716214213345	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214214347	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214214347	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.133	1716214214347	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214215348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214215348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.133	1716214215348	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214216350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214216350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.133	1716214216350	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214217352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214217352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1339	1716214217352	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214218354	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214218354	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1339	1716214218354	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214219356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214219356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1339	1716214219356	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214220358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214220358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1315999999999997	1716214220358	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214221360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214221360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1315999999999997	1716214221360	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214222362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214222362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1315999999999997	1716214222362	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214223364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214223364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.131	1716214223364	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214224366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214224366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.131	1716214224366	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1309	1716214182282	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214183284	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214183284	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1309	1716214183284	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214184286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214184286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1314	1716214184286	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214185288	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214185288	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1314	1716214185288	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214186290	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214186290	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1314	1716214186290	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214187292	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214187292	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1296	1716214187292	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214188294	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214188294	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1296	1716214188294	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214189295	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214189295	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1296	1716214189295	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214190297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214190297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1289000000000002	1716214190297	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214191299	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214191299	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1289000000000002	1716214191299	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214192301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214192301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1289000000000002	1716214192301	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214193303	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214193303	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1323000000000003	1716214193303	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214194305	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214194305	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1323000000000003	1716214194305	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214224394	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214225368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214225368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.131	1716214225368	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214225385	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214226370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214226370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1281	1716214226370	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214226385	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214227371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214227371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1281	1716214227371	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214227385	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214228373	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214228373	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1281	1716214228373	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214228394	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214229377	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214229377	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1330999999999998	1716214229377	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214229390	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214230379	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214230379	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1330999999999998	1716214230379	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214230399	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214231380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214231380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1330999999999998	1716214231380	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214232382	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214232382	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1330999999999998	1716214232382	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214233384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214233384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1330999999999998	1716214233384	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214234387	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214234387	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1330999999999998	1716214234387	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214235389	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214235389	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1325	1716214235389	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214236391	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214236391	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1325	1716214236391	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214237393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214237393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1325	1716214237393	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214238395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214238395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1323000000000003	1716214238395	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214239397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214239397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1323000000000003	1716214239397	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214240398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214240398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1323000000000003	1716214240398	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214241400	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214241400	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1298000000000004	1716214241400	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214242402	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214242402	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1298000000000004	1716214242402	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214243404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214243404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1298000000000004	1716214243404	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214244406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214244406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1327	1716214244406	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214245408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214245408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1327	1716214245408	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214246410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214246410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1327	1716214246410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214247412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214247412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1326	1716214247412	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214248413	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214248413	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1326	1716214248413	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214249417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214249417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1326	1716214249417	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214250419	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214250419	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1333	1716214250419	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	104	1716214251420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214251420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1333	1716214251420	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716214252422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214252422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1333	1716214252422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214231403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214232403	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214233407	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214234401	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214235410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214236416	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214237414	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214238410	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214239419	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214240419	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214241421	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214242422	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214243421	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214244427	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214245430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214246432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214247425	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214248427	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214249439	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214250440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214251441	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214252438	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214253445	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214253424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214253424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1361999999999997	1716214253424	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214254426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214254426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1361999999999997	1716214254426	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214254444	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214255428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214255428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1361999999999997	1716214255428	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214255443	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214256430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214256430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.137	1716214256430	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214256446	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214257432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214257432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.137	1716214257432	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214257447	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214258435	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214258435	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.137	1716214258435	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214258450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214259437	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214259437	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1354	1716214259437	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214259457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214260439	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214260439	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1354	1716214260439	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214260463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214261440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214261440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1354	1716214261440	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214261463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	100	1716214262442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214262442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1327	1716214262442	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214262463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214263444	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214263444	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1327	1716214263444	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214263461	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214264446	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214264446	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1327	1716214264446	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214264468	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214265448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.700000000000001	1716214265448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.134	1716214265448	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214265472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214266450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214266450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.134	1716214266450	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214266471	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214267452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214267452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.134	1716214267452	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214267472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214268454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214268454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1355	1716214268454	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214268475	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214269455	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214269455	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1355	1716214269455	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214270457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214270457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1355	1716214270457	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214271459	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214271459	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.135	1716214271459	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214272461	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214272461	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.135	1716214272461	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214273463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214273463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.135	1716214273463	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214274464	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214274464	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1349	1716214274464	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214275466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214275466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1349	1716214275466	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214276468	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214276468	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1349	1716214276468	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	103	1716214277470	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214277470	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.134	1716214277470	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	101	1716214278472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214278472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.134	1716214278472	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214279474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.3	1716214279474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.134	1716214279474	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214280477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	7.5	1716214280477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1335	1716214280477	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - CPU Utilization	102	1716214281479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Utilization	9.4	1716214281479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Memory Usage GB	2.1335	1716214281479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214269478	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214270479	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214271480	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214272482	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214273476	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214274488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214275490	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214276482	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214277493	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214278488	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214279489	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214280498	5275bcd90fa945bc9b551c01849ed128	0	f
TOP - Swap Memory GB	0.0174	1716214281501	5275bcd90fa945bc9b551c01849ed128	0	f
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
letter	0	97ac8864cc394e9cad9cb36c059cb19f
workload	0	97ac8864cc394e9cad9cb36c059cb19f
listeners	smi+top+dcgmi	97ac8864cc394e9cad9cb36c059cb19f
params	'"-"'	97ac8864cc394e9cad9cb36c059cb19f
file	cifar10.py	97ac8864cc394e9cad9cb36c059cb19f
workload_listener	''	97ac8864cc394e9cad9cb36c059cb19f
letter	0	5275bcd90fa945bc9b551c01849ed128
workload	0	5275bcd90fa945bc9b551c01849ed128
listeners	smi+top+dcgmi	5275bcd90fa945bc9b551c01849ed128
params	'"-"'	5275bcd90fa945bc9b551c01849ed128
file	cifar10.py	5275bcd90fa945bc9b551c01849ed128
workload_listener	''	5275bcd90fa945bc9b551c01849ed128
model	cifar10.py	5275bcd90fa945bc9b551c01849ed128
manual	False	5275bcd90fa945bc9b551c01849ed128
max_epoch	5	5275bcd90fa945bc9b551c01849ed128
max_time	172800	5275bcd90fa945bc9b551c01849ed128
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
97ac8864cc394e9cad9cb36c059cb19f	polite-gnu-695	UNKNOWN			daga	FAILED	1716210379806	1716210421104		active	s3://mlflow-storage/0/97ac8864cc394e9cad9cb36c059cb19f/artifacts	0	\N
5275bcd90fa945bc9b551c01849ed128	(0 0) popular-turtle-552	UNKNOWN			daga	FINISHED	1716211553962	1716214283030		active	s3://mlflow-storage/0/5275bcd90fa945bc9b551c01849ed128/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	97ac8864cc394e9cad9cb36c059cb19f
mlflow.source.name	file:///home/daga/radt#examples/pytorch	97ac8864cc394e9cad9cb36c059cb19f
mlflow.source.type	PROJECT	97ac8864cc394e9cad9cb36c059cb19f
mlflow.project.entryPoint	main	97ac8864cc394e9cad9cb36c059cb19f
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	97ac8864cc394e9cad9cb36c059cb19f
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	97ac8864cc394e9cad9cb36c059cb19f
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	97ac8864cc394e9cad9cb36c059cb19f
mlflow.runName	polite-gnu-695	97ac8864cc394e9cad9cb36c059cb19f
mlflow.project.env	conda	97ac8864cc394e9cad9cb36c059cb19f
mlflow.project.backend	local	97ac8864cc394e9cad9cb36c059cb19f
mlflow.user	daga	5275bcd90fa945bc9b551c01849ed128
mlflow.source.name	file:///home/daga/radt#examples/pytorch	5275bcd90fa945bc9b551c01849ed128
mlflow.source.type	PROJECT	5275bcd90fa945bc9b551c01849ed128
mlflow.project.entryPoint	main	5275bcd90fa945bc9b551c01849ed128
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	5275bcd90fa945bc9b551c01849ed128
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	5275bcd90fa945bc9b551c01849ed128
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	5275bcd90fa945bc9b551c01849ed128
mlflow.project.env	conda	5275bcd90fa945bc9b551c01849ed128
mlflow.project.backend	local	5275bcd90fa945bc9b551c01849ed128
mlflow.runName	(0 0) popular-turtle-552	5275bcd90fa945bc9b551c01849ed128
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

