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
0	Default	s3://mlflow-storage/0	active	1715625300088	1715625300088
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
SMI - Power Draw	14.94	1715625512453	0	f	e42f8d7c87d448479239a7caf9dd502e
SMI - Timestamp	1715625512.439	1715625512453	0	f	e42f8d7c87d448479239a7caf9dd502e
SMI - GPU Util	0	1715625512453	0	f	e42f8d7c87d448479239a7caf9dd502e
SMI - Mem Util	0	1715625512453	0	f	e42f8d7c87d448479239a7caf9dd502e
SMI - Mem Used	0	1715625512453	0	f	e42f8d7c87d448479239a7caf9dd502e
SMI - Performance State	0	1715625512453	0	f	e42f8d7c87d448479239a7caf9dd502e
TOP - CPU Utilization	103	1715626827302	0	f	e42f8d7c87d448479239a7caf9dd502e
TOP - Memory Usage GB	2.7156	1715626827302	0	f	e42f8d7c87d448479239a7caf9dd502e
TOP - Memory Utilization	8.2	1715626827302	0	f	e42f8d7c87d448479239a7caf9dd502e
TOP - Swap Memory GB	0.089	1715626827317	0	f	e42f8d7c87d448479239a7caf9dd502e
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.94	1715625512453	e42f8d7c87d448479239a7caf9dd502e	0	f
SMI - Timestamp	1715625512.439	1715625512453	e42f8d7c87d448479239a7caf9dd502e	0	f
SMI - GPU Util	0	1715625512453	e42f8d7c87d448479239a7caf9dd502e	0	f
SMI - Mem Util	0	1715625512453	e42f8d7c87d448479239a7caf9dd502e	0	f
SMI - Mem Used	0	1715625512453	e42f8d7c87d448479239a7caf9dd502e	0	f
SMI - Performance State	0	1715625512453	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	0	1715625512516	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	0	1715625512516	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	1.9716	1715625512516	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625512531	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	200	1715625513518	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.9	1715625513518	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	1.9716	1715625513518	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625513909	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	99	1715625514521	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	2.4	1715625514521	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	1.9716	1715625514521	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625514544	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	140	1715625515523	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5	1715625515523	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.1859	1715625515523	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625515536	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625516525	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625516525	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.1859	1715625516525	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625516547	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	105	1715625517528	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625517528	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.1859	1715625517528	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625517545	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625518530	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.7	1715625518530	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.186	1715625518530	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625518552	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	105	1715625519532	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715625519532	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.186	1715625519532	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625519561	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	106	1715625520534	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715625520534	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.186	1715625520534	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625520548	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625521536	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625521536	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.1869	1715625521536	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625521558	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	107	1715625522539	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625522539	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.1869	1715625522539	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625522551	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625523541	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5	1715625523541	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.1869	1715625523541	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625523564	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	106	1715625524543	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715625524543	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.1877	1715625524543	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625524565	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	105	1715625525545	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625525545	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.1877	1715625525545	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625525566	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	106	1715625526547	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625526547	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.1877	1715625526547	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0706	1715625526560	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0723	1715625527570	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0723	1715625528570	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.0723	1715625529569	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625533578	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625537585	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625543606	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625545609	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625546611	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625553627	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625556612	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.3	1715625556612	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6284	1715625556612	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625557614	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.299999999999999	1715625557614	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6332	1715625557614	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625558616	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.3	1715625558616	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6332	1715625558616	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625862261	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625862261	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6555	1715625862261	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625864265	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625864265	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6568	1715625864265	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625872282	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625872282	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6512	1715625872282	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625876292	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625876292	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6561	1715625876292	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625877294	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625877294	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6561	1715625877294	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625895330	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625895330	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6567	1715625895330	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625896332	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625896332	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6527	1715625896332	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625899338	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625899338	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6536999999999997	1715625899338	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625900361	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625905366	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625906374	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625913388	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625914390	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625916398	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625920381	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625920381	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6595	1715625920381	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625921384	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.1	1715625921384	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6595	1715625921384	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626109783	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626109783	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6739	1715626109783	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626113791	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626113791	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6685	1715626113791	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626117800	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.1	1715626117800	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6719	1715626117800	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625527550	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715625527550	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.4478	1715625527550	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625528553	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715625528553	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.4478	1715625528553	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625529555	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715625529555	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.4478	1715625529555	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625533563	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715625533563	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7056	1715625533563	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625537572	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625537572	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.704	1715625537572	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625543584	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625543584	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7081	1715625543584	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625545588	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7	1715625545588	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7079	1715625545588	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625546590	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625546590	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7079	1715625546590	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625553606	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7	1715625553606	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6266	1715625553606	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625554630	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625556634	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625557629	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625558639	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625862276	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625868288	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625872298	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625876313	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625877315	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625895353	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625896352	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625900340	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625900340	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6536999999999997	1715625900340	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625905350	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625905350	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6566	1715625905350	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625906352	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625906352	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6566	1715625906352	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625913367	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625913367	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6569000000000003	1715625913367	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625914369	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625914369	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6569000000000003	1715625914369	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625916373	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625916373	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6569000000000003	1715625916373	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625919379	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625919379	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6566	1715625919379	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625920404	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625921405	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626109804	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626113812	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626117823	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625530557	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715625530557	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6926	1715625530557	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625531559	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715625531559	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6926	1715625531559	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625544586	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625544586	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7081	1715625544586	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625550599	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5	1715625550599	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7078	1715625550599	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625554608	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625554608	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6284	1715625554608	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625559639	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625560644	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625863263	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625863263	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6568	1715625863263	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625865267	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625865267	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6568	1715625865267	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625866269	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.9	1715625866269	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6561999999999997	1715625866269	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625867271	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625867271	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6561999999999997	1715625867271	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625871280	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.5	1715625871280	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6576999999999997	1715625871280	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625873286	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625873286	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6512	1715625873286	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625875290	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625875290	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6561	1715625875290	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625878296	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625878296	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6563000000000003	1715625878296	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625879298	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.000000000000001	1715625879298	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6563000000000003	1715625879298	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625885310	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625885310	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6555999999999997	1715625885310	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625888317	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625888317	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6559	1715625888317	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625893326	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625893326	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6567	1715625893326	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625899362	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625902364	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625908373	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625909380	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625912379	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625917389	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625918399	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626118823	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626119829	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626120826	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626125838	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625530576	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625531575	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625544608	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625550619	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625559618	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7	1715625559618	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6332	1715625559618	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625560621	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715625560621	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6329000000000002	1715625560621	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625863278	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625865285	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625866284	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625867284	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625871304	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625873306	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625875304	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625878318	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625879320	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625885327	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625888342	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625893341	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625902344	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.000000000000001	1715625902344	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6553	1715625902344	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625908357	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625908357	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6578000000000004	1715625908357	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625909359	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625909359	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6578000000000004	1715625909359	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625912365	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625912365	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6569000000000003	1715625912365	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625917375	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625917375	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6566	1715625917375	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625918378	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625918378	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6566	1715625918378	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626119804	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715626119804	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6738000000000004	1715626119804	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626120806	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11.6	1715626120806	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6738000000000004	1715626120806	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626125816	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626125816	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6731	1715626125816	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626126818	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626126818	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6731	1715626126818	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626135837	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9	1715626135837	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6736	1715626135837	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626142852	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626142852	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6751	1715626142852	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626147878	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626152872	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626152872	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6778000000000004	1715626152872	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626153874	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626153874	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625532561	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625532561	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6926	1715625532561	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625534587	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625535588	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625536590	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625541596	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625542599	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625547606	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625549620	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625552616	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625555632	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625864282	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625880314	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625882318	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625886335	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625887329	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625889340	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625890342	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625891338	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625892342	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715626121808	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6729000000000003	1715626121808	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626122810	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715626122810	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6729000000000003	1715626122810	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626127821	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.5	1715626127821	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6728	1715626127821	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626128823	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715626128823	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6728	1715626128823	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626129825	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626129825	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6728	1715626129825	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626131829	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626131829	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6728	1715626131829	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626134835	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626134835	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6736	1715626134835	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626141850	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626141850	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6771	1715626141850	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626151870	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626151870	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6778000000000004	1715626151870	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626154876	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715626154876	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6795	1715626154876	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626155878	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626155878	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6795	1715626155878	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626158886	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715626158886	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6742	1715626158886	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626159889	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.3	1715626159889	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6742	1715626159889	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626171913	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.299999999999999	1715626171913	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6763000000000003	1715626171913	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626172915	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715626172915	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625532577	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625538589	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625539592	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625540592	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625548611	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625551622	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625868274	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625868274	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6561999999999997	1715625868274	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625869290	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625870291	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625874301	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625881323	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625883328	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625884328	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625894353	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625897346	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625898358	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625901361	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625903367	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625904370	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625907375	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625910382	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625911386	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625915386	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626126832	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626135861	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626147862	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626147862	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6783	1715626147862	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626149866	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626149866	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.676	1715626149866	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626152886	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626153895	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626156902	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626164920	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626167981	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626169929	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626173917	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626173917	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6779	1715626173917	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626174920	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626174920	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6779	1715626174920	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626175922	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715626175922	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6782	1715626175922	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626180934	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626180934	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6721	1715626180934	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626181936	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626181936	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6768	1715626181936	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626182938	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.5	1715626182938	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6768	1715626182938	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626188951	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9	1715626188951	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6742	1715626188951	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626194963	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626194963	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6784	1715626194963	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	99	1715626199975	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626199975	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625534565	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.799999999999999	1715625534565	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7056	1715625534565	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625535568	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.3	1715625535568	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7056	1715625535568	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625536570	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625536570	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.704	1715625536570	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625541580	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5	1715625541580	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7075	1715625541580	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625542582	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5	1715625542582	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7081	1715625542582	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625547592	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7	1715625547592	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7079	1715625547592	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625549597	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625549597	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7078	1715625549597	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625552603	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715625552603	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6266	1715625552603	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625555610	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7	1715625555610	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6284	1715625555610	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625869276	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625869276	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6576999999999997	1715625869276	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625870278	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.3	1715625870278	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6576999999999997	1715625870278	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625874288	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625874288	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6512	1715625874288	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625881302	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625881302	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6582	1715625881302	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625883306	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625883306	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6582	1715625883306	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625884308	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625884308	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6555999999999997	1715625884308	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625894328	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625894328	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6567	1715625894328	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625897334	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.000000000000001	1715625897334	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6527	1715625897334	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625898336	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625898336	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6527	1715625898336	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625901342	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.4	1715625901342	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6536999999999997	1715625901342	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625903346	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625903346	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6553	1715625903346	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625904348	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625904348	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6553	1715625904348	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625907355	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625538574	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625538574	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.704	1715625538574	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625539576	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.3	1715625539576	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7075	1715625539576	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625540578	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.7	1715625540578	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7075	1715625540578	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625548595	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.3	1715625548595	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7078	1715625548595	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625551601	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625551601	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6266	1715625551601	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625561622	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715625561622	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6329000000000002	1715625561622	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625561636	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625562624	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.2	1715625562624	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6329000000000002	1715625562624	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625562645	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625563627	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625563627	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6334	1715625563627	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625563640	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625564629	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625564629	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6334	1715625564629	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625564649	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625565630	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5	1715625565630	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6334	1715625565630	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625565650	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625566632	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.799999999999999	1715625566632	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6339	1715625566632	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625566648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625567634	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5	1715625567634	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6339	1715625567634	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625567648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625568636	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.7	1715625568636	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6339	1715625568636	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625568654	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625569638	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715625569638	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6339	1715625569638	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625569654	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625570640	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.7	1715625570640	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6339	1715625570640	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625570654	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625571642	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5	1715625571642	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6339	1715625571642	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625571657	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625572644	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625572644	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6254	1715625572644	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625572659	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625573646	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625573646	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6254	1715625573646	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625574670	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625575673	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625577676	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625579676	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625588680	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.7	1715625588680	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.637	1715625588680	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625592689	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625592689	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6381	1715625592689	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625595694	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625595694	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6341	1715625595694	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625610746	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625614754	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625615757	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625880300	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.8	1715625880300	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6563000000000003	1715625880300	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625882304	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625882304	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6582	1715625882304	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625886312	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625886312	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6555999999999997	1715625886312	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625887315	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625887315	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6559	1715625887315	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625889319	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625889319	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6559	1715625889319	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625890320	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625890320	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6563000000000003	1715625890320	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625891322	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.9	1715625891322	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6563000000000003	1715625891322	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625892324	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625892324	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6563000000000003	1715625892324	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625919393	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6778000000000004	1715626153874	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626156882	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626156882	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6795	1715626156882	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626164899	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626164899	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6775	1715626164899	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626167906	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626167906	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6761	1715626167906	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626168932	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626170933	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626173937	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626174941	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626175943	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626180955	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626181953	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626182954	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626188972	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626194986	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626199996	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625573667	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625581682	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625582690	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625584693	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625585695	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625587700	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625590706	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625596710	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625601707	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625601707	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6343	1715625601707	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625602709	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625602709	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.634	1715625602709	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625609723	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625609723	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.636	1715625609723	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625612730	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625612730	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.641	1715625612730	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625617740	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625617740	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6384000000000003	1715625617740	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625620768	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.000000000000001	1715625907355	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6566	1715625907355	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625910361	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625910361	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6578000000000004	1715625910361	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625911363	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625911363	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6569000000000003	1715625911363	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625915371	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625915371	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6569000000000003	1715625915371	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626165901	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626165901	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6775	1715626165901	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626166904	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626166904	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6761	1715626166904	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	107.9	1715626169909	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.2	1715626169909	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6763000000000003	1715626169909	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626179953	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626184963	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626189974	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626191971	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626197991	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626201979	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626201979	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6734	1715626201979	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626210015	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626215029	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626216029	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626217027	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626219035	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715626240057	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6792	1715626240057	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626249078	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626249078	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6789	1715626249078	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626250080	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626250080	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625574648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715625574648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6254	1715625574648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625575651	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625575651	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6306	1715625575651	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625577655	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625577655	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6306	1715625577655	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625579661	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625579661	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6314	1715625579661	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625587678	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625587678	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.637	1715625587678	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625588695	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625592710	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625595715	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625614734	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625614734	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6335	1715625614734	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625615736	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625615736	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6335	1715625615736	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625922386	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.4	1715625922386	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6595	1715625922386	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625929413	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625931427	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625939443	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625944451	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625946456	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625948438	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.000000000000001	1715625948438	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6608	1715625948438	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625954451	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625954451	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6615	1715625954451	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	106	1715625959462	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715625959462	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6641999999999997	1715625959462	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625961466	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.000000000000001	1715625961466	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6641999999999997	1715625961466	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625963470	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625963470	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.662	1715625963470	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625966476	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625966476	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6616999999999997	1715625966476	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625967478	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625967478	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6616999999999997	1715625967478	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625971487	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625971487	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6639	1715625971487	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625978501	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625978501	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6635999999999997	1715625978501	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625981523	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6779	1715626172915	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626178930	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626178930	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6721	1715626178930	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625576653	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625576653	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6306	1715625576653	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625578658	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715625578658	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6314	1715625578658	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625580664	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715625580664	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6314	1715625580664	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625583670	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625583670	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6367	1715625583670	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625589682	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11.6	1715625589682	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.637	1715625589682	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625593690	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625593690	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6341	1715625593690	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625594692	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625594692	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6341	1715625594692	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625597698	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625597698	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6349	1715625597698	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625598715	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625603732	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625604734	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625605730	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625608721	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715625608721	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.636	1715625608721	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625611728	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625611728	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.641	1715625611728	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625616738	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625616738	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6335	1715625616738	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625619744	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.299999999999999	1715625619744	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6384000000000003	1715625619744	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625922407	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625931404	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.1	1715625931404	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6601	1715625931404	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625939420	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625939420	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6569000000000003	1715625939420	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625944430	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625944430	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6625	1715625944430	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625946434	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625946434	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6625	1715625946434	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625947436	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625947436	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6608	1715625947436	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625948461	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625954472	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625959485	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625961486	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625963492	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625966497	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625967500	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625973491	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625576672	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625578674	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625580684	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625583683	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625589704	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625593711	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625594713	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625598700	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625598700	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6349	1715625598700	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625603711	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625603711	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.634	1715625603711	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625604713	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625604713	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.634	1715625604713	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625605715	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625605715	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6382	1715625605715	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625606731	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625608743	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625611751	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625617762	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625619757	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625923388	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.000000000000001	1715625923388	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6601999999999997	1715625923388	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625924390	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625924390	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6601999999999997	1715625924390	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625926394	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625926394	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6594	1715625926394	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625935437	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625952447	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625952447	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6624	1715625952447	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625953449	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625953449	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6615	1715625953449	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625955453	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625955453	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6615	1715625955453	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625957457	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625957457	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6644	1715625957457	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625960464	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.9	1715625960464	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6641999999999997	1715625960464	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625964472	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.5	1715625964472	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.662	1715625964472	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625971502	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625974493	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625974493	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6624	1715625974493	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6782	1715626177927	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626186946	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626186946	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6732	1715626186946	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626187966	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626192983	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626193982	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626195987	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625581666	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625581666	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6367	1715625581666	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625582668	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715625582668	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6367	1715625582668	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625584672	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625584672	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6379	1715625584672	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625585674	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715625585674	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6379	1715625585674	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625586690	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625590684	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625590684	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6381	1715625590684	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625596696	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625596696	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6349	1715625596696	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625597720	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625601721	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625602731	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625609740	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625612753	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625620746	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625620746	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6431999999999998	1715625620746	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625923409	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625924411	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625935412	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625935412	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.661	1715625935412	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625947453	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625952468	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625953462	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625955475	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625957471	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625962483	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625964493	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625973513	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625974516	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626183940	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715626183940	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6768	1715626183940	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626185944	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.2	1715626185944	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6732	1715626185944	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626186961	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626190977	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626196980	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626200977	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	13.799999999999999	1715626200977	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6734	1715626200977	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.699999999999999	1715626241059	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6801	1715626241059	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626243066	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626243066	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6801	1715626243066	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626244082	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626247088	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626248098	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626251106	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626263110	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626263110	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625586676	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625586676	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6379	1715625586676	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625591705	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625599723	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625600727	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625607719	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625607719	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6382	1715625607719	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625610726	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625610726	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.636	1715625610726	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625613753	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625618742	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625618742	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6384000000000003	1715625618742	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625925392	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625925392	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6601999999999997	1715625925392	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625927396	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625927396	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6594	1715625927396	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625928398	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.8	1715625928398	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6594	1715625928398	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625930402	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625930402	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6601	1715625930402	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625933408	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.1	1715625933408	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.66	1715625933408	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625934410	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625934410	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.66	1715625934410	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625936414	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625936414	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.661	1715625936414	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625938418	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.8	1715625938418	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6569000000000003	1715625938418	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625942426	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625942426	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6593	1715625942426	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625949440	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.000000000000001	1715625949440	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6608	1715625949440	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625950443	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625950443	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6624	1715625950443	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625951445	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625951445	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6624	1715625951445	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625958460	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625958460	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6644	1715625958460	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625960485	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625970485	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625970485	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6632	1715625970485	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625972489	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625972489	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6639	1715625972489	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625975495	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.000000000000001	1715625975495	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625591687	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625591687	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6381	1715625591687	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625599703	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715625599703	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6343	1715625599703	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625600705	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625600705	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6343	1715625600705	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625606717	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.799999999999999	1715625606717	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6382	1715625606717	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625607733	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	105	1715625613732	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625613732	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.641	1715625613732	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625616752	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625618763	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625621748	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625621748	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6431999999999998	1715625621748	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625621764	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625622750	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625622750	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6431999999999998	1715625622750	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625622774	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	105	1715625623753	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.399999999999999	1715625623753	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6438	1715625623753	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625623776	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625624755	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625624755	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6438	1715625624755	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625624776	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625625757	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625625757	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6438	1715625625757	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625625779	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625626759	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625626759	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6431	1715625626759	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625626782	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625627761	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625627761	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6431	1715625627761	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625627777	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625628763	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625628763	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6431	1715625628763	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625628785	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625629766	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625629766	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6422	1715625629766	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625629789	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625630768	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625630768	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6422	1715625630768	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625630789	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625631771	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625631771	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6422	1715625631771	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625631786	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625632775	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625632775	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6451	1715625632775	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625634779	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625634779	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6451	1715625634779	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625635781	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625635781	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.645	1715625635781	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625642796	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625642796	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.644	1715625642796	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625643798	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625643798	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.644	1715625643798	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625646819	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625652836	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625657841	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625660832	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625660832	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6441	1715625660832	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625662837	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625662837	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6447	1715625662837	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625666847	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625666847	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6446	1715625666847	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625669870	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625670874	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625673861	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715625673861	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6445	1715625673861	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625676868	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625676868	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6456	1715625676868	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625678874	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625678874	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6466	1715625678874	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625925406	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625927412	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625928414	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625930424	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625933430	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625934425	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625936431	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625938431	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625942440	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625949461	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625950466	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625951459	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625958486	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625962468	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625962468	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.662	1715625962468	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625970505	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625972502	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625975517	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625979525	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625980527	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626189953	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626189953	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6742	1715626189953	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626191957	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626191957	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6761	1715626191957	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626197970	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625632789	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625634800	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625635802	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625642819	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625646804	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625646804	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6434	1715625646804	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625652816	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625652816	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6425	1715625652816	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625657826	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625657826	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6461	1715625657826	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625659854	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625660846	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625662851	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625669853	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625669853	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6438	1715625669853	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625670855	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625670855	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6438	1715625670855	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625671880	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625673878	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625676882	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625678896	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625926410	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625932406	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625932406	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.66	1715625932406	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625937416	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625937416	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.661	1715625937416	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625940422	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625940422	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6569000000000003	1715625940422	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625941424	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625941424	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6593	1715625941424	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625943428	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625943428	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6593	1715625943428	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625945432	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625945432	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6625	1715625945432	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625956455	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.4	1715625956455	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6644	1715625956455	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625965474	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625965474	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6616999999999997	1715625965474	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625968480	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.000000000000001	1715625968480	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6632	1715625968480	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625969483	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625969483	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6632	1715625969483	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625976497	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625976497	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6624	1715625976497	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625977499	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625977499	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6635999999999997	1715625977499	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625981508	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625633777	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625633777	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6451	1715625633777	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625636784	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625636784	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.645	1715625636784	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625637808	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625640792	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715625640792	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6391	1715625640792	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625643811	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625645824	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625647827	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625648821	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625649831	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625651836	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625655843	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625658847	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625664868	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625677871	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625677871	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6466	1715625677871	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625929400	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625929400	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6601	1715625929400	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625932421	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625937437	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625940439	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625941445	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625943450	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625945453	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625956470	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625965497	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625968493	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625969504	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625976511	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625977513	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	4.6	1715626197970	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6769000000000003	1715626197970	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626198972	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9	1715626198972	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6769000000000003	1715626198972	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626209995	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626209995	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6728	1715626209995	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626215006	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626215006	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.673	1715626215006	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626216008	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626216008	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.673	1715626216008	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626217010	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626217010	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6736999999999997	1715626217010	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626219014	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626219014	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6736999999999997	1715626219014	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6801	1715626242063	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626243087	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626245083	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626246093	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626255116	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626259115	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626267139	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626271139	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625633798	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625636797	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625638804	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625640814	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625645802	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625645802	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6434	1715625645802	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625647806	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625647806	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6431	1715625647806	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625648809	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6	1715625648809	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6431	1715625648809	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625649810	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625649810	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6431	1715625649810	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625651814	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625651814	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6425	1715625651814	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625655822	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625655822	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6444	1715625655822	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625658828	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625658828	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6461	1715625658828	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625664841	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715625664841	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6447	1715625664841	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625671858	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625671858	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6445	1715625671858	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.3	1715625973491	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6639	1715625973491	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625978524	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6734	1715626199975	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626203003	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626204004	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626205006	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626206008	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626209015	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626211020	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626212013	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626213022	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626214017	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626218036	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626246072	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6748000000000003	1715626246072	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626255093	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626255093	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6795999999999998	1715626255093	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626259101	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626259101	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6793	1715626259101	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626267118	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715626267118	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6792	1715626267118	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626271126	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.1	1715626271126	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6786	1715626271126	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626273130	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626273130	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6786	1715626273130	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626273145	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626275135	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625637786	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625637786	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.645	1715625637786	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625641813	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625661835	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625661835	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6441	1715625661835	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625665843	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625665843	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6446	1715625665843	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625667849	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625667849	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6446	1715625667849	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625668851	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625668851	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6438	1715625668851	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625675865	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625675865	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6456	1715625675865	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625677895	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625679897	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625680900	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6624	1715625975495	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625979503	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625979503	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6635999999999997	1715625979503	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625980505	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625980505	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.663	1715625980505	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626202981	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626202981	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6721999999999997	1715626202981	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626207011	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626208013	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626220036	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626221033	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6785	1715626250080	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626253088	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626253088	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6795999999999998	1715626253088	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626254090	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.5	1715626254090	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6795999999999998	1715626254090	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626257097	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626257097	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6784	1715626257097	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626258099	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.399999999999999	1715626258099	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6784	1715626258099	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626261105	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626261105	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6793	1715626261105	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6806	1715626274132	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626276137	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.399999999999999	1715626276137	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6806	1715626276137	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626276151	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626279143	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626279143	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6798	1715626279143	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626279158	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626280160	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626281147	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626281147	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625638788	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625638788	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6391	1715625638788	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625639805	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625644823	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625650824	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625653832	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625654841	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625656845	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625663863	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625672860	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625672860	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6445	1715625672860	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625674863	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625674863	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6456	1715625674863	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625981508	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.663	1715625981508	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626203983	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626203983	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6721999999999997	1715626203983	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626204984	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715626204984	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6721999999999997	1715626204984	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626205987	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.2	1715626205987	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6706	1715626205987	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626208993	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626208993	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6728	1715626208993	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626210997	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626210997	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6728	1715626210997	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626211999	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.699999999999999	1715626211999	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6718	1715626211999	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626213001	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626213001	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6718	1715626213001	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626214003	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715626214003	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6718	1715626214003	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626218012	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626218012	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6736999999999997	1715626218012	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626254111	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626257118	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626258112	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626261126	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626275135	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6806	1715626275135	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626277139	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626277139	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6798	1715626277139	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626277153	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626278141	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626278141	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6798	1715626278141	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626278157	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626280145	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626280145	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6786999999999996	1715626280145	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6786999999999996	1715626281147	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626281164	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625639790	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.799999999999999	1715625639790	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6391	1715625639790	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625644800	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715625644800	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6434	1715625644800	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625650812	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625650812	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6425	1715625650812	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625653818	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625653818	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6444	1715625653818	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625654820	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625654820	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6444	1715625654820	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625656824	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625656824	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6461	1715625656824	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625663839	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625663839	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6447	1715625663839	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625666868	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625672883	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625674884	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625982510	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625982510	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.663	1715625982510	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625983512	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625983512	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6616	1715625983512	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625984514	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.000000000000001	1715625984514	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6616	1715625984514	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625985516	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.000000000000001	1715625985516	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6616	1715625985516	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625986518	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625986518	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6629	1715625986518	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625987520	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.000000000000001	1715625987520	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6629	1715625987520	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625990541	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625992546	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625994535	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715625994535	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6638	1715625994535	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626000549	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626000549	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6659	1715626000549	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626001573	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626002566	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626016582	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626016582	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6679	1715626016582	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626017584	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626017584	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6679	1715626017584	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626019589	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715626019589	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6691	1715626019589	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626021593	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715626021593	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6691	1715626021593	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625641795	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625641795	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.644	1715625641795	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625659830	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625659830	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6441	1715625659830	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625661858	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625665857	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625667870	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625668870	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625675887	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625679876	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715625679876	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6466	1715625679876	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625680879	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625680879	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6416999999999997	1715625680879	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625681882	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625681882	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6416999999999997	1715625681882	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625681905	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625682884	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625682884	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6416999999999997	1715625682884	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625682898	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625683886	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625683886	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6433	1715625683886	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625683901	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625684888	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625684888	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6433	1715625684888	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625684901	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625685890	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625685890	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6433	1715625685890	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625685913	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625686892	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625686892	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6444	1715625686892	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625686908	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625687894	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625687894	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6444	1715625687894	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625687915	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625688898	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625688898	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6444	1715625688898	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625688911	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625689900	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625689900	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6421	1715625689900	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625689923	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625690902	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625690902	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6421	1715625690902	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625690921	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625691904	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.299999999999999	1715625691904	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6421	1715625691904	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625691918	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625692906	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625692906	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6416	1715625692906	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625692927	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625695914	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.399999999999999	1715625695914	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6404	1715625695914	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625706936	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625706936	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6459	1715625706936	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625712948	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625712948	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6465	1715625712948	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625716957	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625716957	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6489000000000003	1715625716957	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625717959	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625717959	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6489000000000003	1715625717959	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625721966	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625721966	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6515999999999997	1715625721966	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625723971	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625723971	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6462	1715625723971	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625728982	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625728982	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.647	1715625728982	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625731989	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625731989	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6481	1715625731989	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625733993	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625733993	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6481	1715625733993	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625734995	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625734995	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6484	1715625734995	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625736999	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625736999	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6484	1715625736999	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625982531	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625983533	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625984535	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625985537	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625986541	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625987533	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625992531	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	4.4	1715625992531	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6638	1715625992531	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625993554	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625994558	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626000570	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626002553	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.5	1715626002553	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6663	1715626002553	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626003555	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715626003555	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6663	1715626003555	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626016603	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626017598	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626019610	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626021606	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626027620	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626030628	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626034641	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626039630	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626039630	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625693908	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715625693908	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6416	1715625693908	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625698920	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625698920	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6435	1715625698920	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625700924	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625700924	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6435	1715625700924	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625701926	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625701926	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6445	1715625701926	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625709967	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625718960	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625718960	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6489000000000003	1715625718960	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625719962	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625719962	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6515999999999997	1715625719962	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625722990	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625725990	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625730007	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625988522	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625988522	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6629	1715625988522	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625990527	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715625990527	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6626999999999996	1715625990527	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625991551	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625995537	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.5	1715625995537	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6651	1715625995537	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625997542	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715625997542	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6651	1715625997542	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625998544	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715625998544	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6659	1715625998544	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626001551	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626001551	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6663	1715626001551	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626007564	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.9	1715626007564	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6659	1715626007564	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626009568	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626009568	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6659	1715626009568	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626014578	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626014578	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6686	1715626014578	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626022595	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626022595	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6706999999999996	1715626022595	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626023621	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626028626	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626037648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626042659	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626043659	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626047668	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626050673	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626053679	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626062680	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.5	1715626062680	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6709	1715626062680	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625693930	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625696938	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625697939	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625699943	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625707961	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625708962	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625711968	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625722968	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625722968	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6462	1715625722968	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625724991	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625731011	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625733012	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625738015	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625740026	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625988544	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625991529	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625991529	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6626999999999996	1715625991529	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625993533	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715625993533	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6638	1715625993533	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625995551	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625997566	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625998565	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626005560	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.5	1715626005560	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6654	1715626005560	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626007578	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626009589	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626014599	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626022609	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626028608	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626028608	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6679	1715626028608	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626037626	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626037626	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6714	1715626037626	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626042637	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.2	1715626042637	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6704	1715626042637	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626043639	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715626043639	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6719	1715626043639	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626047646	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626047646	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6696	1715626047646	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626050652	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715626050652	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6696999999999997	1715626050652	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626053658	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.5	1715626053658	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6699	1715626053658	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626055662	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626055662	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6677	1715626055662	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626062701	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626064704	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626065709	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626067714	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626070700	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.5	1715626070700	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6672	1715626070700	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626071702	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625694912	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625694912	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6416	1715625694912	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625695934	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625706950	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625712969	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625716972	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625717983	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625721980	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625723995	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625729003	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625732003	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625734007	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625735016	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625737013	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625989525	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.300000000000001	1715625989525	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6626999999999996	1715625989525	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625996540	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715625996540	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6651	1715625996540	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625999547	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715625999547	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6659	1715625999547	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626003577	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626006577	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626008588	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626010591	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626011588	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626012587	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626013599	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626015604	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626018607	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626020612	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626025615	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626026648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626029624	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626031627	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626033639	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626035643	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626044659	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626045663	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626049671	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626058672	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.5	1715626058672	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6696	1715626058672	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626063682	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.5	1715626063682	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6709	1715626063682	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626074708	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626074708	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6672	1715626074708	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626080720	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715626080720	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6713	1715626080720	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626081723	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.5	1715626081723	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6713	1715626081723	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626084729	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626084729	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6731	1715626084729	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626089752	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626091757	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626094766	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626095767	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625694933	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625698943	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625700945	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625701943	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625713950	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.899999999999999	1715625713950	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6492	1715625713950	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625718973	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625719983	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625725975	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625725975	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6477	1715625725975	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625729985	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.9	1715625729985	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.647	1715625729985	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625989547	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625996553	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625999567	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626006562	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.5	1715626006562	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6654	1715626006562	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626008566	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626008566	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6659	1715626008566	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626010570	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626010570	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6647	1715626010570	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626011572	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626011572	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6647	1715626011572	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626012574	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626012574	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6647	1715626012574	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626013576	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626013576	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6686	1715626013576	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626015580	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.5	1715626015580	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6686	1715626015580	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626018587	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.5	1715626018587	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6679	1715626018587	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626020591	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626020591	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6691	1715626020591	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626025602	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.6	1715626025602	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.665	1715626025602	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	107	1715626026604	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.8	1715626026604	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.665	1715626026604	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626029610	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715626029610	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6679	1715626029610	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626031614	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626031614	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6706	1715626031614	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626033618	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626033618	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6706	1715626033618	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626035622	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626035622	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6694	1715626035622	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626044640	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625696916	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715625696916	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6404	1715625696916	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625697918	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715625697918	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6404	1715625697918	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625699922	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625699922	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6435	1715625699922	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625707938	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625707938	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6452	1715625707938	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625708940	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625708940	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6452	1715625708940	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625711946	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625711946	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6465	1715625711946	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625713963	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625724973	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715625724973	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6462	1715625724973	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625730987	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625730987	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.647	1715625730987	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625732991	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625732991	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6481	1715625732991	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625738001	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625738001	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6492	1715625738001	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625740006	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625740006	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6492	1715625740006	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626004558	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715626004558	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6654	1715626004558	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626005582	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626024599	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626024599	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6706999999999996	1715626024599	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626032616	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715626032616	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6706	1715626032616	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626036638	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626038651	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626046657	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626056665	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715626056665	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6677	1715626056665	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626057669	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9	1715626057669	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6677	1715626057669	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626059674	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626059674	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6696	1715626059674	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	115	1715626060676	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626060676	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6696	1715626060676	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626061678	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.4	1715626061678	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6709	1715626061678	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626066691	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626066691	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625702928	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625702928	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6445	1715625702928	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625703930	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625703930	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6445	1715625703930	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625704932	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.1	1715625704932	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6459	1715625704932	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625705934	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.8	1715625705934	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6459	1715625705934	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625709942	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625709942	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6452	1715625709942	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625710967	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625714965	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625715975	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625720985	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625726992	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625728001	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625736020	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625739026	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625741032	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626004579	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626023597	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715626023597	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6706999999999996	1715626023597	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626024621	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626032638	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626038628	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715626038628	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6714	1715626038628	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626046644	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.5	1715626046644	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6696	1715626046644	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626052680	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626056679	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626057690	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626059698	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626060697	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626061692	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626066704	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626069721	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626073727	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626075731	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626076725	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626079739	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626086783	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626096766	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626099759	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626099759	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6729000000000003	1715626099759	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626206989	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626206989	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6706	1715626206989	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626207991	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715626207991	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6706	1715626207991	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626220016	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626220016	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6746999999999996	1715626220016	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626221018	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626221018	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6746999999999996	1715626221018	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625702949	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625703951	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625704953	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625705955	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625710944	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715625710944	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6465	1715625710944	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625714952	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715625714952	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6492	1715625714952	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625715954	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.399999999999999	1715625715954	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6492	1715625715954	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625720964	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625720964	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6515999999999997	1715625720964	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625726978	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715625726978	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6477	1715625726978	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625727980	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625727980	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6477	1715625727980	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625735997	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625735997	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6484	1715625735997	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625739004	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625739004	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6492	1715625739004	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625741008	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.9	1715625741008	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6502	1715625741008	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625742010	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625742010	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6502	1715625742010	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625742026	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625743012	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625743012	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6456999999999997	1715625743012	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625743037	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625744014	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625744014	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6456999999999997	1715625744014	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625744035	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625745016	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.3	1715625745016	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6456999999999997	1715625745016	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625745036	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625746018	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625746018	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6492	1715625746018	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625746039	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625747020	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.3	1715625747020	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6492	1715625747020	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625747035	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625748022	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.9	1715625748022	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6492	1715625748022	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625748043	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625749024	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625749024	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6503	1715625749024	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625749038	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625750026	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625750026	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6503	1715625750026	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625754035	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625754035	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6508000000000003	1715625754035	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625759044	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715625759044	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6483000000000003	1715625759044	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625761048	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625761048	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6505	1715625761048	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625763052	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625763052	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6505	1715625763052	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625765077	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625768083	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625771082	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625781112	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625789120	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626027606	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626027606	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.665	1715626027606	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626030612	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626030612	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6679	1715626030612	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626034620	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.8	1715626034620	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6694	1715626034620	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626036624	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715626036624	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6694	1715626036624	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626039653	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626040653	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626041648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626048669	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626051667	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626054660	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.1	1715626054660	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6699	1715626054660	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626068696	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.8	1715626068696	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6698000000000004	1715626068696	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626078730	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626083749	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626085752	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626088752	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626090754	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626092758	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626222020	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626222020	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6746999999999996	1715626222020	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626223022	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626223022	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6734	1715626223022	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626228032	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626228032	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6753	1715626228032	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626230036	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626230036	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6751	1715626230036	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626239055	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626239055	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6792	1715626239055	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626240057	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625750047	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625754058	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625759066	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625761069	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	99	1715625765056	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	2.6	1715625765056	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6455	1715625765056	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625768062	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625768062	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6463	1715625768062	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625771068	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625771068	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6477	1715625771068	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625774074	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625774074	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6506999999999996	1715625774074	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625789106	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625789106	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6466999999999996	1715625789106	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625796122	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625796122	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.653	1715625796122	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6714	1715626039630	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626040632	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.5	1715626040632	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6704	1715626040632	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626041635	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715626041635	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6704	1715626041635	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626048648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.8	1715626048648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6696	1715626048648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626051654	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626051654	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6696999999999997	1715626051654	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626052656	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626052656	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6699	1715626052656	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626054681	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626078716	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.8	1715626078716	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6712	1715626078716	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626083727	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626083727	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6731	1715626083727	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626084753	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626088737	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.8	1715626088737	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6736	1715626088737	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626090741	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715626090741	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6736	1715626090741	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626092745	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715626092745	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6681999999999997	1715626092745	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626222035	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626223043	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626228052	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626230051	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626239069	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626240071	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626249098	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626250101	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626253110	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625751028	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625751028	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6503	1715625751028	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625753032	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625753032	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6508000000000003	1715625753032	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625760046	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625760046	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6483000000000003	1715625760046	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625763075	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625769085	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625770087	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625783115	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625784116	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625793128	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625797140	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625798140	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625801147	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626044640	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6719	1715626044640	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626045642	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626045642	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6719	1715626045642	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626049650	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626049650	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6696999999999997	1715626049650	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626055676	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626058693	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626063704	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626074730	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626080742	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626081736	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626089739	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626089739	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6736	1715626089739	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626091743	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6	1715626091743	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6681999999999997	1715626091743	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626094749	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715626094749	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6709	1715626094749	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626095751	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626095751	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6709	1715626095751	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626100762	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626100762	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6736999999999997	1715626100762	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626224024	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.7	1715626224024	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6734	1715626224024	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626227030	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626227030	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6753	1715626227030	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626229034	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626229034	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6751	1715626229034	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626232040	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626232040	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.676	1715626232040	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626236049	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626236049	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6793	1715626236049	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626242063	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626242063	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625751050	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625755036	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11.8	1715625755036	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6491	1715625755036	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625760068	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625769064	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625769064	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6463	1715625769064	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625770066	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625770066	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6477	1715625770066	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625783093	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625783093	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6519	1715625783093	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625784095	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625784095	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6519	1715625784095	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625793115	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625793115	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6488	1715625793115	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625797124	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.3	1715625797124	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6523000000000003	1715625797124	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625798126	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625798126	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6523000000000003	1715625798126	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625801132	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625801132	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6524	1715625801132	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626064686	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626064686	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6712	1715626064686	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626065688	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626065688	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6712	1715626065688	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626067694	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626067694	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6698000000000004	1715626067694	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626068720	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626070722	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626071718	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626072726	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626077735	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626082747	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626087735	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.2	1715626087735	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6739	1715626087735	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626093747	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626093747	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6681999999999997	1715626093747	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626097755	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626097755	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6729000000000003	1715626097755	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626098771	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626224039	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626227044	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626229048	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626232053	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626236069	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626242078	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	98	1715626245070	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	2.9	1715626245070	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6748000000000003	1715626245070	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626246072	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625752030	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.9	1715625752030	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6508000000000003	1715625752030	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625766059	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625766059	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6455	1715625766059	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625780087	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625780087	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6484	1715625780087	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625782091	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625782091	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6519	1715625782091	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625785097	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	13.1	1715625785097	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6525	1715625785097	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625786099	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625786099	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6525	1715625786099	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625788103	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625788103	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6466999999999996	1715625788103	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625790108	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625790108	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6466999999999996	1715625790108	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625791110	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625791110	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6488	1715625791110	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625795120	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625795120	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.653	1715625795120	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625796137	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625799151	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625800155	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6712	1715626066691	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626069698	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626069698	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6698000000000004	1715626069698	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626073706	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626073706	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6672	1715626073706	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626075710	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.6	1715626075710	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6672	1715626075710	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626076712	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	2.8	1715626076712	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6712	1715626076712	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626079718	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.7	1715626079718	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6713	1715626079718	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626086733	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.5	1715626086733	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6739	1715626086733	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626096753	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626096753	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6709	1715626096753	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626097772	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626099774	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626225027	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626225027	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6734	1715626225027	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626237050	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715626237050	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6793	1715626237050	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626241059	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625752048	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625753056	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625756038	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.9	1715625756038	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6491	1715625756038	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625757040	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715625757040	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6491	1715625757040	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625758042	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625758042	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6483000000000003	1715625758042	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625762050	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715625762050	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6505	1715625762050	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625764054	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625764054	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6455	1715625764054	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625766081	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625767060	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625767060	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6463	1715625767060	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625772070	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625772070	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6477	1715625772070	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625773072	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625773072	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6506999999999996	1715625773072	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625774095	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625775097	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625776099	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625777096	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625778105	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625779102	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625780111	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625782107	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625785112	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625786121	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625787101	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625787101	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6525	1715625787101	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625788129	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625790173	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625791131	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	107	1715625792112	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625792112	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6488	1715625792112	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625794118	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625794118	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.653	1715625794118	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625795133	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625799128	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625799128	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6523000000000003	1715625799128	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625800130	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625800130	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6524	1715625800130	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.5	1715626071702	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6672	1715626071702	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626072704	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626072704	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6672	1715626072704	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626077714	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.8	1715626077714	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6712	1715626077714	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625755050	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625756052	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625757054	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625758058	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625762064	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625764077	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625767074	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625772085	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625773093	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625775076	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625775076	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6506999999999996	1715625775076	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625776079	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625776079	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6508000000000003	1715625776079	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625777081	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.899999999999999	1715625777081	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6508000000000003	1715625777081	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625778083	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625778083	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6508000000000003	1715625778083	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625779085	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625779085	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6484	1715625779085	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625781089	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625781089	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6484	1715625781089	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625787115	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625792133	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625794139	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625802136	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625802136	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6524	1715625802136	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625802158	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625803138	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625803138	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6542	1715625803138	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625803159	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625804140	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.5	1715625804140	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6542	1715625804140	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625804161	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625805142	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625805142	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6542	1715625805142	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625805157	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625806144	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625806144	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6527	1715625806144	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625806166	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625807147	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625807147	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6527	1715625807147	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625807169	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625808149	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625808149	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6527	1715625808149	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625808164	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	99	1715625809151	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625809151	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6479	1715625809151	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625809172	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625810153	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.899999999999999	1715625810153	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6479	1715625810153	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625816165	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625816165	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6532	1715625816165	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625833200	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625833200	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6518	1715625833200	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625838232	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625847246	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625849234	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.9	1715625849234	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6535	1715625849234	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625854244	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.8999999999999995	1715625854244	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6546999999999996	1715625854244	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625855261	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626082725	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626082725	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6731	1715626082725	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626085731	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.1000000000000005	1715626085731	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6739	1715626085731	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626087749	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626093761	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626098757	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.5	1715626098757	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6729000000000003	1715626098757	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626225050	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626237064	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626241082	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626244068	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626244068	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6748000000000003	1715626244068	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626247074	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626247074	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6789	1715626247074	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626248076	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626248076	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6789	1715626248076	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626251084	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626251084	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6785	1715626251084	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626262108	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626262108	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6809000000000003	1715626262108	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6809000000000003	1715626263110	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626263123	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626264112	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.399999999999999	1715626264112	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6809000000000003	1715626264112	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626264126	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626268120	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626268120	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.68	1715626268120	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626268141	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626269122	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626269122	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.68	1715626269122	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626269137	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626270124	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626270124	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.68	1715626270124	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626270140	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626272128	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625810166	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625812179	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625821176	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625821176	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6535	1715625821176	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625822178	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625822178	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6535	1715625822178	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625829192	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625829192	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6539	1715625829192	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625836207	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625836207	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.651	1715625836207	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625838211	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625838211	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.651	1715625838211	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625839235	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625841232	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625843243	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625857250	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.9	1715625857250	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6523000000000003	1715625857250	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625860257	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625860257	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6555	1715625860257	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625861259	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715625861259	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6555	1715625861259	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626100779	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626226029	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626226029	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6753	1715626226029	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626231038	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9	1715626231038	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6751	1715626231038	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626233042	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626233042	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.676	1715626233042	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626234044	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626234044	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.676	1715626234044	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626235046	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626235046	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6793	1715626235046	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626238053	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626238053	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6792	1715626238053	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626252086	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.7	1715626252086	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6785	1715626252086	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626256095	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626256095	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6784	1715626256095	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626260103	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626260103	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6793	1715626260103	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626262125	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626265127	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626266137	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626272128	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6786	1715626272128	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	105	1715626274132	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.899999999999999	1715626274132	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625811155	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715625811155	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6479	1715625811155	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625814161	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625814161	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6512	1715625814161	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625817167	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.3	1715625817167	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6532	1715625817167	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625819172	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715625819172	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6521999999999997	1715625819172	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625823180	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625823180	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6535	1715625823180	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	105	1715625824182	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.5	1715625824182	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6531	1715625824182	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625831196	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625831196	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6521	1715625831196	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625834202	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625834202	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6518	1715625834202	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625837209	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625837209	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.651	1715625837209	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625842219	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625842219	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6535	1715625842219	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625845225	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625845225	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6544	1715625845225	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625846227	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625846227	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6544	1715625846227	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625850236	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625850236	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6535	1715625850236	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625851238	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.9	1715625851238	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6506	1715625851238	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715625852240	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625852240	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6506	1715625852240	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625859255	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625859255	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6523000000000003	1715625859255	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626101764	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.8	1715626101764	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6736999999999997	1715626101764	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626104771	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626104771	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6715	1715626104771	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626108781	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626108781	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.671	1715626108781	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626110785	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.5	1715626110785	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6739	1715626110785	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626115796	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715626115796	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6719	1715626115796	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626121808	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625811177	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625814184	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625817181	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625819194	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625823201	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625824202	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625831209	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625834223	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625837222	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625842233	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625845242	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625846240	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625850252	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625851253	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625852253	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625859270	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626101777	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626104788	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626108794	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626110806	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626115816	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626121822	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626122830	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626127843	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626128843	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626129846	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626131842	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626134858	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626141864	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626151888	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626154900	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626155895	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626158908	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626159909	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626171928	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626172930	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626178944	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626183954	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626185969	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626190955	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715626190955	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6761	1715626190955	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626196967	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715626196967	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6769000000000003	1715626196967	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626198995	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626200997	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626226052	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626231060	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626233063	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626234065	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626235059	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626238075	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626252107	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626256108	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626260117	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626265114	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626265114	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6792	1715626265114	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626266116	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626266116	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6792	1715626266116	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626272142	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626274146	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626275148	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625812157	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10	1715625812157	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6512	1715625812157	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625815163	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625815163	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6532	1715625815163	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625821190	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625822192	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625829213	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625836220	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625839213	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625839213	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6545	1715625839213	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625841217	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625841217	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6545	1715625841217	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625843221	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.399999999999999	1715625843221	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6535	1715625843221	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625854258	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625857264	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625860272	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625861273	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626102766	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626102766	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6736999999999997	1715626102766	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626106776	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.8	1715626106776	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.671	1715626106776	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626107793	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626112805	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626123812	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.5	1715626123812	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6729000000000003	1715626123812	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626124814	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626124814	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6731	1715626124814	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626130827	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626130827	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6728	1715626130827	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626140848	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626140848	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6771	1715626140848	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626143854	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626143854	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6751	1715626143854	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626145858	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626145858	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6783	1715626145858	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626146860	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626146860	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6783	1715626146860	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626149888	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626157897	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626160911	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626161906	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626165924	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626166919	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626179932	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626179932	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6721	1715626179932	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626184942	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715626184942	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6732	1715626184942	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625813159	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625813159	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6512	1715625813159	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625818170	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.9	1715625818170	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6521999999999997	1715625818170	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625820174	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625820174	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6521999999999997	1715625820174	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625825184	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625825184	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6531	1715625825184	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625826186	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625826186	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6531	1715625826186	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625827188	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625827188	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6539	1715625827188	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625828190	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625828190	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6539	1715625828190	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625830194	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625830194	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6521	1715625830194	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625832198	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625832198	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6521	1715625832198	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625835204	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625835204	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6518	1715625835204	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625840215	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.3	1715625840215	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6545	1715625840215	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625844223	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625844223	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6535	1715625844223	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625848232	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625848232	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6535	1715625848232	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625853256	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625856266	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625858267	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626102780	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626106790	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626112789	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.8	1715626112789	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6685	1715626112789	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626116810	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626123835	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626124835	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626130848	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626142865	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626143875	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626145880	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626146875	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626157884	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626157884	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6742	1715626157884	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626160891	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626160891	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6795999999999998	1715626160891	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626161893	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626161893	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6795999999999998	1715626161893	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625813176	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625818191	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625820191	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625825209	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625826207	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625827203	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625828212	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625830208	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625832219	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625835219	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625840229	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625844247	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715625853242	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715625853242	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6506	1715625853242	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625856248	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.2	1715625856248	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6546999999999996	1715625856248	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715625858252	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715625858252	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6523000000000003	1715625858252	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626103768	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.8	1715626103768	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6715	1715626103768	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626105773	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626105773	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6715	1715626105773	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626107779	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626107779	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.671	1715626107779	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626111800	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626114814	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626118802	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626118802	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6738000000000004	1715626118802	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626132852	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626133854	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626136853	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626137862	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626138858	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626139867	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626144856	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715626144856	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6751	1715626144856	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626148864	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626148864	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.676	1715626148864	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626150868	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626150868	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.676	1715626150868	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626162895	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626162895	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6795999999999998	1715626162895	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626163897	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626163897	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6775	1715626163897	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626168908	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626168908	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6761	1715626168908	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626176925	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626176925	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6782	1715626176925	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626177927	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.2	1715626177927	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625815177	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625816187	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625833220	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715625847230	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715625847230	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6544	1715625847230	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625848246	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715625849248	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715625855246	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715625855246	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6546999999999996	1715625855246	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626103784	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626105788	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626111787	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.4	1715626111787	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6739	1715626111787	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626114794	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626114794	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6685	1715626114794	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	107	1715626116798	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626116798	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6719	1715626116798	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626132831	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626132831	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6728	1715626132831	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626133833	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9	1715626133833	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6736	1715626133833	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626136840	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626136840	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6721	1715626136840	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626137842	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.5	1715626137842	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6721	1715626137842	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626138844	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626138844	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6721	1715626138844	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626139846	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715626139846	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6771	1715626139846	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626140873	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626144879	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626148885	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626150890	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626162909	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626163918	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626170911	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715626170911	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6763000000000003	1715626170911	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626176946	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626177942	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626187948	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626187948	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6742	1715626187948	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626192959	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626192959	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6761	1715626192959	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626193961	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626193961	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6784	1715626193961	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626195965	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626195965	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6784	1715626195965	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626202001	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626282149	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626282149	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6786999999999996	1715626282149	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626282164	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626283152	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626283152	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6812	1715626283152	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626283168	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626284154	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715626284154	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6812	1715626284154	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626284167	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626285156	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626285156	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6812	1715626285156	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626285170	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626286158	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626286158	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6801999999999997	1715626286158	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626286173	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626287160	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626287160	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6801999999999997	1715626287160	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626287174	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626288162	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626288162	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6801999999999997	1715626288162	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626288177	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626289164	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626289164	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6782	1715626289164	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626289179	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626290167	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626290167	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6782	1715626290167	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626290180	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626291169	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626291169	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6782	1715626291169	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626291189	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626292170	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626292170	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6788000000000003	1715626292170	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626292183	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626293172	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626293172	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6788000000000003	1715626293172	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626293196	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626294174	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626294174	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6788000000000003	1715626294174	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626294190	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626295176	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626295176	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.681	1715626295176	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626295189	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626296178	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.1	1715626296178	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.681	1715626296178	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626296192	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626297181	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626297181	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.681	1715626297181	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626297195	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626298183	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626298183	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6815	1715626298183	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626300187	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626300187	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6815	1715626300187	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626308204	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626308204	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6835999999999998	1715626308204	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626311210	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626311210	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6818	1715626311210	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626312212	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626312212	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6818	1715626312212	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626320249	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626326264	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626328258	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626332274	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626338287	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626762164	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626762164	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7044	1715626762164	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626765174	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626765174	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7073	1715626765174	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626768180	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626768180	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7099	1715626768180	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626771187	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626771187	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7075	1715626771187	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626781207	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715626781207	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7145	1715626781207	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626782210	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.4	1715626782210	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7164	1715626782210	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626787234	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626789246	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626791249	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626793256	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626802250	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626802250	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7143	1715626802250	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626813273	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.3	1715626813273	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7142	1715626813273	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626817294	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626821311	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626824319	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626298197	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626300203	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626308218	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626311226	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626320229	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626320229	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6875	1715626320229	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626326241	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626326241	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6883000000000004	1715626326241	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626328245	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715626328245	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.686	1715626328245	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626332254	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.799999999999999	1715626332254	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6798	1715626332254	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626338266	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626338266	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6846	1715626338266	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626762179	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626765189	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626768196	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626771199	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626781228	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626787220	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715626787220	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7164	1715626787220	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626789224	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626789224	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7134	1715626789224	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626791228	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626791228	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7123000000000004	1715626791228	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626793232	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626793232	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7123000000000004	1715626793232	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626799265	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626802273	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626813294	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626821290	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.5	1715626821290	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7126	1715626821290	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626824296	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.3	1715626824296	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7118	1715626824296	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626826322	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626299185	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626299185	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6815	1715626299185	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626305197	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626305197	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6847	1715626305197	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626306199	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626306199	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6847	1715626306199	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626307201	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626307201	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6835999999999998	1715626307201	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626310208	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715626310208	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6818	1715626310208	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626312227	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626313228	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626314238	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626315237	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626327243	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626327243	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6883000000000004	1715626327243	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626334258	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715626334258	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6826	1715626334258	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626335260	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626335260	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6826	1715626335260	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626336262	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626336262	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6826	1715626336262	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626340270	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715626340270	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6851	1715626340270	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626763166	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.199999999999999	1715626763166	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7044	1715626763166	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626766176	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626766176	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7073	1715626766176	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626770185	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626770185	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7075	1715626770185	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626773190	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626773190	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7109	1715626773190	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626775195	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626775195	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7109	1715626775195	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626780226	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626786235	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626788242	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626795257	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626796259	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626804254	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626804254	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7136	1715626804254	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626805256	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626805256	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7136	1715626805256	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626807274	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626818298	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626825322	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626299206	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626305211	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626306221	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626307215	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626310233	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626313214	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626313214	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6866	1715626313214	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626314216	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.399999999999999	1715626314216	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6866	1715626314216	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626315218	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626315218	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6866	1715626315218	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626317240	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626327257	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626334281	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626335282	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626336282	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626340291	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626763181	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626766190	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626770200	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626773215	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626775211	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626786218	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.5	1715626786218	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7164	1715626786218	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626788222	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.5	1715626788222	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7134	1715626788222	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626795236	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626795236	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7134	1715626795236	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626796238	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.3	1715626796238	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7134	1715626796238	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626799244	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715626799244	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7128	1715626799244	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626804276	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626807260	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11.1	1715626807260	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7134	1715626807260	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626818284	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715626818284	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7153	1715626818284	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626825299	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626825299	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7118	1715626825299	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626301189	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626301189	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6820999999999997	1715626301189	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626316244	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626321252	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626323259	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626324257	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626329268	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626331275	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626337278	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626764170	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626764170	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7073	1715626764170	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626767178	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626767178	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7099	1715626767178	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626769183	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626769183	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7099	1715626769183	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626772189	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626772189	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7075	1715626772189	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626774192	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626774192	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7109	1715626774192	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626776198	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626776198	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7112	1715626776198	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626778202	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626778202	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7112	1715626778202	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626779203	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.799999999999999	1715626779203	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7145	1715626779203	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626783212	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626783212	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7164	1715626783212	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626784214	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626784214	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7164	1715626784214	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626785216	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715626785216	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7164	1715626785216	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626797240	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715626797240	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7128	1715626797240	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626798242	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.4	1715626798242	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7128	1715626798242	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626810267	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626810267	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7128	1715626810267	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626812271	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715626812271	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7142	1715626812271	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626814275	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715626814275	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7142	1715626814275	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626816280	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715626816280	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7131999999999996	1715626816280	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626819286	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.3	1715626819286	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7153	1715626819286	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626301210	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626321231	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626321231	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6875	1715626321231	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626323235	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.1	1715626323235	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6877	1715626323235	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626324237	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626324237	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6877	1715626324237	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626329247	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626329247	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.686	1715626329247	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626331252	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626331252	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6798	1715626331252	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626337264	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626337264	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6846	1715626337264	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626764187	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626767190	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626769199	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626772201	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626774213	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626776220	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626778215	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626779224	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626783232	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626784238	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626785237	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626797261	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626798263	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626810287	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626812284	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626814295	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626816293	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626819301	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626820301	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626827302	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715626827302	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7156	1715626827302	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626302191	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626302191	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6820999999999997	1715626302191	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626303193	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626303193	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6820999999999997	1715626303193	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626304195	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626304195	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6847	1715626304195	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626309206	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626309206	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6835999999999998	1715626309206	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626316220	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626316220	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6866999999999996	1715626316220	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626318224	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	12.2	1715626318224	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6866999999999996	1715626318224	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626319226	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.399999999999999	1715626319226	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6875	1715626319226	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626322233	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715626322233	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6877	1715626322233	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626325239	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626325239	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6883000000000004	1715626325239	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626330249	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715626330249	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.686	1715626330249	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626333256	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626333256	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6798	1715626333256	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626339268	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626339268	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6846	1715626339268	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626341272	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626341272	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6851	1715626341272	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626777200	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626777200	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7112	1715626777200	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626780205	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.5	1715626780205	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7145	1715626780205	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626790226	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.5	1715626790226	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7134	1715626790226	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626792230	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.3	1715626792230	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7123000000000004	1715626792230	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626794234	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.3	1715626794234	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7134	1715626794234	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626800246	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.5	1715626800246	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7143	1715626800246	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626801248	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.1	1715626801248	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7143	1715626801248	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626803252	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626803252	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7136	1715626803252	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626805277	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626302208	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626303214	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626304216	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626309227	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626317222	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626317222	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6866999999999996	1715626317222	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626318238	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626319240	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626322247	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626325260	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626330272	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626333277	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626339281	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626341293	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626342274	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626342274	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6851	1715626342274	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626342296	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626343276	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626343276	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6848	1715626343276	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626343289	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626344278	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.1	1715626344278	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6848	1715626344278	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626344300	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626345280	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626345280	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6848	1715626345280	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626345293	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626346282	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626346282	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626346282	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626346304	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626347284	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626347284	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626347284	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626347299	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626348287	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626348287	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626348287	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626348309	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626349289	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626349289	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6872	1715626349289	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626349309	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626350290	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715626350290	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6872	1715626350290	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626350312	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626351292	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626351292	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6872	1715626351292	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626351313	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626352294	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626352294	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6828000000000003	1715626352294	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626352308	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626353296	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626353296	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6828000000000003	1715626353296	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626353317	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626354298	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626354319	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626354298	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6828000000000003	1715626354298	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626357304	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715626357304	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626357304	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626358306	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626358306	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6843000000000004	1715626358306	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626373362	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626383358	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715626383358	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6872	1715626383358	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626397386	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626397386	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6888	1715626397386	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626401394	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626401394	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6927	1715626401394	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626403398	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626403398	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6921	1715626403398	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626409412	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626409412	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6915999999999998	1715626409412	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626413420	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.8	1715626413420	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6927	1715626413420	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626414422	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715626414422	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6927	1715626414422	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626417430	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626417430	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6902	1715626417430	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626430461	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626430461	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.689	1715626430461	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626431463	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626431463	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.689	1715626431463	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626433467	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626433467	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.691	1715626433467	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626435471	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626435471	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.691	1715626435471	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626438478	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626438478	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6915	1715626438478	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626441508	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626442501	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626447516	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626454510	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626454510	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626454510	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626455512	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11	1715626455512	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626455512	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626458518	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626458518	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6984	1715626458518	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626777221	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626782222	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626790248	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626792255	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626355300	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626355300	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626355300	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626358321	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626362331	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626363337	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626364338	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626367339	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626370352	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626371355	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626376344	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.2	1715626376344	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6848	1715626376344	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626377359	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626380374	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626381369	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626391392	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626394398	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626398387	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.5	1715626398387	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6888	1715626398387	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626410414	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626410414	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6915999999999998	1715626410414	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626411416	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626411416	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6915999999999998	1715626411416	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626412431	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626421459	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626424467	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626427470	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626437488	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626440496	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626443512	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626461547	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626794255	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626800268	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626801262	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626803274	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626806258	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.5	1715626806258	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7134	1715626806258	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626808262	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.3	1715626808262	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7134	1715626808262	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626809265	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.5	1715626809265	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7128	1715626809265	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626811269	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.4	1715626811269	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7128	1715626811269	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626815277	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626815277	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7131999999999996	1715626815277	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626817282	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.3	1715626817282	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7131999999999996	1715626817282	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626822306	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626823317	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626355321	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626362315	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626362315	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626362315	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626363317	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626363317	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626363317	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626364319	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715626364319	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6844	1715626364319	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626367325	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626367325	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6859	1715626367325	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626370331	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.1	1715626370331	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6881	1715626370331	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626371333	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626371333	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6881	1715626371333	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626375342	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626375342	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626375342	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626377346	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.5	1715626377346	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6848	1715626377346	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626380352	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626380352	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626380352	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626381354	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626381354	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626381354	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626391375	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626391375	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6879	1715626391375	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626394381	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626394381	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6905	1715626394381	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626395383	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626395383	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6905	1715626395383	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626398410	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626410434	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626412418	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.399999999999999	1715626412418	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6927	1715626412418	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626421438	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626421438	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6881999999999997	1715626421438	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626424445	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626424445	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6889000000000003	1715626424445	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626427453	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626427453	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.688	1715626427453	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626437475	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626437475	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6915	1715626437475	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626440482	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626440482	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6918	1715626440482	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626443489	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626443489	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.69	1715626443489	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626461525	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626356302	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715626356302	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626356302	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626368348	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626369350	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626375363	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626378369	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626379370	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626385384	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626387387	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626388393	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626389391	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626390386	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626396384	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715626396384	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6905	1715626396384	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626402396	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626402396	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6927	1715626402396	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626404400	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626404400	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6921	1715626404400	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626406406	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626406406	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6902	1715626406406	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626408410	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626408410	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6902	1715626408410	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626411438	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626416446	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626418453	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626423468	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626432480	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626434493	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626436495	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626439500	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626444490	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.3	1715626444490	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.69	1715626444490	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626448498	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.2	1715626448498	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.692	1715626448498	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626452506	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626452506	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6951	1715626452506	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626453508	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626453508	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6951	1715626453508	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626460523	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626460523	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6964	1715626460523	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626806279	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626808276	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626809286	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626811291	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626815291	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626822292	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.1	1715626822292	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7126	1715626822292	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626823294	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626823294	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7126	1715626823294	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626356323	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626369329	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626369329	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6859	1715626369329	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626374360	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626378348	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715626378348	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6848	1715626378348	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626379350	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715626379350	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626379350	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626385362	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626385362	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6863	1715626385362	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626387366	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626387366	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6863	1715626387366	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626388368	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626388368	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6873	1715626388368	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626389370	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626389370	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6873	1715626389370	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626390373	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626390373	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6873	1715626390373	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626395405	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626396398	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626402410	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626404414	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626406427	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626408432	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626416426	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626416426	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6902	1715626416426	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626418432	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626418432	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.687	1715626418432	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626423443	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715626423443	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6881999999999997	1715626423443	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626432465	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626432465	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.689	1715626432465	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626434469	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626434469	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.691	1715626434469	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626436473	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626436473	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6915	1715626436473	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626439480	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715626439480	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6918	1715626439480	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626441484	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626441484	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6918	1715626441484	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626444504	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626448519	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626452520	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626453529	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626460539	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626820288	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715626820288	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7153	1715626820288	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626357319	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626373337	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.3	1715626373337	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626373337	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626374339	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626374339	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626374339	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626383379	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626397400	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626401416	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626403411	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626409436	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626413442	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626414444	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626417445	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626430481	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626431481	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626433488	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626435495	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626438499	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626442486	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715626442486	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.69	1715626442486	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626447496	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626447496	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6896	1715626447496	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626449500	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626449500	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.692	1715626449500	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626454533	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626455528	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626458532	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626826300	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626826300	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7118	1715626826300	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626827317	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626359309	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626359309	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6843000000000004	1715626359309	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626360311	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715626360311	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6843000000000004	1715626360311	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626361313	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626361313	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6856999999999998	1715626361313	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626365321	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626365321	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6844	1715626365321	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626366323	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626366323	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6844	1715626366323	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626368327	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626368327	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6859	1715626368327	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626372349	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626382356	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715626382356	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6872	1715626382356	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626384360	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626384360	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6872	1715626384360	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626386364	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626386364	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6863	1715626386364	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626392377	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626392377	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6879	1715626392377	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626393379	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715626393379	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6879	1715626393379	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626399390	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626399390	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6888	1715626399390	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626400392	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.5	1715626400392	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6927	1715626400392	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626405404	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626405404	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6921	1715626405404	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626407408	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715626407408	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6902	1715626407408	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626415424	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626415424	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6902	1715626415424	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626419434	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626419434	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.687	1715626419434	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626420436	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626420436	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.687	1715626420436	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626422440	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626422440	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6881999999999997	1715626422440	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626425449	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626425449	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6889000000000003	1715626425449	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626426451	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715626426451	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6889000000000003	1715626426451	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626359325	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626360331	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626361334	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626365343	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626366345	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626372335	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.6	1715626372335	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6881	1715626372335	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626376365	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626382370	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626384373	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626386385	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626392389	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626393392	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626399405	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626400406	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626405418	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626407426	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626415439	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626419455	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626420458	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626422454	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626425470	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626426465	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626428476	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626429477	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626445505	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626446515	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626450502	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626450502	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.692	1715626450502	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626451504	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	14	1715626451504	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6951	1715626451504	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626456514	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626456514	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626456514	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626457516	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11	1715626457516	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6984	1715626457516	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626459521	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626459521	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6984	1715626459521	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626428456	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626428456	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.688	1715626428456	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626429458	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715626429458	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.688	1715626429458	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626445492	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.4	1715626445492	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6896	1715626445492	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626446494	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.2	1715626446494	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6896	1715626446494	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626449515	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626450516	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626451527	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626456530	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626457530	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626459535	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626461525	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6964	1715626461525	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	99	1715626462527	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626462527	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6964	1715626462527	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626462543	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626463529	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.5	1715626463529	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6908000000000003	1715626463529	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626463550	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626464531	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.6	1715626464531	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6908000000000003	1715626464531	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626464552	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626465535	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.299999999999999	1715626465535	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6908000000000003	1715626465535	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626465550	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626466537	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626466537	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6911	1715626466537	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626466553	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626467539	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626467539	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6911	1715626467539	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626467555	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626468541	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626468541	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6911	1715626468541	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626468557	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626469544	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626469544	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6902	1715626469544	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626469565	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626470546	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626470546	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6902	1715626470546	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626470567	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626471548	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626471548	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6902	1715626471548	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626471569	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626472550	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626472550	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6906	1715626472550	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626472563	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626473552	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626473552	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6906	1715626473552	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626473572	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626474554	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715626474554	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6906	1715626474554	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626474575	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626475557	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626475557	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6918	1715626475557	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626475571	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626476560	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626476560	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6918	1715626476560	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626476582	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626477562	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626477562	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6918	1715626477562	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626479566	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.8	1715626479566	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6921	1715626479566	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626480568	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626480568	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6921	1715626480568	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626484576	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.299999999999999	1715626484576	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6893000000000002	1715626484576	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626485578	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715626485578	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6893000000000002	1715626485578	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626487582	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626487582	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.693	1715626487582	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626496600	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626496600	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6909	1715626496600	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626499606	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626499606	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6927	1715626499606	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626502612	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626502612	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6959	1715626502612	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626504616	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626504616	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6959	1715626504616	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626505632	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626507643	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626510644	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626521652	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626521652	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6964	1715626521652	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626524684	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626525677	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626528695	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626538692	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11.1	1715626538692	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6946999999999997	1715626538692	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626542701	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626542701	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6961999999999997	1715626542701	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626547710	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626547710	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6986	1715626547710	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626550716	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626550716	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6969000000000003	1715626550716	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626552720	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626552720	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6969000000000003	1715626552720	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626555726	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626555726	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.698	1715626555726	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626557730	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626557730	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626557730	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626568755	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626568755	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6969000000000003	1715626568755	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626575771	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626575771	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6982	1715626575771	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626477583	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626479579	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626480590	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626484596	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626485592	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626487597	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626496621	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626499627	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626502633	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626504637	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626507623	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715626507623	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6906999999999996	1715626507623	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	99	1715626510629	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	3.1	1715626510629	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6958	1715626510629	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626513635	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626513635	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6917	1715626513635	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626524661	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626524661	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6943	1715626524661	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626525663	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626525663	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6943	1715626525663	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626528669	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626528669	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6942	1715626528669	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626536688	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626536688	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6934	1715626536688	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626538713	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626542721	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626547731	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626550737	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626552740	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626555740	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626557745	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626568776	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626577774	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.4	1715626577774	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6982	1715626577774	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626579778	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626579778	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6982	1715626579778	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626478564	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626478564	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6921	1715626478564	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	105	1715626489586	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626489586	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.693	1715626489586	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626490588	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626490588	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6909	1715626490588	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626493594	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.5	1715626493594	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6925	1715626493594	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626495612	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626509627	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626509627	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6958	1715626509627	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626513658	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626529671	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626529671	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6949	1715626529671	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626530675	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626530675	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6949	1715626530675	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626532680	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626532680	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6939	1715626532680	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626533682	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626533682	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6939	1715626533682	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626539695	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626539695	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6946999999999997	1715626539695	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626540697	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626540697	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6946999999999997	1715626540697	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626541699	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.2	1715626541699	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6961999999999997	1715626541699	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626546708	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626546708	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6980999999999997	1715626546708	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626556728	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626556728	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626556728	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626561738	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626561738	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626561738	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626562742	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626562742	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6992	1715626562742	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626565749	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626565749	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7009000000000003	1715626565749	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626569757	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626569757	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6969000000000003	1715626569757	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626570759	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11.1	1715626570759	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6969000000000003	1715626570759	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626572763	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626572763	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6961999999999997	1715626572763	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626478579	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626489608	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626490610	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626493616	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626508625	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626508625	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6958	1715626508625	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626509643	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626515654	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626529693	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626530695	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626532696	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626533704	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626539715	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626540710	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626541713	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626546721	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626556750	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626561760	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626562757	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626565770	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626569778	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626570780	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626572778	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626481570	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626481570	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6933000000000002	1715626481570	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626488584	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715626488584	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.693	1715626488584	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626492592	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6	1715626492592	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6909	1715626492592	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626494596	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626494596	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6925	1715626494596	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626495598	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626495598	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6925	1715626495598	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626497624	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626500629	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626503627	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626506642	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626511631	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626511631	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6917	1715626511631	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626514637	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.8	1715626514637	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6936999999999998	1715626514637	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626518646	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626518646	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6952	1715626518646	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626521676	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626522675	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626523679	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626527684	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626537690	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626537690	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6934	1715626537690	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626543702	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.7	1715626543702	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6961999999999997	1715626543702	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626545706	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626545706	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6980999999999997	1715626545706	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626548712	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626548712	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6986	1715626548712	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626549714	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626549714	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6986	1715626549714	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626551718	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626551718	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6969000000000003	1715626551718	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626554724	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626554724	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.698	1715626554724	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626558732	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626558732	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626558732	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626560736	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626560736	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626560736	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626574769	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626574769	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6982	1715626574769	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626575786	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626578791	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626481592	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626488597	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626492614	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626494609	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626497602	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626497602	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6909	1715626497602	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626500608	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715626500608	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6927	1715626500608	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626503614	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.7	1715626503614	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6959	1715626503614	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626506621	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626506621	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6906999999999996	1715626506621	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626508647	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626511653	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626514659	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626518668	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626522655	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626522655	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6964	1715626522655	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626523659	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	13.7	1715626523659	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6943	1715626523659	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626527667	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626527667	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6942	1715626527667	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626536702	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626537711	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626543715	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626545727	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626548736	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626549737	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626551736	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626554745	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626558745	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626560758	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626574790	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626578776	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626578776	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6982	1715626578776	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626580781	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626580781	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6976	1715626580781	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626482572	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626482572	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6933000000000002	1715626482572	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626483574	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626483574	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6933000000000002	1715626483574	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626486580	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626486580	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6893000000000002	1715626486580	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626491590	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.7	1715626491590	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6909	1715626491590	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626498604	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	3.1	1715626498604	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6909	1715626498604	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626501610	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.799999999999999	1715626501610	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6927	1715626501610	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626505618	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626505618	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6906999999999996	1715626505618	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626512649	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626516641	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626516641	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6936999999999998	1715626516641	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626517644	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.700000000000001	1715626517644	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6952	1715626517644	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626519648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626519648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6952	1715626519648	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626520650	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626520650	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6964	1715626520650	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626526665	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626526665	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6942	1715626526665	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626531678	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626531678	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6949	1715626531678	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626534684	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626534684	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6939	1715626534684	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626535686	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626535686	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6934	1715626535686	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626544704	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626544704	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6980999999999997	1715626544704	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626553722	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626553722	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.698	1715626553722	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626559734	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626559734	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626559734	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626563744	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626563744	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6992	1715626563744	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626564746	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.9	1715626564746	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6992	1715626564746	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626566751	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626566751	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7009000000000003	1715626566751	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626482588	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626483586	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626486604	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626491605	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626498621	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626501631	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626512633	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626512633	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6917	1715626512633	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626515639	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.200000000000001	1715626515639	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6936999999999998	1715626515639	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626516655	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626517657	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626519669	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626520663	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626526687	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626531699	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626534705	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626535707	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626544724	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626553743	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626559756	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626563766	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626564769	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626566767	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626567773	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626571782	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626573786	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626576788	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626581804	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626567753	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626567753	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7009000000000003	1715626567753	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626571761	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626571761	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6961999999999997	1715626571761	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626573766	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.700000000000001	1715626573766	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6961999999999997	1715626573766	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626576773	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626576773	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6982	1715626576773	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626581783	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626581783	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6976	1715626581783	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626577787	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626579792	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626580803	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626582785	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626582785	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6976	1715626582785	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626582805	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626583787	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626583787	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626583787	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626583808	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626584789	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626584789	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626584789	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626584813	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	105	1715626585791	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.6	1715626585791	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626585791	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626585805	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626586793	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626586793	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6971	1715626586793	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626586817	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626587795	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626587795	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6971	1715626587795	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626587811	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626588797	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626588797	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6971	1715626588797	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626588818	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626589799	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626589799	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6994000000000002	1715626589799	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626589821	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626590803	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626590803	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6994000000000002	1715626590803	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626590823	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626591805	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.200000000000001	1715626591805	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6994000000000002	1715626591805	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626591827	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626592808	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626592808	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6963000000000004	1715626592808	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626592822	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626593810	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626593810	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6963000000000004	1715626593810	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626593834	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626594812	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626594812	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6963000000000004	1715626594812	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626594834	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626595814	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626595814	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626595814	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626595830	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626596815	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.6	1715626596815	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626596815	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626596830	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626597817	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626597817	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626597817	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626597839	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626605849	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626606850	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626607862	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626610859	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626614876	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626619883	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626620881	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626623892	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626625890	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626630899	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626631902	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626632911	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626635910	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626642910	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	4.9	1715626642910	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6961999999999997	1715626642910	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626645916	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9	1715626645916	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6971	1715626645916	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626658944	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626658944	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7004	1715626658944	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626659946	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626659946	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7004	1715626659946	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626662953	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626662953	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6999	1715626662953	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626663955	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11	1715626663955	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6999	1715626663955	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626664957	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626664957	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6998	1715626664957	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626675982	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626675982	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7015	1715626675982	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626681995	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626681995	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7026999999999997	1715626681995	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626682997	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.199999999999999	1715626682997	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7041999999999997	1715626682997	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626686004	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626686004	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7049000000000003	1715626686004	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626696041	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626698046	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626722094	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626726088	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.199999999999999	1715626726088	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7	1715626726088	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626727090	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626727090	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7	1715626727090	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	105	1715626729095	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.5	1715626729095	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7006	1715626729095	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626732102	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626732102	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7024	1715626732102	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626737112	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626737112	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626598820	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626598820	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7	1715626598820	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626599822	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626599822	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7	1715626599822	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626600824	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626600824	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7	1715626600824	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626602828	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626602828	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6998	1715626602828	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626608840	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626608840	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7013000000000003	1715626608840	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626611846	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626611846	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7001	1715626611846	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626618883	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626621867	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.6	1715626621867	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6995	1715626621867	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626625875	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626625875	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.697	1715626625875	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626629904	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626636911	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626641922	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626649938	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626651951	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626655959	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626657965	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626660967	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626673998	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626677004	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626679009	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626688008	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9	1715626688008	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7049000000000003	1715626688008	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626689010	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626689010	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7053000000000003	1715626689010	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626690014	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626690014	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7053000000000003	1715626690014	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626697028	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626697028	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7029	1715626697028	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626699032	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626699032	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7032	1715626699032	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626700034	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626700034	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7032	1715626700034	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626702038	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626702038	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6992	1715626702038	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626704042	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626704042	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6991	1715626704042	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626719074	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626719074	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7032	1715626719074	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626734106	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626598843	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626599845	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626600839	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626602852	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626608862	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626611861	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626619862	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626619862	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6995	1715626619862	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626621887	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626629884	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626629884	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.699	1715626629884	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626636898	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.200000000000001	1715626636898	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.698	1715626636898	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626641908	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.200000000000001	1715626641908	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6961999999999997	1715626641908	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626649925	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.199999999999999	1715626649925	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6974	1715626649925	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626651929	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626651929	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6974	1715626651929	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626655938	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.3	1715626655938	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626655938	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626657942	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626657942	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626657942	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626660948	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626660948	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7004	1715626660948	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626673976	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.299999999999999	1715626673976	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7015	1715626673976	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626676984	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626676984	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6983	1715626676984	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626678988	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626678988	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6983	1715626678988	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626685002	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626685002	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7041999999999997	1715626685002	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626688030	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626689030	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626690035	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626697043	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626699045	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626700048	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626702055	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626708068	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626719095	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626734127	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626735130	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626739139	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626743138	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626745128	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626745128	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7046	1715626745128	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626754147	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626754147	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626601826	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626601826	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6998	1715626601826	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626609842	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626609842	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7013000000000003	1715626609842	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626612849	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626612849	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7001	1715626612849	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626616879	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626622883	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626626877	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.4	1715626626877	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.697	1715626626877	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626627879	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.9	1715626627879	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.697	1715626627879	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626628882	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626628882	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.699	1715626628882	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626633892	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.500000000000001	1715626633892	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6991	1715626633892	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626638902	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626638902	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6973000000000003	1715626638902	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626640906	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.700000000000001	1715626640906	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6961999999999997	1715626640906	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626644914	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.8	1715626644914	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6971	1715626644914	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626646919	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626646919	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6982	1715626646919	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626647921	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626647921	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6982	1715626647921	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626648923	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626648923	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6982	1715626648923	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626650927	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626650927	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6974	1715626650927	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626652931	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.199999999999999	1715626652931	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6968	1715626652931	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626656940	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11.2	1715626656940	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6988000000000003	1715626656940	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626661951	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626661951	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6999	1715626661951	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626666975	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626667985	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626668990	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626670990	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626671992	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626672995	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626674999	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626678000	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626681016	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626687019	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626692034	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626601844	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626609864	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626616856	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626616856	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6975	1715626616856	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626622869	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626622869	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7001	1715626622869	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626624896	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626626890	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626627900	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626628902	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626633914	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626638920	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626642931	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626644935	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626646940	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626647936	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626648943	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626650948	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626652945	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626656953	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626666962	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626666962	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6998	1715626666962	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626667964	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626667964	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7005	1715626667964	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626668966	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.199999999999999	1715626668966	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7005	1715626668966	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626670970	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626670970	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.703	1715626670970	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626671972	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626671972	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.703	1715626671972	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626672974	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626672974	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.703	1715626672974	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626674978	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626674978	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7015	1715626674978	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626677986	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.8	1715626677986	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6983	1715626677986	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626680992	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626680992	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7026999999999997	1715626680992	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626687006	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11.2	1715626687006	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7049000000000003	1715626687006	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626692018	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626692018	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7037	1715626692018	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626701036	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626701036	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6992	1715626701036	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626704066	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626706068	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626709074	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626712080	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626716088	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626717092	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626603830	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626603830	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6998	1715626603830	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626604832	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626604832	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7013000000000003	1715626604832	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626612865	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626613871	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626615875	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626617873	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626634907	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626637914	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626639918	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626653933	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626653933	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6968	1715626653933	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626654936	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.9	1715626654936	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6968	1715626654936	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626661965	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626665980	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626669989	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626680003	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626684024	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626686022	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626691038	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626693041	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626694043	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626695039	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626703057	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626705066	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626707061	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626710055	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626710055	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7029	1715626710055	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626711057	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626711057	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7029	1715626711057	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626713061	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626713061	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7016	1715626713061	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626714063	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.3	1715626714063	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7016	1715626714063	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626715065	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626715065	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7016	1715626715065	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626723096	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626730118	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626731121	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626733124	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626738137	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626742136	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626746153	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626753145	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9	1715626753145	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7054	1715626753145	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626603852	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626604853	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626613850	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626613850	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6969000000000003	1715626613850	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626615854	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626615854	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6969000000000003	1715626615854	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626617858	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626617858	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6975	1715626617858	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626634894	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.800000000000001	1715626634894	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.698	1715626634894	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626637900	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	4.9	1715626637900	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6973000000000003	1715626637900	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626639904	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626639904	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6973000000000003	1715626639904	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626643936	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626653952	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626654957	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626665959	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626665959	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6998	1715626665959	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626669968	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.3	1715626669968	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7005	1715626669968	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	99	1715626679990	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	3.3	1715626679990	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7026999999999997	1715626679990	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626683999	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626683999	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7041999999999997	1715626683999	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626685017	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626691016	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626691016	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7053000000000003	1715626691016	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626693020	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11.2	1715626693020	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7037	1715626693020	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626694022	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.199999999999999	1715626694022	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7037	1715626694022	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626695024	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626695024	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7029	1715626695024	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626703040	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.199999999999999	1715626703040	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6992	1715626703040	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626705045	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626705045	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6991	1715626705045	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626707049	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626707049	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6999	1715626707049	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626708051	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626708051	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6999	1715626708051	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626710075	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626711078	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626713075	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626714084	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626605834	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.6000000000000005	1715626605834	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7013000000000003	1715626605834	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626606836	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626606836	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7013000000000003	1715626606836	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626607838	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11.8	1715626607838	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7013000000000003	1715626607838	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626610844	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626610844	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7001	1715626610844	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626614852	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626614852	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6969000000000003	1715626614852	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626618860	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626618860	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6975	1715626618860	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626620864	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.9	1715626620864	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6995	1715626620864	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626623871	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8	1715626623871	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7001	1715626623871	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626624873	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626624873	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7001	1715626624873	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626630886	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8	1715626630886	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.699	1715626630886	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626631888	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.300000000000001	1715626631888	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6991	1715626631888	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626632890	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.1	1715626632890	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6991	1715626632890	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626635896	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.800000000000001	1715626635896	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.698	1715626635896	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626640927	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626643912	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626643912	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6971	1715626643912	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626645939	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626658966	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626659969	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626662974	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626663976	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626664971	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626676004	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626682009	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626683012	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626696026	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626696026	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7029	1715626696026	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626698030	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626698030	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7032	1715626698030	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626722080	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.199999999999999	1715626722080	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6984	1715626722080	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626723082	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626723082	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6984	1715626723082	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626701057	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626706047	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11	1715626706047	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6991	1715626706047	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626709053	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626709053	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6999	1715626709053	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626712059	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626712059	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7029	1715626712059	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626716067	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626716067	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7014	1715626716067	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626717069	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626717069	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7014	1715626717069	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626718071	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.199999999999999	1715626718071	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7014	1715626718071	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626720076	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9.299999999999999	1715626720076	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7032	1715626720076	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626721078	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626721078	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7032	1715626721078	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626724084	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626724084	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.6984	1715626724084	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626725086	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	10.7	1715626725086	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7	1715626725086	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626728093	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626728093	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7006	1715626728093	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626736110	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626736110	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7016999999999998	1715626736110	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626740118	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626740118	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7058	1715626740118	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626744126	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11.2	1715626744126	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7046	1715626744126	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626748135	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	11	1715626748135	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7056	1715626748135	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626749137	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626749137	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7053000000000003	1715626749137	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626750139	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626750139	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7053000000000003	1715626750139	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626752143	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626752143	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7054	1715626752143	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626755149	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	12.4	1715626755149	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7041	1715626755149	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626756173	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626758170	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626761176	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626715087	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626730098	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.199999999999999	1715626730098	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7006	1715626730098	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626731100	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626731100	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7024	1715626731100	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626733104	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626733104	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7024	1715626733104	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626738114	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626738114	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7049000000000003	1715626738114	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	104	1715626742122	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626742122	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7058	1715626742122	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626746131	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626746131	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7056	1715626746131	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626747146	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626753167	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626718089	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626720091	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626721094	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626724104	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626725108	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626728109	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626736131	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626740139	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626747133	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626747133	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7056	1715626747133	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626748149	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626749159	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626750160	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626752156	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626755171	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626758156	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.8	1715626758156	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7047	1715626758156	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626761162	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626761162	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7044	1715626761162	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626726109	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626727111	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626729111	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626732124	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626737134	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626741141	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626751158	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626757153	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.8999999999999995	1715626757153	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7041	1715626757153	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626759158	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	7.6000000000000005	1715626759158	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7047	1715626759158	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626760160	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.199999999999999	1715626760160	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7047	1715626760160	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	5.9	1715626734106	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7016999999999998	1715626734106	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626735108	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626735108	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7016999999999998	1715626735108	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626739116	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	9	1715626739116	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7049000000000003	1715626739116	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	102	1715626743124	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.2	1715626743124	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7046	1715626743124	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626744149	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626745143	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626754170	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7049000000000003	1715626737112	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	100	1715626741120	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.4	1715626741120	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7058	1715626741120	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	101	1715626751141	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	6.199999999999999	1715626751141	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7053000000000003	1715626751141	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - CPU Utilization	103	1715626756151	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Utilization	8.1	1715626756151	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7041	1715626756151	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626757168	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626759171	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Swap Memory GB	0.089	1715626760176	e42f8d7c87d448479239a7caf9dd502e	0	f
TOP - Memory Usage GB	2.7054	1715626754147	e42f8d7c87d448479239a7caf9dd502e	0	f
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
letter	0	2c5382c94a884980a0555cc724e5dc4a
workload	0	2c5382c94a884980a0555cc724e5dc4a
listeners	smi+top+dcgmi	2c5382c94a884980a0555cc724e5dc4a
params	'"-"'	2c5382c94a884980a0555cc724e5dc4a
file	cifar10.py	2c5382c94a884980a0555cc724e5dc4a
workload_listener	''	2c5382c94a884980a0555cc724e5dc4a
letter	0	e42f8d7c87d448479239a7caf9dd502e
workload	0	e42f8d7c87d448479239a7caf9dd502e
listeners	smi+top+dcgmi	e42f8d7c87d448479239a7caf9dd502e
params	'"-"'	e42f8d7c87d448479239a7caf9dd502e
file	cifar10.py	e42f8d7c87d448479239a7caf9dd502e
workload_listener	''	e42f8d7c87d448479239a7caf9dd502e
model	cifar10.py	e42f8d7c87d448479239a7caf9dd502e
manual	False	e42f8d7c87d448479239a7caf9dd502e
max_epoch	5	e42f8d7c87d448479239a7caf9dd502e
max_time	172800	e42f8d7c87d448479239a7caf9dd502e
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
2c5382c94a884980a0555cc724e5dc4a	placid-shoat-533	UNKNOWN			daga	RUNNING	1715625312790	\N		active	s3://mlflow-storage/0/2c5382c94a884980a0555cc724e5dc4a/artifacts	0	\N
e42f8d7c87d448479239a7caf9dd502e	(0 0) sedate-sheep-13	UNKNOWN			daga	FINISHED	1715625507899	1715626828440		active	s3://mlflow-storage/0/e42f8d7c87d448479239a7caf9dd502e/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	2c5382c94a884980a0555cc724e5dc4a
mlflow.source.name	file:///home/daga/radt#examples/pytorch	2c5382c94a884980a0555cc724e5dc4a
mlflow.source.type	PROJECT	2c5382c94a884980a0555cc724e5dc4a
mlflow.project.entryPoint	main	2c5382c94a884980a0555cc724e5dc4a
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	2c5382c94a884980a0555cc724e5dc4a
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	2c5382c94a884980a0555cc724e5dc4a
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	2c5382c94a884980a0555cc724e5dc4a
mlflow.runName	placid-shoat-533	2c5382c94a884980a0555cc724e5dc4a
mlflow.project.env	conda	2c5382c94a884980a0555cc724e5dc4a
mlflow.user	daga	e42f8d7c87d448479239a7caf9dd502e
mlflow.source.name	file:///home/daga/radt#examples/pytorch	e42f8d7c87d448479239a7caf9dd502e
mlflow.source.type	PROJECT	e42f8d7c87d448479239a7caf9dd502e
mlflow.project.entryPoint	main	e42f8d7c87d448479239a7caf9dd502e
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	e42f8d7c87d448479239a7caf9dd502e
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	e42f8d7c87d448479239a7caf9dd502e
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	e42f8d7c87d448479239a7caf9dd502e
mlflow.project.env	conda	e42f8d7c87d448479239a7caf9dd502e
mlflow.project.backend	local	e42f8d7c87d448479239a7caf9dd502e
mlflow.runName	(0 0) sedate-sheep-13	e42f8d7c87d448479239a7caf9dd502e
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

