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
0	Default	s3://mlflow-storage/0	active	1715616411202	1715616411202
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
SMI - Power Draw	14.78	1715616502439	0	f	8cb6db5144e3469999eeada0a53b74e4
SMI - Timestamp	1715616502.425	1715616502439	0	f	8cb6db5144e3469999eeada0a53b74e4
SMI - GPU Util	0	1715616502439	0	f	8cb6db5144e3469999eeada0a53b74e4
SMI - Mem Util	0	1715616502439	0	f	8cb6db5144e3469999eeada0a53b74e4
SMI - Mem Used	0	1715616502439	0	f	8cb6db5144e3469999eeada0a53b74e4
SMI - Performance State	0	1715616502439	0	f	8cb6db5144e3469999eeada0a53b74e4
TOP - CPU Utilization	102	1715616945414	0	f	8cb6db5144e3469999eeada0a53b74e4
TOP - Memory Usage GB	2.5625	1715616945414	0	f	8cb6db5144e3469999eeada0a53b74e4
TOP - Memory Utilization	6.8999999999999995	1715616945414	0	f	8cb6db5144e3469999eeada0a53b74e4
TOP - Swap Memory GB	0.0653	1715616945436	0	f	8cb6db5144e3469999eeada0a53b74e4
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
TOP - CPU Utilization	0	1715616502497	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	0	1715616502497	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	1.835	1715616502497	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0593	1715616502517	8cb6db5144e3469999eeada0a53b74e4	0	f
SMI - Power Draw	14.78	1715616502439	8cb6db5144e3469999eeada0a53b74e4	0	f
SMI - Timestamp	1715616502.425	1715616502439	8cb6db5144e3469999eeada0a53b74e4	0	f
SMI - GPU Util	0	1715616502439	8cb6db5144e3469999eeada0a53b74e4	0	f
SMI - Mem Util	0	1715616502439	8cb6db5144e3469999eeada0a53b74e4	0	f
SMI - Mem Used	0	1715616502439	8cb6db5144e3469999eeada0a53b74e4	0	f
SMI - Performance State	0	1715616502439	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	168.79999999999998	1715616503499	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	8.2	1715616503499	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	1.835	1715616503499	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0593	1715616503520	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	137	1715616504501	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.6	1715616504501	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	1.835	1715616504501	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0593	1715616504516	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616505503	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.6	1715616505503	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.087	1715616505503	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0625	1715616505526	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616506506	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.5	1715616506506	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.087	1715616506506	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0625	1715616506540	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616507508	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.5	1715616507508	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.087	1715616507508	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0625	1715616507521	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616508510	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5	1715616508510	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.0881999999999996	1715616508510	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616508524	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	106	1715616509512	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5	1715616509512	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.0881999999999996	1715616509512	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616509527	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	105	1715616510515	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5	1715616510515	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.0881999999999996	1715616510515	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616510530	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	106	1715616511517	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.3	1715616511517	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.0868	1715616511517	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616511530	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616512520	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5	1715616512520	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.0868	1715616512520	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616512533	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	105	1715616513522	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.9	1715616513522	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.0868	1715616513522	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616513539	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616514524	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.5	1715616514524	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.089	1715616514524	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616514539	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	105	1715616515526	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616515526	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.089	1715616515526	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616515549	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	105	1715616516528	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.6	1715616516528	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.089	1715616516528	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616516550	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616520552	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616822158	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616822158	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5579	1715616822158	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616823160	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.1000000000000005	1715616823160	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5563000000000002	1715616823160	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616828170	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616828170	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5564	1715616828170	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616829193	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616843202	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.8	1715616843202	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5563000000000002	1715616843202	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616844204	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.7	1715616844204	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5581	1715616844204	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616847210	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.199999999999999	1715616847210	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5576	1715616847210	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616848227	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616852242	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616855243	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616859250	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616860251	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616864245	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.2	1715616864245	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.557	1715616864245	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616868253	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616868253	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5609	1715616868253	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616870258	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.2	1715616870258	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5609	1715616870258	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616871260	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616871260	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5623	1715616871260	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616872262	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.2	1715616872262	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5623	1715616872262	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616878274	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616878274	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5613	1715616878274	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616879276	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616879276	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5613	1715616879276	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616517531	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.6	1715616517531	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.0886	1715616517531	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616518533	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5	1715616518533	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.0886	1715616518533	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616822179	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616823181	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616828190	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616842200	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.199999999999999	1715616842200	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5563000000000002	1715616842200	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616843215	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616846230	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616848212	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.7	1715616848212	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5576	1715616848212	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616852221	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616852221	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5591	1715616852221	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616855227	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616855227	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5589	1715616855227	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616859235	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616859235	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5593000000000004	1715616859235	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616860237	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616860237	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5593000000000004	1715616860237	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616862241	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.2	1715616862241	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.557	1715616862241	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616864258	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616868275	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616870274	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616871282	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616872278	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616878287	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616879290	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616517546	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616518548	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616824162	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.4	1715616824162	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5563000000000002	1715616824162	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616829172	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616829172	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5585999999999998	1715616829172	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616832193	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616836210	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616839194	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.399999999999999	1715616839194	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5544000000000002	1715616839194	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616840196	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616840196	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5544000000000002	1715616840196	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616845206	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.5	1715616845206	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5581	1715616845206	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616847227	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616854238	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616856245	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616861262	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616866249	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.2	1715616866249	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5591	1715616866249	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616867251	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616867251	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5591	1715616867251	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616874283	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616877298	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616880295	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616519535	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616519535	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.0886	1715616519535	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616824185	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616832180	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616832180	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.557	1715616832180	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616836188	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616836188	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5581	1715616836188	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616837213	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616839216	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616840212	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616845223	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616854225	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.5	1715616854225	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5589	1715616854225	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616856229	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616856229	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5591	1715616856229	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616861240	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.5	1715616861240	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5593000000000004	1715616861240	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616862256	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616866273	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616874266	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.2	1715616874266	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5613	1715616874266	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616877272	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616877272	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5613	1715616877272	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616880278	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.5	1715616880278	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5615	1715616880278	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616519551	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616825164	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.1000000000000005	1715616825164	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5563000000000002	1715616825164	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616826166	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616826166	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5564	1715616826166	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616844219	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616850238	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616851239	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616853244	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616869269	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616873278	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616875281	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616520537	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616520537	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.3975999999999997	1715616520537	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616521540	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.6	1715616521540	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.3975999999999997	1715616521540	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616521557	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616522542	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5	1715616522542	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.3975999999999997	1715616522542	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0633	1715616522557	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616523544	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.6	1715616523544	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6114	1715616523544	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616523557	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616524546	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616524546	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6114	1715616524546	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616524559	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616525548	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.5	1715616525548	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6114	1715616525548	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616525561	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616526550	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.6000000000000005	1715616526550	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6125	1715616526550	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616526564	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616527552	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616527552	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6125	1715616527552	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616527566	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616528554	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616528554	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6125	1715616528554	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616528569	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616529556	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5	1715616529556	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6214	1715616529556	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616529572	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616530558	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.5	1715616530558	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6214	1715616530558	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616530572	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616531560	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.6	1715616531560	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6214	1715616531560	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616531577	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616532562	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.5	1715616532562	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.622	1715616532562	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616532575	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616533564	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.9	1715616533564	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.622	1715616533564	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616533588	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616534566	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616534566	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.622	1715616534566	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616534587	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616535568	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.9	1715616535568	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6241	1715616535568	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616535595	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616536570	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.1	1715616536570	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6241	1715616536570	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616563626	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.6	1715616563626	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5362	1715616563626	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616570640	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616570640	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5363	1715616570640	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616571642	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.4	1715616571642	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5372	1715616571642	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616577654	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.699999999999999	1715616577654	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.54	1715616577654	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616578656	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616578656	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.54	1715616578656	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616825185	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616826181	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616850216	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.2	1715616850216	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5591	1715616850216	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616851219	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616851219	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5591	1715616851219	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616853223	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616853223	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5589	1715616853223	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616869256	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.699999999999999	1715616869256	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5609	1715616869256	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616873264	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.5	1715616873264	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5623	1715616873264	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616875268	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616875268	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5613	1715616875268	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616876270	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616876270	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5613	1715616876270	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616536591	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616544607	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616551623	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616555624	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616559631	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616560633	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616567647	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616569654	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616573660	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616574662	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616827169	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616827169	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5564	1715616827169	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616830175	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.5	1715616830175	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5585999999999998	1715616830175	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616831178	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.6	1715616831178	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5585999999999998	1715616831178	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616833182	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616833182	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.557	1715616833182	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616834184	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.199999999999999	1715616834184	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.557	1715616834184	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616835186	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616835186	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5581	1715616835186	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616837190	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616837190	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5581	1715616837190	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616838208	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616841219	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616846208	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.2	1715616846208	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5581	1715616846208	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616849227	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616857244	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616858248	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616863270	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616865261	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616876283	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616881302	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616537572	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.7	1715616537572	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6241	1715616537572	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616538574	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.3	1715616538574	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.624	1715616538574	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616539576	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.9	1715616539576	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.624	1715616539576	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616540578	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.5	1715616540578	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.624	1715616540578	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616543584	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5	1715616543584	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6249000000000002	1715616543584	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616545611	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616546612	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616547607	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616552616	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616558632	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616562637	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616565630	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.2	1715616565630	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.532	1715616565630	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	67.4	1715616580660	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.8	1715616580660	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5383	1715616580660	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616827190	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616830196	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616831200	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616833204	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616834205	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616835209	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616838192	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.199999999999999	1715616838192	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5544000000000002	1715616838192	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616841198	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616841198	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5563000000000002	1715616841198	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616842213	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616849214	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	10.399999999999999	1715616849214	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5576	1715616849214	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616857231	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.2	1715616857231	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5591	1715616857231	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616858233	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.199999999999999	1715616858233	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5591	1715616858233	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616863243	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.199999999999999	1715616863243	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.557	1715616863243	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616865247	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616865247	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5591	1715616865247	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616867265	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616881280	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.6	1715616881280	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5615	1715616881280	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616537589	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616538590	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616539601	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616540602	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616541580	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.4	1715616541580	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6249000000000002	1715616541580	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616542582	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.5	1715616542582	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.6249000000000002	1715616542582	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616545588	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.4	1715616545588	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.531	1715616545588	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616546590	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616546590	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.531	1715616546590	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616547592	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.5	1715616547592	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5333	1715616547592	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616548594	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.9	1715616548594	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5333	1715616548594	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616549597	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.5	1715616549597	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5333	1715616549597	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616549618	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616550611	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616553605	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616553605	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5345	1715616553605	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616554607	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616554607	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5345	1715616554607	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616556612	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.6	1715616556612	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5354	1715616556612	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616557614	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616557614	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5354	1715616557614	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616558616	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5	1715616558616	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5354	1715616558616	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616561622	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616561622	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5355	1715616561622	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616562624	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616562624	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5362	1715616562624	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616563642	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616564628	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.9	1715616564628	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5362	1715616564628	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616565645	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616566649	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616568654	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616572656	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616575664	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616576666	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616579675	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616580681	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616882282	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616882282	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5615	1715616882282	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616883284	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616541596	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616542597	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616548616	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616550599	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5	1715616550599	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5353000000000003	1715616550599	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616552603	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.4	1715616552603	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5353000000000003	1715616552603	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616553618	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616554623	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616556634	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616557626	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616561638	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616564642	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616568636	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.6	1715616568636	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5363	1715616568636	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616572643	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616572643	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5372	1715616572643	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616575649	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616575649	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5382	1715616575649	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616576651	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.300000000000001	1715616576651	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5382	1715616576651	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616579658	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.699999999999999	1715616579658	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.54	1715616579658	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616882295	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616883301	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616893324	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616899329	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616900339	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616905352	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616907332	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.8	1715616907332	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.561	1715616907332	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616908334	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616908334	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.561	1715616908334	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616910339	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.399999999999999	1715616910339	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5598	1715616910339	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616928377	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616928377	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5578000000000003	1715616928377	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616930382	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616930382	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5578000000000003	1715616930382	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616931407	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616940426	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616543606	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616566632	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.6	1715616566632	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.532	1715616566632	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616570654	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616571656	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616577668	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616883284	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5589	1715616883284	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616893304	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616893304	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5627	1715616893304	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616899316	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.2	1715616899316	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5612	1715616899316	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616900318	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	8	1715616900318	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5612	1715616900318	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616904326	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.199999999999999	1715616904326	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5594	1715616904326	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616906330	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.399999999999999	1715616906330	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5594	1715616906330	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616907346	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616908355	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616910359	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616928391	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616931384	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.199999999999999	1715616931384	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5585	1715616931384	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616940403	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.699999999999999	1715616940403	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5631	1715616940403	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616544586	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.6	1715616544586	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.531	1715616544586	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616551601	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616551601	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5353000000000003	1715616551601	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616555609	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.6	1715616555609	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5345	1715616555609	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616559618	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.6	1715616559618	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5355	1715616559618	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616560620	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.9	1715616560620	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5355	1715616560620	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616567634	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.6	1715616567634	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.532	1715616567634	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616569638	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616569638	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5363	1715616569638	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616573645	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.699999999999999	1715616573645	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5372	1715616573645	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616574647	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616574647	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5382	1715616574647	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616578673	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616581662	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616581662	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5383	1715616581662	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616581678	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616582664	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616582664	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5383	1715616582664	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616582678	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616583666	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616583666	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5359000000000003	1715616583666	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616583679	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616584668	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.5	1715616584668	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5359000000000003	1715616584668	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616584682	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616585670	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616585670	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5359000000000003	1715616585670	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616585686	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616586672	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616586672	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5323	1715616586672	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616586686	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616587674	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616587674	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5323	1715616587674	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616587689	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616588676	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616588676	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5323	1715616588676	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616588697	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616589678	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616589678	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.533	1715616589678	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616589691	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616590680	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4	1715616590680	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.533	1715616590680	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616596693	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616596693	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5384	1715616596693	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616598696	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616598696	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5391	1715616598696	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616601702	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616601702	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5396	1715616601702	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616603706	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616603706	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5396	1715616603706	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616604721	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616605732	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616606725	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616609732	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616620762	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616621755	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616622758	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616623760	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616630780	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616884286	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616884286	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5589	1715616884286	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616887292	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616887292	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5588	1715616887292	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616888294	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616888294	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5588	1715616888294	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616890298	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616890298	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5605	1715616890298	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616901320	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616901320	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5610999999999997	1715616901320	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616902322	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616902322	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5610999999999997	1715616902322	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616903324	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.3	1715616903324	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5610999999999997	1715616903324	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616906352	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616909351	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616916366	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616917366	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616924367	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.6	1715616924367	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5623	1715616924367	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	99	1715616925370	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616925370	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5601	1715616925370	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616927388	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616929398	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616932402	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616933410	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616935416	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616936415	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616939414	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616941426	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616590703	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616596708	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616598716	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616601723	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616603728	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616605710	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616605710	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5406999999999997	1715616605710	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616606712	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616606712	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5406999999999997	1715616606712	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616609718	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616609718	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5376	1715616609718	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616620740	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616620740	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5376999999999996	1715616620740	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616621742	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	1.6	1715616621742	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5376999999999996	1715616621742	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616622744	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616622744	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5369	1715616622744	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616623746	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616623746	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5369	1715616623746	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616630760	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616630760	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5389	1715616630760	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616884299	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616887307	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616888309	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616890312	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616901342	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616902337	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616904340	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616909336	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616909336	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.561	1715616909336	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616916351	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616916351	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5604	1715616916351	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616917353	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616917353	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5604	1715616917353	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616919357	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.199999999999999	1715616919357	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5603000000000002	1715616919357	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616924381	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616927375	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.699999999999999	1715616927375	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5601	1715616927375	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616929380	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.9	1715616929380	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5578000000000003	1715616929380	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616932386	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.5	1715616932386	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5585	1715616932386	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616933388	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616933388	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5585	1715616933388	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616935392	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.199999999999999	1715616935392	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5589	1715616935392	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616591682	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616591682	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.533	1715616591682	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616592684	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616592684	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5379	1715616592684	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616593686	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4	1715616593686	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5379	1715616593686	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616595690	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616595690	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5384	1715616595690	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616597694	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.9	1715616597694	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5384	1715616597694	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616607714	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616607714	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5376	1715616607714	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616608716	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616608716	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5376	1715616608716	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616611722	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616611722	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5385	1715616611722	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616613725	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616613725	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5395	1715616613725	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616614727	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616614727	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5395	1715616614727	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616617733	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616617733	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5403000000000002	1715616617733	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616629758	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616629758	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5389	1715616629758	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616631762	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616631762	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5403000000000002	1715616631762	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616633766	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616633766	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5403000000000002	1715616633766	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616640781	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.699999999999999	1715616640781	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5423	1715616640781	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616885288	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616885288	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5589	1715616885288	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616886290	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.199999999999999	1715616886290	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5588	1715616886290	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616889296	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.199999999999999	1715616889296	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5605	1715616889296	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616891300	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616891300	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5605	1715616891300	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616892302	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616892302	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5627	1715616892302	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616895308	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616895308	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.56	1715616895308	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616896310	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616591696	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616592698	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616593704	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616595703	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616597708	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616607728	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616608739	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616611743	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616613742	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616614752	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616617746	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616629773	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616631784	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616633786	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616640803	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616885302	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616886304	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616889311	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616891314	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616892324	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616895332	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616896331	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616898327	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616913344	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.2	1715616913344	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5613	1715616913344	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616914360	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616915365	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616920383	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616921383	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616923387	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616926372	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616926372	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5601	1715616926372	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616930397	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616934404	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616938419	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616594688	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616594688	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5379	1715616594688	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616599698	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4	1715616599698	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5391	1715616599698	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616604708	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616604708	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5406999999999997	1715616604708	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616616752	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616618758	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616619759	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616624768	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616625763	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616626772	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616634789	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616636789	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616637787	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616638791	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616639799	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616894306	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616894306	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5627	1715616894306	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616897312	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616897312	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.56	1715616897312	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616903346	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616911360	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616912363	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616918355	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.699999999999999	1715616918355	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5604	1715616918355	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616919374	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616922377	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616937412	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616594709	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616599712	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616616731	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4	1715616616731	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5403000000000002	1715616616731	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616618736	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616618736	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5403000000000002	1715616618736	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	4	1715616619738	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4	1715616619738	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5376999999999996	1715616619738	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616624748	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616624748	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5369	1715616624748	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616625750	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616625750	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5375	1715616625750	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616626752	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616626752	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5375	1715616626752	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616634768	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616634768	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5414	1715616634768	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616636773	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616636773	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5414	1715616636773	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616637775	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616637775	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5416	1715616637775	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616638777	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616638777	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5416	1715616638777	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616639779	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616639779	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5416	1715616639779	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616894321	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616897325	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616911340	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.9	1715616911340	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5598	1715616911340	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616912342	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616912342	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5598	1715616912342	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616913357	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616918369	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616922363	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616922363	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5623	1715616922363	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616937397	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616937397	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5591	1715616937397	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616600700	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616600700	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5391	1715616600700	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	4	1715616602704	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.699999999999999	1715616602704	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5396	1715616602704	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616610720	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4	1715616610720	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5385	1715616610720	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616612723	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616612723	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5385	1715616612723	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616615729	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.9	1715616615729	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5395	1715616615729	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616627754	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616627754	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5375	1715616627754	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616628756	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616628756	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5389	1715616628756	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616632764	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616632764	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5403000000000002	1715616632764	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616635770	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616635770	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5414	1715616635770	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.5	1715616896310	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.56	1715616896310	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616898314	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616898314	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5612	1715616898314	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616905328	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616905328	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5594	1715616905328	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616914346	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.5	1715616914346	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5613	1715616914346	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616915348	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616915348	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5613	1715616915348	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616920359	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.2	1715616920359	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5603000000000002	1715616920359	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616921361	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.9	1715616921361	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5603000000000002	1715616921361	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616923365	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616923365	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5623	1715616923365	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616925390	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616926393	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616934390	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616934390	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5589	1715616934390	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616938399	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616938399	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5591	1715616938399	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616600721	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616602718	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616610733	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616612739	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616615749	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616627768	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616628779	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616632778	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616635794	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616641783	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616641783	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5423	1715616641783	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616641796	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	4	1715616642785	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.5	1715616642785	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5423	1715616642785	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616642799	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616643787	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616643787	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5439000000000003	1715616643787	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616643807	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616644789	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616644789	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5439000000000003	1715616644789	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616644803	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616645791	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616645791	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5439000000000003	1715616645791	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616645812	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616646793	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616646793	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5421	1715616646793	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616646805	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616647795	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616647795	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5421	1715616647795	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616647810	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616648797	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616648797	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5421	1715616648797	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616648811	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616649799	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616649799	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5415	1715616649799	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616649822	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616650801	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616650801	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5415	1715616650801	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616650822	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616651803	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616651803	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5415	1715616651803	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616651817	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616652805	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616652805	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.543	1715616652805	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616652826	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616653807	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616653807	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.543	1715616653807	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616653828	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616654809	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616654809	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.543	1715616654809	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616654830	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616664830	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616664830	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5434	1715616664830	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616666834	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.9	1715616666834	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5434	1715616666834	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616667837	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616667837	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5419	1715616667837	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616668839	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616668839	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5419	1715616668839	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616680864	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616680864	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5438	1715616680864	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616684872	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616684872	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.542	1715616684872	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616686876	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616686876	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5428	1715616686876	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616687893	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616692903	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616695915	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616700929	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616936395	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616936395	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5589	1715616936395	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616939401	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.5	1715616939401	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5591	1715616939401	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616941405	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616941405	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5631	1715616941405	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616655811	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616655811	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5433000000000003	1715616655811	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616656813	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616656813	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5433000000000003	1715616656813	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616657838	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616663828	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4	1715616663828	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5412	1715616663828	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616669862	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616671867	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616672867	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616673872	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616674865	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616675876	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616678873	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616681888	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616682883	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616683885	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616688880	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616688880	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5455	1715616688880	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616696897	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616696897	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5446999999999997	1715616696897	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616699903	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616699903	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5467	1715616699903	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616942407	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616942407	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5631	1715616942407	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616943424	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616655832	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616657815	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616657815	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5433000000000003	1715616657815	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616660843	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616669841	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616669841	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5419	1715616669841	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616671845	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616671845	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.54	1715616671845	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616672847	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616672847	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.54	1715616672847	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616673849	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616673849	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5425	1715616673849	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616674851	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616674851	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5425	1715616674851	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616675853	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616675853	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5425	1715616675853	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616678860	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616678860	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5406999999999997	1715616678860	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616681866	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4	1715616681866	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5438	1715616681866	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616682868	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616682868	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.542	1715616682868	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616683870	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616683870	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.542	1715616683870	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616685888	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616688901	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616696920	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616699918	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616942421	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616656830	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616664845	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616666856	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616667852	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616668853	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616680884	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616684886	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616686889	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616692889	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4	1715616692889	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5423	1715616692889	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616695895	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4	1715616695895	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5446999999999997	1715616695895	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616700905	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4	1715616700905	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5454	1715616700905	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616943410	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.199999999999999	1715616943410	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5625	1715616943410	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616658818	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5	1715616658818	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5418000000000003	1715616658818	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616659820	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616659820	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5418000000000003	1715616659820	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616660821	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616660821	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5418000000000003	1715616660821	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616662840	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616665832	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616665832	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5434	1715616665832	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616670843	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616670843	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.54	1715616670843	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616677858	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616677858	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5406999999999997	1715616677858	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616685874	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616685874	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5428	1715616685874	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616691886	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616691886	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5423	1715616691886	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616944412	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.3	1715616944412	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5625	1715616944412	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616658838	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616659833	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616662825	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616662825	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5412	1715616662825	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616663841	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616665847	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616670864	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616677871	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616687878	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616687878	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5428	1715616687878	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616691907	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616944425	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616661823	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	1.6	1715616661823	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5412	1715616661823	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616676856	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616676856	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5406999999999997	1715616676856	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616679862	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616679862	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5438	1715616679862	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616689882	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616689882	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5455	1715616689882	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616690885	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616690885	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5455	1715616690885	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616693891	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616693891	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5423	1715616693891	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616694893	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616694893	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5446999999999997	1715616694893	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616697899	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616697899	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5467	1715616697899	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616698901	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616698901	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5467	1715616698901	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616945414	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8999999999999995	1715616945414	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5625	1715616945414	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616661844	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616676870	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616679882	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616689906	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616690907	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616693915	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616694915	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616697916	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616698916	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616701907	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616701907	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5454	1715616701907	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616701929	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	4	1715616702909	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616702909	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5454	1715616702909	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616702929	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616703911	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616703911	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5438	1715616703911	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616703931	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616704913	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616704913	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5438	1715616704913	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616704926	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616705915	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616705915	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5438	1715616705915	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616705936	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	4	1715616706918	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616706918	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5436	1715616706918	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616706933	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616707920	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616707920	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5436	1715616707920	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616707941	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616708922	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616708922	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5436	1715616708922	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616708944	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616709924	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616709924	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5446999999999997	1715616709924	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616709938	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616710926	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4	1715616710926	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5446999999999997	1715616710926	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616710948	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616711928	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.9	1715616711928	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5446999999999997	1715616711928	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616711943	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616712930	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.699999999999999	1715616712930	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5414	1715616712930	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616712951	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616713932	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.5	1715616713932	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5414	1715616713932	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616713946	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616714934	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616714934	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5414	1715616714934	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616714949	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616717963	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616728981	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616729987	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616732973	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616732973	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5505999999999998	1715616732973	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616733975	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616733975	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5499	1715616733975	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616734977	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.699999999999999	1715616734977	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5499	1715616734977	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616737984	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.4	1715616737984	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5479000000000003	1715616737984	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616738986	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616738986	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5479000000000003	1715616738986	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616743996	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.4	1715616743996	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5481	1715616743996	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616746022	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616747015	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616749026	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616750027	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616751031	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616754037	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616945436	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616715938	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616715938	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5416999999999996	1715616715938	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616718944	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616718944	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5423	1715616718944	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616719946	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616719946	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5423	1715616719946	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616721950	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616721950	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5421	1715616721950	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616722952	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.1	1715616722952	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5421	1715616722952	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	1	1715616723954	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.7	1715616723954	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5421	1715616723954	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	35	1715616727963	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616727963	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5490999999999997	1715616727963	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	99	1715616735979	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.6	1715616735979	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5499	1715616735979	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616736981	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.699999999999999	1715616736981	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5479000000000003	1715616736981	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616740008	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616741014	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616742012	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616744998	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.5	1715616744998	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5481	1715616744998	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616753014	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616753014	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5496999999999996	1715616753014	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616761031	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616761031	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5496	1715616761031	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616715959	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616718966	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616719967	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616721964	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616722974	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616723968	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616727975	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616736000	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616739988	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616739988	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5465	1715616739988	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616740990	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616740990	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5465	1715616740990	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616741992	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616741992	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5465	1715616741992	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616743008	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616745021	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616753029	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616761052	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616716940	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	2.4	1715616716940	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5416999999999996	1715616716940	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616720948	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616720948	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5423	1715616720948	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616724956	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616724956	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5431	1715616724956	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616742994	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616742994	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5481	1715616742994	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616748004	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.6	1715616748004	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5489	1715616748004	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616757022	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616757022	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5474	1715616757022	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616760029	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616760029	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5496	1715616760029	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616716959	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616720969	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616737004	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616746000	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616746000	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5489	1715616746000	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616748026	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616757043	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616760051	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616717942	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	4.300000000000001	1715616717942	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5416999999999996	1715616717942	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616728965	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616728965	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5490999999999997	1715616728965	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616729967	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.4	1715616729967	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5490999999999997	1715616729967	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616731983	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616732996	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616733996	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616734999	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616737998	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616738998	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616744018	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616747002	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616747002	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5489	1715616747002	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616749006	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616749006	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5493	1715616749006	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616750008	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616750008	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5493	1715616750008	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616751010	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616751010	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5493	1715616751010	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616754016	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616754016	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5488000000000004	1715616754016	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616724970	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616725976	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616726979	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616730993	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616752012	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.699999999999999	1715616752012	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5496999999999996	1715616752012	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616755018	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.4	1715616755018	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5488000000000004	1715616755018	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616756020	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.699999999999999	1715616756020	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5488000000000004	1715616756020	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616758024	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616758024	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5474	1715616758024	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616759026	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616759026	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5474	1715616759026	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	2	1715616725958	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616725958	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5431	1715616725958	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	3	1715616726961	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.6	1715616726961	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5431	1715616726961	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616730969	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.699999999999999	1715616730969	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5505999999999998	1715616730969	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616731971	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616731971	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5505999999999998	1715616731971	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616752033	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616755031	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616756041	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616758039	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616759047	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616762033	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616762033	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5496	1715616762033	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616762057	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616763035	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.4	1715616763035	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5523000000000002	1715616763035	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616763058	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616764037	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616764037	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5523000000000002	1715616764037	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616764058	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616765039	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.699999999999999	1715616765039	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5523000000000002	1715616765039	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616765061	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616766041	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.6	1715616766041	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5511999999999997	1715616766041	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616766062	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616767043	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616767043	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5511999999999997	1715616767043	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616767057	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616768045	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616768045	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5511999999999997	1715616768045	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616768069	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616769047	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616769047	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5523000000000002	1715616769047	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616769071	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616770050	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.5	1715616770050	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5523000000000002	1715616770050	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616770071	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616771052	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.6	1715616771052	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5523000000000002	1715616771052	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616771072	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616772054	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.699999999999999	1715616772054	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5508	1715616772054	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616772069	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616773056	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.4	1715616773056	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5508	1715616773056	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616773078	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616779089	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616784100	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616788103	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616803119	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616803119	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5561	1715616803119	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616807128	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.6000000000000005	1715616807128	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.555	1715616807128	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616810134	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.1000000000000005	1715616810134	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5559000000000003	1715616810134	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616815144	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.299999999999999	1715616815144	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5572	1715616815144	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616774058	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.800000000000001	1715616774058	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5508	1715616774058	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616775060	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616775060	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5511999999999997	1715616775060	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616781072	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	10.3	1715616781072	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5509	1715616781072	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	100	1715616785080	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616785080	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5516	1715616785080	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616795100	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616795100	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.555	1715616795100	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616799109	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616799109	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5551999999999997	1715616799109	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616800113	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616800113	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5551999999999997	1715616800113	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616802130	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616808143	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616809154	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616812159	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616816169	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616821177	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616774072	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616775084	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616781085	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616785094	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616795113	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616799131	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616802117	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.9	1715616802117	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5561	1715616802117	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616808130	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616808130	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5559000000000003	1715616808130	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616809132	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616809132	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5559000000000003	1715616809132	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616812138	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616812138	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5557	1715616812138	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616816146	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616816146	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5572	1715616816146	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616821156	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616821156	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5579	1715616821156	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616776062	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7	1715616776062	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5511999999999997	1715616776062	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	108	1715616778066	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616778066	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5504000000000002	1715616778066	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616780070	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616780070	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5504000000000002	1715616780070	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616782074	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616782074	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5509	1715616782074	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616786083	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8	1715616786083	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5516	1715616786083	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616787085	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.4	1715616787085	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5525	1715616787085	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616789089	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616789089	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5525	1715616789089	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616790090	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8	1715616790090	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5532	1715616790090	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616791092	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616791092	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5532	1715616791092	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616794098	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.7	1715616794098	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.555	1715616794098	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616798107	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616798107	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5545999999999998	1715616798107	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616805148	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616811156	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616813154	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616814163	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616817170	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616818165	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616819172	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616820178	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616776121	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616778088	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616780091	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616782087	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616786105	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616787100	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616789102	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616790108	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616791113	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616794121	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616805123	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.1	1715616805123	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.555	1715616805123	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616811136	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.4	1715616811136	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5557	1715616811136	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616813140	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616813140	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5557	1715616813140	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616814142	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.4	1715616814142	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5572	1715616814142	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616817148	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.8	1715616817148	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5548	1715616817148	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616818150	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.4	1715616818150	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5548	1715616818150	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616819152	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616819152	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5548	1715616819152	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616820154	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616820154	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5579	1715616820154	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616777064	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.800000000000001	1715616777064	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5511999999999997	1715616777064	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616783076	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.4	1715616783076	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5509	1715616783076	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616792094	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616792094	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5532	1715616792094	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616793096	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616793096	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.555	1715616793096	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616796103	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616796103	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5545999999999998	1715616796103	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616797105	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	9.6	1715616797105	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5545999999999998	1715616797105	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616800134	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616801136	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616804137	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616806145	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616777080	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616783096	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616792114	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616793118	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616796118	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616797119	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	104	1715616801115	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.1000000000000005	1715616801115	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5551999999999997	1715616801115	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616804121	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.4	1715616804121	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5561	1715616804121	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616806125	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616806125	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.555	1715616806125	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	101	1715616779068	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	5.2	1715616779068	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5504000000000002	1715616779068	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	102	1715616784078	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	6.9	1715616784078	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5516	1715616784078	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - CPU Utilization	103	1715616788087	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Utilization	7.9	1715616788087	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Memory Usage GB	2.5525	1715616788087	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616798128	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616803140	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616807141	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616810158	8cb6db5144e3469999eeada0a53b74e4	0	f
TOP - Swap Memory GB	0.0653	1715616815158	8cb6db5144e3469999eeada0a53b74e4	0	f
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
letter	0	8cb6db5144e3469999eeada0a53b74e4
workload	0	8cb6db5144e3469999eeada0a53b74e4
listeners	smi+top+dcgmi	8cb6db5144e3469999eeada0a53b74e4
params	'"-"'	8cb6db5144e3469999eeada0a53b74e4
file	cifar10.py	8cb6db5144e3469999eeada0a53b74e4
workload_listener	''	8cb6db5144e3469999eeada0a53b74e4
model	cifar10.py	8cb6db5144e3469999eeada0a53b74e4
manual	False	8cb6db5144e3469999eeada0a53b74e4
max_epoch	5	8cb6db5144e3469999eeada0a53b74e4
max_time	172800	8cb6db5144e3469999eeada0a53b74e4
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
8cb6db5144e3469999eeada0a53b74e4	(0 0) peaceful-mole-750	UNKNOWN			daga	FINISHED	1715616495098	1715616947210		active	s3://mlflow-storage/0/8cb6db5144e3469999eeada0a53b74e4/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	8cb6db5144e3469999eeada0a53b74e4
mlflow.source.name	file:///home/daga/radt#examples/pytorch	8cb6db5144e3469999eeada0a53b74e4
mlflow.source.type	PROJECT	8cb6db5144e3469999eeada0a53b74e4
mlflow.project.entryPoint	main	8cb6db5144e3469999eeada0a53b74e4
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	8cb6db5144e3469999eeada0a53b74e4
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	8cb6db5144e3469999eeada0a53b74e4
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	8cb6db5144e3469999eeada0a53b74e4
mlflow.project.env	conda	8cb6db5144e3469999eeada0a53b74e4
mlflow.project.backend	local	8cb6db5144e3469999eeada0a53b74e4
mlflow.runName	(0 0) peaceful-mole-750	8cb6db5144e3469999eeada0a53b74e4
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

