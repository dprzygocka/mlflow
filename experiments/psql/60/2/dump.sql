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
0	Default	s3://mlflow-storage/0	active	1716238621563	1716238621563
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
SMI - Power Draw	15.26	1716239078420	0	f	0d00664f996847edbcf8d1b3c36fb3f6
SMI - Timestamp	1716239078.406	1716239078420	0	f	0d00664f996847edbcf8d1b3c36fb3f6
SMI - GPU Util	0	1716239078420	0	f	0d00664f996847edbcf8d1b3c36fb3f6
SMI - Mem Util	0	1716239078420	0	f	0d00664f996847edbcf8d1b3c36fb3f6
SMI - Mem Used	0	1716239078420	0	f	0d00664f996847edbcf8d1b3c36fb3f6
SMI - Performance State	0	1716239078420	0	f	0d00664f996847edbcf8d1b3c36fb3f6
TOP - CPU Utilization	103	1716240811233	0	f	0d00664f996847edbcf8d1b3c36fb3f6
TOP - Memory Usage GB	2.054	1716240811233	0	f	0d00664f996847edbcf8d1b3c36fb3f6
TOP - Memory Utilization	8.4	1716240811233	0	f	0d00664f996847edbcf8d1b3c36fb3f6
TOP - Swap Memory GB	0	1716240811259	0	f	0d00664f996847edbcf8d1b3c36fb3f6
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	15.26	1716239078420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
SMI - Timestamp	1716239078.406	1716239078420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
SMI - GPU Util	0	1716239078420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
SMI - Mem Util	0	1716239078420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
SMI - Mem Used	0	1716239078420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
SMI - Performance State	0	1716239078420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	0	1716239078485	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	0	1716239078485	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.2314	1716239078485	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239078499	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	153.39999999999998	1716239079487	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	9	1716239079487	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.2314	1716239079487	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239079502	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239080488	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239080488	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.2314	1716239080488	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239080502	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239081490	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239081490	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.462	1716239081490	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239081511	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239082492	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239082492	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.462	1716239082492	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239082514	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239083494	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239083494	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.462	1716239083494	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239083507	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239084496	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239084496	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.463	1716239084496	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239084517	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239085498	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239085498	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.463	1716239085498	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239085511	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239086500	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239086500	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.463	1716239086500	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239086520	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239087502	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239087502	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4633	1716239087502	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239087524	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239088504	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239088504	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4633	1716239088504	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239088517	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239089506	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239089506	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4633	1716239089506	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239089527	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	106	1716239090508	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239090508	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4632	1716239090508	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239090529	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239091510	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239091510	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4632	1716239091510	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239091531	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239092511	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239092511	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4632	1716239092511	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239092524	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239093535	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239094536	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239095538	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239096540	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239097535	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239098544	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239099547	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239100547	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239101551	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239102544	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239103554	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239104556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239105558	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239106560	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239107554	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239108556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239109559	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239110561	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239111568	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239112565	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239113574	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239114575	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239115577	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239116581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239117577	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239118585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239119585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239120586	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239121592	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239122592	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239123594	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239124595	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239125596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239126599	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239127593	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239128605	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239129608	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239130608	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239131607	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239132603	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239133611	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239134613	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239135616	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239136616	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239137619	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239138623	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239139622	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239140618	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239141626	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239142622	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239143631	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239144633	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239145636	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239146636	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239147632	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239148641	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239149646	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239150645	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239151646	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239393083	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239393083	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9163	1716239393083	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239394085	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239394085	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239093514	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239093514	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4639000000000002	1716239093514	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239094515	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239094515	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4639000000000002	1716239094515	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239095517	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239095517	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4639000000000002	1716239095517	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716239096519	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239096519	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4642	1716239096519	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239097521	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239097521	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4642	1716239097521	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239098523	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239098523	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4642	1716239098523	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716239099525	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239099525	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4644000000000001	1716239099525	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239100527	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239100527	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4644000000000001	1716239100527	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716239101529	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239101529	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4644000000000001	1716239101529	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239102531	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239102531	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4643	1716239102531	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239103533	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239103533	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4643	1716239103533	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239104535	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239104535	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4643	1716239104535	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716239105537	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239105537	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4642	1716239105537	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239106539	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239106539	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4642	1716239106539	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239107541	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239107541	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.4642	1716239107541	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239108543	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239108543	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.7652999999999999	1716239108543	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239109545	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239109545	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.7652999999999999	1716239109545	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239110546	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239110546	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.7652999999999999	1716239110546	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239111548	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239111548	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9797	1716239111548	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239112550	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239112550	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9797	1716239112550	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239113552	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239113552	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9797	1716239113552	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239114554	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239114554	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9841	1716239114554	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239115556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239115556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9841	1716239115556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239116557	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239116557	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9841	1716239116557	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239117559	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239117559	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9854	1716239117559	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239118561	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239118561	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9854	1716239118561	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239119563	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239119563	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9854	1716239119563	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239120565	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239120565	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9861	1716239120565	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239121568	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239121568	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9861	1716239121568	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239122570	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239122570	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9861	1716239122570	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239123572	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239123572	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9866	1716239123572	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239124574	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239124574	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9866	1716239124574	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239125576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239125576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9866	1716239125576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239126578	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239126578	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9882	1716239126578	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239127579	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239127579	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9882	1716239127579	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239128581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239128581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9882	1716239128581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239129583	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239129583	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9872999999999998	1716239129583	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239130585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239130585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9872999999999998	1716239130585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239131587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239131587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9872999999999998	1716239131587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239132589	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239132589	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8937	1716239132589	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239133591	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239133591	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8937	1716239133591	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239134592	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239134592	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8937	1716239134592	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239135594	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239135594	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8947	1716239135594	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239136596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239136596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8947	1716239136596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239137598	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239137598	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8947	1716239137598	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239138600	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239138600	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8962999999999999	1716239138600	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239139602	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239139602	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8962999999999999	1716239139602	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239140604	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239140604	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8962999999999999	1716239140604	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239141606	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239141606	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8945999999999998	1716239141606	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239142607	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239142607	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8945999999999998	1716239142607	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	99	1716239143609	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	4.3	1716239143609	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8945999999999998	1716239143609	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239144612	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239144612	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8952	1716239144612	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239145614	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239145614	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8952	1716239145614	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239146616	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239146616	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8952	1716239146616	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239147618	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239147618	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8964	1716239147618	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239148620	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239148620	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8964	1716239148620	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239149622	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239149622	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8964	1716239149622	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239150624	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239150624	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8952	1716239150624	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239151626	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239151626	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8952	1716239151626	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239152628	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239152628	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8952	1716239152628	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239152642	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239153630	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239153630	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.896	1716239153630	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239153651	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239154632	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.800000000000001	1716239154632	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.896	1716239154632	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239154653	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239155634	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239155634	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.896	1716239155634	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239155655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239156657	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239157651	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239158661	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239159664	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239160665	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239161659	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239162660	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239163673	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239164673	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239165673	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239166677	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239167674	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239168679	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239169684	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239170685	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239171685	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239172682	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239173682	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239174690	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239175692	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239176694	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239177697	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239178692	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239179704	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239180702	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239181704	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239182706	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239183708	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239184710	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239185711	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239186713	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239187707	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239188717	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239189718	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239190721	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239191716	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239192723	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239193726	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239194731	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239195731	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239196732	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239197736	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239198795	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239199737	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239200744	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239201741	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239202735	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239203745	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239204746	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239205749	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239206750	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239207744	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239208754	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239209757	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239210750	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239211760	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239393106	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239394108	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239395110	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239396110	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239397113	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239398108	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239399115	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239400119	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239156636	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239156636	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8999000000000001	1716239156636	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239157638	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239157638	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8999000000000001	1716239157638	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239158640	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239158640	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8999000000000001	1716239158640	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239159641	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239159641	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8975	1716239159641	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239160643	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239160643	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8975	1716239160643	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239161645	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239161645	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8975	1716239161645	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239162647	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239162647	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9002999999999999	1716239162647	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239163649	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.4	1716239163649	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9002999999999999	1716239163649	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239164651	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.7	1716239164651	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9002999999999999	1716239164651	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239165653	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239165653	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9005	1716239165653	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239166655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239166655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9005	1716239166655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239167657	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239167657	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9005	1716239167657	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239168658	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239168658	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9011	1716239168658	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239169660	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239169660	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9011	1716239169660	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239170662	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239170662	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9011	1716239170662	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239171664	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239171664	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9009	1716239171664	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239172666	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239172666	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9009	1716239172666	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239173668	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239173668	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9009	1716239173668	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	99	1716239174670	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239174670	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8977	1716239174670	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239175672	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239175672	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8977	1716239175672	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239176673	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239176673	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8977	1716239176673	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239177675	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239177675	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8991	1716239177675	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239178677	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239178677	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8991	1716239178677	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239179679	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239179679	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8991	1716239179679	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239180681	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239180681	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9021	1716239180681	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239181683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239181683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9021	1716239181683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239182685	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239182685	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9021	1716239182685	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239183687	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239183687	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9048	1716239183687	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239184688	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239184688	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9048	1716239184688	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239185690	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239185690	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9048	1716239185690	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239186692	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239186692	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9059000000000001	1716239186692	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239187694	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239187694	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9059000000000001	1716239187694	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239188696	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239188696	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9059000000000001	1716239188696	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239189698	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239189698	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9032	1716239189698	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239190700	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239190700	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9032	1716239190700	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239191702	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239191702	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9032	1716239191702	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239192703	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239192703	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9034	1716239192703	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239193705	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239193705	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9034	1716239193705	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239194707	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239194707	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9034	1716239194707	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239195709	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239195709	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9034	1716239195709	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	99	1716239196710	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239196710	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9034	1716239196710	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239197712	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239197712	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9034	1716239197712	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239198714	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239198714	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9045999999999998	1716239198714	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239199716	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239199716	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9045999999999998	1716239199716	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	108	1716239200718	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239200718	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9045999999999998	1716239200718	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239201720	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239201720	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9042000000000001	1716239201720	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239202722	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239202722	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9042000000000001	1716239202722	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239203724	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239203724	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9042000000000001	1716239203724	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239204726	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239204726	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9067	1716239204726	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239205727	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239205727	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9067	1716239205727	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239206729	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239206729	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9067	1716239206729	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239207731	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239207731	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9064	1716239207731	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239208733	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239208733	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9064	1716239208733	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239209735	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239209735	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9064	1716239209735	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239210737	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239210737	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9071	1716239210737	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239211738	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239211738	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9071	1716239211738	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239212740	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239212740	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9071	1716239212740	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239212757	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239213742	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239213742	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9085999999999999	1716239213742	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239213763	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239214744	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239214744	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9085999999999999	1716239214744	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239214767	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239215746	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239215746	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9085999999999999	1716239215746	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239215767	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239216748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239216748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9044	1716239216748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239216770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239217749	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239217749	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9044	1716239217749	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239217763	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239218751	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239218751	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9044	1716239218751	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239219753	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239219753	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9074	1716239219753	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239220755	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239220755	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9074	1716239220755	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239221757	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239221757	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9074	1716239221757	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239222759	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239222759	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9073	1716239222759	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239223761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239223761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9073	1716239223761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239224762	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239224762	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9073	1716239224762	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239225764	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239225764	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9095	1716239225764	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239226766	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239226766	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9095	1716239226766	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239227768	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239227768	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9095	1716239227768	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239228770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239228770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9099000000000002	1716239228770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239229772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239229772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9099000000000002	1716239229772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239230774	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239230774	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9099000000000002	1716239230774	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	106	1716239231776	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.5	1716239231776	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.909	1716239231776	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239232778	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239232778	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.909	1716239232778	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239233780	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239233780	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.909	1716239233780	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239234782	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239234782	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9095	1716239234782	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239235784	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239235784	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9095	1716239235784	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239236786	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239236786	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9095	1716239236786	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239237788	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239237788	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9051	1716239237788	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239238789	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239238789	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9051	1716239238789	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239239791	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239218770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239219775	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239220777	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239221770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239222772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239223784	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239224776	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239225787	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239226787	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239227790	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239228793	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239229832	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239230796	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239231790	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239232792	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239233801	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239234802	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239235806	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239236807	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239237805	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239238810	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239239810	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239240808	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239241818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239242810	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239243821	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239244820	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239245822	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239246825	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239247823	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239248829	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239249831	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239250833	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239251827	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239252832	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239253838	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239254840	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239255842	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239256845	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239257846	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239258847	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239259849	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239260852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239261854	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239262849	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239263859	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239264863	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239265863	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239266862	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239267862	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239268867	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239269868	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239270870	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239271871	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9163	1716239394085	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239395087	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239395087	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9163	1716239395087	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239396088	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239396088	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9193	1716239396088	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239397090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239397090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9193	1716239397090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239398092	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239239791	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9051	1716239239791	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239240793	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239240793	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9071	1716239240793	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239241795	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239241795	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9071	1716239241795	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239242796	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239242796	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9071	1716239242796	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239243798	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239243798	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9064	1716239243798	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239244800	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239244800	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9064	1716239244800	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239245802	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239245802	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9064	1716239245802	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239246804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239246804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9082000000000001	1716239246804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239247806	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239247806	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9082000000000001	1716239247806	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239248808	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239248808	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9082000000000001	1716239248808	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239249810	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.900000000000001	1716239249810	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9108	1716239249810	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239250812	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239250812	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9108	1716239250812	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239251814	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239251814	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9108	1716239251814	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239252816	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239252816	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9114	1716239252816	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239253818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239253818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9114	1716239253818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239254819	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239254819	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9114	1716239254819	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239255821	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239255821	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9114	1716239255821	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239256823	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239256823	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9114	1716239256823	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239257825	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.5	1716239257825	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9114	1716239257825	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239258826	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239258826	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9085999999999999	1716239258826	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239259828	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239259828	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9085999999999999	1716239259828	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239260830	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239260830	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9085999999999999	1716239260830	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239261832	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239261832	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9084	1716239261832	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239262834	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239262834	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9084	1716239262834	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239263836	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239263836	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9084	1716239263836	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239264837	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239264837	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9094	1716239264837	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239265839	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239265839	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9094	1716239265839	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239266841	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239266841	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9094	1716239266841	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239267843	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239267843	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9105999999999999	1716239267843	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239268845	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239268845	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9105999999999999	1716239268845	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239269846	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239269846	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9105999999999999	1716239269846	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239270848	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239270848	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9116	1716239270848	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239271850	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239271850	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9116	1716239271850	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239272852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239272852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9116	1716239272852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239272873	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239273855	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239273855	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.913	1716239273855	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239273876	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239274857	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239274857	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.913	1716239274857	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239274878	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239275859	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239275859	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.913	1716239275859	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239275881	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239276860	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239276860	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9139000000000002	1716239276860	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239276883	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239277862	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239277862	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9139000000000002	1716239277862	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239277875	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239278864	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239278864	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9139000000000002	1716239278864	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239278880	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239279866	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239279866	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9148	1716239279866	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239280868	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239280868	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9148	1716239280868	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239281870	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239281870	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9148	1716239281870	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239282872	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239282872	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9087	1716239282872	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239283874	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239283874	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9087	1716239283874	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239284877	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239284877	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9087	1716239284877	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239285879	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239285879	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9118	1716239285879	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239286881	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239286881	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9118	1716239286881	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239287883	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239287883	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9118	1716239287883	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239288884	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239288884	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9137	1716239288884	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239289886	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239289886	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9137	1716239289886	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239290888	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239290888	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9137	1716239290888	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239291890	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239291890	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.915	1716239291890	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239292892	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239292892	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.915	1716239292892	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239293894	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239293894	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.915	1716239293894	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239294895	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239294895	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9150999999999998	1716239294895	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239295897	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239295897	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9150999999999998	1716239295897	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239296899	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239296899	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9150999999999998	1716239296899	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239297901	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239297901	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9152	1716239297901	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239298903	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239298903	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9152	1716239298903	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239299905	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239299905	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9152	1716239299905	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239300907	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.800000000000001	1716239300907	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9156	1716239300907	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239279890	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239280889	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239281891	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239282887	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239283896	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239284898	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239285901	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239286904	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239287906	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239288908	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239289907	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239290909	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239291912	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239292907	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239293909	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239294914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239295918	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239296921	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239297915	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239298924	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239299926	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239300928	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239301921	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239302932	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239303936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239304936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239305939	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239306941	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239307934	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239308937	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239309948	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239310947	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239311949	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239312943	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239313956	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239314958	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239315956	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239316957	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239317959	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239318957	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239319964	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239320966	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239321968	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239322964	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239323972	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239324974	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239325978	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239326980	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239327978	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239328982	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239329984	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239330986	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239331988	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239398092	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9193	1716239398092	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239399094	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239399094	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9174	1716239399094	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239400096	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239400096	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9174	1716239400096	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239401098	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239401098	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9174	1716239401098	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239402100	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239301909	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.500000000000001	1716239301909	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9156	1716239301909	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239302910	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239302910	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9156	1716239302910	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239303912	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239303912	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9148	1716239303912	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239304914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239304914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9148	1716239304914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239305916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239305916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9148	1716239305916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239306918	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239306918	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9115	1716239306918	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239307920	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239307920	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9115	1716239307920	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239308922	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239308922	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9115	1716239308922	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239309924	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239309924	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9152	1716239309924	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239310925	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239310925	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9152	1716239310925	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239311927	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239311927	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9152	1716239311927	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239312929	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239312929	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9155	1716239312929	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239313932	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239313932	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9155	1716239313932	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239314934	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239314934	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9155	1716239314934	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239315936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239315936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9169	1716239315936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239316938	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239316938	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9169	1716239316938	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239317940	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239317940	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9169	1716239317940	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239318942	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239318942	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9179000000000002	1716239318942	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239319943	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239319943	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9179000000000002	1716239319943	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239320945	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239320945	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9179000000000002	1716239320945	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239321947	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239321947	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9147	1716239321947	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239322949	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239322949	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9147	1716239322949	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239323951	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239323951	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9147	1716239323951	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239324953	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239324953	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9139000000000002	1716239324953	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239325955	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239325955	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9139000000000002	1716239325955	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239326957	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239326957	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9139000000000002	1716239326957	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239327959	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239327959	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8964	1716239327959	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239328961	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239328961	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8964	1716239328961	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239329963	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239329963	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.8964	1716239329963	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239330965	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239330965	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9125	1716239330965	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239331967	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239331967	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9125	1716239331967	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239332969	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239332969	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9125	1716239332969	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239332990	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239333970	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239333970	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9155	1716239333970	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239333993	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239334972	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239334972	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9155	1716239334972	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239334993	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239335974	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239335974	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9155	1716239335974	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239335996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239336976	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239336976	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9168	1716239336976	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239336997	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239337978	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239337978	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9168	1716239337978	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239337991	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239338980	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239338980	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9168	1716239338980	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239338993	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239339982	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239339982	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9169	1716239339982	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239340003	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239340984	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239340984	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9169	1716239340984	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239341006	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239342008	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239343003	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239344004	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239345012	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239346014	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239347016	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239348012	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239349015	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239350020	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239351024	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239352029	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239353021	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239354023	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239355034	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239356033	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239357035	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239358030	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239359032	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239360041	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239361045	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239362040	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239363049	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239364050	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239365052	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239366054	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239367053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239368056	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239369051	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239370051	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239371063	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239372063	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239373068	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239374071	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239375062	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239376072	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239377068	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239378069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239379069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239380077	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239381080	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239382083	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239383084	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239384086	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239385090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239386092	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239387086	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239388091	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239389093	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239390100	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239391100	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239392097	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239401118	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239402126	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239403118	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239404126	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239405126	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239406130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239407122	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239408132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239409133	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239410136	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239411130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239412142	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239413135	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239341985	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239341985	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9169	1716239341985	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239342987	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239342987	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9185999999999999	1716239342987	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239343989	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239343989	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9185999999999999	1716239343989	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239344991	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239344991	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9185999999999999	1716239344991	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239345993	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239345993	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9175	1716239345993	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239346995	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239346995	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9175	1716239346995	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239347996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239347996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9175	1716239347996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239348999	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239348999	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9139000000000002	1716239348999	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239350001	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239350001	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9139000000000002	1716239350001	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239351003	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239351003	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9139000000000002	1716239351003	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239352005	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239352005	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9165	1716239352005	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239353007	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239353007	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9165	1716239353007	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239354009	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239354009	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9165	1716239354009	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239355010	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239355010	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.917	1716239355010	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239356012	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239356012	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.917	1716239356012	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239357014	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239357014	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.917	1716239357014	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239358016	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239358016	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9188	1716239358016	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239359018	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239359018	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9188	1716239359018	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239360020	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239360020	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9187	1716239360020	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239361022	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239361022	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9187	1716239361022	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239362023	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239362023	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9187	1716239362023	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239363025	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239363025	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9178	1716239363025	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239364027	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239364027	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9178	1716239364027	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239365029	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239365029	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9178	1716239365029	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239366031	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239366031	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9189	1716239366031	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239367033	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239367033	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9189	1716239367033	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239368035	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239368035	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9189	1716239368035	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239369036	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239369036	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9201	1716239369036	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239370038	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239370038	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9201	1716239370038	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239371040	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239371040	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9201	1716239371040	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239372042	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239372042	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9132	1716239372042	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239373044	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239373044	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9132	1716239373044	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239374046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239374046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9132	1716239374046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239375048	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239375048	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9174	1716239375048	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239376050	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239376050	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9174	1716239376050	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239377052	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239377052	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9174	1716239377052	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239378053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239378053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9169	1716239378053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239379055	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239379055	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9169	1716239379055	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239380057	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239380057	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9169	1716239380057	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239381060	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239381060	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9187	1716239381060	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239382061	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239382061	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9187	1716239382061	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239383063	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239383063	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9187	1716239383063	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239384065	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239384065	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9178	1716239384065	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239385067	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239385067	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9178	1716239385067	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239386069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239386069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9178	1716239386069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239387071	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239387071	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9168	1716239387071	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239388074	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239388074	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9168	1716239388074	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239389076	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239389076	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9168	1716239389076	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239390077	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239390077	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9181	1716239390077	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239391079	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239391079	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9181	1716239391079	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239392081	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239392081	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9181	1716239392081	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239402100	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9213	1716239402100	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239403102	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239403102	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9213	1716239403102	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239404104	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239404104	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9213	1716239404104	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239405106	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239405106	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9219000000000002	1716239405106	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239406107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239406107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9219000000000002	1716239406107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239407109	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239407109	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9219000000000002	1716239407109	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239408111	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239408111	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9221	1716239408111	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239409113	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239409113	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9221	1716239409113	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239410115	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239410115	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9221	1716239410115	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239411117	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239411117	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9201	1716239411117	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239412119	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239412119	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9201	1716239412119	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239413121	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239413121	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9201	1716239413121	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239414122	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239414122	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9163	1716239414122	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239414146	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239415124	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239415124	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9163	1716239415124	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239416126	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239416126	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9163	1716239416126	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239417128	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239417128	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9173	1716239417128	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239418130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239418130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9173	1716239418130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239419132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239419132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9173	1716239419132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239420134	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239420134	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.919	1716239420134	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239421136	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	5.9	1716239421136	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.919	1716239421136	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239422138	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.6000000000000005	1716239422138	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.919	1716239422138	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239423139	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239423139	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9234	1716239423139	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239424141	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239424141	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9234	1716239424141	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239425143	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239425143	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9234	1716239425143	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239426145	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239426145	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9225999999999999	1716239426145	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239427146	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239427146	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9225999999999999	1716239427146	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239428148	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239428148	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9225999999999999	1716239428148	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239429150	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239429150	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9199000000000002	1716239429150	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239430152	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716239430152	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9199000000000002	1716239430152	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239431154	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239431154	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9199000000000002	1716239431154	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239432156	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239432156	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9216	1716239432156	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239433158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239433158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9216	1716239433158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239434159	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239434159	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9216	1716239434159	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239435161	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239435161	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.922	1716239435161	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239436163	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239415145	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239416146	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239417149	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239418143	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239419152	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239420156	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239421158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239422158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239423162	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239424163	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239425165	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239426166	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239427171	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239428167	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239429175	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239430173	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239431166	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239432178	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239433175	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239434182	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239435182	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239436187	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239437187	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239438182	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239439189	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239440193	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239441196	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239442197	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239443192	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239444199	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239445193	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239446202	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239447205	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239448200	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239449209	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239450212	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239451216	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239452219	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239812882	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239812882	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9452	1716239812882	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239813884	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239813884	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9473	1716239813884	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239814886	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239814886	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9473	1716239814886	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239815888	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239815888	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9473	1716239815888	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239816889	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239816889	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9442000000000002	1716239816889	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239817891	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239817891	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9442000000000002	1716239817891	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239818893	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239818893	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9442000000000002	1716239818893	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239819895	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239819895	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9422000000000001	1716239819895	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239820897	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239820897	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9422000000000001	1716239820897	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239436163	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.922	1716239436163	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239437165	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239437165	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.922	1716239437165	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239438167	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239438167	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9201	1716239438167	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239439169	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239439169	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9201	1716239439169	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239440170	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239440170	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9201	1716239440170	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239441172	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239441172	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9198	1716239441172	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239442174	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239442174	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9198	1716239442174	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239443176	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239443176	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9198	1716239443176	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239444178	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239444178	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9215	1716239444178	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239445180	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239445180	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9215	1716239445180	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239446182	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239446182	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9215	1716239446182	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239447184	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239447184	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.922	1716239447184	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239448186	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239448186	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.922	1716239448186	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239449187	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239449187	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.922	1716239449187	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239450191	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239450191	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9228	1716239450191	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239451193	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239451193	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9228	1716239451193	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239452194	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239452194	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9228	1716239452194	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239453196	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239453196	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9215	1716239453196	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239453211	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239454198	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239454198	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9215	1716239454198	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239454222	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239455202	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239455202	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9215	1716239455202	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239455223	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239456204	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239456204	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9234	1716239456204	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239457206	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239457206	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9234	1716239457206	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239458209	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239458209	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9234	1716239458209	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239459211	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239459211	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9233	1716239459211	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239460213	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239460213	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9233	1716239460213	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239461215	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239461215	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9233	1716239461215	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239462217	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239462217	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9213	1716239462217	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239463219	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239463219	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9213	1716239463219	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239464220	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239464220	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9213	1716239464220	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239465222	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239465222	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9223	1716239465222	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239466224	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239466224	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9223	1716239466224	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239467226	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239467226	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9223	1716239467226	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239468228	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239468228	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9238	1716239468228	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239469230	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239469230	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9238	1716239469230	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239470231	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239470231	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9238	1716239470231	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239471233	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239471233	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9265	1716239471233	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239472235	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239472235	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9265	1716239472235	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239473237	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239473237	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9265	1716239473237	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239474239	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239474239	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9261	1716239474239	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239475241	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239475241	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9261	1716239475241	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239476243	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239476243	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9261	1716239476243	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239477245	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239477245	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9265999999999999	1716239477245	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239456226	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239457230	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239458222	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239459231	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239460236	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239461239	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239462241	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239463235	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239464243	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239465245	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239466245	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239467248	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239468242	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239469250	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239470254	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239471255	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239472250	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239473251	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239474260	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239475262	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239476264	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239477258	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239478261	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239479271	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239480272	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239481275	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239482277	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239483270	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239484280	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239485284	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239486276	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239487281	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239488280	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239489285	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239490294	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239491295	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239492289	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239493294	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239494293	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239495303	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239496306	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239497307	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239498301	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239499311	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239500315	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239501317	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239502314	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239503313	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239504322	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239505323	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239506326	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239507320	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239508325	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239509332	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239510333	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239511339	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239512338	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239812904	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239813907	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239814901	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239815909	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239816915	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239817908	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239818917	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239819908	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239478248	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239478248	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9265999999999999	1716239478248	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239479250	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239479250	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9265999999999999	1716239479250	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239480252	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239480252	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.926	1716239480252	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239481253	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239481253	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.926	1716239481253	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239482255	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239482255	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.926	1716239482255	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239483257	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239483257	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9259000000000002	1716239483257	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239484259	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239484259	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9259000000000002	1716239484259	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239485261	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239485261	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9259000000000002	1716239485261	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239486263	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239486263	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9245	1716239486263	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239487265	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239487265	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9245	1716239487265	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239488267	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239488267	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9245	1716239488267	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239489269	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239489269	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9267999999999998	1716239489269	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239490271	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239490271	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9267999999999998	1716239490271	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239491273	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239491273	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9267999999999998	1716239491273	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239492275	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239492275	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9264000000000001	1716239492275	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239493278	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239493278	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9264000000000001	1716239493278	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239494280	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239494280	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9264000000000001	1716239494280	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239495282	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239495282	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9239000000000002	1716239495282	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239496284	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239496284	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9239000000000002	1716239496284	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239497286	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239497286	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9239000000000002	1716239497286	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239498288	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239498288	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9249	1716239498288	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239499290	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239499290	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9249	1716239499290	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239500292	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239500292	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9249	1716239500292	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239501294	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239501294	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9262000000000001	1716239501294	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239502297	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239502297	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9262000000000001	1716239502297	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239503299	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239503299	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9262000000000001	1716239503299	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239504301	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239504301	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9234	1716239504301	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239505303	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239505303	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9234	1716239505303	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239506305	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239506305	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9234	1716239506305	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239507307	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239507307	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9237	1716239507307	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239508309	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239508309	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9237	1716239508309	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239509310	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239509310	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9237	1716239509310	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239510312	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239510312	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9249	1716239510312	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239511314	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239511314	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9249	1716239511314	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239512316	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239512316	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9249	1716239512316	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239513318	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239513318	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9267	1716239513318	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239513333	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239514320	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239514320	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9267	1716239514320	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239514342	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239515322	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239515322	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9267	1716239515322	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239515344	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239516323	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239516323	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9281	1716239516323	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239516344	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239517325	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239517325	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9281	1716239517325	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239517339	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239518327	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239518327	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9281	1716239518327	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239518342	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239519352	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239520354	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239521356	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239522349	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239523354	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239524362	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239525363	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239526364	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239527358	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239528361	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239529374	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239530372	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239531376	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239532377	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239533369	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239534371	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239535381	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239536383	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239537386	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239538379	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239539390	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239540390	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239541393	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239542396	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239543390	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239544400	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239545398	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239546400	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239547395	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239548398	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239549407	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239550408	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239551410	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239552408	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239553407	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239554416	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239555417	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239556422	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239557419	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239558420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239559428	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239560429	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239561434	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239562428	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239563430	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239564437	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239565440	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239566442	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239567442	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239568436	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239569445	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239570447	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239571449	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239572443	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239820920	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239821919	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239822914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239823924	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239824918	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239825919	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239826931	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239827930	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239828934	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239829929	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239519330	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239519330	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9267	1716239519330	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239520331	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239520331	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9267	1716239520331	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239521333	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239521333	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9267	1716239521333	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239522335	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239522335	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9265	1716239522335	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239523337	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239523337	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9265	1716239523337	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239524339	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239524339	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9265	1716239524339	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239525341	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239525341	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9258	1716239525341	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239526343	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239526343	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9258	1716239526343	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239527345	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239527345	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9258	1716239527345	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239528347	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239528347	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9236	1716239528347	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239529349	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239529349	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9236	1716239529349	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239530350	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239530350	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9236	1716239530350	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239531352	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239531352	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9269	1716239531352	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239532354	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239532354	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9269	1716239532354	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239533356	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716239533356	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9269	1716239533356	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239534358	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239534358	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9254	1716239534358	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239535360	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239535360	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9254	1716239535360	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239536362	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	2.9	1716239536362	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9254	1716239536362	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239537364	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239537364	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9284000000000001	1716239537364	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239538365	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239538365	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9284000000000001	1716239538365	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239539367	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239539367	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9284000000000001	1716239539367	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239540369	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239540369	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9285	1716239540369	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239541371	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239541371	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9285	1716239541371	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239542373	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239542373	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9285	1716239542373	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239543375	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239543375	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.928	1716239543375	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239544376	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239544376	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.928	1716239544376	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239545378	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239545378	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.928	1716239545378	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239546380	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239546380	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9301	1716239546380	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239547382	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239547382	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9301	1716239547382	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239548384	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239548384	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9301	1716239548384	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239549385	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239549385	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9293	1716239549385	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239550387	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239550387	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9293	1716239550387	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239551389	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239551389	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9293	1716239551389	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239552391	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239552391	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9270999999999998	1716239552391	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239553393	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239553393	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9270999999999998	1716239553393	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239554395	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239554395	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9270999999999998	1716239554395	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239555397	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239555397	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9301	1716239555397	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239556399	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.7	1716239556399	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9301	1716239556399	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239557400	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6	1716239557400	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9301	1716239557400	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239558402	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239558402	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.932	1716239558402	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239559404	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239559404	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.932	1716239559404	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239560407	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239560407	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.932	1716239560407	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239561409	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239561409	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.93	1716239561409	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239562411	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239562411	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.93	1716239562411	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239563413	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239563413	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.93	1716239563413	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239564415	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239564415	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9316	1716239564415	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239565417	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239565417	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9316	1716239565417	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239566418	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239566418	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9316	1716239566418	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239567420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239567420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9302000000000001	1716239567420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239568422	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239568422	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9302000000000001	1716239568422	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239569424	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.800000000000001	1716239569424	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9302000000000001	1716239569424	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239570426	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239570426	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9322000000000001	1716239570426	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239571428	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239571428	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9322000000000001	1716239571428	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239572430	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239572430	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9322000000000001	1716239572430	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239573432	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239573432	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9303	1716239573432	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239573445	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239574434	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239574434	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9303	1716239574434	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239574456	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239575436	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239575436	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9303	1716239575436	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239575458	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239576438	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239576438	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9324000000000001	1716239576438	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239576458	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239577439	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239577439	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9324000000000001	1716239577439	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239577452	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239578441	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239578441	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9324000000000001	1716239578441	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239578455	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239579444	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239579444	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9324000000000001	1716239579444	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239579465	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239580447	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239580447	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9324000000000001	1716239580447	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239581449	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239581449	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9324000000000001	1716239581449	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239582450	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239582450	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9301	1716239582450	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239583454	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239583454	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9301	1716239583454	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239584456	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239584456	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9301	1716239584456	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239585458	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239585458	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9325	1716239585458	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239586459	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239586459	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9325	1716239586459	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239587461	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239587461	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9325	1716239587461	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239588463	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239588463	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9327	1716239588463	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239589465	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239589465	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9327	1716239589465	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239590467	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239590467	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9327	1716239590467	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239591469	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239591469	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9316	1716239591469	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239592471	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239592471	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9316	1716239592471	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239593473	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239593473	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9316	1716239593473	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239594475	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239594475	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9274	1716239594475	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239595476	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239595476	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9274	1716239595476	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239596478	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239596478	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9274	1716239596478	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239597480	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239597480	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9335	1716239597480	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239598482	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239598482	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9335	1716239598482	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239599484	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239599484	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9335	1716239599484	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239600485	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239600485	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.931	1716239600485	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239601487	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239601487	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.931	1716239601487	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239580467	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239581470	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239582464	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239583467	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239584471	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239585480	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239586481	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239587483	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239588477	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239589488	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239590488	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239591491	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239592484	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239593488	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239594498	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239595499	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239596502	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239597493	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239598504	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239599505	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239600506	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239601509	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239602503	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239603512	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239604515	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239605515	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239606517	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239607512	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239608523	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239609523	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239610527	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239611520	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239612523	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239613531	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239614533	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239615536	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239616537	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239617541	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239618542	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239619544	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239620544	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239621546	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239622540	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239623549	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239624551	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239625556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239626556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239627550	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239628560	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239629561	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239630563	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239631566	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239632566	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239633570	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239634572	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239635575	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239636577	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239637571	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239638582	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239639580	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239640585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239641577	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239642581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239643588	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239644589	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239602489	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239602489	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.931	1716239602489	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239603491	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239603491	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9319000000000002	1716239603491	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239604493	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239604493	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9319000000000002	1716239604493	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239605495	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239605495	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9319000000000002	1716239605495	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239606496	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239606496	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9282000000000001	1716239606496	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239607498	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239607498	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9282000000000001	1716239607498	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239608500	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239608500	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9282000000000001	1716239608500	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239609503	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239609503	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9307999999999998	1716239609503	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239610505	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239610505	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9307999999999998	1716239610505	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239611507	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239611507	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9307999999999998	1716239611507	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239612509	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239612509	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.932	1716239612509	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239613510	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239613510	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.932	1716239613510	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239614512	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716239614512	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.932	1716239614512	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239615514	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239615514	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9343	1716239615514	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239616516	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239616516	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9343	1716239616516	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239617518	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239617518	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9343	1716239617518	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239618520	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239618520	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9330999999999998	1716239618520	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239619522	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239619522	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9330999999999998	1716239619522	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239620523	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239620523	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9330999999999998	1716239620523	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239621525	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239621525	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9336	1716239621525	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239622527	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239622527	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9336	1716239622527	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239623529	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239623529	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9336	1716239623529	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239624531	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239624531	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9316	1716239624531	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239625533	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239625533	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9316	1716239625533	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239626535	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239626535	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9316	1716239626535	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239627536	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239627536	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9341	1716239627536	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239628538	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239628538	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9341	1716239628538	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239629541	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239629541	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9341	1716239629541	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239630543	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239630543	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9345	1716239630543	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239631545	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239631545	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9345	1716239631545	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239632546	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239632546	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9345	1716239632546	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239633548	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239633548	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9343	1716239633548	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239634550	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239634550	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9343	1716239634550	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239635552	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239635552	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9343	1716239635552	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239636554	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239636554	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9307999999999998	1716239636554	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239637556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239637556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9307999999999998	1716239637556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239638557	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239638557	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9307999999999998	1716239638557	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	99	1716239639559	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239639559	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9305999999999999	1716239639559	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239640561	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239640561	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9305999999999999	1716239640561	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239641563	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239641563	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9305999999999999	1716239641563	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239642565	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239642565	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.933	1716239642565	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239643566	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239643566	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.933	1716239643566	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239644568	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239644568	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.933	1716239644568	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239645570	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239645570	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9330999999999998	1716239645570	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239646572	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239646572	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9330999999999998	1716239646572	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239647574	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239647574	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9330999999999998	1716239647574	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239648576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239648576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9335	1716239648576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239649578	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239649578	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9335	1716239649578	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239650579	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239650579	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9335	1716239650579	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239651581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239651581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9359000000000002	1716239651581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239652583	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239652583	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9359000000000002	1716239652583	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239653585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239653585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9359000000000002	1716239653585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239654587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239654587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9375	1716239654587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239655589	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239655589	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9375	1716239655589	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239656591	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239656591	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9375	1716239656591	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239657593	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239657593	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9379000000000002	1716239657593	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239658595	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239658595	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9379000000000002	1716239658595	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239659596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239659596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9379000000000002	1716239659596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239660598	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239660598	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9327	1716239660598	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239661600	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239661600	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9327	1716239661600	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239662602	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239662602	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9327	1716239662602	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239663604	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239663604	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9362000000000001	1716239663604	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239664606	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239664606	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9362000000000001	1716239664606	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239665608	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239665608	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9362000000000001	1716239665608	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239645594	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239646592	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239647587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239648597	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239649599	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239650600	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239651605	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239652597	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239653599	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239654611	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239655611	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239656611	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239657613	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239658612	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239659619	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239660620	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239661622	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239662623	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239663624	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239664630	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239665628	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239666632	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239667633	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239668634	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239669636	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239670639	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239671631	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239672634	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239673646	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239674645	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239675647	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239676651	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239677651	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239678653	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239679655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239680656	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239681658	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239682654	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239683662	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239684664	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239685666	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239686671	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239687662	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239688673	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239689674	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239690669	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239691683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239821899	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239821899	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9422000000000001	1716239821899	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239822900	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239822900	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9422000000000001	1716239822900	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239823902	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239823902	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9422000000000001	1716239823902	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239824904	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239824904	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9422000000000001	1716239824904	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239825906	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239825906	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9459000000000002	1716239825906	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239826908	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239826908	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9459000000000002	1716239826908	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239666609	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239666609	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9353	1716239666609	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239667611	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239667611	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9353	1716239667611	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239668613	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239668613	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9353	1716239668613	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239669615	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239669615	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9356	1716239669615	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239670616	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239670616	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9356	1716239670616	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239671618	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239671618	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9356	1716239671618	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239672621	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239672621	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9363	1716239672621	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239673623	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239673623	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9363	1716239673623	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239674625	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239674625	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9363	1716239674625	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239675627	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239675627	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9359000000000002	1716239675627	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239676628	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239676628	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9359000000000002	1716239676628	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239677630	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239677630	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9359000000000002	1716239677630	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239678632	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239678632	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9387	1716239678632	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239679633	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239679633	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9387	1716239679633	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239680635	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239680635	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9387	1716239680635	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239681637	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239681637	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9369	1716239681637	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239682639	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239682639	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9369	1716239682639	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239683641	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239683641	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9369	1716239683641	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239684643	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239684643	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9384000000000001	1716239684643	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239685645	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239685645	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9384000000000001	1716239685645	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239686646	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239686646	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9384000000000001	1716239686646	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239687648	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239687648	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9390999999999998	1716239687648	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239688650	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239688650	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9390999999999998	1716239688650	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239689653	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239689653	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9390999999999998	1716239689653	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239690655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.8	1716239690655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.939	1716239690655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239691657	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239691657	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.939	1716239691657	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239692659	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.1	1716239692659	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.939	1716239692659	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239692673	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239693661	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239693661	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9381	1716239693661	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239693683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239694663	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239694663	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9381	1716239694663	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239694676	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239695665	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239695665	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9381	1716239695665	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239695689	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239696666	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239696666	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9412	1716239696666	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239696689	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716239697668	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239697668	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9412	1716239697668	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239697689	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239698670	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239698670	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9412	1716239698670	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239698684	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239699672	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239699672	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.938	1716239699672	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239699693	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239700674	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239700674	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.938	1716239700674	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239700695	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239701676	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	4.8	1716239701676	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.938	1716239701676	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239701697	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239702678	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239702678	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9365999999999999	1716239702678	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239702699	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239703679	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239703679	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9365999999999999	1716239703679	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239703700	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239704681	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6000000000000005	1716239704681	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9365999999999999	1716239704681	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239705683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239705683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9389	1716239705683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239706685	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239706685	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9389	1716239706685	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239707687	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239707687	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9389	1716239707687	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239708689	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239708689	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9397	1716239708689	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239709691	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239709691	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9397	1716239709691	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239710693	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239710693	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9397	1716239710693	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239711695	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239711695	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9405999999999999	1716239711695	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239712696	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239712696	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9405999999999999	1716239712696	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239713698	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239713698	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9405999999999999	1716239713698	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239714700	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239714700	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9413	1716239714700	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239715702	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239715702	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9413	1716239715702	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239716703	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239716703	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9413	1716239716703	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239717705	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239717705	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9389	1716239717705	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239718706	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239718706	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9389	1716239718706	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239719708	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239719708	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9389	1716239719708	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239720710	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239720710	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9399000000000002	1716239720710	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239721712	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239721712	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9399000000000002	1716239721712	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239722713	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239722713	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9399000000000002	1716239722713	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239723715	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239723715	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9402000000000001	1716239723715	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239724717	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239724717	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9402000000000001	1716239724717	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239725718	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239725718	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9402000000000001	1716239725718	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239704704	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239705708	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239706709	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239707700	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239708711	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239709713	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239710714	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239711717	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239712710	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239713719	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239714722	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239715720	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239716725	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239717721	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239718728	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239719722	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239720724	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239721728	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239722734	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239723736	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239724732	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239725741	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239726748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239727736	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239728739	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239729747	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239730749	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239731752	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239732750	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239733758	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239734758	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239735759	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239736760	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239737759	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239738764	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239739763	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239740767	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239741769	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239742772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239743768	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239744774	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239745776	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239746778	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239747781	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239748782	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239749785	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239750790	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239751791	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239752783	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239753791	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239754796	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239755795	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239756798	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239757794	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239758795	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239759802	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239760807	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239761807	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239762801	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239763812	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239764813	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239765818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239766809	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239767820	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239768821	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239726720	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239726720	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9404000000000001	1716239726720	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239727722	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239727722	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9404000000000001	1716239727722	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239728724	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239728724	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9404000000000001	1716239728724	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239729726	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239729726	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9399000000000002	1716239729726	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239730728	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239730728	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9399000000000002	1716239730728	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239731730	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239731730	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9399000000000002	1716239731730	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239732732	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239732732	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9422000000000001	1716239732732	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239733734	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239733734	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9422000000000001	1716239733734	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239734736	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239734736	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9422000000000001	1716239734736	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239735738	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239735738	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9407	1716239735738	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239736739	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239736739	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9407	1716239736739	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239737741	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239737741	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9407	1716239737741	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239738743	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239738743	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.943	1716239738743	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239739745	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239739745	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.943	1716239739745	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239740746	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239740746	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.943	1716239740746	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239741748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239741748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9414	1716239741748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239742750	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239742750	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9414	1716239742750	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239743752	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239743752	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9414	1716239743752	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239744754	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239744754	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9441	1716239744754	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239745756	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239745756	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9441	1716239745756	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239746757	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239746757	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9441	1716239746757	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239747759	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239747759	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9403	1716239747759	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239748761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239748761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9403	1716239748761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239749763	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239749763	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9403	1716239749763	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239750765	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239750765	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9410999999999998	1716239750765	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239751767	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239751767	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9410999999999998	1716239751767	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239752769	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239752769	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9410999999999998	1716239752769	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239753770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239753770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9405	1716239753770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239754772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239754772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9405	1716239754772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239755774	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239755774	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9405	1716239755774	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239756776	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239756776	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.939	1716239756776	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239757778	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239757778	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.939	1716239757778	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239758780	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239758780	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.939	1716239758780	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239759782	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239759782	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9413	1716239759782	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239760784	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239760784	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9413	1716239760784	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239761785	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239761785	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9413	1716239761785	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239762787	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239762787	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9419000000000002	1716239762787	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239763790	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239763790	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9419000000000002	1716239763790	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239764792	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239764792	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9419000000000002	1716239764792	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239765793	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239765793	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9404000000000001	1716239765793	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239766795	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239766795	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9404000000000001	1716239766795	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239767797	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239767797	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9404000000000001	1716239767797	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239768799	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239768799	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9410999999999998	1716239768799	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239769800	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239769800	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9410999999999998	1716239769800	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239770802	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239770802	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9410999999999998	1716239770802	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239771804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239771804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9410999999999998	1716239771804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239772806	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239772806	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9410999999999998	1716239772806	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239773808	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239773808	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9410999999999998	1716239773808	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239774810	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239774810	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9424000000000001	1716239774810	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239775812	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239775812	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9424000000000001	1716239775812	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239776814	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239776814	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9424000000000001	1716239776814	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239777816	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239777816	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9405	1716239777816	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239778818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239778818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9405	1716239778818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239779821	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239779821	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9405	1716239779821	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239780823	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239780823	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9410999999999998	1716239780823	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239781826	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239781826	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9410999999999998	1716239781826	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239782827	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239782827	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9410999999999998	1716239782827	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239783829	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239783829	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9425999999999999	1716239783829	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239784831	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239784831	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9425999999999999	1716239784831	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239785833	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239785833	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9425999999999999	1716239785833	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239786834	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239786834	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9413	1716239786834	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239787836	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239787836	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9413	1716239787836	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239788838	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239788838	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9413	1716239788838	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239789840	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239789840	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9435	1716239789840	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239769821	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239770816	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239771818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239772828	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239773824	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239774832	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239775836	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239776831	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239777838	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239778840	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239779835	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239780848	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239781839	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239782848	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239783849	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239784852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239785853	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239786849	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239787857	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239788852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239789863	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239790864	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239791861	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239792867	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239793870	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239794870	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239795874	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239796867	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239797871	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239798878	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239799881	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239800880	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239801884	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239802877	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239803887	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239804880	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239805890	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239806892	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239807887	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239808896	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239809890	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239810900	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239811897	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239827910	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239827910	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9459000000000002	1716239827910	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239828912	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239828912	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9474	1716239828912	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239829914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239829914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9474	1716239829914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239830916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239830916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9474	1716239830916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239831917	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239831917	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9458	1716239831917	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239832919	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239832919	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9458	1716239832919	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239833921	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239833921	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9458	1716239833921	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239834923	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239790842	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239790842	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9435	1716239790842	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239791844	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239791844	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9435	1716239791844	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239792846	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239792846	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.941	1716239792846	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239793848	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239793848	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.941	1716239793848	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239794850	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239794850	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.941	1716239794850	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239795851	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239795851	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9429	1716239795851	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239796853	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239796853	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9429	1716239796853	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239797855	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239797855	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9429	1716239797855	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239798857	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239798857	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9444000000000001	1716239798857	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239799858	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239799858	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9444000000000001	1716239799858	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239800860	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239800860	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9444000000000001	1716239800860	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239801862	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239801862	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9430999999999998	1716239801862	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239802864	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239802864	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9430999999999998	1716239802864	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239803866	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239803866	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9430999999999998	1716239803866	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239804867	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239804867	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9470999999999998	1716239804867	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239805869	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239805869	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9470999999999998	1716239805869	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239806871	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239806871	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9470999999999998	1716239806871	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239807873	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239807873	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9444000000000001	1716239807873	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239808875	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239808875	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9444000000000001	1716239808875	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239809876	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6000000000000005	1716239809876	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9444000000000001	1716239809876	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239810878	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	7.9	1716239810878	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9452	1716239810878	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239811880	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.2	1716239811880	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9452	1716239811880	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239830936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239831939	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239832933	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239833942	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239834923	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9485999999999999	1716239834923	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239834937	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239835925	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239835925	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9485999999999999	1716239835925	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239835949	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239836927	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239836927	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9485999999999999	1716239836927	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239836949	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239837930	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239837930	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9475	1716239837930	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239837945	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239838932	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239838932	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9475	1716239838932	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239838954	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239839934	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239839934	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9475	1716239839934	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239839947	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239840936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239840936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9485999999999999	1716239840936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239840958	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239841938	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239841938	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9485999999999999	1716239841938	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239841954	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239842940	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239842940	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9485999999999999	1716239842940	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239842961	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239843942	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239843942	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9492	1716239843942	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239843964	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239844943	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239844943	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9492	1716239844943	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239844957	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239845945	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239845945	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9492	1716239845945	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239845966	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239846947	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239846947	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9492	1716239846947	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239846961	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239847949	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239847949	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9492	1716239847949	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239847970	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716239848951	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239848951	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9492	1716239848951	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239848974	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239849966	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239850977	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239851970	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239852981	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239853983	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239854975	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239855985	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239856986	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239857991	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239858991	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239860002	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239860995	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239862004	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239862997	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239864006	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239865007	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239866013	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239867017	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239868015	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239869022	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239870028	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239871027	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239872030	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239873030	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239874033	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239875031	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239876029	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239877042	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239878038	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239879046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239880041	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239881052	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239882054	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239883049	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239884059	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239885058	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239886062	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239887067	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239888069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239889069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239890069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239891072	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239892078	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239893077	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239894083	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239895089	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239896087	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239897088	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239898089	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239899096	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239900100	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239901107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239902104	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239903105	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239904107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239905110	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239906111	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239907115	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239908107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239909117	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239910115	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239911125	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239912128	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239913121	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239849953	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239849953	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9490999999999998	1716239849953	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239850955	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239850955	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9490999999999998	1716239850955	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239851956	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239851956	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9490999999999998	1716239851956	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239852958	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239852958	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9498	1716239852958	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239853960	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239853960	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9498	1716239853960	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239854962	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239854962	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9498	1716239854962	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239855964	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239855964	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9499000000000002	1716239855964	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239856966	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239856966	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9499000000000002	1716239856966	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239857968	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239857968	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9499000000000002	1716239857968	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239858970	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239858970	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9502000000000002	1716239858970	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239859972	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239859972	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9502000000000002	1716239859972	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239860975	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239860975	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9502000000000002	1716239860975	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239861977	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239861977	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9453	1716239861977	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239862979	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239862979	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9453	1716239862979	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239863982	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239863982	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9453	1716239863982	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239864985	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239864985	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9450999999999998	1716239864985	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239865989	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239865989	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9450999999999998	1716239865989	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239866991	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239866991	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9450999999999998	1716239866991	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239867993	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239867993	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9461	1716239867993	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239868996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239868996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9461	1716239868996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239869998	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239869998	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9461	1716239869998	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239871000	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239871000	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9453	1716239871000	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239872003	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239872003	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9453	1716239872003	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239873005	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239873005	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9453	1716239873005	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239874006	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239874006	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9475	1716239874006	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239875008	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239875008	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9475	1716239875008	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239876011	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239876011	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9475	1716239876011	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239877014	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239877014	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9473	1716239877014	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239878016	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239878016	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9473	1716239878016	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716239879018	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239879018	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9479000000000002	1716239879018	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239880021	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239880021	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9479000000000002	1716239880021	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239881024	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239881024	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9479000000000002	1716239881024	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239882026	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239882026	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.947	1716239882026	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239883029	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239883029	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.947	1716239883029	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239884032	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239884032	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.947	1716239884032	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239885034	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239885034	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9474	1716239885034	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239886036	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239886036	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9474	1716239886036	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239887039	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239887039	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9474	1716239887039	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239888041	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239888041	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.947	1716239888041	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239889044	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239889044	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.947	1716239889044	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239890046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239890046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.947	1716239890046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239891049	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239891049	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.948	1716239891049	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239892051	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239892051	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.948	1716239892051	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239893053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239893053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.948	1716239893053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239894057	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239894057	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9461	1716239894057	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239895059	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239895059	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9461	1716239895059	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239896061	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239896061	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9461	1716239896061	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239897063	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239897063	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9465	1716239897063	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239898068	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239898068	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9465	1716239898068	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239899070	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239899070	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9465	1716239899070	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239900073	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716239900073	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9463	1716239900073	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239901075	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239901075	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9463	1716239901075	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239902077	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239902077	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9463	1716239902077	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239903079	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239903079	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9484000000000001	1716239903079	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239904081	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239904081	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9484000000000001	1716239904081	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239905083	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239905083	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9484000000000001	1716239905083	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239906085	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239906085	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9487	1716239906085	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239907088	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239907088	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9487	1716239907088	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239908090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239908090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9487	1716239908090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239909094	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239909094	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9465	1716239909094	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239910096	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239910096	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9465	1716239910096	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239911099	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239911099	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9465	1716239911099	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239912101	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239912101	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.948	1716239912101	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239913104	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239913104	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.948	1716239913104	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239914107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239914107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.948	1716239914107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239915110	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239915110	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9502000000000002	1716239915110	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239916112	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239916112	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9502000000000002	1716239916112	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239917115	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239917115	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9502000000000002	1716239917115	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239918117	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239918117	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9496	1716239918117	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239919119	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239919119	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9496	1716239919119	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239920121	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239920121	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9496	1716239920121	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239921123	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239921123	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9485999999999999	1716239921123	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239922126	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239922126	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9485999999999999	1716239922126	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239923128	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239923128	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9485999999999999	1716239923128	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239924130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239924130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9498	1716239924130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239925132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239925132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9498	1716239925132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239926134	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239926134	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9498	1716239926134	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239927137	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239927137	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9505	1716239927137	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239928139	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239928139	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9505	1716239928139	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239929142	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239929142	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9505	1716239929142	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239930144	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239930144	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9504000000000001	1716239930144	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239931147	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239931147	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9504000000000001	1716239931147	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239932151	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239932151	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9504000000000001	1716239932151	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240293012	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240293012	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9690999999999999	1716240293012	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240294015	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240294015	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9690999999999999	1716240294015	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240295017	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239914134	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239915140	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239916138	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239917141	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239918143	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239919143	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239920140	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239921147	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239922142	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239923154	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239924156	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239925159	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239926160	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239927159	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239928165	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239929172	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239930163	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239931173	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239932170	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239933153	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239933153	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.952	1716239933153	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239933178	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239934155	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239934155	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.952	1716239934155	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239934179	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239935156	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239935156	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.952	1716239935156	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239935174	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716239936158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239936158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9478	1716239936158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239936188	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239937161	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239937161	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9478	1716239937161	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239937187	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239938163	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239938163	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9478	1716239938163	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239938181	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239939165	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239939165	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9499000000000002	1716239939165	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239939193	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239940169	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239940169	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9499000000000002	1716239940169	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239940188	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239941171	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239941171	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9499000000000002	1716239941171	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239941197	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239942174	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239942174	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9506	1716239942174	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239942200	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239943176	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239943176	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9506	1716239943176	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239943192	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239944178	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239944178	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9506	1716239944178	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239945180	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239945180	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.951	1716239945180	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239946183	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239946183	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.951	1716239946183	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239947185	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239947185	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.951	1716239947185	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239948187	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239948187	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9512	1716239948187	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239949189	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239949189	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9512	1716239949189	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239950192	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239950192	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9512	1716239950192	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239951194	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239951194	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.951	1716239951194	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239952197	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239952197	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.951	1716239952197	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239953200	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239953200	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.951	1716239953200	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239954203	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239954203	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9507	1716239954203	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239955207	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239955207	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9507	1716239955207	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239956209	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239956209	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9507	1716239956209	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239957212	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239957212	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9499000000000002	1716239957212	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239958214	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239958214	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9499000000000002	1716239958214	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239959216	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239959216	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9499000000000002	1716239959216	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239960218	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239960218	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.951	1716239960218	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239961220	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239961220	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.951	1716239961220	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239962222	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239962222	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.951	1716239962222	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239963224	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239963224	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9510999999999998	1716239963224	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239964227	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239964227	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9510999999999998	1716239964227	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239965229	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239965229	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9510999999999998	1716239965229	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239944206	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239945203	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239946212	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239947202	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239948212	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239949216	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239950212	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239951220	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239952214	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239953223	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239954227	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239955224	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239956235	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239957229	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239958241	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239959242	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239960241	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239961249	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239962246	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239963249	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239964251	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239965250	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239966259	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239967261	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239968262	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239969263	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239970261	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239971271	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239972272	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239973276	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239974278	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239975273	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239976284	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239977288	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239978288	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239979293	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239980284	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239981296	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239982298	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239983294	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239984302	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239985300	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239986313	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239987310	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239988307	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239989316	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239990320	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239991325	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239992328	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239993328	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239994328	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239995331	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239996335	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239997330	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239998338	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716239999340	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240000343	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240001344	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240002347	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240003353	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240004354	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240005352	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240006357	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240007362	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240008361	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239966232	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239966232	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9527999999999999	1716239966232	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239967234	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239967234	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9527999999999999	1716239967234	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239968236	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239968236	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9527999999999999	1716239968236	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239969238	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239969238	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9529	1716239969238	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239970241	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239970241	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9529	1716239970241	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239971244	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239971244	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9529	1716239971244	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239972246	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239972246	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9498	1716239972246	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239973251	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239973251	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9498	1716239973251	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239974253	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239974253	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9498	1716239974253	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239975256	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239975256	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9505	1716239975256	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239976258	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239976258	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9505	1716239976258	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239977261	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239977261	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9505	1716239977261	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239978264	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239978264	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9527999999999999	1716239978264	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239979266	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239979266	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9527999999999999	1716239979266	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239980268	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239980268	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9527999999999999	1716239980268	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716239981270	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239981270	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.953	1716239981270	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239982273	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239982273	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.953	1716239982273	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239983275	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239983275	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.953	1716239983275	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239984277	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239984277	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9550999999999998	1716239984277	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239985279	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239985279	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9550999999999998	1716239985279	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239986283	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239986283	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9550999999999998	1716239986283	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239987286	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239987286	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.954	1716239987286	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239988289	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239988289	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.954	1716239988289	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239989290	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716239989290	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.954	1716239989290	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239990293	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239990293	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9535	1716239990293	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239991295	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239991295	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9535	1716239991295	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239992298	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239992298	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9535	1716239992298	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239993300	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239993300	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9544000000000001	1716239993300	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239994302	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239994302	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9544000000000001	1716239994302	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239995304	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239995304	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9544000000000001	1716239995304	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239996307	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239996307	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9547999999999999	1716239996307	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716239997310	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716239997310	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9547999999999999	1716239997310	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716239998312	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239998312	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9547999999999999	1716239998312	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716239999314	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716239999314	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9547	1716239999314	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240000317	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240000317	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9547	1716240000317	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240001319	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240001319	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9547	1716240001319	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240002322	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240002322	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9553	1716240002322	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240003325	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240003325	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9553	1716240003325	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240004327	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240004327	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9553	1716240004327	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240005329	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240005329	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9541	1716240005329	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240006331	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240006331	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9541	1716240006331	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240007334	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240007334	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9541	1716240007334	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240008336	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240008336	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9507999999999999	1716240008336	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240009338	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240009338	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9507999999999999	1716240009338	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240010340	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240010340	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9507999999999999	1716240010340	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240011342	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240011342	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9533	1716240011342	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240012345	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240012345	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9533	1716240012345	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240013347	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240013347	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9533	1716240013347	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240014349	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240014349	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9533	1716240014349	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240015354	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240015354	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9533	1716240015354	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240016357	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240016357	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9533	1716240016357	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240017359	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240017359	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9527	1716240017359	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240018361	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240018361	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9527	1716240018361	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240019364	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240019364	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9527	1716240019364	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240020366	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240020366	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9537	1716240020366	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240021368	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240021368	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9537	1716240021368	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240022370	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240022370	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9537	1716240022370	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240023374	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240023374	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9543	1716240023374	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240024376	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240024376	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9543	1716240024376	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240025379	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240025379	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9543	1716240025379	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240026381	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240026381	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9539000000000002	1716240026381	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240027384	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240027384	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9539000000000002	1716240027384	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240028386	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240028386	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9539000000000002	1716240028386	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240029388	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240029388	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9552	1716240029388	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240009362	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240010366	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240011368	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240012363	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240013364	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240014376	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240015379	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240016385	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240017386	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240018382	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240019390	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240020394	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240021393	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240022387	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240023391	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240024404	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240025405	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240026410	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240027403	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240028410	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240029414	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240030416	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240031428	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240032412	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240033422	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240034425	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240035427	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240036427	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240037425	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240038437	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240039441	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240040441	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240041442	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240042450	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240043442	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240044448	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240045452	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240046455	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240047457	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240048451	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240049461	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240050455	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240051470	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240052473	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240293039	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240294041	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240295044	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240296046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240297047	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240298041	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240299051	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240300055	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240301071	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240302066	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240303059	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240304070	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240305073	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240306076	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240307076	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240308070	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240309077	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240310081	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240311077	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240312079	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240313090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240030390	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240030390	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9552	1716240030390	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240031392	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240031392	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9552	1716240031392	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240032395	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240032395	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9555	1716240032395	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240033397	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240033397	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9555	1716240033397	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240034399	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240034399	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9555	1716240034399	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240035401	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240035401	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9535	1716240035401	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240036403	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240036403	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9535	1716240036403	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240037406	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240037406	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9535	1716240037406	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240038408	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240038408	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9533	1716240038408	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240039411	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240039411	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9533	1716240039411	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240040415	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240040415	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9533	1716240040415	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240041417	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240041417	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.952	1716240041417	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240042420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240042420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.952	1716240042420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240043422	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240043422	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.952	1716240043422	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240044424	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240044424	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9487	1716240044424	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240045426	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240045426	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9487	1716240045426	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240046428	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240046428	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9487	1716240046428	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240047430	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240047430	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9510999999999998	1716240047430	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240048433	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240048433	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9510999999999998	1716240048433	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240049436	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.300000000000001	1716240049436	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9510999999999998	1716240049436	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240050439	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240050439	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9509	1716240050439	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240051442	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8	1716240051442	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9509	1716240051442	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240052444	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240052444	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9509	1716240052444	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240053447	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240053447	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9518	1716240053447	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240053473	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240054450	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240054450	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9518	1716240054450	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240054474	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240055452	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240055452	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9518	1716240055452	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240055477	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240056455	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240056455	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9525	1716240056455	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240056481	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240057458	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240057458	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9525	1716240057458	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240057477	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240058460	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240058460	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9525	1716240058460	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240058475	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240059462	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240059462	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9515	1716240059462	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240059486	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240060464	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240060464	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9515	1716240060464	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240060491	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240061466	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240061466	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9515	1716240061466	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240061493	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240062468	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240062468	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9543	1716240062468	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240062486	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240063471	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240063471	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9543	1716240063471	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240063497	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240064473	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240064473	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9543	1716240064473	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240064501	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240065475	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240065475	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9547999999999999	1716240065475	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240065501	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240066477	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240066477	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9547999999999999	1716240066477	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240066503	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240067479	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240067479	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9547999999999999	1716240067479	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240067504	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240068510	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240069509	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240070514	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240071512	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240072509	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240073519	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240074519	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240075521	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240076526	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240077522	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240078529	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240079531	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240080536	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240081537	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240082532	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240083542	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240084548	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240085549	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240086552	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240087545	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240088557	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240089556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240090560	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240091563	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240092558	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240093567	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240094570	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240095571	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240096576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240097579	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240098581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240099575	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240100581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240101585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240102582	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240103596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240104594	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240105600	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240106599	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240107594	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240108606	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240109612	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240110614	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240111612	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240112618	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240113623	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240114617	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240115622	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240116624	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240117619	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240118620	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240119632	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240120633	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240121637	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240122633	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240123641	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240124641	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240125647	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240126651	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240127656	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240128657	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240129656	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240130661	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240131661	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240068481	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240068481	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9510999999999998	1716240068481	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240069483	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240069483	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9510999999999998	1716240069483	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240070486	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240070486	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9510999999999998	1716240070486	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240071488	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240071488	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9535	1716240071488	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240072490	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240072490	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9535	1716240072490	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240073492	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240073492	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9535	1716240073492	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240074494	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240074494	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9554	1716240074494	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240075497	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240075497	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9554	1716240075497	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240076499	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240076499	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9554	1716240076499	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240077501	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240077501	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9544000000000001	1716240077501	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240078503	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240078503	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9544000000000001	1716240078503	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240079506	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240079506	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9544000000000001	1716240079506	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240080508	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240080508	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9536	1716240080508	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240081511	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240081511	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9536	1716240081511	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240082513	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240082513	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9536	1716240082513	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240083516	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.5	1716240083516	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9504000000000001	1716240083516	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240084519	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240084519	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9504000000000001	1716240084519	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240085522	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240085522	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9504000000000001	1716240085522	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240086525	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240086525	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9507	1716240086525	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240087527	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240087527	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9507	1716240087527	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240088529	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240088529	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9507	1716240088529	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240089532	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240089532	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9515	1716240089532	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240090534	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240090534	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9515	1716240090534	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240091537	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240091537	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9515	1716240091537	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240092539	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240092539	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9535	1716240092539	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240093541	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240093541	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9535	1716240093541	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240094543	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240094543	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9535	1716240094543	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240095546	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240095546	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9553	1716240095546	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240096548	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240096548	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9553	1716240096548	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240097551	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240097551	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9553	1716240097551	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240098553	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240098553	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9546	1716240098553	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240099555	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240099555	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9546	1716240099555	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240100558	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240100558	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9546	1716240100558	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240101560	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240101560	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9545	1716240101560	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240102563	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240102563	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9545	1716240102563	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240103567	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240103567	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9545	1716240103567	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240104569	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240104569	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9559000000000002	1716240104569	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240105571	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240105571	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9559000000000002	1716240105571	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240106573	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240106573	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9559000000000002	1716240106573	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240107576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240107576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.956	1716240107576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240108579	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240108579	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.956	1716240108579	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240109581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240109581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.956	1716240109581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240110585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240110585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9553	1716240110585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240111587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240111587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9553	1716240111587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240112589	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240112589	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9553	1716240112589	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240113591	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240113591	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9537	1716240113591	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240114593	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240114593	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9537	1716240114593	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240115596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240115596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9537	1716240115596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240116599	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240116599	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.954	1716240116599	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240117601	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240117601	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.954	1716240117601	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240118603	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240118603	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.954	1716240118603	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240119605	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240119605	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9515	1716240119605	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240120607	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240120607	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9515	1716240120607	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240121609	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240121609	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9515	1716240121609	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240122613	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240122613	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9546	1716240122613	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240123615	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240123615	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9546	1716240123615	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240124617	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240124617	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9546	1716240124617	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240125621	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240125621	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9542	1716240125621	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240126624	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240126624	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9542	1716240126624	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240127627	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240127627	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9542	1716240127627	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240128628	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240128628	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9553	1716240128628	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240129630	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240129630	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9553	1716240129630	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240130633	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240130633	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9553	1716240130633	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240131635	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240131635	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9538	1716240131635	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240132637	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240132637	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9538	1716240132637	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240133639	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240133639	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9538	1716240133639	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240134641	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240134641	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9555	1716240134641	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240135643	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240135643	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9555	1716240135643	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240136647	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240136647	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9555	1716240136647	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240137649	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240137649	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9556	1716240137649	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240138652	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240138652	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9556	1716240138652	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240139655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240139655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9556	1716240139655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240140656	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240140656	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9556	1716240140656	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240141659	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240141659	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9556	1716240141659	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240142661	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240142661	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9556	1716240142661	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240143663	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240143663	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9556	1716240143663	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240144665	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240144665	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9556	1716240144665	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240145668	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240145668	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9556	1716240145668	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240146670	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240146670	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9567999999999999	1716240146670	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240147673	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240147673	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9567999999999999	1716240147673	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240148675	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240148675	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9567999999999999	1716240148675	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240149677	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240149677	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9567999999999999	1716240149677	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240150679	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240150679	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9567999999999999	1716240150679	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240151681	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240151681	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9567999999999999	1716240151681	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240152688	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240152688	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9583	1716240152688	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240153686	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240132654	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240133660	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240134667	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240135671	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240136672	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240137665	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240138678	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240139683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240140683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240141687	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240142688	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240143687	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240144691	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240145693	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240146695	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240147692	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240148702	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240149707	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240150705	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240151707	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240152705	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240153713	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240154715	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240155717	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240156718	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240157721	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240158716	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240159728	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240160733	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240161738	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240162729	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240163740	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240164741	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240165742	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240166742	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240167737	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240168747	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240169747	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240170753	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240171752	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240295017	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9690999999999999	1716240295017	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240296019	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240296019	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9692	1716240296019	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240297022	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240297022	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9692	1716240297022	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240298024	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240298024	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9692	1716240298024	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240299026	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240299026	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9427999999999999	1716240299026	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240300029	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240300029	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9427999999999999	1716240300029	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240301037	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240301037	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9427999999999999	1716240301037	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240302039	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240302039	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9495	1716240302039	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240303041	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240303041	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240153686	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9583	1716240153686	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240154689	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240154689	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9583	1716240154689	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716240155691	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240155691	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9559000000000002	1716240155691	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240156693	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240156693	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9559000000000002	1716240156693	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240157696	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240157696	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9559000000000002	1716240157696	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240158698	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240158698	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9562	1716240158698	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240159701	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240159701	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9562	1716240159701	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240160703	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240160703	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9562	1716240160703	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240161706	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240161706	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9557	1716240161706	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240162708	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240162708	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9557	1716240162708	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240163710	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240163710	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9557	1716240163710	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240164712	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240164712	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9555	1716240164712	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240165714	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240165714	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9555	1716240165714	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240166716	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.5	1716240166716	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9555	1716240166716	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240167719	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240167719	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9575	1716240167719	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240168721	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240168721	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9575	1716240168721	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240169723	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240169723	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9575	1716240169723	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240170725	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240170725	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9564000000000001	1716240170725	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240171726	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240171726	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9564000000000001	1716240171726	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240172729	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240172729	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9564000000000001	1716240172729	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240172748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240173731	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240173731	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9581	1716240173731	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240173758	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240174733	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240174733	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9581	1716240174733	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240175735	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240175735	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9581	1716240175735	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240176737	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240176737	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9586	1716240176737	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240177739	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240177739	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9586	1716240177739	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240178742	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240178742	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9586	1716240178742	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240179745	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240179745	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9595	1716240179745	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240180748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240180748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9595	1716240180748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240181749	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240181749	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9595	1716240181749	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240182751	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240182751	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9596	1716240182751	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240183753	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240183753	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9596	1716240183753	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240184756	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240184756	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9596	1716240184756	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240185758	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240185758	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9579000000000002	1716240185758	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240186761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240186761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9579000000000002	1716240186761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240187763	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240187763	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9579000000000002	1716240187763	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240188766	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240188766	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9587	1716240188766	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240189768	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240189768	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9587	1716240189768	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240190770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240190770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9587	1716240190770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240191772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240191772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9541	1716240191772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240192774	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240192774	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9541	1716240192774	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240193776	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240193776	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9541	1716240193776	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240194778	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240194778	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9565	1716240194778	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240195781	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240174760	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240175764	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240176761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240177758	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240178766	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240179772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240180774	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240181777	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240182771	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240183781	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240184783	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240185786	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240186789	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240187791	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240188791	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240189794	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240190800	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240191801	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240192793	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240193803	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240194804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240195808	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240196810	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240197802	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240198813	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240199818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240200819	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240201821	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240202815	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240203823	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240204829	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240205831	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240206836	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240207832	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240208838	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240209842	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240210846	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240211846	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240212849	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240213852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240214855	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240215856	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240216858	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240217864	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240218855	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240219864	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240220869	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240221870	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240222867	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240223873	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240224881	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240225881	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240226883	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240227877	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240228881	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240229892	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240230892	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240231894	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240232897	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240233901	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240234902	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240235905	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240236906	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240237902	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240238910	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240195781	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9565	1716240195781	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240196783	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240196783	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9565	1716240196783	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240197785	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240197785	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.956	1716240197785	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240198787	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240198787	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.956	1716240198787	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240199790	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240199790	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.956	1716240199790	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240200792	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240200792	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9573	1716240200792	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240201794	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240201794	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9573	1716240201794	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240202797	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240202797	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9573	1716240202797	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240203799	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240203799	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9590999999999998	1716240203799	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240204801	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240204801	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9590999999999998	1716240204801	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240205804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240205804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9590999999999998	1716240205804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240206807	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240206807	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9586	1716240206807	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240207809	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240207809	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9586	1716240207809	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240208811	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240208811	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9586	1716240208811	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240209814	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240209814	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9594	1716240209814	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240210817	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240210817	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9594	1716240210817	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240211820	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240211820	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9594	1716240211820	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240212822	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240212822	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9570999999999998	1716240212822	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240213825	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240213825	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9570999999999998	1716240213825	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240214827	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240214827	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9570999999999998	1716240214827	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240215829	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240215829	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9603	1716240215829	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240216831	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240216831	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9603	1716240216831	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240217834	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240217834	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9603	1716240217834	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240218837	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240218837	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9605	1716240218837	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240219838	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240219838	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9605	1716240219838	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240220842	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240220842	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9605	1716240220842	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240221844	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240221844	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9594	1716240221844	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240222847	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240222847	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9594	1716240222847	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240223849	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240223849	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9594	1716240223849	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240224852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240224852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9595	1716240224852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240225854	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240225854	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9595	1716240225854	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240226857	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240226857	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9595	1716240226857	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240227859	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240227859	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9557	1716240227859	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240228862	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240228862	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9557	1716240228862	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240229864	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240229864	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9557	1716240229864	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240230866	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240230866	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9572	1716240230866	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240231868	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240231868	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9572	1716240231868	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240232871	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240232871	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9572	1716240232871	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240233873	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240233873	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9545	1716240233873	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240234876	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240234876	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9545	1716240234876	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240235878	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240235878	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9545	1716240235878	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240236880	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240236880	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9566	1716240236880	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240237882	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240237882	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9566	1716240237882	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240238885	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240238885	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9566	1716240238885	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240239887	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240239887	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.961	1716240239887	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240240890	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240240890	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.961	1716240240890	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240241893	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240241893	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.961	1716240241893	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240242895	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240242895	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.96	1716240242895	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240243897	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240243897	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.96	1716240243897	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240244899	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240244899	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.96	1716240244899	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240245904	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240245904	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9647000000000001	1716240245904	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240246906	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240246906	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9647000000000001	1716240246906	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240247909	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240247909	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9647000000000001	1716240247909	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240248911	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240248911	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9618	1716240248911	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240249914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240249914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9618	1716240249914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240250916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.4	1716240250916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9618	1716240250916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240251918	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240251918	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9619000000000002	1716240251918	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240252920	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.1	1716240252920	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9619000000000002	1716240252920	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240253923	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240253923	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9619000000000002	1716240253923	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240254925	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240254925	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9604000000000001	1716240254925	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240255926	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240255926	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9604000000000001	1716240255926	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240256929	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240256929	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9604000000000001	1716240256929	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240257931	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.6	1716240257931	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9633	1716240257931	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240258935	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240258935	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9633	1716240258935	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240259936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240239914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240240916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240241918	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240242914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240243924	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240244928	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240245929	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240246934	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240247937	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240248938	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240249941	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240250943	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240251944	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240252937	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240253950	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240254953	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240255953	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240256954	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240257949	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240258962	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240259960	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240260964	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240261967	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240262974	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240263972	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240264972	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240265976	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240266982	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240267980	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240268981	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240269979	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240270991	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240271991	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240272992	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240274003	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240274997	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240275992	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240277000	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240278004	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240279007	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240280015	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240281017	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240282007	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240283015	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240284018	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240285023	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240286022	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240287015	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240288026	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240289028	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240290033	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240291032	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240292026	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9495	1716240303041	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240304044	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240304044	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9495	1716240304044	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240305046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240305046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9592	1716240305046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240306048	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240306048	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9592	1716240306048	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240307050	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240307050	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240259936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9633	1716240259936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240260939	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240260939	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9633	1716240260939	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240261941	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240261941	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9633	1716240261941	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240262943	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240262943	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9633	1716240262943	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240263945	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240263945	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.956	1716240263945	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240264947	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240264947	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.956	1716240264947	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240265949	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240265949	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.956	1716240265949	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240266952	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240266952	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9596	1716240266952	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240267954	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240267954	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9596	1716240267954	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240268956	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240268956	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9596	1716240268956	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240269958	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240269958	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9636	1716240269958	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240270961	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240270961	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9636	1716240270961	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240271963	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240271963	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9636	1716240271963	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240272966	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240272966	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9656	1716240272966	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240273969	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240273969	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9656	1716240273969	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240274971	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240274971	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9656	1716240274971	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240275973	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240275973	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9662	1716240275973	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240276976	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240276976	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9662	1716240276976	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240277978	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240277978	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9662	1716240277978	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240278980	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240278980	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9666	1716240278980	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240279983	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240279983	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9666	1716240279983	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240280985	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240280985	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9666	1716240280985	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240281987	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240281987	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9667999999999999	1716240281987	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240282989	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240282989	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9667999999999999	1716240282989	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240283992	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240283992	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9667999999999999	1716240283992	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240284994	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240284994	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.967	1716240284994	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240285996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240285996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.967	1716240285996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240286998	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240286998	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.967	1716240286998	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240288000	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240288000	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9675	1716240288000	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240289002	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240289002	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9675	1716240289002	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240290005	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240290005	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9675	1716240290005	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240291007	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240291007	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9690999999999999	1716240291007	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240292010	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240292010	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9690999999999999	1716240292010	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9592	1716240307050	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240308053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240308053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9646	1716240308053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240309055	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240309055	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9646	1716240309055	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240310057	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240310057	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9646	1716240310057	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240311060	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240311060	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9676	1716240311060	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240312062	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240312062	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9676	1716240312062	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240313064	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240313064	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9676	1716240313064	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240314066	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240314066	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.969	1716240314066	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240314090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240315069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240315069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.969	1716240315069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240315094	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240316071	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240316071	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.969	1716240316071	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240316098	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240317095	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240318103	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240319109	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240320109	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240321113	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240322107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240323113	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240324125	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240325120	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240326126	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240327127	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240328119	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240329130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240330131	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240331133	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240332137	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240333132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240334134	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240335146	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240336149	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240337142	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240338153	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240339148	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240340157	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240341162	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240342154	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240343166	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240344164	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240345170	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240346172	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240347170	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240348179	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240349178	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240350182	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240351188	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240352189	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240317073	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240317073	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9694	1716240317073	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240318078	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240318078	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9694	1716240318078	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240319080	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240319080	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9694	1716240319080	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716240320083	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240320083	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9703	1716240320083	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240321087	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240321087	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9703	1716240321087	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240322090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240322090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9703	1716240322090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240323092	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240323092	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9718	1716240323092	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240324095	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240324095	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9718	1716240324095	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240325097	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240325097	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9718	1716240325097	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240326099	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240326099	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9718	1716240326099	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240327101	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240327101	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9718	1716240327101	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240328103	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240328103	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9718	1716240328103	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240329105	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240329105	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9718	1716240329105	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240330107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240330107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9718	1716240330107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240331109	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240331109	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9718	1716240331109	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240332111	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240332111	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.97	1716240332111	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240333113	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240333113	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.97	1716240333113	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240334116	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240334116	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.97	1716240334116	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240335120	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240335120	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9706	1716240335120	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240336123	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240336123	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9706	1716240336123	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240337125	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240337125	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9706	1716240337125	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240338127	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240338127	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9687000000000001	1716240338127	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240339130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240339130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9687000000000001	1716240339130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240340132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240340132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9687000000000001	1716240340132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240341135	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240341135	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9706	1716240341135	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240342136	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240342136	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9706	1716240342136	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240343138	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240343138	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9706	1716240343138	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240344141	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240344141	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9714	1716240344141	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240345144	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240345144	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9714	1716240345144	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240346146	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240346146	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9714	1716240346146	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240347148	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240347148	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9721	1716240347148	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240348151	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240348151	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9721	1716240348151	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240349153	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.9	1716240349153	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9721	1716240349153	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240350155	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240350155	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9713	1716240350155	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240351158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240351158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9713	1716240351158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240352160	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240352160	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9713	1716240352160	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240353162	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240353162	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9712	1716240353162	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240353193	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240354165	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240354165	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9712	1716240354165	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240354192	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240355168	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240355168	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9712	1716240355168	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240355196	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240356170	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240356170	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9721	1716240356170	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240356200	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240357173	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240357173	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9721	1716240357173	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240357201	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240358175	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240358175	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9721	1716240358175	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240359177	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240359177	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9733	1716240359177	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240360179	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240360179	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9733	1716240360179	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240361180	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240361180	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9733	1716240361180	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240362183	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240362183	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9744000000000002	1716240362183	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240363185	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240363185	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9744000000000002	1716240363185	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240364188	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240364188	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9744000000000002	1716240364188	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240365190	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240365190	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9735999999999998	1716240365190	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240366193	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240366193	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9735999999999998	1716240366193	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240367195	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240367195	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9735999999999998	1716240367195	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240368197	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240368197	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9744000000000002	1716240368197	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240369199	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240369199	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9744000000000002	1716240369199	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716240370201	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240370201	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9744000000000002	1716240370201	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240371203	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240371203	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9758	1716240371203	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240372206	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240372206	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9758	1716240372206	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240373209	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240373209	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9758	1716240373209	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240374210	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240374210	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.97	1716240374210	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240375213	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240375213	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.97	1716240375213	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240376216	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240376216	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.97	1716240376216	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240377218	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240377218	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9716	1716240377218	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240378220	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240378220	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9716	1716240378220	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240379222	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240358190	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240359205	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240360207	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240361204	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240362208	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240363203	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240364216	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240365214	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240366221	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240367221	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240368223	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240369225	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240370226	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240371228	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240372223	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240373238	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240374236	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240375232	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240376243	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240377237	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240378249	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240379244	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240380252	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240381252	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240382254	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240383258	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240384259	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240385260	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240386267	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240387266	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240388264	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240389263	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240390273	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240391277	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240392277	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240393276	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240394284	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240395285	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240396288	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240397291	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240398297	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240399290	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240400298	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240401300	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240402308	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240403296	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240404306	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240405307	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240406320	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240407317	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240408315	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240409317	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240410313	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240411324	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240412327	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240413328	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240414332	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240415334	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240416335	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240417331	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240418339	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240419342	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240420345	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240421348	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240422342	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240379222	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9716	1716240379222	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240380224	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240380224	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9712	1716240380224	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240381227	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240381227	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9712	1716240381227	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240382229	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240382229	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9712	1716240382229	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240383232	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240383232	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9710999999999999	1716240383232	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240384233	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240384233	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9710999999999999	1716240384233	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240385236	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240385236	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9710999999999999	1716240385236	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240386238	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240386238	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9726	1716240386238	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240387241	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240387241	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9726	1716240387241	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240388243	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240388243	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9726	1716240388243	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240389245	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240389245	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9723	1716240389245	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240390248	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240390248	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9723	1716240390248	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240391252	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240391252	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9723	1716240391252	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240392254	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240392254	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9762	1716240392254	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240393256	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240393256	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9762	1716240393256	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240394258	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240394258	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9762	1716240394258	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240395260	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240395260	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.981	1716240395260	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240396262	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240396262	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.981	1716240396262	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240397264	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240397264	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.981	1716240397264	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240398267	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240398267	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9812	1716240398267	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240399270	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240399270	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9812	1716240399270	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240400272	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240400272	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9812	1716240400272	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240401274	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240401274	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9799	1716240401274	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240402276	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240402276	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9799	1716240402276	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240403278	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240403278	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9799	1716240403278	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240404281	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240404281	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9788	1716240404281	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240405283	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240405283	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9788	1716240405283	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240406285	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240406285	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9788	1716240406285	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240407289	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240407289	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9786	1716240407289	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240408291	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240408291	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9786	1716240408291	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240409293	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240409293	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9786	1716240409293	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240410295	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240410295	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9755999999999998	1716240410295	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240411298	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240411298	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9755999999999998	1716240411298	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240412300	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240412300	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9755999999999998	1716240412300	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240413302	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240413302	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9764000000000002	1716240413302	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240414304	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240414304	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9764000000000002	1716240414304	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240415306	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240415306	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9764000000000002	1716240415306	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240416309	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240416309	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9766	1716240416309	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240417311	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240417311	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9766	1716240417311	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240418314	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240418314	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9766	1716240418314	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240419316	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240419316	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9772	1716240419316	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240420318	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240420318	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9772	1716240420318	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240421321	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240421321	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9772	1716240421321	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240422323	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240422323	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9768	1716240422323	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240423325	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240423325	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9768	1716240423325	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240424328	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240424328	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9768	1716240424328	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240425331	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240425331	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9787000000000001	1716240425331	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240426333	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240426333	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9787000000000001	1716240426333	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240427336	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240427336	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9787000000000001	1716240427336	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240428338	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240428338	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.978	1716240428338	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240429340	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240429340	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.978	1716240429340	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240430342	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240430342	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.978	1716240430342	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240431344	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240431344	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9799	1716240431344	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240432347	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240432347	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9799	1716240432347	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240433349	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240433349	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9799	1716240433349	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240434351	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240434351	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9786	1716240434351	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240435354	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240435354	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9786	1716240435354	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240436356	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240436356	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9786	1716240436356	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240437358	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240437358	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9801	1716240437358	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240438360	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240438360	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9801	1716240438360	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240439362	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240439362	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9801	1716240439362	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240440365	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240440365	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9809	1716240440365	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240441367	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.9	1716240441367	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9809	1716240441367	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240442369	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240442369	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9809	1716240442369	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240443372	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240423350	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240424359	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240425356	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240426362	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240427360	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240428364	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240429361	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240430360	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240431370	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240432365	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240433376	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240434378	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240435378	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240436383	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240437375	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240438383	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240439381	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240440385	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240441393	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240442394	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240443399	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240444401	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240445405	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240446396	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240447400	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240448406	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240449416	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240450414	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240451418	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240452412	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240453421	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240454417	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240455427	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240456430	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240457426	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240458434	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240459426	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240460440	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240461440	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240462434	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240463445	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240464449	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240465451	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240466457	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240467447	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240468457	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240469464	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240470464	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240471466	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240472467	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240473473	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240474470	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240475476	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240476476	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240477470	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240478472	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240479482	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240480482	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240481486	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240482481	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240483491	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240484490	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240485496	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240486501	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240487500	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240443372	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9839	1716240443372	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240444374	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240444374	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9839	1716240444374	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240445377	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240445377	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9839	1716240445377	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240446379	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240446379	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9779	1716240446379	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240447381	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240447381	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9779	1716240447381	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240448384	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240448384	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9779	1716240448384	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240449387	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240449387	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9775	1716240449387	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240450389	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240450389	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9775	1716240450389	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240451391	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240451391	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9775	1716240451391	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240452394	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240452394	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9810999999999999	1716240452394	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240453396	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240453396	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9810999999999999	1716240453396	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240454399	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240454399	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9810999999999999	1716240454399	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240455401	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240455401	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9821	1716240455401	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240456403	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240456403	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9821	1716240456403	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240457405	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240457405	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9821	1716240457405	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240458407	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240458407	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9832	1716240458407	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240459409	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240459409	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9832	1716240459409	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240460412	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240460412	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9832	1716240460412	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240461414	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240461414	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9847000000000001	1716240461414	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240462417	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240462417	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9847000000000001	1716240462417	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240463420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240463420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9847000000000001	1716240463420	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240464422	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240464422	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9739	1716240464422	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240465425	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240465425	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9739	1716240465425	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240466427	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240466427	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9739	1716240466427	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240467430	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240467430	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9763	1716240467430	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240468432	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240468432	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9763	1716240468432	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240469434	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240469434	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9763	1716240469434	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240470436	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240470436	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9849	1716240470436	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240471439	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240471439	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9849	1716240471439	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240472441	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240472441	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9849	1716240472441	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240473443	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240473443	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9904000000000002	1716240473443	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240474445	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240474445	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9904000000000002	1716240474445	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240475447	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240475447	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	1.9904000000000002	1716240475447	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240476450	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240476450	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0011	1716240476450	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240477452	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240477452	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0011	1716240477452	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240478455	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240478455	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0011	1716240478455	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240479457	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240479457	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.003	1716240479457	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240480459	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240480459	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.003	1716240480459	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240481461	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240481461	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.003	1716240481461	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240482463	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240482463	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0088	1716240482463	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240483465	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240483465	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0088	1716240483465	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240484468	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240484468	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0088	1716240484468	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240485470	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240485470	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0093	1716240485470	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240486472	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240486472	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0093	1716240486472	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240487475	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240487475	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0093	1716240487475	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240488476	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.2	1716240488476	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.017	1716240488476	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240489479	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.5	1716240489479	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.017	1716240489479	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240490481	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240490481	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.017	1716240490481	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240491483	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240491483	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0222	1716240491483	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240492486	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240492486	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0222	1716240492486	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240493488	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240493488	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0222	1716240493488	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240494490	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240494490	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0229	1716240494490	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240495493	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240495493	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0229	1716240495493	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240496495	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240496495	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0229	1716240496495	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240497497	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240497497	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0262000000000002	1716240497497	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240498499	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240498499	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0262000000000002	1716240498499	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240499502	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240499502	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0262000000000002	1716240499502	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240500504	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240500504	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0349	1716240500504	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240501506	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240501506	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0349	1716240501506	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240502509	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240502509	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0349	1716240502509	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240503511	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240503511	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0392	1716240503511	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240504515	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240504515	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0392	1716240504515	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240505518	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240505518	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0392	1716240505518	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240506521	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240506521	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.043	1716240506521	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240507523	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240488504	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240489504	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240490507	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240491510	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240492502	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240493506	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240494515	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240495515	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240496521	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240497516	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240498524	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240499529	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240500529	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240501533	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240502535	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240503540	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240504541	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240505543	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240506549	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240507548	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240508542	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240509556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240510556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240511550	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240512554	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240513556	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240514569	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240515567	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240516571	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240517571	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240518576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240519576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240520580	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240521583	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240522581	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240523578	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240524587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240525591	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240526593	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240527599	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240528593	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240529604	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240530605	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240531607	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240532601	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240507523	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.043	1716240507523	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240508526	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240508526	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.043	1716240508526	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240509528	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240509528	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0414	1716240509528	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	100	1716240510530	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240510530	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0414	1716240510530	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240511532	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240511532	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0414	1716240511532	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240512534	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240512534	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0412	1716240512534	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240513537	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240513537	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0412	1716240513537	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240514539	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240514539	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0412	1716240514539	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240515542	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240515542	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0425999999999997	1716240515542	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240516544	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240516544	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0425999999999997	1716240516544	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240517546	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240517546	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0425999999999997	1716240517546	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240518549	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240518549	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0443	1716240518549	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240519551	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240519551	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0443	1716240519551	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240520553	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240520553	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0443	1716240520553	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240521555	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240521555	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0424	1716240521555	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240522557	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240522557	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0424	1716240522557	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240523559	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240523559	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0424	1716240523559	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240524562	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240524562	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0224	1716240524562	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240525564	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240525564	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0224	1716240525564	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240526567	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240526567	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0224	1716240526567	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240527569	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240527569	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0282999999999998	1716240527569	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240528573	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240528573	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0282999999999998	1716240528573	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240529576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240529576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0282999999999998	1716240529576	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240530578	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240530578	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0282	1716240530578	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240531580	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240531580	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0282	1716240531580	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240532582	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240532582	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0282	1716240532582	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240533585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240533585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0289	1716240533585	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240533611	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240534587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.7	1716240534587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0289	1716240534587	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240534612	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240535589	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240535589	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0289	1716240535589	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240535616	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240536592	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240536592	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0318	1716240536592	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240536611	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240537594	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240537594	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0318	1716240537594	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240537613	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240538596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240538596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0318	1716240538596	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240538622	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240539598	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240539598	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0322	1716240539598	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240539624	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240540601	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240540601	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0322	1716240540601	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240540626	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240541603	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240541603	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0322	1716240541603	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240541630	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240542605	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240542605	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0332	1716240542605	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240542625	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240543607	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240543607	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0332	1716240543607	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240543637	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240544609	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240544609	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0332	1716240544609	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240544632	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240545612	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240545612	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0315	1716240545612	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240545642	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240546640	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240547646	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240548645	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240549641	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240550652	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240551654	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240552649	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240553658	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240554654	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240555662	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240556663	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240557662	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240558666	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240559662	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240560674	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240561674	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240562676	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240563671	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240564674	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240565682	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240566683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240567687	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240568681	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240569684	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240570693	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240571696	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240572701	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240573692	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240574699	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240575708	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240576710	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240577713	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240578713	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240579705	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240580709	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240581716	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240582716	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240583724	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240584722	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240585732	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240586734	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240587728	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240588738	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240589736	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240590744	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240591745	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240592746	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240593753	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240594744	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240595753	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240596755	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240597748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240598761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240599752	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240600764	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240601770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240602768	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240603771	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240604765	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240605779	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240606779	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240607782	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240608783	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240609781	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240546614	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240546614	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0315	1716240546614	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240547616	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240547616	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0315	1716240547616	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240548620	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240548620	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.032	1716240548620	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240549622	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240549622	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.032	1716240549622	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240550624	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240550624	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.032	1716240550624	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240551627	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240551627	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0291	1716240551627	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240552629	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240552629	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0291	1716240552629	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240553632	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240553632	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0291	1716240553632	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240554634	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240554634	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0311	1716240554634	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240555636	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240555636	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0311	1716240555636	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240556638	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240556638	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0311	1716240556638	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240557640	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240557640	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0331	1716240557640	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240558642	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240558642	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0331	1716240558642	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240559645	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240559645	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0331	1716240559645	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240560647	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240560647	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0356	1716240560647	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240561649	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240561649	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0356	1716240561649	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240562651	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240562651	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0356	1716240562651	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240563653	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240563653	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0365	1716240563653	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240564655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240564655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0365	1716240564655	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240565657	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240565657	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0365	1716240565657	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240566659	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240566659	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0379	1716240566659	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240567661	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240567661	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0379	1716240567661	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240568663	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240568663	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0379	1716240568663	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240569666	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240569666	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0366	1716240569666	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240570668	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240570668	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0366	1716240570668	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240571670	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240571670	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0366	1716240571670	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240572672	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240572672	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.035	1716240572672	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240573674	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240573674	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.035	1716240573674	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240574677	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240574677	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.035	1716240574677	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240575679	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240575679	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0365	1716240575679	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240576681	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240576681	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0365	1716240576681	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240577683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240577683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0365	1716240577683	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240578686	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240578686	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.037	1716240578686	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	106	1716240579689	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240579689	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.037	1716240579689	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240580693	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240580693	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.037	1716240580693	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240581695	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240581695	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0362999999999998	1716240581695	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240582697	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240582697	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0362999999999998	1716240582697	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240583700	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240583700	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0362999999999998	1716240583700	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240584702	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240584702	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0368	1716240584702	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240585706	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240585706	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0368	1716240585706	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240586707	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240586707	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0368	1716240586707	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240587709	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240587709	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0383	1716240587709	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240588711	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240588711	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0383	1716240588711	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240589713	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240589713	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0383	1716240589713	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240590716	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240590716	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0384	1716240590716	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240591718	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240591718	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0384	1716240591718	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240592720	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240592720	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0384	1716240592720	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240593723	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240593723	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0358	1716240593723	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240594725	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240594725	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0358	1716240594725	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240595728	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240595728	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0358	1716240595728	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240596730	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240596730	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0358	1716240596730	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240597732	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240597732	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0358	1716240597732	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240598734	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240598734	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0358	1716240598734	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240599736	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240599736	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0375	1716240599736	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240600738	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240600738	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0375	1716240600738	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240601741	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240601741	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0375	1716240601741	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240602744	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240602744	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0384	1716240602744	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240603746	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240603746	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0384	1716240603746	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240604748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240604748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0384	1716240604748	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240605751	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240605751	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0384	1716240605751	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240606753	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240606753	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0384	1716240606753	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240607756	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240607756	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0384	1716240607756	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240608759	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240608759	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0396	1716240608759	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240609761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240609761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0396	1716240609761	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240610764	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240610764	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0396	1716240610764	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240611766	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240611766	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0388	1716240611766	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240612768	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240612768	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0388	1716240612768	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240613770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240613770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0388	1716240613770	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240614772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240614772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0399000000000003	1716240614772	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240615775	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240615775	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0399000000000003	1716240615775	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240616778	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240616778	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0399000000000003	1716240616778	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240617780	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240617780	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0403	1716240617780	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240618783	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240618783	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0403	1716240618783	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240619785	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240619785	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0403	1716240619785	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240620788	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240620788	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0408	1716240620788	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240621790	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240621790	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0408	1716240621790	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240622795	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240622795	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0408	1716240622795	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240623797	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240623797	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0418	1716240623797	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240624800	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240624800	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0418	1716240624800	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240625802	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240625802	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0418	1716240625802	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240626804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.7	1716240626804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.042	1716240626804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240627806	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240627806	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.042	1716240627806	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240628808	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240628808	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.042	1716240628808	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	99	1716240629811	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240629811	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0401	1716240629811	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240630813	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240630813	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0401	1716240630813	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240631816	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240610781	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240611791	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240612788	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240613796	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240614793	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240615802	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240616803	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240617797	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240618810	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240619804	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240620812	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240621817	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240622811	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240623822	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240624818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240625827	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240626830	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240627822	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240628833	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240629829	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240630839	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240631840	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240632837	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240633848	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240634840	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240635852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240636854	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240637857	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240638865	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240639855	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240640862	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240641868	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240642862	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240643874	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240644864	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240645876	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240646878	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240647873	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240648888	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240649882	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240650887	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240651883	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240652884	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240653892	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240654895	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240655900	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240656890	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240657905	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240658906	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240659907	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240660909	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240661903	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240662913	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240663915	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240664916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240665924	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240666915	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240667927	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240668927	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240669932	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240670933	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240671933	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240672927	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240673938	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240674941	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240631816	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0401	1716240631816	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240632818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240632818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0423	1716240632818	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240633821	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240633821	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0423	1716240633821	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240634823	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240634823	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0423	1716240634823	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240635826	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240635826	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0406	1716240635826	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240636829	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240636829	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0406	1716240636829	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240637831	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240637831	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0406	1716240637831	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240638834	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240638834	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0408	1716240638834	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240639836	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240639836	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0408	1716240639836	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240640838	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240640838	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0408	1716240640838	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240641841	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240641841	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0418	1716240641841	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240642843	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240642843	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0418	1716240642843	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240643845	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240643845	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0418	1716240643845	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240644847	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240644847	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0418	1716240644847	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240645850	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240645850	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0418	1716240645850	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240646852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240646852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0418	1716240646852	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240647854	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240647854	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0409	1716240647854	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240648856	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240648856	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0409	1716240648856	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240649858	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240649858	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0409	1716240649858	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240650860	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240650860	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0417	1716240650860	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240651863	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240651863	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0417	1716240651863	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240652865	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240652865	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0417	1716240652865	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240653868	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240653868	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0409	1716240653868	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240654869	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240654869	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0409	1716240654869	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240655871	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240655871	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0409	1716240655871	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240656874	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240656874	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0405	1716240656874	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240657876	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240657876	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0405	1716240657876	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240658878	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240658878	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0405	1716240658878	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240659880	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240659880	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0415	1716240659880	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240660883	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240660883	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0415	1716240660883	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240661885	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240661885	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0415	1716240661885	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240662887	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240662887	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0422000000000002	1716240662887	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240663889	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240663889	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0422000000000002	1716240663889	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240664891	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240664891	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0422000000000002	1716240664891	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240665893	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240665893	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0374	1716240665893	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240666896	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240666896	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0374	1716240666896	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	106	1716240667898	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240667898	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0374	1716240667898	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240668900	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240668900	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0369	1716240668900	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240669903	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240669903	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0369	1716240669903	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240670905	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240670905	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0369	1716240670905	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240671908	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240671908	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0373	1716240671908	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240672910	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240672910	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0373	1716240672910	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240673912	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240673912	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0373	1716240673912	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240674914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240674914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0381	1716240674914	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240675916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240675916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0381	1716240675916	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240676920	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240676920	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0381	1716240676920	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240677923	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240677923	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0389	1716240677923	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240678924	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240678924	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0389	1716240678924	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240679927	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240679927	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0389	1716240679927	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240680929	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240680929	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0374	1716240680929	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240681932	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240681932	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0374	1716240681932	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240682934	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240682934	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0374	1716240682934	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240683936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.6	1716240683936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0375	1716240683936	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240684939	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240684939	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0375	1716240684939	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240685942	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240685942	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0375	1716240685942	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240686944	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.299999999999999	1716240686944	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0373	1716240686944	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240687946	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240687946	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0373	1716240687946	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240688948	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240688948	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0373	1716240688948	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240689950	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240689950	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0391	1716240689950	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240690952	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240690952	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0391	1716240690952	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240691955	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240691955	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0391	1716240691955	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240692956	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240692956	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0399000000000003	1716240692956	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240693958	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240693958	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0399000000000003	1716240693958	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240694961	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240694961	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0399000000000003	1716240694961	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240695963	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240675942	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240676945	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240677940	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240678952	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240679954	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240680956	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240681950	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240682953	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240683963	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240684967	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240685967	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240686963	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240687964	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240688976	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240689974	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240690980	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240691980	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240692973	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240693985	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240694987	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240695989	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240696991	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240697996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240698999	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240699998	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240701008	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240702004	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240702997	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240704006	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240705012	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240706010	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240707015	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240708008	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240709021	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240710022	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240711029	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240712019	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240695963	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0397	1716240695963	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240696966	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240696966	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0397	1716240696966	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240697968	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240697968	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0397	1716240697968	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240698970	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240698970	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.04	1716240698970	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240699972	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240699972	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.04	1716240699972	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240700974	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240700974	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.04	1716240700974	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240701976	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240701976	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0367	1716240701976	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240702978	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240702978	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0367	1716240702978	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240703981	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240703981	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0367	1716240703981	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240704983	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240704983	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.041	1716240704983	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240705986	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240705986	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.041	1716240705986	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240706988	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240706988	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.041	1716240706988	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240707990	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240707990	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0415	1716240707990	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240708994	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240708994	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0415	1716240708994	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240709996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240709996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0415	1716240709996	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240710998	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240710998	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0432	1716240710998	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240712001	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240712001	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0432	1716240712001	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240713003	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240713003	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0432	1716240713003	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240713029	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240714006	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240714006	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.043	1716240714006	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240714031	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240715011	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240715011	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.043	1716240715011	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240715037	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240716013	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240716013	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.043	1716240716013	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240717015	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240717015	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0425999999999997	1716240717015	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240718018	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240718018	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0425999999999997	1716240718018	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240719021	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240719021	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0405	1716240719021	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240720023	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240720023	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0405	1716240720023	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240721025	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240721025	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0405	1716240721025	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240722028	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240722028	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0422000000000002	1716240722028	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240723030	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240723030	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0422000000000002	1716240723030	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240724033	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240724033	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0422000000000002	1716240724033	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240725036	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.8	1716240725036	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0442	1716240725036	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240726038	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240726038	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0442	1716240726038	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240727040	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240727040	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0442	1716240727040	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240728042	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240728042	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0443	1716240728042	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240729044	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240729044	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0443	1716240729044	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240730046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240730046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0443	1716240730046	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240731049	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240731049	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0454	1716240731049	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240732051	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240732051	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0454	1716240732051	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240733053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240733053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0454	1716240733053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240734056	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240734056	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0458	1716240734056	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240735058	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240735058	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0458	1716240735058	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240736060	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240736060	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0458	1716240736060	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240737062	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240737062	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0449	1716240737062	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240716039	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240717033	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240718042	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240719049	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240720053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240721053	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240722048	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240723058	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240724059	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240725061	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240726063	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240727056	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240728070	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240729070	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240730073	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240731076	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240732073	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240733071	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240734082	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240735086	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240736089	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240737088	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240738083	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240739094	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240740093	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240741096	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240742102	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240743101	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240744103	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240745106	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240746109	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240747106	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240748104	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240749112	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240750119	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240751109	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240752122	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240753117	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240754125	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240755129	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240756132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240757133	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240758135	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240759139	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240760142	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240761141	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240762136	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240763147	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240764148	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240765152	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240766152	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240767148	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240768157	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240769159	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240770161	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240771165	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240772165	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240773168	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240774172	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240775175	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240776174	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240777183	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240778182	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240779184	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240780187	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240738064	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240738064	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0449	1716240738064	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240739066	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240739066	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0449	1716240739066	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240740069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240740069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.042	1716240740069	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240741071	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240741071	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.042	1716240741071	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240742073	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240742073	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.042	1716240742073	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240743075	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240743075	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0425	1716240743075	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240744078	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240744078	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0425	1716240744078	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240745080	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240745080	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0425	1716240745080	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240746082	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240746082	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0431	1716240746082	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240747085	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240747085	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0431	1716240747085	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240748086	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240748086	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0431	1716240748086	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240749088	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240749088	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0425999999999997	1716240749088	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240750090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240750090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0425999999999997	1716240750090	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240751093	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240751093	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0425999999999997	1716240751093	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240752096	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240752096	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0434	1716240752096	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240753099	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240753099	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0434	1716240753099	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240754100	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240754100	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0434	1716240754100	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240755103	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240755103	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0433	1716240755103	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240756107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240756107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0433	1716240756107	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240757109	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240757109	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0433	1716240757109	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240758111	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240758111	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0435	1716240758111	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240759113	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240759113	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0435	1716240759113	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240760115	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240760115	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0435	1716240760115	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240761116	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240761116	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0436	1716240761116	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	105	1716240762119	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240762119	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0436	1716240762119	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240763121	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240763121	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0436	1716240763121	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240764123	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240764123	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0463	1716240764123	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240765125	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240765125	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0463	1716240765125	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240766127	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240766127	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0463	1716240766127	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240767130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240767130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0427	1716240767130	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240768132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240768132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0427	1716240768132	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240769134	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240769134	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0427	1716240769134	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240770137	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240770137	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.045	1716240770137	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240771139	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240771139	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.045	1716240771139	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240772141	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240772141	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.045	1716240772141	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240773144	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240773144	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0448	1716240773144	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240774146	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240774146	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0448	1716240774146	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240775148	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240775148	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0448	1716240775148	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240776150	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240776150	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0407	1716240776150	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240777153	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240777153	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0407	1716240777153	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240778155	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240778155	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0407	1716240778155	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240779158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240779158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.046	1716240779158	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240780160	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240780160	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.046	1716240780160	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240781163	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240781163	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.046	1716240781163	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240782167	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240782167	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0464	1716240782167	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240783169	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240783169	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0464	1716240783169	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240784172	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240784172	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0464	1716240784172	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240785174	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240785174	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0477	1716240785174	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240786177	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240786177	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0477	1716240786177	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240787179	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240787179	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0477	1716240787179	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240788181	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240788181	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0488000000000004	1716240788181	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240789183	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240789183	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0488000000000004	1716240789183	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240790185	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240790185	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0488000000000004	1716240790185	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240791187	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240791187	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0496	1716240791187	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240792190	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240792190	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0496	1716240792190	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240793192	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240793192	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0496	1716240793192	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240794194	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240794194	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0519000000000003	1716240794194	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240795196	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240795196	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0519000000000003	1716240795196	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240796198	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240796198	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0519000000000003	1716240796198	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240797200	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240797200	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0563000000000002	1716240797200	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240798203	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240798203	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0563000000000002	1716240798203	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240799206	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240799206	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0563000000000002	1716240799206	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240800208	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240800208	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0551999999999997	1716240800208	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240801211	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240801211	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0551999999999997	1716240801211	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240781193	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240782192	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240783186	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240784201	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240785199	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240786205	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240787206	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240788208	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240789210	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240790211	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240791214	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240792219	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240793211	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240794224	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240795228	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240796223	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240797228	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240798221	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240799233	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240800233	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240801237	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240802243	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240803240	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240804244	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240805247	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240806248	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240807246	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240808244	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240809257	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240810257	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Swap Memory GB	0	1716240811259	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240802213	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240802213	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0551999999999997	1716240802213	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240803215	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240803215	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0538000000000003	1716240803215	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240804217	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240804217	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0538000000000003	1716240804217	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240805221	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240805221	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0538000000000003	1716240805221	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	102	1716240806223	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240806223	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0536	1716240806223	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240807225	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240807225	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0536	1716240807225	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240808227	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240808227	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.0536	1716240808227	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	104	1716240809229	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240809229	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.054	1716240809229	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	101	1716240810230	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	6.7	1716240810230	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.054	1716240810230	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - CPU Utilization	103	1716240811233	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Utilization	8.4	1716240811233	0d00664f996847edbcf8d1b3c36fb3f6	0	f
TOP - Memory Usage GB	2.054	1716240811233	0d00664f996847edbcf8d1b3c36fb3f6	0	f
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
letter	0	e00e273c2c9841a7aee8ef3aca552b9e
workload	0	e00e273c2c9841a7aee8ef3aca552b9e
listeners	smi+top+dcgmi	e00e273c2c9841a7aee8ef3aca552b9e
params	'"-"'	e00e273c2c9841a7aee8ef3aca552b9e
file	cifar10.py	e00e273c2c9841a7aee8ef3aca552b9e
workload_listener	''	e00e273c2c9841a7aee8ef3aca552b9e
letter	0	0d00664f996847edbcf8d1b3c36fb3f6
workload	0	0d00664f996847edbcf8d1b3c36fb3f6
listeners	smi+top+dcgmi	0d00664f996847edbcf8d1b3c36fb3f6
params	'"-"'	0d00664f996847edbcf8d1b3c36fb3f6
file	cifar10.py	0d00664f996847edbcf8d1b3c36fb3f6
workload_listener	''	0d00664f996847edbcf8d1b3c36fb3f6
model	cifar10.py	0d00664f996847edbcf8d1b3c36fb3f6
manual	False	0d00664f996847edbcf8d1b3c36fb3f6
max_epoch	5	0d00664f996847edbcf8d1b3c36fb3f6
max_time	172800	0d00664f996847edbcf8d1b3c36fb3f6
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
e00e273c2c9841a7aee8ef3aca552b9e	melodic-shrike-410	UNKNOWN			daga	FAILED	1716238835982	1716238879570		active	s3://mlflow-storage/0/e00e273c2c9841a7aee8ef3aca552b9e/artifacts	0	\N
0d00664f996847edbcf8d1b3c36fb3f6	(0 0) respected-rook-49	UNKNOWN			daga	FINISHED	1716239072372	1716240812759		active	s3://mlflow-storage/0/0d00664f996847edbcf8d1b3c36fb3f6/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	e00e273c2c9841a7aee8ef3aca552b9e
mlflow.source.name	file:///home/daga/radt#examples/pytorch	e00e273c2c9841a7aee8ef3aca552b9e
mlflow.source.type	PROJECT	e00e273c2c9841a7aee8ef3aca552b9e
mlflow.project.entryPoint	main	e00e273c2c9841a7aee8ef3aca552b9e
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	e00e273c2c9841a7aee8ef3aca552b9e
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	e00e273c2c9841a7aee8ef3aca552b9e
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	e00e273c2c9841a7aee8ef3aca552b9e
mlflow.runName	melodic-shrike-410	e00e273c2c9841a7aee8ef3aca552b9e
mlflow.project.env	conda	e00e273c2c9841a7aee8ef3aca552b9e
mlflow.project.backend	local	e00e273c2c9841a7aee8ef3aca552b9e
mlflow.user	daga	0d00664f996847edbcf8d1b3c36fb3f6
mlflow.source.name	file:///home/daga/radt#examples/pytorch	0d00664f996847edbcf8d1b3c36fb3f6
mlflow.source.type	PROJECT	0d00664f996847edbcf8d1b3c36fb3f6
mlflow.project.entryPoint	main	0d00664f996847edbcf8d1b3c36fb3f6
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	0d00664f996847edbcf8d1b3c36fb3f6
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	0d00664f996847edbcf8d1b3c36fb3f6
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	0d00664f996847edbcf8d1b3c36fb3f6
mlflow.project.env	conda	0d00664f996847edbcf8d1b3c36fb3f6
mlflow.project.backend	local	0d00664f996847edbcf8d1b3c36fb3f6
mlflow.runName	(0 0) respected-rook-49	0d00664f996847edbcf8d1b3c36fb3f6
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

