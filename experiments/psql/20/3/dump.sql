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
0	Default	s3://mlflow-storage/0	active	1716159184683	1716159184683
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
SMI - Power Draw	14.33	1716159431715	0	f	a3bfeaac84ab4aa9bf0586e3cbc349b5
SMI - Timestamp	1716159431.702	1716159431715	0	f	a3bfeaac84ab4aa9bf0586e3cbc349b5
SMI - GPU Util	0	1716159431715	0	f	a3bfeaac84ab4aa9bf0586e3cbc349b5
SMI - Mem Util	0	1716159431715	0	f	a3bfeaac84ab4aa9bf0586e3cbc349b5
SMI - Mem Used	0	1716159431715	0	f	a3bfeaac84ab4aa9bf0586e3cbc349b5
SMI - Performance State	0	1716159431715	0	f	a3bfeaac84ab4aa9bf0586e3cbc349b5
TOP - CPU Utilization	103	1716159873614	0	f	a3bfeaac84ab4aa9bf0586e3cbc349b5
TOP - Memory Usage GB	1.9630999999999998	1716159873614	0	f	a3bfeaac84ab4aa9bf0586e3cbc349b5
TOP - Memory Utilization	7.8	1716159873614	0	f	a3bfeaac84ab4aa9bf0586e3cbc349b5
TOP - Swap Memory GB	0.0003	1716159873638	0	f	a3bfeaac84ab4aa9bf0586e3cbc349b5
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.33	1716159431715	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
SMI - Timestamp	1716159431.702	1716159431715	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
SMI - GPU Util	0	1716159431715	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
SMI - Mem Util	0	1716159431715	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
SMI - Mem Used	0	1716159431715	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
SMI - Performance State	0	1716159431715	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	0	1716159431781	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	0	1716159431781	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.2543	1716159431781	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159431795	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	153.39999999999998	1716159432783	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	9.1	1716159432783	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.2543	1716159432783	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159432798	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159433785	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159433785	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.2543	1716159433785	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159433799	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159434787	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159434787	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4830999999999999	1716159434787	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159434800	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159435789	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159435789	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4830999999999999	1716159435789	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159435803	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159436792	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159436792	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4830999999999999	1716159436792	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159436813	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159437794	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159437794	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4833	1716159437794	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159437808	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	108	1716159438795	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159438795	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4833	1716159438795	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159438816	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159439797	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159439797	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4833	1716159439797	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159439811	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159440799	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159440799	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.484	1716159440799	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159440814	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	105	1716159441801	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159441801	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.484	1716159441801	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159441820	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	105	1716159442803	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159442803	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.484	1716159442803	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159442824	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159443805	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159443805	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4828	1716159443805	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159443827	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159444807	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159444807	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4828	1716159444807	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159444829	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	105	1716159445809	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159445809	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4828	1716159445809	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159445823	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159446811	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159446811	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4827000000000001	1716159446811	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159446832	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	105	1716159447813	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159447813	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4827000000000001	1716159447813	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159447834	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159448815	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159448815	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4827000000000001	1716159448815	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159448836	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159449817	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159449817	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4826	1716159449817	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159449838	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159450819	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159450819	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4826	1716159450819	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159450833	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	105	1716159451821	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159451821	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.4826	1716159451821	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0	1716159451842	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159452823	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159452823	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.788	1716159452823	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159452844	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159453825	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159453825	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.788	1716159453825	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159453845	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159454827	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159454827	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.788	1716159454827	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159454841	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159455829	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159455829	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9977	1716159455829	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159455842	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159456830	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159456830	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9977	1716159456830	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159456851	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159457832	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159457832	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9977	1716159457832	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159457853	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159458834	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159458834	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0048	1716159458834	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159458855	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159459836	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159459836	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0048	1716159459836	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159459857	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159460838	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.9	1716159460838	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0048	1716159460838	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159460851	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159461840	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159461840	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0104	1716159461840	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159461861	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159462862	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159463863	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159464866	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159465859	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159466864	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159467867	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159468869	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159469877	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159470871	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159471883	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159472883	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159473882	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159474884	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159475880	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159476882	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159477883	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159478885	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159479898	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159480887	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159481899	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159482894	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159483902	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159484903	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159485898	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159486899	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159487908	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159488912	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159489916	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159490906	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159491918	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159492921	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159493920	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159494921	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159495916	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159496927	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159497927	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159498929	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159499930	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159500924	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159501936	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159502937	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159503940	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159504942	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159746376	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159746376	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9509	1716159746376	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159747378	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159747378	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9507999999999999	1716159747378	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159748380	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159748380	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9507999999999999	1716159748380	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159749381	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159749381	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9507999999999999	1716159749381	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159750383	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159750383	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9507999999999999	1716159750383	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159751385	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159751385	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9507999999999999	1716159751385	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159752387	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159752387	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9507999999999999	1716159752387	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159462841	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159462841	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0104	1716159462841	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159463843	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159463843	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0104	1716159463843	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159464845	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159464845	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0089	1716159464845	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159465846	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159465846	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0089	1716159465846	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159466848	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159466848	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0089	1716159466848	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159467850	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159467850	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0074	1716159467850	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159468852	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159468852	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0074	1716159468852	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159469855	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159469855	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0074	1716159469855	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159470856	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159470856	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0079000000000002	1716159470856	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159471858	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159471858	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0079000000000002	1716159471858	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159472860	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159472860	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	2.0079000000000002	1716159472860	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159473862	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159473862	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9223	1716159473862	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159474864	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159474864	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9223	1716159474864	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159475866	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159475866	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9223	1716159475866	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159476868	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159476868	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9245999999999999	1716159476868	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159477869	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159477869	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9245999999999999	1716159477869	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159478871	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159478871	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9245999999999999	1716159478871	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159479873	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159479873	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9259000000000002	1716159479873	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159480875	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159480875	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9259000000000002	1716159480875	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159481877	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159481877	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9259000000000002	1716159481877	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159482879	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159482879	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9287	1716159482879	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159483881	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159483881	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9287	1716159483881	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159484882	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159484882	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9287	1716159484882	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159485884	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159485884	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.93	1716159485884	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159486886	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159486886	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.93	1716159486886	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159487888	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159487888	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.93	1716159487888	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159488890	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159488890	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9289	1716159488890	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159489891	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159489891	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9289	1716159489891	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159490893	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159490893	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9289	1716159490893	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159491895	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159491895	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9285999999999999	1716159491895	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159492897	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159492897	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9285999999999999	1716159492897	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159493899	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159493899	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9285999999999999	1716159493899	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159494901	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159494901	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9287999999999998	1716159494901	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159495902	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159495902	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9287999999999998	1716159495902	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159496904	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159496904	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9287999999999998	1716159496904	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159497906	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159497906	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9324000000000001	1716159497906	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159498908	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159498908	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9324000000000001	1716159498908	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159499910	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159499910	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9324000000000001	1716159499910	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159500911	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	2.6	1716159500911	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.93	1716159500911	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159501913	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159501913	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.93	1716159501913	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159502915	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159502915	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.93	1716159502915	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159503916	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159503916	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9316	1716159503916	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159504919	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159504919	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9316	1716159504919	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159505920	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159505920	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9316	1716159505920	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159505935	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159506922	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159506922	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9312	1716159506922	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159506938	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159507924	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159507924	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9312	1716159507924	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159507946	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159508926	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.7	1716159508926	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9312	1716159508926	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159508950	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159509928	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.5	1716159509928	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9298	1716159509928	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159509943	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159510930	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159510930	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9298	1716159510930	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159510945	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159511931	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159511931	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9298	1716159511931	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159511944	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159512933	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159512933	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9281	1716159512933	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159512956	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159513937	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159513937	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9281	1716159513937	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159513959	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159514938	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159514938	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9281	1716159514938	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159514961	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159515940	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159515940	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9341	1716159515940	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159515955	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159516942	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159516942	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9341	1716159516942	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159516967	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159517944	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159517944	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9341	1716159517944	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159517969	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159518946	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159518946	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9325999999999999	1716159518946	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159518970	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159519948	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159519948	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9325999999999999	1716159519948	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159519972	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159520949	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159520949	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9325999999999999	1716159520949	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159520967	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159521976	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159522976	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159523977	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159524978	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159525973	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159526983	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159527983	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159528988	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159529988	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159530982	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159531992	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159532993	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159533994	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159534996	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159535993	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159537001	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159538002	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159539004	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159540000	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159541000	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159542010	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159543013	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159544005	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159545017	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159546014	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159547021	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159548022	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159549024	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159550023	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159551021	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159552087	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159553029	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159554032	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159555035	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159556027	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159557037	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159558039	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159559036	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159560036	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159561037	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159562046	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159563048	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159564050	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159565046	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159746397	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159747398	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159748404	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159749403	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159750404	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159751399	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159752410	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159753410	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159754412	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159755413	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159756408	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159757421	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159758419	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159759424	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159760424	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159761426	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159762430	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159763429	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159764434	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159765432	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159521951	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159521951	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9336	1716159521951	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159522953	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159522953	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9336	1716159522953	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159523955	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159523955	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9336	1716159523955	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159524957	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159524957	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9357	1716159524957	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159525958	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159525958	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9357	1716159525958	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159526960	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159526960	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9357	1716159526960	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159527962	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159527962	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9333	1716159527962	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159528964	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159528964	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9333	1716159528964	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159529966	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159529966	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9333	1716159529966	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159530968	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159530968	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9353	1716159530968	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159531970	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159531970	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9353	1716159531970	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159532971	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159532971	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9353	1716159532971	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159533973	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159533973	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9335	1716159533973	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159534975	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159534975	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9335	1716159534975	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159535977	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159535977	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9335	1716159535977	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159536979	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159536979	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.935	1716159536979	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159537981	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159537981	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.935	1716159537981	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159538983	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159538983	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.935	1716159538983	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159539985	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159539985	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9350999999999998	1716159539985	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159540987	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159540987	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9350999999999998	1716159540987	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159541989	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159541989	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9350999999999998	1716159541989	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159542990	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159542990	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9353	1716159542990	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159543992	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159543992	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9353	1716159543992	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159544994	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159544994	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9353	1716159544994	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159545996	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159545996	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9354	1716159545996	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159546998	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159546998	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9354	1716159546998	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159548000	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159548000	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9354	1716159548000	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159549001	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159549001	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9350999999999998	1716159549001	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159550003	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159550003	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9350999999999998	1716159550003	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159551005	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159551005	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9350999999999998	1716159551005	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159552006	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159552006	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.937	1716159552006	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159553008	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159553008	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.937	1716159553008	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	108	1716159554010	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159554010	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.937	1716159554010	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159555012	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159555012	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9250999999999998	1716159555012	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159556014	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159556014	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9250999999999998	1716159556014	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159557016	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159557016	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9250999999999998	1716159557016	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159558018	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159558018	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9352	1716159558018	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159559020	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159559020	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9352	1716159559020	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159560022	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159560022	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9352	1716159560022	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159561024	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159561024	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.936	1716159561024	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159562026	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159562026	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.936	1716159562026	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159563027	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159563027	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.936	1716159563027	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159564029	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159564029	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9409	1716159564029	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159565031	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	8	1716159565031	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9409	1716159565031	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159566033	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159566033	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9409	1716159566033	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159566050	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159567035	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159567035	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9404000000000001	1716159567035	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159567058	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159568037	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159568037	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9404000000000001	1716159568037	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159568051	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159569039	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159569039	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9404000000000001	1716159569039	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159569059	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159570041	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159570041	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9404000000000001	1716159570041	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159570054	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159571042	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159571042	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9404000000000001	1716159571042	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159571056	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159572044	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159572044	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9404000000000001	1716159572044	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159572066	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159573046	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159573046	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9434	1716159573046	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159573067	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159574048	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159574048	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9434	1716159574048	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159574061	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159575050	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159575050	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9434	1716159575050	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159575069	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159576052	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159576052	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9357	1716159576052	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159576065	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159577053	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159577053	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9357	1716159577053	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159577068	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159578055	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159578055	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9357	1716159578055	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159578078	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159579057	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159579057	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9392	1716159579057	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159579079	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159580059	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159580059	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9392	1716159580059	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159580084	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159581062	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159581062	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9392	1716159581062	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159582064	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159582064	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9373	1716159582064	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159583066	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159583066	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9373	1716159583066	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159584068	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159584068	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9373	1716159584068	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159585070	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159585070	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9365999999999999	1716159585070	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159586072	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159586072	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9365999999999999	1716159586072	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159587073	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159587073	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9365999999999999	1716159587073	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159588076	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159588076	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9387999999999999	1716159588076	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159589077	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159589077	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9387999999999999	1716159589077	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159590079	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159590079	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9387999999999999	1716159590079	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159591082	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159591082	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9417	1716159591082	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159592084	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159592084	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9417	1716159592084	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159593086	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159593086	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9417	1716159593086	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159594088	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159594088	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9410999999999998	1716159594088	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159595090	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159595090	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9410999999999998	1716159595090	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159596092	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159596092	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9410999999999998	1716159596092	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159597093	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159597093	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9355	1716159597093	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159598095	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159598095	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9355	1716159598095	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159599097	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159599097	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9355	1716159599097	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159600099	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159600099	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9389	1716159600099	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159601101	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159601101	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9389	1716159601101	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159602103	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159581080	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159582079	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159583093	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159584089	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159585091	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159586087	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159587094	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159588092	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159589092	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159590101	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159591097	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159592104	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159593107	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159594109	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159595105	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159596112	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159597114	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159598110	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159599119	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159600114	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159601115	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159602124	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159603126	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159604120	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159605131	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159606124	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159607131	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159608135	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159609136	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159610139	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159611141	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159612142	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159613143	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159614146	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159615147	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159616141	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159617150	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159618152	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159619155	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159620156	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159621152	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159622159	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159623161	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159624165	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159625166	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159753389	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159753389	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9516	1716159753389	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159754390	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159754390	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9516	1716159754390	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159755392	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159755392	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9516	1716159755392	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159756394	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159756394	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9516	1716159756394	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159757396	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159757396	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9516	1716159757396	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159758398	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159758398	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9516	1716159758398	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159759401	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159759401	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159602103	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9389	1716159602103	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159603104	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159603104	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9403	1716159603104	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159604106	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159604106	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9403	1716159604106	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159605108	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159605108	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9403	1716159605108	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159606110	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159606110	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9452	1716159606110	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159607111	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159607111	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9452	1716159607111	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159608113	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159608113	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9452	1716159608113	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159609114	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159609114	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9455	1716159609114	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159610117	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159610117	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9455	1716159610117	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159611118	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159611118	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9455	1716159611118	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159612120	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159612120	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9456	1716159612120	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159613122	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159613122	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9456	1716159613122	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159614124	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159614124	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9456	1716159614124	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159615126	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159615126	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9470999999999998	1716159615126	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159616128	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159616128	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9470999999999998	1716159616128	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159617130	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159617130	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9470999999999998	1716159617130	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159618131	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159618131	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9421	1716159618131	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159619133	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159619133	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9421	1716159619133	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159620135	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159620135	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9421	1716159620135	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159621137	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159621137	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9447999999999999	1716159621137	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159622139	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159622139	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9447999999999999	1716159622139	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159623141	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159623141	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9447999999999999	1716159623141	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159624143	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159624143	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9442000000000002	1716159624143	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159625145	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159625145	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9442000000000002	1716159625145	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159626147	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159626147	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9442000000000002	1716159626147	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159626160	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159627148	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159627148	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9463	1716159627148	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159627166	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159628150	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159628150	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9463	1716159628150	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159628171	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159629152	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159629152	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9463	1716159629152	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159629176	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159630155	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159630155	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9461	1716159630155	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159630176	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159631157	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159631157	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9461	1716159631157	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159631172	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159632159	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159632159	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9461	1716159632159	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159632180	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159633161	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159633161	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9441	1716159633161	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159633183	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159634163	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159634163	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9441	1716159634163	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159634184	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159635164	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.800000000000001	1716159635164	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9441	1716159635164	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159635185	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159636166	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.6000000000000005	1716159636166	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9456	1716159636166	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159636187	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159637168	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159637168	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9456	1716159637168	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159637183	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159638170	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159638170	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9456	1716159638170	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159638184	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159639172	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159639172	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9412	1716159639172	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159639193	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159640174	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159640174	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9412	1716159640174	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159641176	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159641176	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9412	1716159641176	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159642178	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159642178	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9456	1716159642178	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159643180	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159643180	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9456	1716159643180	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159644181	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159644181	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9456	1716159644181	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159645183	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159645183	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9457	1716159645183	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159646185	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159646185	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9457	1716159646185	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159647187	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159647187	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9457	1716159647187	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159648189	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159648189	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.944	1716159648189	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159649191	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159649191	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.944	1716159649191	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159650192	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159650192	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.944	1716159650192	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159651195	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159651195	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9459000000000002	1716159651195	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159652196	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159652196	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9459000000000002	1716159652196	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159653198	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159653198	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9459000000000002	1716159653198	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159654200	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159654200	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9452	1716159654200	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159655202	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159655202	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9452	1716159655202	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159656204	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159656204	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9452	1716159656204	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159657206	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159657206	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.944	1716159657206	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159658208	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159658208	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.944	1716159658208	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159659210	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159659210	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.944	1716159659210	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159660211	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159660211	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.944	1716159660211	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159661213	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159661213	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159640187	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159641189	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159642195	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159643204	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159644204	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159645205	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159646201	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159647209	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159648202	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159649212	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159650214	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159651208	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159652221	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159653220	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159654223	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159655218	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159656226	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159657221	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159658228	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159659230	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159660230	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159661228	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159662229	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159663231	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159664234	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159665243	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159666237	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159667241	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159668243	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159669242	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159670244	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159671252	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159672247	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159673256	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159674258	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159675260	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159676254	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159677256	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159678259	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159679262	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159680262	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159681265	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159682275	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159683276	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159684281	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159685283	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9513	1716159759401	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159760402	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159760402	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9513	1716159760402	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159761404	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159761404	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9513	1716159761404	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159762406	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159762406	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9523	1716159762406	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159763408	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159763408	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9523	1716159763408	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159764410	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159764410	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9523	1716159764410	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159765411	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159765411	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9496	1716159765411	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.944	1716159661213	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159662215	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159662215	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.944	1716159662215	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159663217	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159663217	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9485	1716159663217	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159664219	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159664219	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9485	1716159664219	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159665221	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159665221	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9485	1716159665221	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159666223	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159666223	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9469	1716159666223	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159667225	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159667225	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9469	1716159667225	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159668226	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159668226	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9469	1716159668226	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159669228	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159669228	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9482000000000002	1716159669228	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159670230	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159670230	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9482000000000002	1716159670230	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159671232	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159671232	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9482000000000002	1716159671232	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159672234	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159672234	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.948	1716159672234	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159673236	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159673236	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.948	1716159673236	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159674238	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159674238	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.948	1716159674238	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159675239	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159675239	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9481	1716159675239	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159676241	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159676241	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9481	1716159676241	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159677243	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159677243	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9481	1716159677243	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159678245	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159678245	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9465999999999999	1716159678245	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159679247	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159679247	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9465999999999999	1716159679247	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159680249	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159680249	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9465999999999999	1716159680249	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159681251	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159681251	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9502000000000002	1716159681251	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159682253	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159682253	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9502000000000002	1716159682253	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159683254	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159683254	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9502000000000002	1716159683254	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159684256	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159684256	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9485999999999999	1716159684256	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159685259	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159685259	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9485999999999999	1716159685259	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159686261	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159686261	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9485999999999999	1716159686261	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159686285	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159687263	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159687263	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9449	1716159687263	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159687286	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159688265	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159688265	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9449	1716159688265	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159688286	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159689267	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159689267	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9449	1716159689267	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159689288	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159690269	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159690269	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9432	1716159690269	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159690289	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159691271	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159691271	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9432	1716159691271	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159691284	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159692273	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159692273	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9432	1716159692273	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159692295	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159693275	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159693275	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9458	1716159693275	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159693296	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159694278	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159694278	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9458	1716159694278	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159694299	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159695280	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159695280	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9458	1716159695280	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159695302	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159696282	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159696282	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9483	1716159696282	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159696296	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159697284	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6.3	1716159697284	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9483	1716159697284	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159697307	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159698286	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159698286	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9483	1716159698286	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159698307	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159699288	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159699288	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9482000000000002	1716159699288	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159699311	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159700310	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159701313	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159702307	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159703316	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159704319	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159705363	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159706315	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159707327	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159708328	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159709328	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159710322	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159711324	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159712334	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159713337	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159714347	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159715333	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159716342	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159717342	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159718348	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159719347	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159720341	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159721343	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159722352	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159723353	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159724358	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159725359	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159726360	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159727362	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159728368	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159729369	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159730360	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159731371	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159732373	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159733377	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159734377	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159735371	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159736371	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159737384	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159738385	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159739384	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159740378	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159741387	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159742389	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159743393	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159744394	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159745389	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159766413	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159766413	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9496	1716159766413	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159767415	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159767415	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9496	1716159767415	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159768417	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159768417	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9512	1716159768417	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159769419	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159769419	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9512	1716159769419	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159770421	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159770421	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9512	1716159770421	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159771422	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159771422	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9490999999999998	1716159771422	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159700290	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159700290	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9482000000000002	1716159700290	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159701292	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159701292	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9482000000000002	1716159701292	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159702293	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159702293	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9476	1716159702293	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159703295	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159703295	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9476	1716159703295	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159704297	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159704297	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9476	1716159704297	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159705299	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159705299	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9413	1716159705299	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159706301	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159706301	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9413	1716159706301	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	108	1716159707303	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.699999999999999	1716159707303	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9413	1716159707303	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159708305	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159708305	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9474	1716159708305	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159709307	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159709307	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9474	1716159709307	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159710308	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159710308	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9474	1716159710308	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159711310	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159711310	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9476	1716159711310	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159712312	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159712312	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9476	1716159712312	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159713314	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159713314	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9476	1716159713314	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159714316	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159714316	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9482000000000002	1716159714316	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159715318	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159715318	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9482000000000002	1716159715318	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159716320	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159716320	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9482000000000002	1716159716320	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159717321	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159717321	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9481	1716159717321	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159718323	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159718323	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9481	1716159718323	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159719325	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159719325	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9481	1716159719325	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159720326	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159720326	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9483	1716159720326	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159721328	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159721328	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9483	1716159721328	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159722330	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159722330	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9483	1716159722330	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159723332	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159723332	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.951	1716159723332	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159724334	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159724334	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.951	1716159724334	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159725337	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.699999999999999	1716159725337	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.951	1716159725337	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159726339	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159726339	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9517	1716159726339	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159727341	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159727341	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9517	1716159727341	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159728343	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159728343	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9517	1716159728343	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159729345	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159729345	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9475	1716159729345	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159730347	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159730347	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9475	1716159730347	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159731349	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159731349	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9475	1716159731349	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159732350	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159732350	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9493	1716159732350	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159733352	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159733352	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9493	1716159733352	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159734354	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159734354	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9493	1716159734354	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159735356	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159735356	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9498	1716159735356	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159736358	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159736358	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9498	1716159736358	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159737360	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159737360	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9498	1716159737360	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159738361	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159738361	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9481	1716159738361	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159739363	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159739363	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9481	1716159739363	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159740365	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159740365	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9481	1716159740365	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159741366	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159741366	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9506	1716159741366	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159742368	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159742368	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9506	1716159742368	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159743370	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159743370	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9506	1716159743370	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159744372	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159744372	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9509	1716159744372	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159745374	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159745374	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9509	1716159745374	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159766427	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159767437	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159768442	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159769442	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159770435	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159771438	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159772424	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159772424	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9490999999999998	1716159772424	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159772450	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159773426	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159773426	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9490999999999998	1716159773426	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159773449	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159774428	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159774428	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.951	1716159774428	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159774451	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159775430	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159775430	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.951	1716159775430	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159775451	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159776431	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159776431	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.951	1716159776431	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159776451	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159777433	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159777433	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.951	1716159777433	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159777453	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159778435	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159778435	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.951	1716159778435	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159778459	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159779437	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159779437	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.951	1716159779437	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159779459	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159780439	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159780439	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9516	1716159780439	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159780461	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159781441	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159781441	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9516	1716159781441	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159781455	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159782443	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159782443	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9516	1716159782443	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159782466	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159783445	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159783445	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9506	1716159783445	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159783468	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159784446	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159784446	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9506	1716159784446	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159785448	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159785448	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9506	1716159785448	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159786450	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159786450	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9523	1716159786450	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159787452	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	5.9	1716159787452	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9523	1716159787452	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159788453	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.7	1716159788453	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9523	1716159788453	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159789455	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159789455	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9476	1716159789455	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159790458	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159790458	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9476	1716159790458	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159791459	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159791459	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9476	1716159791459	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159792461	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159792461	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9492	1716159792461	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159793463	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159793463	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9492	1716159793463	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159794465	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159794465	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9492	1716159794465	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159795466	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159795466	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9507	1716159795466	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159796468	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159796468	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9507	1716159796468	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159797470	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159797470	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9507	1716159797470	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159798472	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159798472	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9515	1716159798472	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159799474	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159799474	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9515	1716159799474	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159800476	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159800476	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9515	1716159800476	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159801478	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	8.200000000000001	1716159801478	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9523	1716159801478	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159802480	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159802480	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9523	1716159802480	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159803482	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159803482	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9523	1716159803482	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159804484	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159804484	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9526	1716159804484	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159805486	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159784460	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159785469	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159786464	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159787472	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159788474	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159789476	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159790471	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159791480	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159792484	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159793484	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159794487	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159795481	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159796491	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159797492	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159798493	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159799495	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159800490	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159801501	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159802501	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159803503	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159804505	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159805499	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159805486	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9526	1716159805486	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159806487	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159806487	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9526	1716159806487	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159806509	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159807489	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159807489	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9569	1716159807489	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159807512	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159808491	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159808491	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9569	1716159808491	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159808512	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159809493	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159809493	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9569	1716159809493	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159809515	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159810495	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159810495	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9510999999999998	1716159810495	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159810517	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159811497	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159811497	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9510999999999998	1716159811497	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159811513	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159812499	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159812499	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9510999999999998	1716159812499	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159812521	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159813501	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159813501	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9529	1716159813501	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159813521	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159814503	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159814503	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9529	1716159814503	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159814525	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159815504	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159815504	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9529	1716159815504	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159815527	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159816506	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159816506	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9544000000000001	1716159816506	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159816520	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159817508	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159817508	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9544000000000001	1716159817508	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159817531	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159818510	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159818510	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9544000000000001	1716159818510	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159818533	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159819512	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159819512	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9553	1716159819512	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159819534	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159820514	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159820514	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9553	1716159820514	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159820533	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159821516	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159821516	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9553	1716159821516	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159822518	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159822518	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9547999999999999	1716159822518	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159823521	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159823521	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9547999999999999	1716159823521	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159824523	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159824523	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9547999999999999	1716159824523	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159825525	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159825525	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9582	1716159825525	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159826527	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159826527	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9582	1716159826527	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159827529	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159827529	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9582	1716159827529	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159828531	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159828531	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9569	1716159828531	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159829532	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159829532	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9569	1716159829532	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159830534	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159830534	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9569	1716159830534	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159831536	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159831536	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716159831536	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159832538	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159832538	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716159832538	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159833540	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159833540	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9524000000000001	1716159833540	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159834542	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159834542	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9567999999999999	1716159834542	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	104	1716159835544	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159835544	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9567999999999999	1716159835544	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159836545	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159836545	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9567999999999999	1716159836545	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159837548	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159837548	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9586	1716159837548	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159838549	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159838549	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9586	1716159838549	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159839551	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159839551	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9586	1716159839551	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159840553	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159840553	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9599000000000002	1716159840553	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159841555	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159841555	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9599000000000002	1716159841555	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159842557	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159842557	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9599000000000002	1716159842557	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159821539	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159822539	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159823542	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159824545	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159825546	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159826541	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159827551	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159828553	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159829554	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159830556	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159831551	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159832560	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159833562	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159834565	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159835564	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159836571	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159837571	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159838572	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159839572	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159840567	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159841578	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159842579	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159843581	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159844584	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159845582	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159846586	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159847586	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159848589	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159849590	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159850592	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159851597	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159852596	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159853594	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159854600	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159855599	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159856607	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159857607	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159858609	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159859609	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159860605	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159861615	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159862615	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159863618	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159864616	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159865618	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159843559	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159843559	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9604000000000001	1716159843559	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159844561	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159844561	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9604000000000001	1716159844561	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159845561	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159845561	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9604000000000001	1716159845561	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159846563	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159846563	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9593	1716159846563	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159847565	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159847565	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9593	1716159847565	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159848567	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159848567	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9593	1716159848567	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159849569	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159849569	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9606	1716159849569	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159850571	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159850571	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9606	1716159850571	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159851573	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159851573	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9606	1716159851573	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159852575	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159852575	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9585	1716159852575	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159853577	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159853577	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9585	1716159853577	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159854579	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159854579	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9585	1716159854579	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159855581	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159855581	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9582	1716159855581	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159856583	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159856583	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9582	1716159856583	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159857585	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159857585	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9582	1716159857585	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159858586	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159858586	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9570999999999998	1716159858586	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159859588	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159859588	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9570999999999998	1716159859588	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159860590	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159860590	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9570999999999998	1716159860590	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159861592	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159861592	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.96	1716159861592	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159862594	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159862594	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.96	1716159862594	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159863596	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159863596	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.96	1716159863596	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	100	1716159864597	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159864597	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9619000000000002	1716159864597	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159865599	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159865599	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9619000000000002	1716159865599	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159866601	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159866601	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9619000000000002	1716159866601	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159866625	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159867603	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159867603	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9625	1716159867603	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159867624	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159868605	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159868605	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9625	1716159868605	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159868627	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159869607	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159869607	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9625	1716159869607	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159869629	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	101	1716159870609	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159870609	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9612	1716159870609	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159870630	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159871611	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159871611	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9612	1716159871611	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159871625	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	102	1716159872613	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	6	1716159872613	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9612	1716159872613	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159872634	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - CPU Utilization	103	1716159873614	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Utilization	7.8	1716159873614	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Memory Usage GB	1.9630999999999998	1716159873614	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
TOP - Swap Memory GB	0.0003	1716159873638	a3bfeaac84ab4aa9bf0586e3cbc349b5	0	f
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
letter	0	408be097e3d84d78bd4a256e6ff1f9df
workload	0	408be097e3d84d78bd4a256e6ff1f9df
listeners	smi+top+dcgmi	408be097e3d84d78bd4a256e6ff1f9df
params	'"-"'	408be097e3d84d78bd4a256e6ff1f9df
file	cifar10.py	408be097e3d84d78bd4a256e6ff1f9df
workload_listener	''	408be097e3d84d78bd4a256e6ff1f9df
letter	0	a3bfeaac84ab4aa9bf0586e3cbc349b5
workload	0	a3bfeaac84ab4aa9bf0586e3cbc349b5
listeners	smi+top+dcgmi	a3bfeaac84ab4aa9bf0586e3cbc349b5
params	'"-"'	a3bfeaac84ab4aa9bf0586e3cbc349b5
file	cifar10.py	a3bfeaac84ab4aa9bf0586e3cbc349b5
workload_listener	''	a3bfeaac84ab4aa9bf0586e3cbc349b5
model	cifar10.py	a3bfeaac84ab4aa9bf0586e3cbc349b5
manual	False	a3bfeaac84ab4aa9bf0586e3cbc349b5
max_epoch	5	a3bfeaac84ab4aa9bf0586e3cbc349b5
max_time	172800	a3bfeaac84ab4aa9bf0586e3cbc349b5
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
408be097e3d84d78bd4a256e6ff1f9df	trusting-crow-314	UNKNOWN			daga	FAILED	1716159152282	1716159317353		active	s3://mlflow-storage/0/408be097e3d84d78bd4a256e6ff1f9df/artifacts	0	\N
a3bfeaac84ab4aa9bf0586e3cbc349b5	(0 0) bold-wolf-311	UNKNOWN			daga	FINISHED	1716159424688	1716159875099		active	s3://mlflow-storage/0/a3bfeaac84ab4aa9bf0586e3cbc349b5/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	408be097e3d84d78bd4a256e6ff1f9df
mlflow.source.name	file:///home/daga/radt#examples/pytorch	408be097e3d84d78bd4a256e6ff1f9df
mlflow.source.type	PROJECT	408be097e3d84d78bd4a256e6ff1f9df
mlflow.project.entryPoint	main	408be097e3d84d78bd4a256e6ff1f9df
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	408be097e3d84d78bd4a256e6ff1f9df
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	408be097e3d84d78bd4a256e6ff1f9df
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	408be097e3d84d78bd4a256e6ff1f9df
mlflow.runName	trusting-crow-314	408be097e3d84d78bd4a256e6ff1f9df
mlflow.project.env	conda	408be097e3d84d78bd4a256e6ff1f9df
mlflow.project.backend	local	408be097e3d84d78bd4a256e6ff1f9df
mlflow.user	daga	a3bfeaac84ab4aa9bf0586e3cbc349b5
mlflow.source.name	file:///home/daga/radt#examples/pytorch	a3bfeaac84ab4aa9bf0586e3cbc349b5
mlflow.source.type	PROJECT	a3bfeaac84ab4aa9bf0586e3cbc349b5
mlflow.project.entryPoint	main	a3bfeaac84ab4aa9bf0586e3cbc349b5
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	a3bfeaac84ab4aa9bf0586e3cbc349b5
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	a3bfeaac84ab4aa9bf0586e3cbc349b5
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	a3bfeaac84ab4aa9bf0586e3cbc349b5
mlflow.project.env	conda	a3bfeaac84ab4aa9bf0586e3cbc349b5
mlflow.project.backend	local	a3bfeaac84ab4aa9bf0586e3cbc349b5
mlflow.runName	(0 0) bold-wolf-311	a3bfeaac84ab4aa9bf0586e3cbc349b5
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

