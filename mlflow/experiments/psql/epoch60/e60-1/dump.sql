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
0	Default	s3://mlflow-storage/0	active	1715618311502	1715618311502
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
SMI - Power Draw	14.85	1715618430218	0	f	d9a4aed0fbb449c0988fb0a7a56f642d
SMI - Timestamp	1715618430.202	1715618430218	0	f	d9a4aed0fbb449c0988fb0a7a56f642d
SMI - GPU Util	0	1715618430218	0	f	d9a4aed0fbb449c0988fb0a7a56f642d
SMI - Mem Util	0	1715618430218	0	f	d9a4aed0fbb449c0988fb0a7a56f642d
SMI - Mem Used	0	1715618430218	0	f	d9a4aed0fbb449c0988fb0a7a56f642d
SMI - Performance State	0	1715618430218	0	f	d9a4aed0fbb449c0988fb0a7a56f642d
TOP - CPU Utilization	101	1715619732996	0	f	d9a4aed0fbb449c0988fb0a7a56f642d
TOP - Memory Usage GB	2.6816999999999998	1715619732996	0	f	d9a4aed0fbb449c0988fb0a7a56f642d
TOP - Memory Utilization	6.4	1715619732996	0	f	d9a4aed0fbb449c0988fb0a7a56f642d
TOP - Swap Memory GB	0.07809999999999999	1715619733009	0	f	d9a4aed0fbb449c0988fb0a7a56f642d
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.85	1715618430218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
SMI - Timestamp	1715618430.202	1715618430218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
SMI - GPU Util	0	1715618430218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
SMI - Mem Util	0	1715618430218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
SMI - Mem Used	0	1715618430218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
SMI - Performance State	0	1715618430218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	0	1715618430267	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	0	1715618430267	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	1.912	1715618430267	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618430283	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	187.5	1715618431269	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.6	1715618431269	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	1.912	1715618431269	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618431288	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618432271	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618432271	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	1.912	1715618432271	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618432285	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	107	1715618433273	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	13.4	1715618433273	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.1471999999999998	1715618433273	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618433300	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618434276	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.5	1715618434276	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.1471999999999998	1715618434276	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618434294	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618435278	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618435278	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.1471999999999998	1715618435278	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618435291	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618436280	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.5	1715618436280	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.1484	1715618436280	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618436298	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715618437281	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.8	1715618437281	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.1484	1715618437281	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618437294	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618438283	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618438283	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.1484	1715618438283	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618438298	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	106	1715618439285	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1000000000000005	1715618439285	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.1503	1715618439285	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618439298	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618440287	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.8	1715618440287	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.1503	1715618440287	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618440303	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618441290	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1000000000000005	1715618441290	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.1503	1715618441290	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618441307	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715618442292	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618442292	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.1498000000000004	1715618442292	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618442306	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	106	1715618443294	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.299999999999999	1715618443294	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.1498000000000004	1715618443294	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618443309	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618444296	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618444296	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.1498000000000004	1715618444296	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618444312	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0741	1715618450325	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618752940	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715618752940	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6224000000000003	1715618752940	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618755946	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.1	1715618755946	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6224000000000003	1715618755946	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618763962	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618763962	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6215	1715618763962	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618769975	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.700000000000001	1715618769975	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6250999999999998	1715618769975	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618779996	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715618779996	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6321999999999997	1715618779996	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618786031	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618789037	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618793039	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618797046	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618803045	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5	1715618803045	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6343	1715618803045	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618805070	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618811084	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618812087	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715619005471	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6483000000000003	1715619005471	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619008492	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619011567	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619012499	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619021504	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715619021504	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6511	1715619021504	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619022506	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619022506	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6517	1715619022506	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619025512	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619025512	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6533	1715619025512	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619026514	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619026514	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6533	1715619026514	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619027516	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.299999999999999	1715619027516	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6533	1715619027516	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619038538	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619038538	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6521999999999997	1715619038538	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619044552	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715619044552	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6535	1715619044552	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619050565	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619050565	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6544	1715619050565	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619052569	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.2	1715619052569	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6552	1715619052569	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6549	1715619121714	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619127727	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.8	1715619127727	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6549	1715619127727	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619128729	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	106	1715618445298	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.5	1715618445298	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.15	1715618445298	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618446301	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.699999999999999	1715618446301	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.15	1715618446301	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715618447303	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618447303	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.15	1715618447303	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618448306	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1000000000000005	1715618448306	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.4033	1715618448306	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618451312	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1000000000000005	1715618451312	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6594	1715618451312	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618452314	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.8	1715618452314	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6594	1715618452314	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618752961	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618755970	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618763983	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618772981	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618772981	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6321999999999997	1715618772981	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618780010	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618789016	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715618789016	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6351999999999998	1715618789016	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618793025	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5	1715618793025	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6304000000000003	1715618793025	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618797033	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618797033	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6319	1715618797033	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618802061	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618805050	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715618805050	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6343	1715618805050	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618811063	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618811063	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6355	1715618811063	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618812066	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618812066	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6363000000000003	1715618812066	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6499	1715619009480	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619015492	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619015492	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6515	1715619015492	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619017496	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619017496	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6503	1715619017496	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619018498	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619018498	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6503	1715619018498	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619023508	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715619023508	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6517	1715619023508	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619029543	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619032542	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619039566	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619043574	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619045575	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619046579	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619047572	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618445312	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618446322	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.06509999999999999	1715618447316	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0741	1715618448324	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0741	1715618451331	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0741	1715618452328	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618753942	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618753942	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6224000000000003	1715618753942	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618757950	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.7	1715618757950	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6237	1715618757950	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618758952	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618758952	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6237	1715618758952	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618762960	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618762960	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6216999999999997	1715618762960	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618765989	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618768973	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715618768973	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6309	1715618768973	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618771992	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618773983	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715618773983	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6321999999999997	1715618773983	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618774985	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.7	1715618774985	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6321999999999997	1715618774985	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618776001	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618779010	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618782013	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618783023	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618785028	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618788014	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8	1715618788014	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6351999999999998	1715618788014	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618790018	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8	1715618790018	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6351999999999998	1715618790018	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618791020	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618791020	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6304000000000003	1715618791020	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618798035	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715618798035	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6319	1715618798035	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618799037	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618799037	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6319	1715618799037	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618801041	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.9	1715618801041	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6339	1715618801041	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618803060	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.999999999999999	1715619016494	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6503	1715619016494	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619024510	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715619024510	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6517	1715619024510	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619030522	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619030522	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6531	1715619030522	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619036555	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619040558	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619042560	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618449308	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1000000000000005	1715618449308	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.4033	1715618449308	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618753965	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618757963	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618758974	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618762975	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618767971	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.700000000000001	1715618767971	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6309	1715618767971	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618768996	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618772997	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618774005	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618775987	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715618775987	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6319	1715618775987	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618778994	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715618778994	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6321999999999997	1715618778994	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618782000	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.7	1715618782000	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6338000000000004	1715618782000	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618783002	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715618783002	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6338000000000004	1715618783002	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618785008	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5	1715618785008	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6346999999999996	1715618785008	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618786010	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715618786010	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6346999999999996	1715618786010	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618788029	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618790039	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618791041	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618798057	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618799058	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618801064	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6511	1715619019500	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619020502	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619020502	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6511	1715619020502	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619028519	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715619028519	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6531	1715619028519	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619029520	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715619029520	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6531	1715619029520	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619031546	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619033550	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619034551	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619035546	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619037536	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619037536	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6521999999999997	1715619037536	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619041545	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619041545	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6536999999999997	1715619041545	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619051567	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619051567	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6544	1715619051567	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619126725	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6561	1715619126725	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619132737	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619132737	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0741	1715618449332	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618754944	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.7	1715618754944	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6224000000000003	1715618754944	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618756961	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618761978	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618766990	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618771979	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618771979	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6250999999999998	1715618771979	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618776990	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8	1715618776990	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6319	1715618776990	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618777992	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5	1715618777992	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6319	1715618777992	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618780998	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5	1715618780998	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6321999999999997	1715618780998	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618784004	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8	1715618784004	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6338000000000004	1715618784004	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618787012	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.7	1715618787012	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6346999999999996	1715618787012	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618792022	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8	1715618792022	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6304000000000003	1715618792022	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715618796031	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.7	1715618796031	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6324	1715618796031	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618800039	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8	1715618800039	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6339	1715618800039	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618804048	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618804048	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6343	1715618804048	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618806052	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715618806052	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6349	1715618806052	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618807054	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618807054	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6349	1715618807054	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618808056	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618808056	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6349	1715618808056	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619033528	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6531	1715619033528	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619034530	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.9	1715619034530	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6551	1715619034530	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619035532	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619035532	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6551	1715619035532	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619036534	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715619036534	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6551	1715619036534	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619037551	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619041565	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619051590	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619128729	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6549	1715619128729	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619133739	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619133739	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618450310	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618450310	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.4033	1715618450310	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618453316	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1000000000000005	1715618453316	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6594	1715618453316	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0741	1715618453335	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618454319	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618454319	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6699	1715618454319	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0741	1715618454384	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618455321	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715618455321	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6699	1715618455321	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0741	1715618455337	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618456323	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7	1715618456323	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6699	1715618456323	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0741	1715618456341	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618457325	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.8	1715618457325	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6719	1715618457325	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0741	1715618457340	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618458327	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.899999999999999	1715618458327	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6719	1715618458327	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0741	1715618458343	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618459330	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618459330	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6719	1715618459330	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0741	1715618459343	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618460332	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1000000000000005	1715618460332	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6727	1715618460332	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618460348	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618461334	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715618461334	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6727	1715618461334	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618461350	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618462336	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.5	1715618462336	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6727	1715618462336	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618462353	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618463338	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.8	1715618463338	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6728	1715618463338	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618463353	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618464340	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.4	1715618464340	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6728	1715618464340	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618464354	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618465342	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715618465342	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6728	1715618465342	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618465357	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618466345	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.299999999999999	1715618466345	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6717	1715618466345	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618466361	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618467347	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7	1715618467347	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6717	1715618467347	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618467362	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715618468349	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618468349	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6717	1715618468349	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618472358	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1000000000000005	1715618472358	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6767	1715618472358	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618475364	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7	1715618475364	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6004	1715618475364	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618477383	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618478384	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618485400	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618488403	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618499428	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618501434	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618507443	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618508446	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618754965	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618759968	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618760970	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618764988	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618767988	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618770992	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618794051	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618795042	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618809059	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618809059	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6355	1715618809059	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618810061	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618810061	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6355	1715618810061	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619048574	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619049585	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6559	1715619132737	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619138750	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715619138750	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6549	1715619138750	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619141757	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619141757	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6559	1715619141757	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619142759	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619142759	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6561999999999997	1715619142759	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619145765	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619145765	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6546999999999996	1715619145765	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619148771	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619148771	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.654	1715619148771	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619159816	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619160818	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619162817	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619163816	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619164805	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619164805	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6593	1715619164805	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619164821	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10	1715619165807	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6593	1715619165807	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619165829	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619166809	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619166809	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6579	1715619166809	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619166831	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619167811	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619167831	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618468362	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618472371	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618475377	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618478370	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715618478370	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6013	1715618478370	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618485384	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618485384	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6054	1715618485384	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618488391	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7	1715618488391	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6063	1715618488391	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618499414	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618499414	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6106	1715618499414	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618501418	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618501418	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6106	1715618501418	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618507430	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.8	1715618507430	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6073000000000004	1715618507430	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618508432	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618508432	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6075	1715618508432	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618756948	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618756948	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6224000000000003	1715618756948	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618761958	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.7	1715618761958	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6216999999999997	1715618761958	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618766968	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618766968	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6309	1715618766968	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618769997	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618775008	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618777002	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618778005	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618781019	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618784025	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618787026	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618792044	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618796057	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618800061	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618804069	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618806073	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618807067	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618808069	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619053571	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619053571	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6552	1715619053571	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619054573	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619054573	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6552	1715619054573	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619070607	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619070607	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6515999999999997	1715619070607	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619072613	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619072613	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6515999999999997	1715619072613	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619082648	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619085655	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619086656	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619087658	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619088667	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618469352	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.4	1715618469352	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6746	1715618469352	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618470354	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618470354	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6746	1715618470354	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618474362	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618474362	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6767	1715618474362	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618479372	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.2	1715618479372	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6013	1715618479372	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618483380	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715618483380	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6014	1715618483380	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618489393	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.8	1715618489393	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6063	1715618489393	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618491412	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618493415	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618495406	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618495406	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6105	1715618495406	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618502420	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618502420	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6111	1715618502420	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618503422	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618503422	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6111	1715618503422	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618506428	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618506428	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6073000000000004	1715618506428	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618759954	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.1	1715618759954	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6237	1715618759954	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618760956	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618760956	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6216999999999997	1715618760956	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618764964	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618764964	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6215	1715618764964	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	63	1715618765966	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618765966	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6215	1715618765966	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618770977	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5	1715618770977	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6250999999999998	1715618770977	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618794027	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715618794027	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6324	1715618794027	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715618795029	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618795029	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6324	1715618795029	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618802043	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715618802043	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6339	1715618802043	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618809081	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618810082	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619053594	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619054588	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619070629	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619082634	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619082634	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6544	1715619082634	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618469365	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618470367	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618477368	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1000000000000005	1715618477368	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6004	1715618477368	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618479385	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618483399	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618491397	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618491397	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.607	1715618491397	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618493401	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618493401	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6105	1715618493401	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618494404	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618494404	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6105	1715618494404	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618495420	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618502435	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618503436	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618506447	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618813068	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618813068	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6363000000000003	1715618813068	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618817076	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618817076	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6328	1715618817076	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618818078	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618818078	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6351	1715618818078	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618819080	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.999999999999999	1715618819080	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6351	1715618819080	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618820082	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618820082	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6351	1715618820082	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618827097	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618827097	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6369000000000002	1715618827097	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618832107	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618832107	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6369000000000002	1715618832107	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618834111	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618834111	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.637	1715618834111	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618835113	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	11.399999999999999	1715618835113	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.637	1715618835113	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618844133	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.799999999999999	1715618844133	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6318	1715618844133	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618846157	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618847154	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618850145	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618850145	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6314	1715618850145	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618851148	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.999999999999999	1715618851148	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6344000000000003	1715618851148	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618855170	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618858162	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618858162	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6339	1715618858162	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618860166	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618860166	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618471356	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618471356	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6746	1715618471356	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618474376	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618482392	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618487405	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618492399	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618492399	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.607	1715618492399	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618496408	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618496408	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6073000000000004	1715618496408	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618504436	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618505439	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618512454	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618813089	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618817099	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618818094	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618819102	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618826095	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618826095	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.635	1715618826095	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618827117	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618832128	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618834133	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618842149	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618844154	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618847139	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618847139	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6336999999999997	1715618847139	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618849143	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618849143	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6314	1715618849143	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618850166	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618855156	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618855156	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6355999999999997	1715618855156	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618857175	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618858183	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618860188	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619055575	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619055575	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6521	1715619055575	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619056578	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.5	1715619056578	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6521	1715619056578	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619062591	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619062591	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6545	1715619062591	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619063593	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619063593	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6545	1715619063593	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619065597	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619065597	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6546	1715619065597	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619069622	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619071631	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619078626	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619078626	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.651	1715619078626	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619081632	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619081632	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.65	1715619081632	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619090650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618471370	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618482379	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7	1715618482379	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6014	1715618482379	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618487389	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618487389	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6063	1715618487389	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618489407	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618492412	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618504424	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618504424	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6111	1715618504424	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618505426	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618505426	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6073000000000004	1715618505426	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618512440	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618512440	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6071	1715618512440	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715618814070	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618814070	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6363000000000003	1715618814070	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618815072	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618815072	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6328	1715618815072	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618820103	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618824111	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618830103	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618830103	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6369000000000002	1715618830103	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618831105	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3999999999999995	1715618831105	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6369000000000002	1715618831105	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715618833109	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618833109	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.637	1715618833109	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618835126	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618838135	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618839144	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618840139	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618841147	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618848158	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618859179	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618863186	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618865198	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618867202	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618870208	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619055597	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619056598	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619062605	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619063606	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619069605	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619069605	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6567	1715619069605	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619071609	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619071609	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6515999999999997	1715619071609	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619074631	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619078638	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619081650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619092655	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.7	1715619092655	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6491	1715619092655	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619100671	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619100671	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618473360	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.5	1715618473360	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6767	1715618473360	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618476366	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.699999999999999	1715618476366	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6004	1715618476366	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618480374	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618480374	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6013	1715618480374	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618481377	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618481377	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6014	1715618481377	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618484382	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.5	1715618484382	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6054	1715618484382	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618486387	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7	1715618486387	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6054	1715618486387	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	50	1715618490395	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1000000000000005	1715618490395	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.607	1715618490395	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618494419	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618497410	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618497410	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6073000000000004	1715618497410	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618498412	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618498412	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6073000000000004	1715618498412	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618500416	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618500416	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6106	1715618500416	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618509434	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618509434	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6075	1715618509434	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618510436	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618510436	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6075	1715618510436	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618511438	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618511438	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6071	1715618511438	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618814091	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618815096	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618824090	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618824090	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.635	1715618824090	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618826109	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618830124	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618831126	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618833124	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618838120	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618838120	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6329000000000002	1715618838120	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618839122	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.1	1715618839122	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6330999999999998	1715618839122	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618840124	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618840124	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6330999999999998	1715618840124	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618841126	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618841126	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6330999999999998	1715618841126	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618848141	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.3	1715618848141	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6314	1715618848141	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618473375	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618476382	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618480387	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618481393	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618484396	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07379999999999999	1715618486401	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618490408	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618496426	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618497423	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618498426	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618500431	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618509448	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618510455	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618511452	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618513442	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618513442	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6071	1715618513442	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618513456	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618514444	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618514444	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6081	1715618514444	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618514461	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618515446	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.1	1715618515446	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6081	1715618515446	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618515461	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618516448	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618516448	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6081	1715618516448	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618516463	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618517450	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618517450	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6069	1715618517450	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618517466	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618518452	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.299999999999999	1715618518452	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6069	1715618518452	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618518465	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618519454	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618519454	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6069	1715618519454	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618519467	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618520456	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618520456	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6109	1715618520456	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618520476	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618521458	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618521458	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6109	1715618521458	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618521482	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618522460	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618522460	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6109	1715618522460	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618522476	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618523462	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618523462	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6101	1715618523462	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618523481	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618524464	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618524464	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6101	1715618524464	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618524477	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618525466	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618525466	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6101	1715618525466	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618525480	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618527492	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618536510	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618539508	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618542515	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618546508	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618546508	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6103	1715618546508	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618551518	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618551518	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.613	1715618551518	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618552520	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618552520	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.613	1715618552520	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618553522	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618553522	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6098000000000003	1715618553522	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618555526	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618555526	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6098000000000003	1715618555526	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618562540	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618562540	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6155	1715618562540	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618566572	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618568573	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618570577	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618816074	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618816074	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6328	1715618816074	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715618823088	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.1	1715618823088	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6355999999999997	1715618823088	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618825092	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618825092	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.635	1715618825092	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618845135	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.1	1715618845135	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6336999999999997	1715618845135	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618846137	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618846137	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6336999999999997	1715618846137	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618853152	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.5	1715618853152	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6344000000000003	1715618853152	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618854154	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618854154	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6355999999999997	1715618854154	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618856158	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618856158	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6355999999999997	1715618856158	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618861168	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618861168	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6341	1715618861168	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618864195	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618866200	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618869185	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618869185	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6373	1715618869185	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618871189	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618871189	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6373	1715618871189	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618872192	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618872192	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6357	1715618872192	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618526468	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618526468	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6088	1715618526468	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618534484	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618534484	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6106	1715618534484	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618535486	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618535486	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6106	1715618535486	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618538492	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618538492	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6063	1715618538492	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618540496	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618540496	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6063	1715618540496	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618541499	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618541499	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6101	1715618541499	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618545506	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618545506	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6103	1715618545506	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618548512	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618548512	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6107	1715618548512	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618549530	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618567572	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618571558	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618571558	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6155	1715618571558	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618816088	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618823103	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618825106	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618845156	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618851169	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618853172	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618854175	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618856180	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618864175	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.1	1715618864175	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6338000000000004	1715618864175	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618866179	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618866179	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6381	1715618866179	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618868183	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618868183	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6381	1715618868183	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618869207	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618871213	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618872213	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619057580	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619057580	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6521	1715619057580	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619058582	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.5	1715619058582	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6541	1715619058582	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619059584	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619059584	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6541	1715619059584	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619064595	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.9	1715619064595	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6546	1715619064595	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619065623	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619067616	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619068617	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618526482	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618534497	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618535509	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618538510	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618540511	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618541514	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618545527	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618549514	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618549514	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6107	1715618549514	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618567550	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618567550	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6169000000000002	1715618567550	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618569554	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618569554	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6163000000000003	1715618569554	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618571572	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618821085	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618821085	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6355999999999997	1715618821085	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618822087	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.4	1715618822087	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6355999999999997	1715618822087	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618828099	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.4	1715618828099	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6369000000000002	1715618828099	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618829101	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618829101	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6369000000000002	1715618829101	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618836115	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618836115	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6329000000000002	1715618836115	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618837118	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618837118	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6329000000000002	1715618837118	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618842128	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618842128	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6318	1715618842128	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618843144	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618852150	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618852150	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6344000000000003	1715618852150	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715618857160	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618857160	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6339	1715618857160	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618862170	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618862170	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6341	1715618862170	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619057593	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619058606	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619059606	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619064615	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619067600	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.5	1715619067600	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6567	1715619067600	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619068603	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619068603	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6567	1715619068603	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619072637	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619080643	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619084653	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619091665	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619097679	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619101694	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618527470	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618527470	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6088	1715618527470	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618536488	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618536488	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6106	1715618536488	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618539494	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618539494	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6063	1715618539494	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618542500	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.5	1715618542500	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6101	1715618542500	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618543502	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618543502	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6101	1715618543502	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618546530	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618551539	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618552535	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618553543	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618555540	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618562553	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618568552	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618568552	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6163000000000003	1715618568552	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618570556	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618570556	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6163000000000003	1715618570556	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618821099	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618822101	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618828120	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618829115	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618836136	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618837132	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618843130	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618843130	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6318	1715618843130	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618849164	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618852163	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618861189	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618862191	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619060587	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619060587	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6541	1715619060587	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619061589	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619061589	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6545	1715619061589	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619066598	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619066598	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6546	1715619066598	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619073615	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619073615	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6519	1715619073615	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619074617	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.600000000000001	1715619074617	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6519	1715619074617	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619075644	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619076642	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619077645	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619079642	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619083650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619093671	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619096663	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619096663	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6517	1715619096663	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618528472	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618528472	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6088	1715618528472	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618530476	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618530476	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6088	1715618530476	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618532480	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618532480	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6106	1715618532480	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618533482	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618533482	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6106	1715618533482	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618543517	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618547531	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618550516	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618550516	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.613	1715618550516	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618557530	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618557530	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6125	1715618557530	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618559534	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618559534	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6129000000000002	1715618559534	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618565546	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618565546	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6169000000000002	1715618565546	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618566548	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618566548	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6169000000000002	1715618566548	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618572560	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618572560	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6155	1715618572560	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618859164	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.799999999999999	1715618859164	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6339	1715618859164	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	106	1715618863173	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	12.600000000000001	1715618863173	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6338000000000004	1715618863173	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618865177	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.799999999999999	1715618865177	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6338000000000004	1715618865177	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618867181	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618867181	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6381	1715618867181	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618870187	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.5	1715618870187	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6373	1715618870187	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619060608	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619061610	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619066624	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619073631	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619075619	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619075619	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6519	1715619075619	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619076622	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619076622	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.651	1715619076622	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619077624	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619077624	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.651	1715619077624	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619079628	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619079628	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.65	1715619079628	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619083636	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618528493	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618530497	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618532501	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618533497	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618547510	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.5999999999999996	1715618547510	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6107	1715618547510	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618548532	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618550536	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618557544	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618559550	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618565566	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618569569	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618572581	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6341	1715618860166	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618868197	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619080630	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619080630	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.65	1715619080630	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619084638	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619084638	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6544	1715619084638	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619091652	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619091652	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6491	1715619091652	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619097665	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619097665	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6535	1715619097665	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619101673	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619101673	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6528	1715619101673	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619102675	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619102675	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6528	1715619102675	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619107686	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619107686	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6576	1715619107686	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619110692	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619110692	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6579	1715619110692	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619114721	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619115715	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619123732	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619125744	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6521999999999997	1715619133739	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619134741	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619134741	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6521999999999997	1715619134741	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619135760	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619136761	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619139766	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619140769	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619143776	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619146767	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619146767	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6546999999999996	1715619146767	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619149795	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619150776	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619150776	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.654	1715619150776	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619152801	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619153803	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619155802	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619156804	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619157790	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618529474	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618529474	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6088	1715618529474	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618531478	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618531478	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6088	1715618531478	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618537490	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618537490	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6106	1715618537490	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618544504	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618544504	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6103	1715618544504	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618554524	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618554524	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6098000000000003	1715618554524	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618556528	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618556528	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6125	1715618556528	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618558532	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618558532	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6125	1715618558532	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618560537	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618560537	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6129000000000002	1715618560537	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618561539	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618561539	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6129000000000002	1715618561539	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618563542	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618563542	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6155	1715618563542	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618564544	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618564544	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6155	1715618564544	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618873194	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618873194	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6357	1715618873194	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618876200	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.1	1715618876200	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6355	1715618876200	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618881210	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618881210	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6370999999999998	1715618881210	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618889228	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618889228	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.638	1715618889228	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618892256	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618894259	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618903278	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618909270	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.6	1715618909270	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6438	1715618909270	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618911274	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618911274	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6428000000000003	1715618911274	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618914281	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715618914281	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.644	1715618914281	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618921296	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618921296	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6389	1715618921296	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618927308	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715618927308	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6424000000000003	1715618927308	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	107.9	1715618928310	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618529487	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618531502	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618537507	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618544516	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618554538	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618556549	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618558555	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618560550	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618561559	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618563561	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618564565	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618573562	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618573562	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6155	1715618573562	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618573587	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618574564	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618574564	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6161999999999996	1715618574564	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618574577	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618575566	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618575566	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6161999999999996	1715618575566	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618575586	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618576568	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618576568	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6161999999999996	1715618576568	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618576589	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618577570	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618577570	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6159	1715618577570	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618577591	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618578573	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618578573	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6159	1715618578573	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618578587	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618579575	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618579575	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6159	1715618579575	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618579589	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618580577	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618580577	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6151999999999997	1715618580577	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618580598	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618581579	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618581579	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6151999999999997	1715618581579	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618581595	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618582581	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618582581	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6151999999999997	1715618582581	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618582602	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618583583	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618583583	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6175	1715618583583	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618583597	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618584585	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618584585	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6175	1715618584585	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618584600	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618585587	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618585587	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6175	1715618585587	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618585609	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618586589	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618586602	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618586589	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6179	1715618586589	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618587591	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618587591	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6179	1715618587591	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618590597	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618590597	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6198	1715618590597	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618592601	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618592601	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.619	1715618592601	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618595607	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618595607	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6186	1715618595607	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618597611	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618597611	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6186	1715618597611	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618598627	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618603650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618604639	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618616650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618616650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6181	1715618616650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618619656	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618619656	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6204	1715618619656	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618620673	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618623687	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618873209	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618876222	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618881231	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618889244	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618894239	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.7	1715618894239	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6405	1715618894239	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618900268	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618908282	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618909291	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618911296	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618914304	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618921319	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618927321	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618928324	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618930328	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619083636	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6544	1715619083636	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619093657	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619093657	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6491	1715619093657	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619095686	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619096681	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619098688	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619103700	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619104700	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619105703	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619108709	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619116704	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10	1715619116704	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6553	1715619116704	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619119710	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619119710	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6553	1715619119710	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619121714	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619121714	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618587612	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618590611	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618592617	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618595628	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618597637	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618603624	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618603624	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6153000000000004	1715618603624	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618604626	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618604626	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6191	1715618604626	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618606651	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618618654	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618618654	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6181	1715618618654	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618619670	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618623664	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618623664	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6187	1715618623664	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618874196	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618874196	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6357	1715618874196	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618884216	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618884216	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6382	1715618884216	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618887247	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618888240	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618893236	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618893236	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6405	1715618893236	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618895241	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.1	1715618895241	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6405	1715618895241	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618899249	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618899249	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6403000000000003	1715618899249	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618904260	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618904260	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6441	1715618904260	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618908268	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618908268	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6438	1715618908268	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618918290	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618918290	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6441999999999997	1715618918290	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618919292	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618919292	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6441999999999997	1715618919292	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619085640	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.2	1715619085640	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6534	1715619085640	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619086642	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	12.9	1715619086642	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6534	1715619086642	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619087644	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619087644	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6534	1715619087644	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619088646	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619088646	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6532	1715619088646	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619089648	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619089648	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6532	1715619089648	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619090671	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618588593	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618588593	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6179	1715618588593	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618605628	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618605628	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6191	1715618605628	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618609636	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618609636	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6146	1715618609636	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618612656	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618624666	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618624666	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6187	1715618624666	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618874219	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618887224	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618887224	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.638	1715618887224	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618888226	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618888226	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.638	1715618888226	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618892234	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618892234	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6389	1715618892234	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618893250	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618895254	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618899264	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618904281	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618912293	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618918310	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618919313	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619089670	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619094659	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619094659	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6517	1715619094659	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619095661	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10	1715619095661	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6517	1715619095661	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619099693	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619106704	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619109713	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619111716	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619113722	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619117727	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619120735	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619126746	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619132750	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619138764	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619141771	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619142772	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619145779	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619148786	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619152780	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6533	1715619152780	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619153782	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619153782	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6533	1715619153782	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619155787	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619155787	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6526	1715619155787	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619156788	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619156788	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6526	1715619156788	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619159794	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619159794	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618588614	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618605650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618609650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618616672	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618624680	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618875198	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618875198	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6355	1715618875198	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618877202	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618877202	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6355	1715618877202	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618878204	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618878204	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6370999999999998	1715618878204	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618879206	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618879206	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6370999999999998	1715618879206	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618880207	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618880207	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6370999999999998	1715618880207	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618891232	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618891232	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6389	1715618891232	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618896243	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618896243	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6408	1715618896243	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618898247	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618898247	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6408	1715618898247	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618900251	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618900251	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6403000000000003	1715618900251	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618902268	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618907282	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618915305	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618916306	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618920315	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618922320	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618924322	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618925325	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618929333	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619090650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6532	1715619090650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619092668	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619100692	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619112709	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619118721	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619122730	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619124741	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619129746	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619130746	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619131750	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619137748	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10	1715619137748	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6549	1715619137748	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619144776	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619149773	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.7	1715619149773	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.654	1715619149773	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619151791	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619154807	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619157790	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6558	1715619157790	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619158792	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619161811	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618589595	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618589595	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6198	1715618589595	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618591599	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618591599	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6198	1715618591599	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618593603	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618593603	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.619	1715618593603	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618596609	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618596609	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6186	1715618596609	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618598614	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618598614	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6181	1715618598614	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618599629	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618601635	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618602644	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618613666	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618614662	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618615670	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618620658	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618620658	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6204	1715618620658	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618875218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618877223	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618878219	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618879221	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618880230	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618891254	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618896265	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618898263	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618902256	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618902256	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6441	1715618902256	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618907266	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618907266	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6439	1715618907266	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618915283	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618915283	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.644	1715618915283	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618916285	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618916285	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.644	1715618916285	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618920294	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618920294	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6389	1715618920294	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618922298	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618922298	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6389	1715618922298	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618924302	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618924302	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.643	1715618924302	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618925304	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618925304	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.643	1715618925304	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618929312	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618929312	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6445	1715618929312	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619094680	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619099669	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.600000000000001	1715619099669	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6535	1715619099669	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619106684	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618589608	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618591613	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618593616	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618596630	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618599616	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618599616	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6181	1715618599616	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618601620	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618601620	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6153000000000004	1715618601620	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618602622	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618602622	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6153000000000004	1715618602622	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618613644	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618613644	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6203000000000003	1715618613644	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618614646	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618614646	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6203000000000003	1715618614646	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618615648	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618615648	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6203000000000003	1715618615648	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618618675	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618630679	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618630679	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6176	1715618630679	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618882212	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.6	1715618882212	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6370999999999998	1715618882212	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618883214	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618883214	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6370999999999998	1715618883214	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618884239	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618885232	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618886242	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618890255	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618897259	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618901269	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618905262	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715618905262	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6439	1715618905262	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618906264	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618906264	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6439	1715618906264	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618910272	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618910272	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6438	1715618910272	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618912276	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.5	1715618912276	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6428000000000003	1715618912276	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618913296	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618917310	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618923315	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618926327	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618931331	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618932340	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619098667	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619098667	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6535	1715619098667	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619103677	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619103677	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6566	1715619103677	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619104679	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619104679	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618594605	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618594605	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.619	1715618594605	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618600618	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618600618	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6181	1715618600618	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618606630	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618606630	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6191	1715618606630	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618607646	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618608658	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618610660	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618611661	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618617652	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618617652	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6181	1715618617652	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618621660	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618621660	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6204	1715618621660	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618622662	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618622662	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6187	1715618622662	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618625669	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618625669	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6172	1715618625669	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618626671	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618626671	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6172	1715618626671	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618627673	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715618627673	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6172	1715618627673	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618628675	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618628675	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6176	1715618628675	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618629677	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.5	1715618629677	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6176	1715618629677	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618630700	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618631702	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618882233	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618883229	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618885218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618885218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6382	1715618885218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618886221	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715618886221	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6382	1715618886221	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618890230	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618890230	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6389	1715618890230	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618897245	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.1	1715618897245	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6408	1715618897245	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618901253	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.1	1715618901253	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6403000000000003	1715618901253	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618903258	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618903258	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6441	1715618903258	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618905285	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618906283	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618910293	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618913279	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618913279	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618594618	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618600633	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618607632	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618607632	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6146	1715618607632	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618608634	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618608634	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6146	1715618608634	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618610638	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618610638	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6181	1715618610638	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618611640	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618611640	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6181	1715618611640	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618612642	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618612642	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6181	1715618612642	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618617665	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618621682	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618622675	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618625690	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618626693	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618627687	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618628693	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618629690	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618631681	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618631681	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6182	1715618631681	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618632683	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618632683	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6182	1715618632683	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618632696	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618633685	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618633685	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6182	1715618633685	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618633708	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618634687	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618634687	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6201	1715618634687	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618634701	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618635689	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618635689	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6201	1715618635689	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618635711	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618636691	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618636691	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6201	1715618636691	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618636715	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618637695	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618637695	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6193	1715618637695	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618637709	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618638698	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618638698	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6193	1715618638698	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618638716	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618639701	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618639701	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6193	1715618639701	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618639714	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618640703	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618640703	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6209000000000002	1715618640703	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618640725	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618641705	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618641705	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6209000000000002	1715618641705	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618642708	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618642708	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6209000000000002	1715618642708	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618647718	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618647718	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.622	1715618647718	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618655735	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618655735	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6228000000000002	1715618655735	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618656737	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618656737	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6228000000000002	1715618656737	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618659743	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715618659743	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618659743	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618661749	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618661749	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6235999999999997	1715618661749	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618662767	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618664777	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618666783	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618671792	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618672787	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618674777	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618674777	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6223	1715618674777	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618680790	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618680790	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6235999999999997	1715618680790	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618681792	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618681792	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6235999999999997	1715618681792	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618682794	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618682794	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6219	1715618682794	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618683796	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618683796	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6219	1715618683796	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618684798	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.5	1715618684798	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6219	1715618684798	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618690810	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618690810	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6224000000000003	1715618690810	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6428000000000003	1715618913279	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618917288	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.9	1715618917288	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6441999999999997	1715618917288	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618923300	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618923300	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.643	1715618923300	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618926306	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618926306	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6424000000000003	1715618926306	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618931316	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618931316	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6445	1715618931316	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618932319	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618932319	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6435999999999997	1715618932319	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6528	1715619100671	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618641729	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618644712	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618644712	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6216999999999997	1715618644712	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618647732	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618655756	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618656759	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618659765	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618661769	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618664757	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618664757	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6221	1715618664757	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618666761	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618666761	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6221	1715618666761	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618671771	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618671771	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.622	1715618671771	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618672773	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618672773	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.622	1715618672773	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618673775	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618673775	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6223	1715618673775	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618674799	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618680813	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618681814	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618682816	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618683810	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618684819	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618690831	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618928310	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6424000000000003	1715618928310	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618930314	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618930314	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6445	1715618930314	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619102689	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619107699	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619110713	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619115702	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619115702	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6553	1715619115702	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619123718	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619123718	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6549	1715619123718	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619125723	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619125723	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6561	1715619125723	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619133754	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619134756	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619147769	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619147769	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6546999999999996	1715619147769	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619150789	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619157805	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619158792	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6558	1715619158792	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619158805	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619162801	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6571	1715619162801	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619163803	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619163803	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6593	1715619163803	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619165807	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618642722	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618648720	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.1	1715618648720	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.622	1715618648720	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618652729	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618652729	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.622	1715618652729	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618660747	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618660747	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618660747	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618662751	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618662751	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6235999999999997	1715618662751	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618669784	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618675780	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.5	1715618675780	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6223	1715618675780	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618677784	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618677784	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6221	1715618677784	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618687804	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618687804	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6186	1715618687804	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618688806	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618688806	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6224000000000003	1715618688806	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618689808	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618689808	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6224000000000003	1715618689808	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618691812	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618691812	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6223	1715618691812	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618933321	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.6	1715618933321	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6435999999999997	1715618933321	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618934323	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.5	1715618934323	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6435999999999997	1715618934323	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618937352	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618941358	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618943358	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618947372	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618952383	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618956392	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618968395	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618968395	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6404	1715618968395	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618973406	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715618973406	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.641	1715618973406	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618974408	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618974408	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6426999999999996	1715618974408	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715618975410	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618975410	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6426999999999996	1715618975410	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618978442	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618985430	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.799999999999999	1715618985430	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6477	1715618985430	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618987434	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618987434	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6466	1715618987434	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618988453	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618643710	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618643710	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6216999999999997	1715618643710	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618650725	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618650725	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618650725	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618653745	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618654746	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618657759	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618658756	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618663774	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618668765	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618668765	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6226	1715618668765	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618670769	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618670769	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.622	1715618670769	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618676782	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618676782	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6221	1715618676782	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618679788	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618679788	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6235999999999997	1715618679788	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618685800	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618685800	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6186	1715618685800	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618933342	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618937329	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715618937329	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6438	1715618937329	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618941338	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618941338	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6403000000000003	1715618941338	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618943342	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618943342	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6403000000000003	1715618943342	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618947351	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618947351	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6454	1715618947351	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618952362	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618952362	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6459	1715618952362	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618956370	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618956370	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6447	1715618956370	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618959394	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618968408	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618973419	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618974430	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618975430	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618983440	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618985451	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618987455	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618992445	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618992445	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6447	1715618992445	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618993470	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619002481	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619003491	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619004491	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619006487	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619007489	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619009480	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619009480	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618643724	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618653731	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618653731	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.622	1715618653731	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618654733	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618654733	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.622	1715618654733	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618657739	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618657739	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6228000000000002	1715618657739	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618658741	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618658741	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618658741	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618663753	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618663753	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6235999999999997	1715618663753	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618665759	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618665759	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6221	1715618665759	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618668778	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618670791	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618676803	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618679809	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618685815	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618934345	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618935346	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618936347	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618946349	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715618946349	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6431	1715618946349	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618949355	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618949355	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6454	1715618949355	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618953364	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618953364	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6444	1715618953364	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618957372	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618957372	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6447	1715618957372	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618962383	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618962383	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6452	1715618962383	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618965389	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.799999999999999	1715618965389	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6412	1715618965389	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618966391	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618966391	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6412	1715618966391	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618967393	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715618967393	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6412	1715618967393	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715618970399	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618970399	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6404	1715618970399	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715618971402	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.4	1715618971402	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.641	1715618971402	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618977414	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618977414	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6471999999999998	1715618977414	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618978416	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618978416	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6471999999999998	1715618978416	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618979441	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618644726	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618645714	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618645714	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6216999999999997	1715618645714	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618645736	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618646716	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618646716	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.622	1715618646716	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618646738	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618648741	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618649723	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618649723	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618649723	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618649736	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618650745	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618651727	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618651727	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618651727	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618651748	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618652751	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618660760	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618665772	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618667763	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618667763	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6226	1715618667763	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618667777	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618669767	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618669767	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6226	1715618669767	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618673792	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618675800	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618677797	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618678786	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.5	1715618678786	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6221	1715618678786	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618678805	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618686802	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618686802	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6186	1715618686802	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618686817	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618687825	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618688821	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618689829	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618691834	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618692814	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618692814	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6223	1715618692814	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618692827	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618693816	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618693816	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6223	1715618693816	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618693837	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618694818	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618694818	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618694818	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618694841	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618695820	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618695820	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618695820	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618695838	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618696822	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618696822	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618696822	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618696845	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618697824	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618697824	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618697824	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618703903	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618708868	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618710866	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618714859	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.799999999999999	1715618714859	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6225	1715618714859	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618716863	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.7	1715618716863	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6234	1715618716863	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618717865	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618717865	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6234	1715618717865	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618721873	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.1	1715618721873	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6222	1715618721873	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618722875	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618722875	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6222	1715618722875	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618736927	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618740936	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618743920	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715618743920	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6238	1715618743920	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618935325	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618935325	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6438	1715618935325	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618936327	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618936327	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6438	1715618936327	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	108	1715618944344	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618944344	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6431	1715618944344	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618948367	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618949378	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618953377	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618959376	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715618959376	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6425	1715618959376	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618962398	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618965403	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618966415	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618967414	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618970421	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618971422	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618977437	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618979418	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618979418	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6471999999999998	1715618979418	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618981422	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618981422	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6469	1715618981422	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618982424	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618982424	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6469	1715618982424	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618984428	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618984428	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6477	1715618984428	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618988436	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618988436	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6466	1715618988436	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618990461	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619005471	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618697837	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618698826	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618698826	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618698826	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618698840	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618699851	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618702834	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.6	1715618702834	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.625	1715618702834	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	6.9	1715618705841	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.7	1715618705841	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6227	1715618705841	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618705861	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618707845	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715618707845	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6198	1715618707845	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618707858	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618709849	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618709849	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6213	1715618709849	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618711852	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618711852	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6213	1715618711852	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618711866	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618712875	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618715861	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618715861	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6234	1715618715861	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618715882	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618718867	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618718867	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618718867	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618718883	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618719892	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618726900	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618728901	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618729890	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618729890	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6195	1715618729890	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618729913	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618730913	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618731894	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618731894	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6221	1715618731894	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618732897	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715618732897	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6221	1715618732897	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618734901	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618734901	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618734901	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618735903	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7	1715618735903	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618735903	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618736905	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.3	1715618736905	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6248	1715618736905	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618738909	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.1	1715618738909	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6248	1715618738909	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618738931	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618739931	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618743936	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618746927	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.7	1715618746927	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618699828	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.8999999999999995	1715618699828	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618699828	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618702848	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618709862	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618719869	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.7	1715618719869	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618719869	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618726884	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.7	1715618726884	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6254	1715618726884	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618728888	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.1	1715618728888	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6195	1715618728888	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618730892	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.3999999999999995	1715618730892	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6221	1715618730892	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	0	1715618733899	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	0	1715618733899	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618733899	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618734922	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618735927	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618739911	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.7	1715618739911	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6237	1715618739911	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618742941	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618747951	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618938331	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618938331	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6456999999999997	1715618938331	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618939333	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618939333	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6456999999999997	1715618939333	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618940335	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618940335	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6456999999999997	1715618940335	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618942340	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618942340	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6403000000000003	1715618942340	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618946365	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618950358	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715618950358	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6459	1715618950358	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618955368	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.9	1715618955368	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6444	1715618955368	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618964387	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715618964387	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6452	1715618964387	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618972404	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618972404	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.641	1715618972404	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618976412	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618976412	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6426999999999996	1715618976412	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618980420	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.9	1715618980420	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6469	1715618980420	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618989439	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618989439	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6468000000000003	1715618989439	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618991457	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618996453	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618996453	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618700830	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618700830	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.625	1715618700830	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618701832	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4	1715618701832	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.625	1715618701832	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618704838	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618704838	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6227	1715618704838	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618706843	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618706843	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6198	1715618706843	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618713857	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618713857	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6225	1715618713857	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618720871	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618720871	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6233	1715618720871	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618723877	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618723877	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6222	1715618723877	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618724880	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.7	1715618724880	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6254	1715618724880	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618725882	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618725882	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6254	1715618725882	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618727886	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618727886	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6195	1715618727886	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618731916	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618733917	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618737921	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618741930	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618744947	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618745945	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618748948	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618751961	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618938347	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618939347	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618940356	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618942422	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618948353	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.9	1715618948353	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6454	1715618948353	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618950379	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618955381	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618964401	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618972417	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618976429	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618980442	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618989464	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618992458	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618996475	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	109	1715619001464	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715619001464	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.649	1715619001464	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619010482	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715619010482	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6499	1715619010482	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	108	1715619013488	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715619013488	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6515	1715619013488	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619016494	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618700852	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618701853	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618704860	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618706865	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618713874	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618720885	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618723899	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618724893	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618725903	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618727909	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618732917	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618737907	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618737907	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6248	1715618737907	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618741916	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.1	1715618741916	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6237	1715618741916	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618744923	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715618744923	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6238	1715618744923	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618745925	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618745925	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6231	1715618745925	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618748931	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618748931	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6209000000000002	1715618748931	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	1	1715618751938	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.8	1715618751938	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6224000000000003	1715618751938	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618944366	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618945361	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618951380	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618954387	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618958374	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618958374	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6447	1715618958374	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618960378	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618960378	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6425	1715618960378	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618961380	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715618961380	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6425	1715618961380	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618963385	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618963385	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6452	1715618963385	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715618969397	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715618969397	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6404	1715618969397	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618983426	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715618983426	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6477	1715618983426	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618986453	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618994470	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618995472	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618997469	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618998480	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618999540	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619014503	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619019524	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619020523	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619028539	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619031524	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.4	1715619031524	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6531	1715619031524	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619033528	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618703836	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618703836	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6227	1715618703836	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	4	1715618708847	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715618708847	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6198	1715618708847	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618710851	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.7	1715618710851	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6213	1715618710851	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618712855	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.7	1715618712855	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6225	1715618712855	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618714882	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618716885	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618717886	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618721895	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618722890	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	3	1715618740913	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618740913	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6237	1715618740913	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618742918	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715618742918	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6238	1715618742918	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618750936	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.7	1715618750936	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6209000000000002	1715618750936	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618945347	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618945347	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6431	1715618945347	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618951360	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715618951360	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6459	1715618951360	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618954366	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618954366	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6444	1715618954366	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618957385	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618958387	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618960391	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618961394	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618963401	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618969418	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618986432	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618986432	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6466	1715618986432	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715618994449	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618994449	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6447	1715618994449	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618995451	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618995451	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6498000000000004	1715618995451	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618997455	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715618997455	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6498000000000004	1715618997455	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715618998458	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715618998458	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6506	1715618998458	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715618999460	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715618999460	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6506	1715618999460	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619000462	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619000462	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6506	1715619000462	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619019500	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619019500	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6231	1715618746927	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618749934	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	4.1	1715618749934	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6209000000000002	1715618749934	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618981443	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618982443	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618984449	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715618990440	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618990440	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6468000000000003	1715618990440	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618991443	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715618991443	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6468000000000003	1715618991443	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619005494	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619011484	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.7	1715619011484	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6499	1715619011484	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619012486	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619012486	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6499	1715619012486	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619014490	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715619014490	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6515	1715619014490	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619021526	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619022521	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619025534	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619026536	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619027531	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619038562	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619044577	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619050579	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619052583	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6566	1715619104679	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619105682	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619105682	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6566	1715619105682	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619108688	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619108688	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6576	1715619108688	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619114700	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619114700	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6536999999999997	1715619114700	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619116717	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619119734	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619121735	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619127740	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619128743	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619135744	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10	1715619135744	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6521999999999997	1715619135744	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619139753	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619139753	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6559	1715619139753	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619140755	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619140755	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6559	1715619140755	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619143761	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619143761	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6561999999999997	1715619143761	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619144763	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619144763	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6561999999999997	1715619144763	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619146782	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619152780	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618746951	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618749956	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715618993447	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	12.8	1715618993447	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6447	1715618993447	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619002466	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	2.9	1715619002466	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.649	1715619002466	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619003468	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.4	1715619003468	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.649	1715619003468	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619004470	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619004470	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6483000000000003	1715619004470	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619006473	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619006473	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6483000000000003	1715619006473	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619007475	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715619007475	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6499	1715619007475	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619008478	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619008478	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6499	1715619008478	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619009501	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619015515	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619017510	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619018520	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619023530	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619032526	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619032526	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6531	1715619032526	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619039540	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619039540	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6521999999999997	1715619039540	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619043550	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.499999999999999	1715619043550	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6535	1715619043550	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619045554	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	12.8	1715619045554	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6535	1715619045554	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619046557	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619046557	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6561	1715619046557	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619047559	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619047559	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6561	1715619047559	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619106684	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6576	1715619106684	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619109690	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619109690	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6579	1715619109690	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619111694	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619111694	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6579	1715619111694	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619113698	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619113698	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6536999999999997	1715619113698	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619117706	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619117706	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6553	1715619117706	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619120712	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619120712	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6553	1715619120712	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619126725	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	2	1715618747929	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.199999999999999	1715618747929	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6231	1715618747929	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715618750958	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6498000000000004	1715618996453	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619000483	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619001485	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619010496	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619013510	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619016514	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619024531	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619030544	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619040543	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.999999999999999	1715619040543	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6536999999999997	1715619040543	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619042547	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619042547	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6536999999999997	1715619042547	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619048561	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619048561	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6561	1715619048561	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619049563	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619049563	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6544	1715619049563	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619112696	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619112696	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6536999999999997	1715619112696	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619118708	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10	1715619118708	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6553	1715619118708	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619122716	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.600000000000001	1715619122716	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6549	1715619122716	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619124720	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619124720	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6561	1715619124720	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619129731	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619129731	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6549	1715619129731	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619130733	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.2	1715619130733	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6559	1715619130733	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619131735	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.6	1715619131735	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6559	1715619131735	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619136746	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619136746	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6549	1715619136746	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619137762	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619147782	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619151778	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715619151778	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6533	1715619151778	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619154784	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.1	1715619154784	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6526	1715619154784	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6558	1715619159794	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619160797	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.600000000000001	1715619160797	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6571	1715619160797	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619161799	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.3	1715619161799	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6571	1715619161799	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619162801	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619167811	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6579	1715619167811	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619172822	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619172822	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6576	1715619172822	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619174851	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619175829	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.700000000000001	1715619175829	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6558	1715619175829	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619177848	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619178858	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619180863	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619185875	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619189877	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619190887	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619191888	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619192890	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619194875	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619194875	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6588000000000003	1715619194875	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619195877	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.700000000000001	1715619195877	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6588000000000003	1715619195877	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619197882	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619197882	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6601	1715619197882	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619200909	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619202913	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619203916	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619205921	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619206900	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619206900	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6595999999999997	1715619206900	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619207917	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619208926	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619209927	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619210923	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619212912	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.3	1715619212912	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.663	1715619212912	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619213936	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619214939	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619216940	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619217921	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619217921	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.661	1715619217921	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619218924	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619218924	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.661	1715619218924	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619225960	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619227942	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619227942	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6631	1715619227942	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619229946	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619229946	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6639	1715619229946	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619230970	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619231950	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619231950	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6639	1715619231950	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619232965	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619234980	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619235958	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619235958	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619168814	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619168814	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6579	1715619168814	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619170818	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619170818	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6567	1715619170818	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619171820	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619171820	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6567	1715619171820	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619172837	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619175852	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619176831	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619176831	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6558	1715619176831	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619178836	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619178836	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6586999999999996	1715619178836	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619179861	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619183870	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619184875	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619189863	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619189863	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6594	1715619189863	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619190865	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619190865	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6614	1715619190865	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619191867	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619191867	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6614	1715619191867	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619192869	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619192869	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6614	1715619192869	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619193872	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619193872	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6588000000000003	1715619193872	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619194898	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619200888	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619200888	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6601	1715619200888	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619201910	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619202892	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619202892	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6603000000000003	1715619202892	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619203894	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619203894	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6603000000000003	1715619203894	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619205898	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619205898	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6595999999999997	1715619205898	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619207902	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619207902	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6595999999999997	1715619207902	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619208905	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619208905	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6603000000000003	1715619208905	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619209907	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619209907	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6603000000000003	1715619209907	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619210909	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619210909	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6603000000000003	1715619210909	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619211932	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619212926	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619215942	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619168832	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619170834	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619171841	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619173824	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619173824	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6576	1715619173824	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619176845	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619179839	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619179839	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6586999999999996	1715619179839	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619181845	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619181845	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.659	1715619181845	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619182847	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619182847	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.659	1715619182847	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619183849	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.8	1715619183849	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.659	1715619183849	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619184851	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619184851	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6583	1715619184851	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619186855	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619186855	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6583	1715619186855	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619187858	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619187858	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6594	1715619187858	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619188860	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619188860	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6594	1715619188860	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619193891	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619196901	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619198899	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619199899	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619201890	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619201890	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6601	1715619201890	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619204917	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619211910	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619211910	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.663	1715619211910	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619215917	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619215917	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6614	1715619215917	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619219948	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619220928	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619220928	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6605	1715619220928	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619221951	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619222945	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619223934	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619223934	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6628000000000003	1715619223934	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619224936	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619224936	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6628000000000003	1715619224936	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619226940	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619226940	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6631	1715619226940	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619228964	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619233954	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619233954	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6647	1715619233954	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619169816	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619169816	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6567	1715619169816	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619173845	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619181866	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619182865	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619186877	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619187871	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619188883	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619196879	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619196879	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6601	1715619196879	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619198884	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619198884	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6601	1715619198884	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619199886	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.100000000000001	1715619199886	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6601	1715619199886	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619204896	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619204896	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6603000000000003	1715619204896	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619217944	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619218947	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619219926	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619219926	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.661	1715619219926	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619221930	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619221930	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6605	1715619221930	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619222932	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.8	1715619222932	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6605	1715619222932	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619227955	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619228944	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619228944	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6631	1715619228944	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619229967	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619231971	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619234956	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619234956	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6647	1715619234956	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6628000000000003	1715619235958	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619235980	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619236960	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619236960	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6628000000000003	1715619236960	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619236981	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619237962	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619237962	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6628000000000003	1715619237962	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619238964	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619238964	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6647	1715619238964	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619239967	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	11.1	1715619239967	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6647	1715619239967	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619241971	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619241971	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6607	1715619241971	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619241992	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619246001	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619247004	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619247984	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619247984	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619169837	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619174827	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619174827	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6576	1715619174827	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619177833	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.600000000000001	1715619177833	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6558	1715619177833	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619180841	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.600000000000001	1715619180841	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6586999999999996	1715619180841	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619185853	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619185853	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6583	1715619185853	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619195899	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619197902	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619206922	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619213914	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619213914	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.663	1715619213914	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619214916	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619214916	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6614	1715619214916	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619216919	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619216919	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6614	1715619216919	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619220948	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619223956	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619224957	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619225938	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619225938	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6628000000000003	1715619225938	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619226961	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619230948	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619230948	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6639	1715619230948	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619232952	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619232952	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6647	1715619232952	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619233979	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619237976	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619238985	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619239987	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619240969	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619240969	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6647	1715619240969	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619240991	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619242973	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619242973	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6607	1715619242973	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619242988	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619243975	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.600000000000001	1715619243975	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6607	1715619243975	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619243995	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619244977	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.2	1715619244977	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6626	1715619244977	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619244997	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619245979	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619245979	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6626	1715619245979	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619246981	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619246981	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6626	1715619246981	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6646	1715619247984	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619248999	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619250008	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619251013	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619256000	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619256000	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6643000000000003	1715619256000	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619261011	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619261011	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6612	1715619261011	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619262013	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619262013	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6612	1715619262013	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619264017	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619264017	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6623	1715619264017	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619273036	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619273036	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6666999999999996	1715619273036	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619274038	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619274038	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6666999999999996	1715619274038	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619277044	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619277044	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6655	1715619277044	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619278046	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619278046	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6666	1715619278046	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619281074	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619288067	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619288067	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6641999999999997	1715619288067	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619289069	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619289069	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6641999999999997	1715619289069	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619292075	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619292075	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6648	1715619292075	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619653830	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619653830	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6782	1715619653830	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619660845	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619660845	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6789	1715619660845	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619665856	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619665856	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.68	1715619665856	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619676878	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619676878	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.678	1715619676878	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619678882	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619678882	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6780999999999997	1715619678882	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619695918	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619695918	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6809000000000003	1715619695918	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619696921	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619696921	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6809000000000003	1715619696921	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619698925	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619698925	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6815	1715619698925	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619702933	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.2	1715619702933	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619248000	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619263015	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619263015	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6623	1715619263015	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619266040	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619271031	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619271031	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6664	1715619271031	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619275040	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619275040	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6655	1715619275040	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619280050	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619280050	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6666	1715619280050	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619283057	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619283057	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6573	1715619283057	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619284059	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.8	1715619284059	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6653000000000002	1715619284059	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619286063	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619286063	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6653000000000002	1715619286063	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619287065	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.800000000000001	1715619287065	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6641999999999997	1715619287065	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619291073	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619291073	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6648	1715619291073	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619653852	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619660869	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619665879	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619676893	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619678896	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619695938	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619696943	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619698941	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619702947	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619706955	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619709971	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619248986	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619248986	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6646	1715619248986	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619249988	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10	1715619249988	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6646	1715619249988	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619250990	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619250990	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6656	1715619250990	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619253015	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619256015	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619261031	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619262036	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619264030	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619273049	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619274062	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619277064	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619278066	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619282077	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619288081	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619289090	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619292096	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619654832	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619654832	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6782	1715619654832	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619662850	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619662850	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.679	1715619662850	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619664867	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619669887	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619671883	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619673893	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619681889	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619681889	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6775	1715619681889	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619682907	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619686912	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619701931	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715619701931	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.682	1715619701931	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619703935	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619703935	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.682	1715619703935	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619710950	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619710950	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6826999999999996	1715619710950	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619251992	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619251992	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6656	1715619251992	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619252994	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619252994	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6656	1715619252994	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619258020	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619270050	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619272055	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619279062	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619282055	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619282055	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6573	1715619282055	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619654853	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619662868	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619669864	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619669864	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6791	1715619669864	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619671868	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619671868	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6763000000000003	1715619671868	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619673872	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715619673872	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6763000000000003	1715619673872	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619680886	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619680886	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6775	1715619680886	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619682890	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.5	1715619682890	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6775	1715619682890	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619686899	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619686899	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6795	1715619686899	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619688916	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619701953	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619703956	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619710974	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619252013	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619258004	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619258004	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6604	1715619258004	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619270029	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619270029	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6664	1715619270029	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619272034	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619272034	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6666999999999996	1715619272034	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619279048	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619279048	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6666	1715619279048	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619281053	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619281053	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6573	1715619281053	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619655835	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619655835	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6782	1715619655835	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619656837	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715619656837	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6774	1715619656837	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619664854	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715619664854	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.679	1715619664854	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619666879	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619667881	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619668876	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619672883	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619675891	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619677897	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619681906	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619683906	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619684911	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619689919	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619690922	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619691932	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619708968	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619711975	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619253996	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619253996	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6643000000000003	1715619253996	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619254998	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619254998	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6643000000000003	1715619254998	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619257017	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619259021	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619260022	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619265019	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.3	1715619265019	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6623	1715619265019	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619267044	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619268038	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619269048	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619276064	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619285085	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619290093	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619655858	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619656857	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619666858	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.2	1715619666858	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.68	1715619666858	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619667860	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619667860	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.68	1715619667860	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619668862	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.1	1715619668862	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6791	1715619668862	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619672870	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.1	1715619672870	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6763000000000003	1715619672870	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619675876	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715619675876	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.678	1715619675876	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619677880	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619677880	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6780999999999997	1715619677880	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619680903	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619683893	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.2	1715619683893	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6806	1715619683893	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619684895	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619684895	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6806	1715619684895	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619689905	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619689905	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6786999999999996	1715619689905	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619690908	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.299999999999999	1715619690908	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6786999999999996	1715619690908	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619691910	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619691910	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6786999999999996	1715619691910	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619708946	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.4	1715619708946	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6820999999999997	1715619708946	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619711952	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	11	1715619711952	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6826999999999996	1715619711952	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619254009	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619257002	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.100000000000001	1715619257002	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6604	1715619257002	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619259006	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.9	1715619259006	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6604	1715619259006	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619260008	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619260008	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6612	1715619260008	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619263035	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619265034	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619268025	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619268025	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6634	1715619268025	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619269027	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619269027	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6664	1715619269027	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619276042	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619276042	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6655	1715619276042	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619285061	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619285061	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6653000000000002	1715619285061	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619290071	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.9	1715619290071	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6648	1715619290071	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619657839	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619657839	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6774	1715619657839	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619658841	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.2	1715619658841	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6774	1715619658841	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619659843	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619659843	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6789	1715619659843	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619661847	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619661847	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6789	1715619661847	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619663852	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619663852	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.679	1715619663852	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619670866	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619670866	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6791	1715619670866	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619674874	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.1	1715619674874	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.678	1715619674874	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619679884	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619679884	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6780999999999997	1715619679884	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619685897	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.799999999999999	1715619685897	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6806	1715619685897	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619687901	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619687901	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6795	1715619687901	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619688903	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619688903	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6795	1715619688903	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619692933	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619693928	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619694932	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619697944	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619255014	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619266020	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619266020	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6634	1715619266020	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619267023	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619267023	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6634	1715619267023	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619271052	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619275053	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619280071	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619283070	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619284072	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619286084	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619287087	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619291097	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619293077	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.3	1715619293077	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6663	1715619293077	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619293101	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619294079	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619294079	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6663	1715619294079	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619294101	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619295082	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	11.1	1715619295082	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6663	1715619295082	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619295106	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619296084	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619296084	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6647	1715619296084	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619296105	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619297086	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619297086	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6647	1715619297086	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619297108	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619298088	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619298088	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6647	1715619298088	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619298103	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	99	1715619299090	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	3.1	1715619299090	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6641999999999997	1715619299090	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619299112	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619300092	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619300092	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6641999999999997	1715619300092	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619300115	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619301094	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.8	1715619301094	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6641999999999997	1715619301094	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619301109	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619302097	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.7	1715619302097	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.664	1715619302097	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619302112	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619303099	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619303099	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.664	1715619303099	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619303113	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619304101	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.4	1715619304101	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.664	1715619304101	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619304122	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619305103	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	13.000000000000002	1715619305103	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6595999999999997	1715619305103	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619307107	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619307107	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6595999999999997	1715619307107	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619311116	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619311116	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6651	1715619311116	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619315123	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619315123	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6662	1715619315123	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619316125	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619316125	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6662	1715619316125	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619324143	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619324143	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6677	1715619324143	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619325146	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619325146	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6677	1715619325146	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619327150	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.399999999999999	1715619327150	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6634	1715619327150	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619332172	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619333177	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619337192	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619346210	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619350221	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619354206	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5	1715619354206	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6675999999999997	1715619354206	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619355208	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619355208	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6675999999999997	1715619355208	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619359216	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619359216	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6696999999999997	1715619359216	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619361220	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619361220	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6696999999999997	1715619361220	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619363225	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619363225	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6684	1715619363225	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619364227	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619364227	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6684	1715619364227	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619366231	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619366231	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6712	1715619366231	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619368249	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619371262	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619373260	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619374263	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619375265	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619377267	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619380282	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619391304	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619394310	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619396314	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619399323	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619400324	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619657853	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619658862	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619659864	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619305118	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619307130	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619311130	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619315137	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619316139	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619324158	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619325160	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619327172	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619333162	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619333162	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6659	1715619333162	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619337170	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619337170	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6655	1715619337170	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619346189	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.2	1715619346189	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6652	1715619346189	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619350198	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619350198	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6662	1715619350198	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619352224	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619354228	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619355228	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619359237	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619361241	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619363240	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619364248	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619366245	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619371241	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.899999999999999	1715619371241	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6645	1715619371241	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619373247	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619373247	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6645	1715619373247	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619374248	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619374248	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.665	1715619374248	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619375250	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619375250	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.665	1715619375250	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619377254	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619377254	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6663	1715619377254	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619380260	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619380260	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6668000000000003	1715619380260	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619391283	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619391283	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6675	1715619391283	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619394289	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619394289	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6643000000000003	1715619394289	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619396293	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619396293	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6675	1715619396293	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619399300	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.200000000000001	1715619399300	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6678	1715619399300	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619400303	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619400303	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6678	1715619400303	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619661868	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619663873	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619670882	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619306105	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10	1715619306105	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6595999999999997	1715619306105	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619308110	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619308110	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6625	1715619308110	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619309112	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9	1715619309112	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6625	1715619309112	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619310114	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619310114	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6625	1715619310114	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619317128	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619317128	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6662	1715619317128	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619320135	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.4	1715619320135	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6655	1715619320135	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619323141	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619323141	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6677	1715619323141	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619326148	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619326148	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6634	1715619326148	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619332160	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619332160	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6659	1715619332160	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619334185	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619336168	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.899999999999999	1715619336168	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6655	1715619336168	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619344199	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619348207	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619353219	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619369237	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619369237	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6693000000000002	1715619369237	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619376252	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619376252	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.665	1715619376252	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619378270	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619382278	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619384282	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619385284	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619386293	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619389299	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619395312	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619403324	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619405335	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619408332	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619409345	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619674896	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619679899	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619685912	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619687915	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619692912	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619692912	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6776	1715619692912	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619693914	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619693914	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6776	1715619693914	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619694916	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619694916	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6776	1715619694916	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619306127	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619308123	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619309129	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619310127	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619317141	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619320148	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619323162	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619326169	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619334164	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9	1715619334164	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6659	1715619334164	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619335166	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619335166	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6655	1715619335166	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619336190	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619348194	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619348194	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6635	1715619348194	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619353204	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619353204	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6675999999999997	1715619353204	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619357236	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619369258	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619378256	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619378256	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6663	1715619378256	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619382264	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619382264	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6668000000000003	1715619382264	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619384268	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619384268	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6700999999999997	1715619384268	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619385270	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619385270	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6700999999999997	1715619385270	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619386272	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619386272	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.67	1715619386272	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619389278	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619389278	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6675	1715619389278	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619395291	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619395291	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6675	1715619395291	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619403310	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619403310	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6703	1715619403310	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619405314	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619405314	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6695	1715619405314	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619408320	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619408320	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6698000000000004	1715619408320	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619409322	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.4	1715619409322	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6698000000000004	1715619409322	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619697923	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619697923	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6809000000000003	1715619697923	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619699927	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619699927	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6815	1715619699927	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619700929	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715619700929	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619312118	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619312118	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6651	1715619312118	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619319132	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619319132	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6662	1715619319132	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619322139	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619322139	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6655	1715619322139	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619328152	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619328152	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6634	1715619328152	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619335180	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619340199	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619343198	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619345208	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619347205	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619351213	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619356210	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619356210	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6693000000000002	1715619356210	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619358214	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619358214	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6693000000000002	1715619358214	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619367233	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619367233	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6712	1715619367233	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619370254	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619388290	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619392307	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619404333	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619410345	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619699947	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619700951	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619704958	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619705961	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619707958	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619312131	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619319153	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619322162	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619328165	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619340177	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619340177	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6666	1715619340177	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619343183	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619343183	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6649000000000003	1715619343183	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619345187	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619345187	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6652	1715619345187	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619347192	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619347192	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6635	1715619347192	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619351200	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619351200	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6662	1715619351200	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619352202	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.8	1715619352202	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6662	1715619352202	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619356231	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619358228	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619367254	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619388276	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619388276	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.67	1715619388276	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619392285	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619392285	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6643000000000003	1715619392285	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619404312	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619404312	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6695	1715619404312	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619410324	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.8	1715619410324	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6689000000000003	1715619410324	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6815	1715619700929	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619704938	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715619704938	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6801999999999997	1715619704938	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619705940	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619705940	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6801999999999997	1715619705940	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619707944	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715619707944	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6820999999999997	1715619707944	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619313120	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619313120	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6651	1715619313120	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619314121	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619314121	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6662	1715619314121	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619318130	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.4	1715619318130	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6662	1715619318130	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619321137	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619321137	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6655	1715619321137	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619329154	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619329154	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6649000000000003	1715619329154	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619330157	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619330157	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6649000000000003	1715619330157	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619331158	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619331158	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6649000000000003	1715619331158	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619338172	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619338172	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6666	1715619338172	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619339174	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619339174	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6666	1715619339174	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619341179	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619341179	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6649000000000003	1715619341179	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619342181	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619342181	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6649000000000003	1715619342181	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619344185	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.200000000000001	1715619344185	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6652	1715619344185	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619349218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619360218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619360218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6696999999999997	1715619360218	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619362222	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619362222	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6684	1715619362222	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619365229	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619365229	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6712	1715619365229	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619368235	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619368235	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6693000000000002	1715619368235	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619372243	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619372243	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6645	1715619372243	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619376267	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619379272	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619381275	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619383279	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619387295	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619390301	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619393303	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619397318	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619398319	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619401327	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619402330	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619406337	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619313134	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619314137	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619318143	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619321158	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619329175	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619330178	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619331171	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619338193	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619339195	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619341200	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619342202	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619349196	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619349196	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6635	1715619349196	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619357212	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619357212	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6693000000000002	1715619357212	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619360239	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619362237	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619365243	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619370239	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.200000000000001	1715619370239	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6693000000000002	1715619370239	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619372264	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619379258	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	13	1715619379258	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6663	1715619379258	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619381262	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619381262	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6668000000000003	1715619381262	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619383266	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619383266	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6700999999999997	1715619383266	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619387274	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619387274	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.67	1715619387274	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619390280	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619390280	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6675	1715619390280	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619393287	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619393287	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6643000000000003	1715619393287	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619397296	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619397296	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6675	1715619397296	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619398298	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619398298	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6678	1715619398298	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619401306	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619401306	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6703	1715619401306	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619402308	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619402308	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6703	1715619402308	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619406316	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.100000000000001	1715619406316	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6695	1715619406316	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619407318	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619407318	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6698000000000004	1715619407318	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619411326	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619411326	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6689000000000003	1715619411326	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619412328	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619407339	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619411347	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619412351	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.682	1715619702933	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619706942	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.4	1715619706942	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6801999999999997	1715619706942	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619709948	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715619709948	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6820999999999997	1715619709948	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619412328	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6689000000000003	1715619412328	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619413330	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619413330	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6645	1715619413330	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619413352	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619414332	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619414332	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6645	1715619414332	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619414353	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619415334	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619415334	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6645	1715619415334	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619415356	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619416337	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9	1715619416337	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6693000000000002	1715619416337	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619416359	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619417339	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619417339	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6693000000000002	1715619417339	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619417359	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619418341	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619418341	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6693000000000002	1715619418341	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619418361	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619419343	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619419343	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6674	1715619419343	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619419356	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619420345	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619420345	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6674	1715619420345	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619420366	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619421347	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619421347	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6674	1715619421347	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619421368	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619422349	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619422349	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6692	1715619422349	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619422373	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619423351	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619423351	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6692	1715619423351	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619423367	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619424353	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.899999999999999	1715619424353	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6692	1715619424353	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619424374	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619425355	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619425355	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.669	1715619425355	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619425371	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619426358	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619426358	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.669	1715619426358	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619426380	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619427360	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.7	1715619427360	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.669	1715619427360	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619427381	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619428363	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9	1715619428363	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6669	1715619428363	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619430382	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619441414	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619445420	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619451433	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619453431	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619459452	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619460453	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619462456	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619464459	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619476490	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619479484	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619490514	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619493499	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619493499	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6726	1715619493499	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619499512	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619499512	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6714	1715619499512	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619514544	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715619514544	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6746	1715619514544	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619517551	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619517551	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6755	1715619517551	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619518554	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619518554	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6751	1715619518554	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619519556	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619519556	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6751	1715619519556	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619521560	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619521560	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6691	1715619521560	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619522562	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619522562	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6691	1715619522562	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619524566	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619524566	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6713	1715619524566	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619528574	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619528574	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6721	1715619528574	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619529576	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619529576	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6721	1715619529576	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619531580	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619531580	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6709	1715619531580	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619532582	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619532582	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6709	1715619532582	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619712954	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619712954	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6826999999999996	1715619712954	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619721973	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715619721973	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6820999999999997	1715619721973	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619727986	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.4	1715619727986	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.682	1715619727986	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619732996	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.4	1715619732996	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6816999999999998	1715619732996	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619428378	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619429387	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619432395	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619433389	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619449408	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715619449408	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6693000000000002	1715619449408	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619457450	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619465464	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619467468	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619471454	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715619471454	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6706999999999996	1715619471454	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619478468	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619478468	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6706	1715619478468	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619480472	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619480472	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6719	1715619480472	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619484494	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619486505	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619490493	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.1	1715619490493	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6736	1715619490493	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619497507	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619497507	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6714	1715619497507	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619501516	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619501516	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6705	1715619501516	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619502519	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619502519	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6705	1715619502519	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619503521	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619503521	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6691	1715619503521	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619504523	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619504523	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6691	1715619504523	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619505525	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619505525	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6691	1715619505525	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619515547	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619515547	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6755	1715619515547	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619523564	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619523564	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6691	1715619523564	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619526570	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619526570	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6713	1715619526570	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619532595	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619712971	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619722975	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.4	1715619722975	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6806	1715619722975	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619728000	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619733009	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619429366	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619429366	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6669	1715619429366	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619432372	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619432372	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6698000000000004	1715619432372	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619433374	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619433374	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6698000000000004	1715619433374	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619434376	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619434376	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6666999999999996	1715619434376	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619449424	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619465442	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.5	1715619465442	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6696999999999997	1715619465442	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619467446	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619467446	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6713	1715619467446	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619468448	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619468448	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6713	1715619468448	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619471475	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619478482	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619484480	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619484480	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6708000000000003	1715619484480	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619486484	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619486484	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6723000000000003	1715619486484	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619489491	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619489491	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6736	1715619489491	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619492497	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9	1715619492497	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6726	1715619492497	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619497524	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619501536	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619502540	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619503534	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619504536	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619505540	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619515568	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619523578	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619526591	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619713956	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619713956	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6801999999999997	1715619713956	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619714958	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.8	1715619714958	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6801999999999997	1715619714958	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619717965	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619717965	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6822	1715619717965	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619719969	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715619719969	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6820999999999997	1715619719969	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619720971	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.4	1715619720971	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6820999999999997	1715619720971	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619721991	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619727008	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619730011	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619430368	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6	1715619430368	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6669	1715619430368	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619441392	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619441392	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6671	1715619441392	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619445400	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715619445400	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6674	1715619445400	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619451412	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619451412	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6693000000000002	1715619451412	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619453417	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.7	1715619453417	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6706999999999996	1715619453417	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619459429	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5	1715619459429	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6694	1715619459429	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619460431	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619460431	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6694	1715619460431	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619462435	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619462435	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6702	1715619462435	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619464440	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619464440	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6696999999999997	1715619464440	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619476464	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619476464	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6706	1715619476464	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619479470	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619479470	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6719	1715619479470	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619485482	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.2	1715619485482	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6723000000000003	1715619485482	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619492518	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619493513	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619499525	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619514557	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619517564	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619518574	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619519569	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619521580	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619522576	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619524579	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619528587	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619529589	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619531601	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619713981	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619714980	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619717978	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619719991	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619720992	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619726984	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619726984	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.682	1715619726984	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619729990	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.5	1715619729990	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.682	1715619729990	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619431370	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619431370	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6698000000000004	1715619431370	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619435378	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619435378	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6666999999999996	1715619435378	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619436380	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619436380	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6666999999999996	1715619436380	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619438384	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619438384	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.668	1715619438384	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619439388	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619439388	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.668	1715619439388	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619442394	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619442394	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6671	1715619442394	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619443396	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.399999999999999	1715619443396	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6674	1715619443396	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619447404	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619447404	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6696	1715619447404	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619452414	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619452414	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6706999999999996	1715619452414	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619455442	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619461433	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619461433	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6702	1715619461433	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619463438	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.2	1715619463438	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6702	1715619463438	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619466466	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619469450	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619469450	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6713	1715619469450	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619483478	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619483478	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6708000000000003	1715619483478	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619489504	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619496520	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619498523	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619500535	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619507529	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619507529	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6704	1715619507529	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619508531	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.2	1715619508531	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6704	1715619508531	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619512540	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619512540	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6746	1715619512540	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619516549	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619516549	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6755	1715619516549	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619520558	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619520558	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6751	1715619520558	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619525568	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.5	1715619525568	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6713	1715619525568	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619715960	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619431394	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619435395	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619436396	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619438401	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619439403	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619442407	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619443415	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619447419	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619455421	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619455421	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6686	1715619455421	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619457425	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619457425	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6686	1715619457425	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619461455	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619466444	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619466444	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6696999999999997	1715619466444	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619468462	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619469469	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619483495	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619496505	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619496505	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6724	1715619496505	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619498510	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619498510	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6714	1715619498510	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619500514	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619500514	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6705	1715619500514	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619506527	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.499999999999999	1715619506527	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6704	1715619506527	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619507551	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619508546	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619512562	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619516570	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619520578	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619525589	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715619715960	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6801999999999997	1715619715960	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619722991	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619724995	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619434390	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619437395	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619440411	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619444414	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619446416	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619448427	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619450431	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619454419	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715619454419	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6706999999999996	1715619454419	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619456423	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619456423	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6686	1715619456423	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619458427	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619458427	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6694	1715619458427	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619463453	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619470473	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619472477	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619473481	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619474480	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619475482	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619477487	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619481474	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619481474	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6719	1715619481474	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619482476	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619482476	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6708000000000003	1715619482476	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619485497	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619487501	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619488501	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619491515	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619494514	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619495518	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619509533	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715619509533	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6727	1715619509533	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619510536	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715619510536	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6727	1715619510536	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619511538	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619511538	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6727	1715619511538	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619513542	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619513542	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6746	1715619513542	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619527572	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715619527572	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6721	1715619527572	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619530578	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619530578	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6709	1715619530578	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619715975	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619724979	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.5	1715619724979	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6806	1715619724979	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619437382	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.2	1715619437382	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.668	1715619437382	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619440390	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.5	1715619440390	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6671	1715619440390	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619444398	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619444398	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6674	1715619444398	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619446402	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.2	1715619446402	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6696	1715619446402	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619448406	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619448406	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6696	1715619448406	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619450410	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619450410	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6693000000000002	1715619450410	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619452434	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619454444	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619456445	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619458451	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619470452	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.2	1715619470452	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6706999999999996	1715619470452	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619472456	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619472456	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6706999999999996	1715619472456	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619473458	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619473458	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6715999999999998	1715619473458	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619474460	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619474460	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6715999999999998	1715619474460	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619475462	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619475462	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6715999999999998	1715619475462	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619477466	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619477466	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6706	1715619477466	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619480493	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619481495	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619482497	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619487486	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.7	1715619487486	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6723000000000003	1715619487486	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619488489	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619488489	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6736	1715619488489	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619491495	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619491495	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6726	1715619491495	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619494501	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619494501	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6724	1715619494501	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619495503	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619495503	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6724	1715619495503	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619506549	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619509546	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619510556	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619511561	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619513555	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619527585	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619530604	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619533584	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8	1715619533584	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6738000000000004	1715619533584	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619533605	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619534586	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9	1715619534586	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6738000000000004	1715619534586	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619534603	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619535588	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619535588	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6738000000000004	1715619535588	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619535603	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619536590	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9	1715619536590	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6732	1715619536590	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619536603	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619537592	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619537592	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6732	1715619537592	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619537613	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619538594	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715619538594	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6732	1715619538594	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619538609	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619539596	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619539596	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6735	1715619539596	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619539610	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619540598	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619540598	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6735	1715619540598	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619540621	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619541600	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619541600	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6735	1715619541600	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619541621	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619542602	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9	1715619542602	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6711	1715619542602	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619542620	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619543604	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3	1715619543604	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6711	1715619543604	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619543618	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619544606	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715619544606	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6711	1715619544606	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619544619	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619545608	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619545608	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6733000000000002	1715619545608	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619545630	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619546611	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619546611	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6733000000000002	1715619546611	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619546635	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619547613	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715619547613	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6733000000000002	1715619547613	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619547625	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619548616	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.1	1715619548616	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6761	1715619548616	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619548638	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619549618	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619549618	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6761	1715619549618	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619549632	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619550621	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.6	1715619550621	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6761	1715619550621	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619551623	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619551623	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6766	1715619551623	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619552625	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.299999999999999	1715619552625	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6766	1715619552625	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619552648	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619554629	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619554629	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6731	1715619554629	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619556633	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715619556633	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6731	1715619556633	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619556650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619557635	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619557635	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6734	1715619557635	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619557649	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619558637	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619558637	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6734	1715619558637	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619558651	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619559640	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619559640	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6734	1715619559640	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619559655	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619562646	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619562646	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.674	1715619562646	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619562667	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619564650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619564650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6719	1715619564650	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619564663	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619565667	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619566667	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619567669	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619568671	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619569660	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619569660	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6729000000000003	1715619569660	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619569673	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619570679	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619571685	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619573668	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619573668	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6723000000000003	1715619573668	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619573682	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619574670	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619574670	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6723000000000003	1715619574670	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619574684	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619576696	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619581698	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619583689	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715619583689	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619550647	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619551636	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619554642	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619565652	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619565652	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6719	1715619565652	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619566654	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619566654	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6733000000000002	1715619566654	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619567656	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619567656	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6733000000000002	1715619567656	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619568658	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715619568658	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6733000000000002	1715619568658	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619570662	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715619570662	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6729000000000003	1715619570662	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619571664	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619571664	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6729000000000003	1715619571664	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619576674	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.799999999999999	1715619576674	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6733000000000002	1715619576674	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619581684	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619581684	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6761	1715619581684	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619586695	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619586695	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6719	1715619586695	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619588714	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619591727	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619594725	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619595737	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619596729	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619597738	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619604747	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619605755	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619611746	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619611746	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6755999999999998	1715619611746	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619613750	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619613750	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6755999999999998	1715619613750	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619616756	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619616756	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6767	1715619616756	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619622768	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619622768	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6778000000000004	1715619622768	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619627778	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619627778	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6795999999999998	1715619627778	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619633790	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619633790	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6757	1715619633790	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619636796	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619636796	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6778000000000004	1715619636796	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619637798	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619637798	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6778000000000004	1715619637798	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	105	1715619639802	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.2	1715619639802	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619553627	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619553627	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6766	1715619553627	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619560642	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619560642	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.674	1715619560642	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619563648	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619563648	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6719	1715619563648	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619572666	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.299999999999999	1715619572666	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6723000000000003	1715619572666	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619577677	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619577677	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6733000000000002	1715619577677	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619582686	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619582686	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6761	1715619582686	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619584691	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619584691	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6719	1715619584691	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619585693	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619585693	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6719	1715619585693	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619587697	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619587697	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.672	1715619587697	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619592708	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619592708	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6718	1715619592708	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619598734	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619612761	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619614764	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619615767	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619618775	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619620784	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619623792	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619634792	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.799999999999999	1715619634792	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6757	1715619634792	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619716963	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.4	1715619716963	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6822	1715619716963	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619718967	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.4	1715619718967	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6822	1715619718967	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619723977	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.7	1715619723977	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6806	1715619723977	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619725982	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.7	1715619725982	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.682	1715619725982	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619728988	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.1	1715619728988	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.682	1715619728988	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619730992	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.699999999999999	1715619730992	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.682	1715619730992	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619731994	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	11	1715619731994	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6816999999999998	1715619731994	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.0736	1715619553645	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619560662	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619563668	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619572687	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619577689	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619582703	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619584707	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619585708	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619587710	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619592722	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619612748	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619612748	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6755999999999998	1715619612748	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619614752	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619614752	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6767	1715619614752	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619615754	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.299999999999999	1715619615754	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6767	1715619615754	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619618760	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619618760	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6767	1715619618760	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619620764	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619620764	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6778000000000004	1715619620764	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619623770	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.899999999999999	1715619623770	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6779	1715619623770	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619632788	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619632788	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6757	1715619632788	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619634805	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619716985	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619718990	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619723998	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619726005	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619729010	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619731013	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619732016	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619555631	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619555631	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6731	1715619555631	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619561644	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.299999999999999	1715619561644	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.674	1715619561644	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619575672	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619575672	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6733000000000002	1715619575672	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619578679	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619578679	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.674	1715619578679	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619579680	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619579680	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.674	1715619579680	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619580682	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	9.2	1715619580682	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.674	1715619580682	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619589701	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619589701	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.672	1715619589701	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619593710	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715619593710	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6742	1715619593710	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619598720	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715619598720	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6745	1715619598720	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619599738	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619600748	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619601739	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619602749	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619603744	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619606758	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619610764	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619617771	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619619775	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619624772	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619624772	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6779	1715619624772	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619625774	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619625774	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6779	1715619625774	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619626776	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619626776	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6795999999999998	1715619626776	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619628780	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619628780	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6795999999999998	1715619628780	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619635794	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619635794	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6778000000000004	1715619635794	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619638800	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.6	1715619638800	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6759	1715619638800	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619640804	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619640804	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6759	1715619640804	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619643810	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619643810	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6783	1715619643810	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619644812	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619644812	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6778000000000004	1715619644812	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619646816	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619555646	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619561666	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619575686	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619578692	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619579694	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619580703	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619589717	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619593731	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619599722	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619599722	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6744	1715619599722	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619600725	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.799999999999999	1715619600725	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6744	1715619600725	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619601727	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619601727	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6744	1715619601727	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619602729	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8.6	1715619602729	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.676	1715619602729	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619603730	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619603730	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.676	1715619603730	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619606736	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715619606736	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6746	1715619606736	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619610744	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619610744	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6761999999999997	1715619610744	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619617758	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.8999999999999995	1715619617758	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6767	1715619617758	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619619762	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619619762	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6767	1715619619762	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619621790	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619624785	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619625795	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619626796	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619628802	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619635817	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619638813	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619640829	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619643824	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619644826	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619646836	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619648833	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619651848	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619652842	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6761	1715619583689	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619586710	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619590725	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619608740	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619608740	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6761999999999997	1715619608740	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619609742	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	10.299999999999999	1715619609742	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6761999999999997	1715619609742	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619621766	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619621766	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6778000000000004	1715619621766	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619629796	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619630805	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619631806	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619641807	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715619641807	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6783	1715619641807	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619645835	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619647841	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619649837	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619650845	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619583713	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619590704	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619590704	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6718	1715619590704	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619607738	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619607738	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6746	1715619607738	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619608763	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619609756	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619629782	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	7.3999999999999995	1715619629782	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6758	1715619629782	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619630784	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619630784	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6758	1715619630784	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619631786	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619631786	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6758	1715619631786	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619632802	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619645814	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619645814	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6778000000000004	1715619645814	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619647818	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619647818	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6795	1715619647818	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	104	1715619649822	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619649822	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6795	1715619649822	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619650824	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619650824	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6784	1715619650824	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619588699	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619588699	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.672	1715619588699	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619591706	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619591706	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6718	1715619591706	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619594712	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.199999999999999	1715619594712	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6742	1715619594712	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619595714	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619595714	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6742	1715619595714	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619596716	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619596716	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6745	1715619596716	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619597718	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	5.699999999999999	1715619597718	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6745	1715619597718	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	102	1715619604732	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619604732	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.676	1715619604732	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	103	1715619605734	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619605734	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6746	1715619605734	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619607761	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619611770	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619613766	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619616769	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619622789	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619627793	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619633813	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619636817	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619637812	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619639815	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619642809	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619642809	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6783	1715619642809	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6759	1715619639802	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619641828	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Swap Memory GB	0.07809999999999999	1715619642830	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619646816	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6778000000000004	1715619646816	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	100	1715619648820	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619648820	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6795	1715619648820	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619651826	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	8	1715619651826	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6784	1715619651826	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - CPU Utilization	101	1715619652828	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Utilization	6.3	1715619652828	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
TOP - Memory Usage GB	2.6784	1715619652828	d9a4aed0fbb449c0988fb0a7a56f642d	0	f
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
letter	0	2549055e39384669a01fd1197fe00f86
workload	0	2549055e39384669a01fd1197fe00f86
listeners	smi+top+dcgmi	2549055e39384669a01fd1197fe00f86
params	'"-"'	2549055e39384669a01fd1197fe00f86
file	cifar10.py	2549055e39384669a01fd1197fe00f86
workload_listener	''	2549055e39384669a01fd1197fe00f86
letter	0	d9a4aed0fbb449c0988fb0a7a56f642d
workload	0	d9a4aed0fbb449c0988fb0a7a56f642d
listeners	smi+top+dcgmi	d9a4aed0fbb449c0988fb0a7a56f642d
params	'"-"'	d9a4aed0fbb449c0988fb0a7a56f642d
file	cifar10.py	d9a4aed0fbb449c0988fb0a7a56f642d
workload_listener	''	d9a4aed0fbb449c0988fb0a7a56f642d
model	cifar10.py	d9a4aed0fbb449c0988fb0a7a56f642d
manual	False	d9a4aed0fbb449c0988fb0a7a56f642d
max_epoch	5	d9a4aed0fbb449c0988fb0a7a56f642d
max_time	172800	d9a4aed0fbb449c0988fb0a7a56f642d
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
2549055e39384669a01fd1197fe00f86	agreeable-hog-847	UNKNOWN			daga	FAILED	1715618320393	1715618364680		active	s3://mlflow-storage/0/2549055e39384669a01fd1197fe00f86/artifacts	0	\N
d9a4aed0fbb449c0988fb0a7a56f642d	(0 0) wise-slug-62	UNKNOWN			daga	FINISHED	1715618422765	1715619734739		active	s3://mlflow-storage/0/d9a4aed0fbb449c0988fb0a7a56f642d/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	2549055e39384669a01fd1197fe00f86
mlflow.source.name	file:///home/daga/radt#examples/pytorch	2549055e39384669a01fd1197fe00f86
mlflow.source.type	PROJECT	2549055e39384669a01fd1197fe00f86
mlflow.project.entryPoint	main	2549055e39384669a01fd1197fe00f86
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	2549055e39384669a01fd1197fe00f86
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	2549055e39384669a01fd1197fe00f86
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	2549055e39384669a01fd1197fe00f86
mlflow.runName	agreeable-hog-847	2549055e39384669a01fd1197fe00f86
mlflow.project.env	conda	2549055e39384669a01fd1197fe00f86
mlflow.project.backend	local	2549055e39384669a01fd1197fe00f86
mlflow.user	daga	d9a4aed0fbb449c0988fb0a7a56f642d
mlflow.source.name	file:///home/daga/radt#examples/pytorch	d9a4aed0fbb449c0988fb0a7a56f642d
mlflow.source.type	PROJECT	d9a4aed0fbb449c0988fb0a7a56f642d
mlflow.project.entryPoint	main	d9a4aed0fbb449c0988fb0a7a56f642d
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	d9a4aed0fbb449c0988fb0a7a56f642d
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	d9a4aed0fbb449c0988fb0a7a56f642d
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	d9a4aed0fbb449c0988fb0a7a56f642d
mlflow.project.env	conda	d9a4aed0fbb449c0988fb0a7a56f642d
mlflow.project.backend	local	d9a4aed0fbb449c0988fb0a7a56f642d
mlflow.runName	(0 0) wise-slug-62	d9a4aed0fbb449c0988fb0a7a56f642d
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

