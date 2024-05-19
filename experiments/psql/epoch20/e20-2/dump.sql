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
0	Default	s3://mlflow-storage/0	active	1716037251038	1716037251038
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
SMI - GPU Util	0	1716037446203	0	f	c35fda81caaf4bb8ae1acddfedafb171
SMI - Mem Used	0	1716037446203	0	f	c35fda81caaf4bb8ae1acddfedafb171
SMI - Mem Util	0	1716037446203	0	f	c35fda81caaf4bb8ae1acddfedafb171
SMI - Performance State	3	1716037446203	0	f	c35fda81caaf4bb8ae1acddfedafb171
SMI - Power Draw	14.39	1716037446203	0	f	c35fda81caaf4bb8ae1acddfedafb171
SMI - Timestamp	1716037446.202	1716037446203	0	f	c35fda81caaf4bb8ae1acddfedafb171
TOP - CPU Utilization	105	1716038289387	0	f	c35fda81caaf4bb8ae1acddfedafb171
TOP - Memory Usage GB	2.2807	1716038289387	0	f	c35fda81caaf4bb8ae1acddfedafb171
TOP - Memory Utilization	10.2	1716038289387	0	f	c35fda81caaf4bb8ae1acddfedafb171
TOP - Swap Memory GB	0.0156	1716038289409	0	f	c35fda81caaf4bb8ae1acddfedafb171
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.39	1716037445203	c35fda81caaf4bb8ae1acddfedafb171	0	f
SMI - Timestamp	1716037445.184	1716037445203	c35fda81caaf4bb8ae1acddfedafb171	0	f
SMI - GPU Util	0	1716037445203	c35fda81caaf4bb8ae1acddfedafb171	0	f
SMI - Mem Util	0	1716037445203	c35fda81caaf4bb8ae1acddfedafb171	0	f
SMI - Mem Used	0	1716037445203	c35fda81caaf4bb8ae1acddfedafb171	0	f
SMI - Performance State	3	1716037445203	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	0	1716037445231	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	0	1716037445231	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.5662	1716037445231	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037445249	c35fda81caaf4bb8ae1acddfedafb171	0	f
SMI - Power Draw	14.39	1716037446203	c35fda81caaf4bb8ae1acddfedafb171	0	f
SMI - Timestamp	1716037446.202	1716037446203	c35fda81caaf4bb8ae1acddfedafb171	0	f
SMI - GPU Util	0	1716037446203	c35fda81caaf4bb8ae1acddfedafb171	0	f
SMI - Mem Util	0	1716037446203	c35fda81caaf4bb8ae1acddfedafb171	0	f
SMI - Mem Used	0	1716037446203	c35fda81caaf4bb8ae1acddfedafb171	0	f
SMI - Performance State	3	1716037446203	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	173.39999999999998	1716037446234	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.3	1716037446234	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.5662	1716037446234	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037446256	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037447236	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	12.5	1716037447236	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.5662	1716037447236	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037447254	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037448238	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5	1716037448238	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8099	1716037448238	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037448254	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037449241	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5	1716037449241	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8099	1716037449241	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037449267	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037450244	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037450244	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8099	1716037450244	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037450266	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037451247	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037451247	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.7985	1716037451247	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037451279	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037452250	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037452250	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.7985	1716037452250	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037452272	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037453253	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037453253	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.7985	1716037453253	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037453280	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037454256	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5	1716037454256	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.7997	1716037454256	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037454291	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037455258	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037455258	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.7997	1716037455258	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037455280	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037456261	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037456261	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.7997	1716037456261	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037456286	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037457264	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037457264	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.801	1716037457264	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037457284	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037458265	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037458265	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.801	1716037458265	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037461273	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037461273	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8006	1716037461273	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037466287	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037466287	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.7999	1716037466287	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037470323	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037479322	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037479322	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8008	1716037479322	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716037481326	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037481326	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8013	1716037481326	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037487356	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037794122	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037794122	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2649	1716037794122	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037800135	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037800135	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2669	1716037800135	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037803143	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037803143	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2664	1716037803143	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037806151	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037806151	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2669	1716037806151	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037814173	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037814173	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2647	1716037814173	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037818184	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037818184	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2664	1716037818184	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037819186	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037819186	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2664	1716037819186	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037823197	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037823197	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2672	1716037823197	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037825202	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037825202	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2672	1716037825202	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037835255	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037840270	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037842253	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037842253	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2643	1716037842253	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037845260	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037845260	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2651	1716037845260	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037846265	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037846265	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2651	1716037846265	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037847286	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037848291	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037853300	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038074844	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038074844	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2743	1716038074844	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038075846	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038075846	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2752	1716038075846	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038077851	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037458282	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037461299	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037466307	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037472323	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037479339	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716037487340	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037487340	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8026	1716037487340	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037794145	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037800157	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037803164	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037806177	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037814193	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037818204	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037822194	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037822194	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.265	1716037822194	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037823221	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037830249	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037839269	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037841251	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037841251	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2643	1716037841251	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037842274	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037845283	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037846286	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037848270	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037848270	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2678000000000003	1716037848270	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037853283	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037853283	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2631	1716037853283	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038077851	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2752	1716038077851	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038082862	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038082862	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2731999999999997	1716038082862	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038088879	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.2	1716038088879	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2721	1716038088879	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038091887	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038091887	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2672	1716038091887	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038092889	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038092889	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2672	1716038092889	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038093910	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038094918	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038099905	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716038099905	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2697	1716038099905	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038100925	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038102912	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038102912	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2725	1716038102912	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038105920	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716038105920	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2725999999999997	1716038105920	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038108927	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038108927	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2723	1716038108927	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038109930	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.8	1716038109930	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2723	1716038109930	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037459268	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037459268	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.801	1716037459268	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037460271	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037460271	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8006	1716037460271	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037473306	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037473306	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8000999999999998	1716037473306	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716037476314	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037476314	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8011	1716037476314	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037477316	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037477316	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8011	1716037477316	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037478319	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037478319	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8008	1716037478319	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716037482329	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037482329	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8013	1716037482329	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	107	1716037483331	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037483331	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8013	1716037483331	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037488360	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0073	1716037491368	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	99	1716037493357	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037493357	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3085	1716037493357	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037795125	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037795125	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2649	1716037795125	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037802163	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037808182	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037810188	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037811193	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037815176	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037815176	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2647	1716037815176	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037816178	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.3	1716037816178	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2647	1716037816178	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037821210	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037828210	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037828210	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2656	1716037828210	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037837241	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.700000000000001	1716037837241	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2649	1716037837241	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037838243	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037838243	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2628000000000004	1716037838243	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037841271	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037849291	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038111935	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2721	1716038111935	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038113958	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038115944	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716038115944	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2727	1716038115944	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038116967	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038117971	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038119976	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038120978	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037459295	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037469295	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037469295	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.7997999999999998	1716037469295	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037473325	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037476340	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037477336	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037481343	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037482347	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037483350	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037491351	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5	1716037491351	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.1069	1716037491351	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0073	1716037492380	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0148	1716037493377	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037795146	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037808155	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037808155	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2613000000000003	1716037808155	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037810161	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037810161	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2613000000000003	1716037810161	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037811164	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037811164	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.263	1716037811164	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037813192	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037815197	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037821192	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037821192	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.265	1716037821192	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037824200	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037824200	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2672	1716037824200	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037831246	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037837261	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037838263	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037849272	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037849272	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2678000000000003	1716037849272	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038112958	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038121980	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038125992	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038127996	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038129003	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038140010	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.2	1716038140010	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2755	1716038140010	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038142040	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038145040	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038147028	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	12.8	1716038147028	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038147028	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038152066	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038164094	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038165090	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038167076	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.6	1716038167076	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2803	1716038167076	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038172108	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038182133	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038187127	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038187127	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2764	1716038187127	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038190163	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038192159	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037460292	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037462298	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037463305	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037464312	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037465311	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037467312	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037468320	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037474309	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037474309	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8000999999999998	1716037474309	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037475311	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037475311	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8011	1716037475311	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716037488343	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037488343	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8026	1716037488343	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037489368	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716037796127	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037796127	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2654	1716037796127	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037801160	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037809177	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037820189	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037820189	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.265	1716037820189	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037822214	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037826205	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037826205	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2656	1716037826205	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037827208	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037827208	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2656	1716037827208	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037829213	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037829213	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2645	1716037829213	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037831225	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037831225	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2645	1716037831225	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037833230	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8	1716037833230	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2649	1716037833230	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037839246	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037839246	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2628000000000004	1716037839246	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037843255	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037843255	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2643	1716037843255	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037844258	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037844258	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2651	1716037844258	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037850275	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037850275	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2679	1716037850275	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037851278	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037851278	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2679	1716037851278	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037852280	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037852280	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2679	1716037852280	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038113939	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038113939	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2721	1716038113939	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038118953	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038118953	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037462277	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037462277	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8006	1716037462277	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	107	1716037463279	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037463279	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8	1716037463279	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037464282	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.4	1716037464282	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8	1716037464282	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037465285	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037465285	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8	1716037465285	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037467291	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5	1716037467291	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.7999	1716037467291	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716037468293	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037468293	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.7999	1716037468293	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037469314	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037471301	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037471301	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.7997999999999998	1716037471301	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037472304	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037472304	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8000999999999998	1716037472304	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037474332	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037475339	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037478343	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037480341	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037484351	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037485361	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037486363	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037489347	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.2	1716037489347	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8026	1716037489347	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0073	1716037490366	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037492354	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037492354	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.1069	1716037492354	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037796146	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037797151	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037798151	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037799153	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037804146	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037804146	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2664	1716037804146	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037805148	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037805148	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2669	1716037805148	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037807153	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037807153	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2669	1716037807153	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037812168	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037812168	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.263	1716037812168	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037816198	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037817199	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037825222	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037830223	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037830223	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2645	1716037830223	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037833247	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037834269	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037836260	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037470298	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037470298	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.7997999999999998	1716037470298	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0068	1716037471330	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	108	1716037480324	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037480324	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8008	1716037480324	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	107	1716037484333	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037484333	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8014000000000001	1716037484333	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037485336	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037485336	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8014000000000001	1716037485336	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	107	1716037486338	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037486338	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	1.8014000000000001	1716037486338	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037490349	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037490349	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.1069	1716037490349	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037494360	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716037494360	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3085	1716037494360	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0148	1716037494380	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037495363	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037495363	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3085	1716037495363	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0148	1716037495383	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037496365	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037496365	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3152	1716037496365	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037496387	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716037497368	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037497368	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3152	1716037497368	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037497386	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037498372	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037498372	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3152	1716037498372	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037498394	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037499374	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037499374	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3204000000000002	1716037499374	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037499393	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037500376	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.999999999999999	1716037500376	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3204000000000002	1716037500376	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037500395	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037501378	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037501378	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3204000000000002	1716037501378	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037501394	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037502381	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.8	1716037502381	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3218	1716037502381	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037502402	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037503383	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037503383	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3218	1716037503383	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037503402	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037504386	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.4	1716037504386	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3218	1716037504386	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037504407	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037505389	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037505389	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3205999999999998	1716037505389	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037509418	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037513407	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037513407	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.322	1716037513407	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037514409	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037514409	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3209	1716037514409	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037517417	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037517417	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3224	1716037517417	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037518439	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037521445	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037522451	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037527443	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037527443	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.324	1716037527443	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037535483	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037536488	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037543511	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037549518	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037550530	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037797129	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037797129	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2654	1716037797129	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037798131	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037798131	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2654	1716037798131	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037799134	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037799134	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2669	1716037799134	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037802140	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037802140	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2664	1716037802140	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037804173	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037805172	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037807184	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037812194	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037817181	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037817181	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2664	1716037817181	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037819210	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037828229	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037832247	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037834233	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037834233	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2649	1716037834233	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716037836238	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037836238	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2649	1716037836238	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037847267	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037847267	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2678000000000003	1716037847267	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038114959	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	100	1716038116945	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038116945	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2727	1716038116945	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038117950	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716038117950	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2727	1716038117950	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038119955	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038119955	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2727	1716038119955	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037505408	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037506411	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037508418	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037511402	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037511402	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.322	1716037511402	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037519422	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037519422	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3224	1716037519422	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037520425	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037520425	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3226999999999998	1716037520425	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037523450	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037531456	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037531456	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2386	1716037531456	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037532459	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037532459	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2514000000000003	1716037532459	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037538473	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037538473	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2546	1716037538473	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037540498	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037544513	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037546493	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037546493	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.255	1716037546493	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037801138	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037801138	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2669	1716037801138	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037809158	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037809158	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2613000000000003	1716037809158	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037813171	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037813171	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.263	1716037813171	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037820212	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037824224	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037826224	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037827228	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037829233	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	107	1716037832228	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.2	1716037832228	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2649	1716037832228	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037835236	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.8999999999999995	1716037835236	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2649	1716037835236	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037840249	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037840249	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2628000000000004	1716037840249	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037843274	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037844275	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037850295	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037851301	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037852300	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2727	1716038118953	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038122964	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038122964	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2734	1716038122964	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038123966	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038123966	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2719	1716038123966	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038124969	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716038124969	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037506391	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037506391	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3205999999999998	1716037506391	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037508395	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037508395	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3208	1716037508395	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037510420	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037511420	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037519444	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037520447	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037526455	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037531477	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037537490	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037540478	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.899999999999999	1716037540478	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2546	1716037540478	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037541501	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037545510	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037546522	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037854285	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037854285	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2631	1716037854285	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037856307	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037863310	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037863310	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2651999999999997	1716037863310	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037868322	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037868322	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2675	1716037868322	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037870327	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037870327	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2675	1716037870327	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037871330	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037871330	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2691999999999997	1716037871330	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037877365	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037879349	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1	1716037879349	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2664	1716037879349	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037882357	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037882357	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2665	1716037882357	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037884362	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.4	1716037884362	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2662	1716037884362	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037885364	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037885364	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2662	1716037885364	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037891405	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037893402	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037895410	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037896411	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037897412	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037898419	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037910428	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716037910428	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2681999999999998	1716037910428	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038120960	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038120960	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2734	1716038120960	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038126974	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038126974	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.271	1716038126974	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038130001	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037507393	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.4	1716037507393	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3205999999999998	1716037507393	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037512404	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.8	1716037512404	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.322	1716037512404	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037517438	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037525455	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037528465	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037529470	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037530480	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037533462	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5	1716037533462	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2514000000000003	1716037533462	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037534464	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	12.4	1716037534464	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2514000000000003	1716037534464	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037535465	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037535465	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2544	1716037535465	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037539476	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037539476	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2546	1716037539476	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037541481	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037541481	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2539000000000002	1716037541481	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037544488	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037544488	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.255	1716037544488	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037548498	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5	1716037548498	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2555	1716037548498	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037551505	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037551505	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2569	1716037551505	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037552525	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037854303	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037861304	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037861304	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2653000000000003	1716037861304	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037865336	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037869345	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037872332	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1	1716037872332	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2691999999999997	1716037872332	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037873354	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037874355	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037880370	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037883359	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037883359	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2662	1716037883359	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037887368	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037887368	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2678000000000003	1716037887368	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037888370	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.800000000000001	1716037888370	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2678000000000003	1716037888370	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037890394	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037894412	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037899418	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037901430	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037904412	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037904412	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2685	1716037904412	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037507414	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037512425	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037525437	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.8	1716037525437	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3224	1716037525437	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037528445	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037528445	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.324	1716037528445	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037529451	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037529451	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2386	1716037529451	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037530454	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037530454	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2386	1716037530454	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037532480	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037533481	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037534484	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037538493	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037539496	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037542484	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037542484	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2539000000000002	1716037542484	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037545490	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037545490	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.255	1716037545490	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037548522	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037552507	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037552507	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2569	1716037552507	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037855287	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.700000000000001	1716037855287	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2631	1716037855287	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037858294	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037858294	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2651999999999997	1716037858294	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037859320	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037867319	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037867319	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2666	1716037867319	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037876342	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037876342	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2668000000000004	1716037876342	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037886366	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716037886366	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2678000000000003	1716037886366	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037903410	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037903410	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.267	1716037903410	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037906447	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037911430	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037911430	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2681999999999998	1716037911430	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037912434	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716037912434	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2681999999999998	1716037912434	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037913462	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2719	1716038124969	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038133994	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038133994	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2741	1716038133994	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038141047	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038144020	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.1	1716038144020	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2767	1716038144020	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037509397	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037509397	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3208	1716037509397	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037510400	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037510400	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3208	1716037510400	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037513425	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037514430	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037518419	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037518419	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3224	1716037518419	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037521428	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037521428	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3226999999999998	1716037521428	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037522430	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5	1716037522430	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3226999999999998	1716037522430	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037523433	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037523433	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3224	1716037523433	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037527460	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037536467	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037536467	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2544	1716037536467	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037543485	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037543485	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2539000000000002	1716037543485	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037549500	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037549500	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2555	1716037549500	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037550502	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037550502	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2569	1716037550502	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037551550	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037855310	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037858315	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037861323	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037867348	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037876362	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037886396	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	109.9	1716037906419	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037906419	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2685	1716037906419	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037907421	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037907421	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.267	1716037907421	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037911449	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037913436	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.2	1716037913436	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2658	1716037913436	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038126992	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038130986	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038130986	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2721	1716038130986	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038135997	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716038135997	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2751	1716038135997	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038137000	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038137000	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2751	1716038137000	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038138005	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038138005	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2751	1716038138005	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038139008	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037515412	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037515412	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3209	1716037515412	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037516414	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037516414	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3209	1716037516414	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037524435	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037524435	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.3224	1716037524435	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037526440	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037526440	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.324	1716037526440	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037542507	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037547522	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037856289	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037856289	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2651999999999997	1716037856289	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037862324	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037863328	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037868351	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037870345	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037877345	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037877345	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2664	1716037877345	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037878347	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.800000000000001	1716037878347	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2664	1716037878347	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037879373	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037883378	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037884387	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037891380	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037891380	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2666	1716037891380	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037893384	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716037893384	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2655	1716037893384	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037895390	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1	1716037895390	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2676	1716037895390	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037896392	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037896392	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2676	1716037896392	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037897394	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716037897394	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2676	1716037897394	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037898397	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716037898397	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2681999999999998	1716037898397	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037908424	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.800000000000001	1716037908424	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.267	1716037908424	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038129981	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2721	1716038129981	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038140029	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038143017	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038143017	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2769	1716038143017	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038146052	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038147053	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038165070	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038165070	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2803	1716038165070	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038166095	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038169102	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037515433	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037516436	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037524457	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037537470	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037537470	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2544	1716037537470	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037547496	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037547496	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2555	1716037547496	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716037553510	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037553510	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2565	1716037553510	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037553529	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037554512	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037554512	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2565	1716037554512	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037554537	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037555515	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037555515	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2565	1716037555515	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037555544	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037556518	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037556518	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2549	1716037556518	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037556546	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037557522	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037557522	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2549	1716037557522	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037557545	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037558525	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037558525	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2549	1716037558525	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037558545	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037559527	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.8999999999999995	1716037559527	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2558000000000002	1716037559527	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037559553	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037560530	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037560530	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2558000000000002	1716037560530	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037560546	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037561532	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037561532	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2558000000000002	1716037561532	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037561558	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037562534	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.8999999999999995	1716037562534	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2582	1716037562534	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037562562	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037563536	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037563536	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2582	1716037563536	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037563554	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037564538	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037564538	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2582	1716037564538	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037564562	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037565540	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037565540	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2592	1716037565540	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037565568	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037566542	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037566542	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2592	1716037566542	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037566569	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037568569	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037572560	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.4	1716037572560	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2575	1716037572560	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037573561	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5	1716037573561	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2575	1716037573561	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037574564	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037574564	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2588000000000004	1716037574564	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037576569	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.4	1716037576569	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2588000000000004	1716037576569	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037579576	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.2	1716037579576	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2586	1716037579576	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716037580579	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037580579	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2583	1716037580579	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037583615	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037585621	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037588601	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037588601	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2599	1716037588601	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037590632	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037595618	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037595618	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2607	1716037595618	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037602635	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8	1716037602635	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2618	1716037602635	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037604662	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037609654	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.2	1716037609654	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2555	1716037609654	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037610656	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.1	1716037610656	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2584	1716037610656	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037611658	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037611658	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2584	1716037611658	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037857292	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037857292	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2651999999999997	1716037857292	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037860301	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037860301	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2653000000000003	1716037860301	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037862307	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037862307	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2651999999999997	1716037862307	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037864331	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037866340	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037875339	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	11.2	1716037875339	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2668000000000004	1716037875339	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037878365	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037882378	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037889400	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037892382	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.8	1716037892382	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2655	1716037892382	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037900402	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716037900402	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037567545	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.4	1716037567545	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2592	1716037567545	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037571556	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037571556	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2575	1716037571556	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037574592	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037581582	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037581582	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2583	1716037581582	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037582585	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037582585	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2583	1716037582585	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037583589	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037583589	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2603	1716037583589	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037584619	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037593614	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037593614	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2618	1716037593614	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037600631	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037600631	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2611999999999997	1716037600631	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037601633	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037601633	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2618	1716037601633	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037603638	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037603638	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2618	1716037603638	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037857310	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037860321	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037864312	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037864312	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2651999999999997	1716037864312	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037866317	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037866317	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2666	1716037866317	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037873334	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037873334	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2691999999999997	1716037873334	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037875359	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037881376	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037889374	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037889374	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2666	1716037889374	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037890377	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8	1716037890377	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2666	1716037890377	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037892409	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037900432	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037902427	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037905433	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037909426	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037909426	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.267	1716037909426	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037910445	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038131005	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038136017	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038137023	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038138031	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038139039	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038146025	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038146025	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2767	1716038146025	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037567564	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037593643	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037596645	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037597643	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037599628	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037599628	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2611999999999997	1716037599628	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037605672	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037606669	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037859297	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037859297	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2653000000000003	1716037859297	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037865315	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037865315	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2666	1716037865315	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037869325	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.800000000000001	1716037869325	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2675	1716037869325	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037871353	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037872355	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037874337	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037874337	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2668000000000004	1716037874337	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037880351	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.4	1716037880351	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2665	1716037880351	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037881354	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1	1716037881354	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2665	1716037881354	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037885383	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037887389	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037888387	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037894387	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037894387	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2655	1716037894387	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037899399	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1	1716037899399	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2681999999999998	1716037899399	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037901405	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037901405	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.267	1716037901405	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037903438	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037904431	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037912455	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038132991	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2741	1716038132991	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038134015	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038135017	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038148052	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038149059	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.2	1716038168079	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2765999999999997	1716038168079	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	108	1716038169081	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	15.7	1716038169081	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2765999999999997	1716038169081	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038171085	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038171085	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2743	1716038171085	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038175115	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038176116	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038194145	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.3	1716038194145	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2793	1716038194145	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038197152	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037568547	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037568547	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2534	1716037568547	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037570554	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037570554	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2534	1716037570554	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037572587	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037573585	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037575566	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037575566	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2588000000000004	1716037575566	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037576595	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037579603	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037580608	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037585594	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.4	1716037585594	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2603	1716037585594	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037587618	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037588622	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037592631	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037595649	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037602653	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037608651	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037608651	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2555	1716037608651	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037609681	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037610676	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037611685	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2681999999999998	1716037900402	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037902407	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037902407	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.267	1716037902407	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037905416	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716037905416	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2685	1716037905416	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037908441	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037909443	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038139008	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2755	1716038139008	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038143035	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038150034	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.300000000000001	1716038150034	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2786	1716038150034	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038180108	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.277	1716038180108	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716038184118	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.2	1716038184118	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2776	1716038184118	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038185121	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038185121	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2776	1716038185121	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038187148	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038188151	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038195147	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038195147	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2811	1716038195147	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038196149	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2811	1716038196149	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038198174	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038199178	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038200159	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038200159	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.279	1716038200159	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038202164	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	100	1716037569552	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.8999999999999995	1716037569552	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2534	1716037569552	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037577571	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.4	1716037577571	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2586	1716037577571	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037578594	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037586618	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037589603	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037589603	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2609	1716037589603	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037590605	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037590605	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2609	1716037590605	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037591634	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037594636	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037603658	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037607666	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037612661	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037612661	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2584	1716037612661	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037907441	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038141012	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2755	1716038141012	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038142015	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.3	1716038142015	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2769	1716038142015	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038144050	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038150053	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038151065	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038153069	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038181110	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038181110	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.277	1716038181110	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038186145	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038190135	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038190135	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038190135	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038192140	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.6	1716038192140	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2793	1716038192140	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038195166	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.1	1716038197152	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2811	1716038197152	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038201162	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.4	1716038201162	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2789	1716038201162	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038201180	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038202164	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2789	1716038202164	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038202184	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038204191	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038205173	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038205173	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2789	1716038205173	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038205203	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038206196	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038207195	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038208197	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038209200	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038210204	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038211187	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.000000000000001	1716038211187	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2765	1716038211187	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037569579	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037578574	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037578574	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2586	1716037578574	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037586595	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.6	1716037586595	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2599	1716037586595	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037587598	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037587598	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2599	1716037587598	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037589622	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037591608	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037591608	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2609	1716037591608	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037594616	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.4	1716037594616	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2618	1716037594616	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037598645	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037604641	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037604641	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2611999999999997	1716037604641	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037608669	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037612681	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037914439	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037914439	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2658	1716037914439	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037922457	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037922457	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2685	1716037922457	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037925491	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037929500	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037932480	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037932480	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2666999999999997	1716037932480	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037934485	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.2	1716037934485	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706	1716037934485	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037937493	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037937493	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2696	1716037937493	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037938496	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037938496	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2696	1716037938496	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037939498	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.2	1716037939498	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2696	1716037939498	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037940500	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.800000000000001	1716037940500	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2698	1716037940500	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037941529	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037947544	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037950528	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.700000000000001	1716037950528	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2718000000000003	1716037950528	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037951531	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.3	1716037951531	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2718000000000003	1716037951531	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037952534	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.800000000000001	1716037952534	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2716	1716037952534	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037962577	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037964586	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037965592	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037970581	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037570584	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037571582	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037575595	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037581609	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037582611	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037584591	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5	1716037584591	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2603	1716037584591	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037592610	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037592610	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2618	1716037592610	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037599657	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037600657	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037601660	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037914467	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037925465	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037925465	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2678000000000003	1716037925465	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037929473	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716037929473	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2687	1716037929473	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037931477	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.2	1716037931477	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2666999999999997	1716037931477	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037932500	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037934512	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037937513	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037938522	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037939520	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037940527	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037947520	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037947520	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2715	1716037947520	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037948552	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037950549	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037951552	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037952554	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037963562	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716037963562	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706	1716037963562	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037965569	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716037965569	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2728	1716037965569	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037969599	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037970598	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037986620	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.8	1716037986620	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2731	1716037986620	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037988649	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037991653	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037993662	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037999653	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037999653	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.269	1716037999653	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038001679	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038006689	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038009701	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038018701	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038018701	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2711	1716038018701	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038025720	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038025720	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2733000000000003	1716038025720	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038145022	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	13	1716038145022	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037577599	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037596620	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037596620	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2607	1716037596620	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037597623	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037597623	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2607	1716037597623	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037598625	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037598625	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2611999999999997	1716037598625	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037605643	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	12.5	1716037605643	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2611999999999997	1716037605643	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037606645	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037606645	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2611999999999997	1716037606645	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037607648	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037607648	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2555	1716037607648	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037613663	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037613663	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2598000000000003	1716037613663	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037613681	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037614665	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037614665	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2598000000000003	1716037614665	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037614694	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037615667	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037615667	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2598000000000003	1716037615667	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037615696	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037616669	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.4	1716037616669	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2615	1716037616669	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037616699	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037617672	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5	1716037617672	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2615	1716037617672	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037617690	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037618674	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037618674	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2615	1716037618674	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037618697	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037619677	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037619677	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2604	1716037619677	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037619706	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037620679	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037620679	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2604	1716037620679	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037620708	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037621681	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037621681	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2604	1716037621681	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037621708	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037622685	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037622685	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.261	1716037622685	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037622705	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037623688	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037623688	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.261	1716037623688	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037623714	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037624690	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037624690	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.261	1716037624690	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037633737	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037636718	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037636718	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2611999999999997	1716037636718	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037637740	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037643736	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037643736	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2613000000000003	1716037643736	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037644738	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037644738	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2613000000000003	1716037644738	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037647747	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037647747	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2589	1716037647747	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037650756	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037650756	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2593	1716037650756	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037653764	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037653764	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2608	1716037653764	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037655794	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037656797	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037659807	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037664793	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.899999999999999	1716037664793	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2594000000000003	1716037664793	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037665796	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037665796	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2594000000000003	1716037665796	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037666799	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037666799	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2594000000000003	1716037666799	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037667802	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037667802	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2599	1716037667802	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037915441	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.800000000000001	1716037915441	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2658	1716037915441	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037918448	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1	1716037918448	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2681999999999998	1716037918448	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037920453	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037920453	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2681999999999998	1716037920453	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037923478	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037930500	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037936519	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037944535	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037946545	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037954538	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.2	1716037954538	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2716	1716037954538	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037955564	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037956568	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037967573	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.2	1716037967573	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706999999999997	1716037967573	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037971604	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037972606	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037974607	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037976595	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037976595	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037624720	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037625721	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037629734	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037630736	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037638744	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037641756	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037645769	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037649780	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037654767	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037654767	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2608	1716037654767	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037657775	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037657775	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2598000000000003	1716037657775	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037661785	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037661785	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2608	1716037661785	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037662805	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037663811	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037669808	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037669808	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2599	1716037669808	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037915469	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037916467	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037918468	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037920476	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037924481	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037941502	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.800000000000001	1716037941502	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2698	1716037941502	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037953556	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037963585	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037992657	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037998669	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038003663	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038003663	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.27	1716038003663	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038004666	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	11	1716038004666	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.27	1716038004666	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038005668	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038005668	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.27	1716038005668	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038010712	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038011704	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038015721	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038016714	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038032740	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038032740	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2725999999999997	1716038032740	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2767	1716038145022	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038151037	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.000000000000001	1716038151037	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2786	1716038151037	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038153041	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038153041	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2796999999999996	1716038153041	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038182113	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038182113	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.277	1716038182113	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038183130	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038189152	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038191158	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038193161	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038196149	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037625693	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037625693	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2607	1716037625693	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037628721	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037630705	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037630705	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2620999999999998	1716037630705	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037631732	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037641731	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037641731	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2619000000000002	1716037641731	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037645740	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037645740	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2613000000000003	1716037645740	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037648777	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037653803	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037654794	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037658777	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037658777	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2605999999999997	1716037658777	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037661813	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037663791	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037663791	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2608	1716037663791	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037668806	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037668806	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2599	1716037668806	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037669834	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037916443	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.800000000000001	1716037916443	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2681999999999998	1716037916443	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037917475	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037919476	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037923460	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037923460	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2685	1716037923460	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037927470	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.2	1716037927470	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2678000000000003	1716037927470	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037949546	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037954557	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037977617	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037996667	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038002680	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038003683	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038004685	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038007693	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038011684	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038011684	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2638000000000003	1716038011684	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038015694	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038015694	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.268	1716038015694	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038016697	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038016697	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.268	1716038016697	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038025739	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038032759	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038154043	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	11.200000000000001	1716038154043	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2796999999999996	1716038154043	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038155046	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038155046	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2796999999999996	1716038155046	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037626695	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037626695	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2607	1716037626695	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037627698	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037627698	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2607	1716037627698	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037628701	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037628701	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2620999999999998	1716037628701	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037631707	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037631707	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2609	1716037631707	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037632728	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037635745	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037642755	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037646773	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037648750	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037648750	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2589	1716037648750	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037651788	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037658795	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037670811	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037670811	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2626	1716037670811	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037917445	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	11	1716037917445	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2681999999999998	1716037917445	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037919450	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037919450	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2681999999999998	1716037919450	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037922486	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037930475	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037930475	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2687	1716037930475	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037936490	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.800000000000001	1716037936490	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706	1716037936490	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037944510	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037944510	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2704	1716037944510	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037945512	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037945512	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2704	1716037945512	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037949525	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.800000000000001	1716037949525	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2718000000000003	1716037949525	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037955541	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.1	1716037955541	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.27	1716037955541	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037956544	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716037956544	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.27	1716037956544	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037964566	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.100000000000001	1716037964566	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2728	1716037964566	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037968575	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716037968575	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706999999999997	1716037968575	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037972585	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037972585	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2672	1716037972585	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037974590	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037974590	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706999999999997	1716037974590	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037626723	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037627718	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037629703	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037629703	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2620999999999998	1716037629703	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037632709	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037632709	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2609	1716037632709	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037635716	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037635716	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2611999999999997	1716037635716	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037642733	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037642733	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2619000000000002	1716037642733	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037646744	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037646744	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2589	1716037646744	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037647769	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037651759	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037651759	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2593	1716037651759	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037652762	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037652762	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2608	1716037652762	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037668830	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037670835	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037921455	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.3	1716037921455	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2681999999999998	1716037921455	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037924462	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8	1716037924462	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2685	1716037924462	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037926495	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037928472	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.700000000000001	1716037928472	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2687	1716037928472	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037931496	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037933503	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037935514	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037942531	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037943527	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037946517	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037946517	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2715	1716037946517	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037953536	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.800000000000001	1716037953536	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2716	1716037953536	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037957566	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037958568	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037959570	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037960573	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037961575	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037966571	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037966571	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2728	1716037966571	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037967592	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037969578	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.2	1716037969578	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706999999999997	1716037969578	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037973609	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037978599	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037978599	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2691	1716037978599	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037980605	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037633712	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037633712	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2609	1716037633712	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037634714	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037634714	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2611999999999997	1716037634714	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037634743	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037636743	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037637721	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037637721	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2598000000000003	1716037637721	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037638724	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037638724	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2598000000000003	1716037638724	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037639725	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037639725	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2598000000000003	1716037639725	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037639746	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037640728	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037640728	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2619000000000002	1716037640728	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037640755	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037643766	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037644766	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037649753	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037649753	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2593	1716037649753	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037650773	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037652789	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037655769	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037655769	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2598000000000003	1716037655769	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037656772	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037656772	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2598000000000003	1716037656772	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037657796	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037659780	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.3	1716037659780	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2605999999999997	1716037659780	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037660783	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.1	1716037660783	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2605999999999997	1716037660783	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037660807	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037662787	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037662787	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2608	1716037662787	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037664820	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037665821	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037666823	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037667822	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037671813	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037671813	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2626	1716037671813	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037671839	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037672815	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037672815	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2626	1716037672815	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037672834	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037673817	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037673817	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.261	1716037673817	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037673842	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037674819	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037674819	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.261	1716037674819	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037674845	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037675821	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037675821	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.261	1716037675821	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037675847	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037676826	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037676826	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.262	1716037676826	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037676855	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037677829	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037677829	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.262	1716037677829	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037677848	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037678831	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037678831	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.262	1716037678831	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037678853	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037680837	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037680837	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2631	1716037680837	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037680866	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037683873	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037686852	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037686852	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2632	1716037686852	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037686881	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037687873	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037688881	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037689888	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037694870	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037694870	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2591	1716037694870	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037694895	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037698880	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037698880	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2586	1716037698880	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037698904	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037700885	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037700885	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2591	1716037700885	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037705899	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037705899	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2589	1716037705899	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037705924	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037706901	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037706901	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2603	1716037706901	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037706927	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037707903	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037707903	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2603	1716037707903	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037707921	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037708928	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037709908	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037709908	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2601999999999998	1716037709908	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037709935	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037711913	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037711913	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2601999999999998	1716037711913	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037711937	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037712915	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037712915	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037679835	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037679835	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2631	1716037679835	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037682842	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037682842	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2634000000000003	1716037682842	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037683845	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037683845	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2634000000000003	1716037683845	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037688857	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037688857	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2579000000000002	1716037688857	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037690887	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037693893	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037695899	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037696904	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037697895	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037699909	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037701887	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037701887	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2591	1716037701887	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037702889	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037702889	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2591	1716037702889	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037703892	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037703892	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2589	1716037703892	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037704924	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037710910	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037710910	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2601999999999998	1716037710910	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037714920	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037714920	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2607	1716037714920	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037715923	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037715923	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.264	1716037715923	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037722961	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037723963	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037725973	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037729987	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037730988	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037732967	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037732967	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2596999999999996	1716037732967	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037921482	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037926467	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716037926467	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2678000000000003	1716037926467	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037927496	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037928501	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037933483	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.700000000000001	1716037933483	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2666999999999997	1716037933483	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037935488	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037935488	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706	1716037935488	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037942505	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.2	1716037942505	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2698	1716037942505	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037943507	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037943507	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2704	1716037943507	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037945540	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037679866	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037681840	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037681840	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2631	1716037681840	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037681861	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037682862	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037684848	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037684848	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2634000000000003	1716037684848	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037684879	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037685850	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037685850	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2632	1716037685850	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037685873	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037687855	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037687855	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2632	1716037687855	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037689859	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037689859	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2579000000000002	1716037689859	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037690861	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037690861	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2579000000000002	1716037690861	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037691863	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.1	1716037691863	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2594000000000003	1716037691863	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037691888	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037692866	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037692866	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2594000000000003	1716037692866	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037692884	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037693868	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037693868	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2594000000000003	1716037693868	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037695873	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037695873	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2591	1716037695873	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037696875	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037696875	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2591	1716037696875	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037697878	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037697878	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2586	1716037697878	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037699883	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037699883	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2586	1716037699883	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037700903	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037701911	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037702906	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037703919	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037704895	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037704895	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2589	1716037704895	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037708905	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8	1716037708905	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2603	1716037708905	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037710935	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037713918	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037713918	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2607	1716037713918	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037714949	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037719934	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037719934	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2631	1716037719934	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2607	1716037712915	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037716925	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037716925	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.264	1716037716925	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037717928	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037717928	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.264	1716037717928	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037948523	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037948523	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2715	1716037948523	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037957546	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.2	1716037957546	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.27	1716037957546	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037958548	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037958548	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2702	1716037958548	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037959551	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716037959551	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2702	1716037959551	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037960554	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716037960554	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2702	1716037960554	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037961555	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037961555	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706	1716037961555	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037962559	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716037962559	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706	1716037962559	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037966588	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037968594	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037973588	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037973588	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706999999999997	1716037973588	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037975592	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716037975592	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706999999999997	1716037975592	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037978626	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037980624	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037982629	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037983631	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037984635	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037985637	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037989653	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037990648	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038000655	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038000655	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2714000000000003	1716038000655	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038012708	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038013711	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038017719	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038019724	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038020726	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038021731	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038022733	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038023738	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038024744	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038031762	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038154071	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038157051	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.3	1716038157051	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2796999999999996	1716038157051	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038158070	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038160076	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038180108	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037712935	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037716944	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037717947	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716037970581	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2672	1716037970581	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716037971583	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	13.2	1716037971583	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2672	1716037971583	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037988626	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8	1716037988626	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.272	1716037988626	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037991633	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037991633	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2687	1716037991633	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037993638	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037993638	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2687	1716037993638	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037995665	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	111	1716038001658	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8	1716038001658	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2714000000000003	1716038001658	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038006671	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038006671	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2708000000000004	1716038006671	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038009679	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.1	1716038009679	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2638000000000003	1716038009679	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	100	1716038010682	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716038010682	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2638000000000003	1716038010682	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038018720	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038155064	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038156073	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038161061	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.300000000000001	1716038161061	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2803	1716038161061	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038162064	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038162064	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2786999999999997	1716038162064	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038163066	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038163066	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2786999999999997	1716038163066	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038166073	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.6	1716038166073	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2803	1716038166073	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038172088	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.2	1716038172088	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2743	1716038172088	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038173111	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038174117	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038177100	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716038177100	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2779000000000003	1716038177100	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038178102	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.3	1716038178102	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2779000000000003	1716038178102	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038179105	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038179105	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2779000000000003	1716038179105	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038181139	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038183115	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.5	1716038183115	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2776	1716038183115	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038189133	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037713940	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037718930	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037718930	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2631	1716037718930	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037719958	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037721958	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037728975	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037975613	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037976612	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037979602	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716037979602	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2727	1716037979602	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037981608	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037981608	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2727	1716037981608	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037986638	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037987643	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037994641	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.3	1716037994641	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2699000000000003	1716037994641	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037996646	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037996646	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2699000000000003	1716037996646	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037997665	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037999759	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038002661	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	12.600000000000001	1716038002661	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2714000000000003	1716038002661	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038008675	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038008675	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2708000000000004	1716038008675	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038012687	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716038012687	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2664	1716038012687	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038014711	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038026740	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038027746	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038028751	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038029756	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038030755	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038156048	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038156048	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2796999999999996	1716038156048	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038158053	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038158053	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2796999999999996	1716038158053	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038161080	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038162089	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038164068	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038164068	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2786999999999997	1716038164068	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038170102	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038173090	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.000000000000001	1716038173090	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2743	1716038173090	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038174093	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.2	1716038174093	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2771999999999997	1716038174093	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038175095	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038175095	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2771999999999997	1716038175095	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038177122	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038178120	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038179125	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037715943	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037719017	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037721938	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037721938	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2629	1716037721938	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037728956	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037728956	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.259	1716037728956	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2691	1716037976595	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037977597	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716037977597	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2691	1716037977597	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037979624	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037981625	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037987622	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716037987622	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2731	1716037987622	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037992635	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716037992635	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2687	1716037992635	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037994662	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037997649	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.8	1716037997649	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.269	1716037997649	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037998651	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.3	1716037998651	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.269	1716037998651	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038000673	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038005692	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038008693	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038014692	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716038014692	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2664	1716038014692	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	111	1716038026723	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038026723	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2733000000000003	1716038026723	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038027725	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.2	1716038027725	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2725999999999997	1716038027725	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038028729	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038028729	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2725999999999997	1716038028729	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038029732	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038029732	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2725999999999997	1716038029732	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038030735	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716038030735	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2725999999999997	1716038030735	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038157077	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038160058	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038160058	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2803	1716038160058	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038163082	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038180128	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038184137	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038185144	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	107	1716038188130	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	12.8	1716038188130	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2764	1716038188130	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.4	1716038189133	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038189133	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038191138	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038191138	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038191138	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	108.9	1716037720936	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037720936	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2631	1716037720936	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037724974	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037726951	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037726951	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2618	1716037726951	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037727953	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.8999999999999995	1716037727953	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.259	1716037727953	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037731965	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037731965	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2596999999999996	1716037731965	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037980605	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2727	1716037980605	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037982610	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716037982610	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706999999999997	1716037982610	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037983613	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037983613	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706999999999997	1716037983613	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037984615	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716037984615	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2706999999999997	1716037984615	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037985617	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037985617	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2731	1716037985617	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037989629	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037989629	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.272	1716037989629	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037990631	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037990631	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.272	1716037990631	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037995644	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037995644	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2699000000000003	1716037995644	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038007673	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038007673	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2708000000000004	1716038007673	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038013689	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038013689	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2664	1716038013689	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038017699	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038017699	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.268	1716038017699	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038019707	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038019707	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2711	1716038019707	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038020709	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038020709	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2711	1716038020709	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038021711	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038021711	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2723	1716038021711	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038022713	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038022713	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2723	1716038022713	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038023716	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038023716	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2723	1716038023716	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038024718	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038024718	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2733000000000003	1716038024718	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038031738	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037720959	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037725948	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037725948	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2618	1716037725948	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037726970	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037727971	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038031738	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2725999999999997	1716038031738	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038159055	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038159055	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2803	1716038159055	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038167112	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038168106	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038170083	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.000000000000001	1716038170083	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2765999999999997	1716038170083	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038171104	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038176098	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038176098	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2771999999999997	1716038176098	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038186124	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038186124	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2764	1716038186124	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038193143	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038193143	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2793	1716038193143	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038194166	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038196168	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038197171	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038198155	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038198155	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.279	1716038198155	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038199157	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.000000000000001	1716038199157	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.279	1716038199157	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038200177	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038203167	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038203167	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2789	1716038203167	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038203187	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038204169	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.6	1716038204169	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2789	1716038204169	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038206175	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.1	1716038206175	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2789	1716038206175	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038207177	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.2	1716038207177	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2753	1716038207177	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038208180	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038208180	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2753	1716038208180	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038209182	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038209182	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2753	1716038209182	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038210185	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.300000000000001	1716038210185	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2765	1716038210185	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038211213	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038212190	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038212190	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2765	1716038212190	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038212215	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038213192	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037722941	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037722941	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2629	1716037722941	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037723943	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037723943	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2629	1716037723943	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037724946	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037724946	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2618	1716037724946	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037729959	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037729959	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.259	1716037729959	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037730962	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037730962	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2596999999999996	1716037730962	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037731984	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037732987	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037733970	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.8999999999999995	1716037733970	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.263	1716037733970	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037733999	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037734973	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037734973	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.263	1716037734973	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037734993	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037735976	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037735976	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.263	1716037735976	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037736004	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037736978	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037736978	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2636999999999996	1716037736978	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037737005	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037737980	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037737980	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2636999999999996	1716037737980	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037737999	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037738983	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037738983	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2636999999999996	1716037738983	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037739011	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037739986	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037739986	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2636	1716037739986	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037740011	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037740988	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8	1716037740988	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2636	1716037740988	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037741017	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037741991	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037741991	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2636	1716037741991	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037742023	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037742993	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.700000000000001	1716037742993	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2626999999999997	1716037742993	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037743014	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037743996	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037743996	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2626999999999997	1716037743996	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037744017	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037744998	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037744998	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2626999999999997	1716037744998	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037745023	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037746028	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037748033	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037751038	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037754019	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037754019	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2632	1716037754019	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037758029	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037758029	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.263	1716037758029	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037760036	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037760036	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2628000000000004	1716037760036	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037762078	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037763068	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037765075	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037768055	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037768055	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2636	1716037768055	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037769057	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037769057	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2603	1716037769057	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037770080	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037773068	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037773068	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2601	1716037773068	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037774070	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037774070	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2601	1716037774070	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037781090	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037781090	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2636	1716037781090	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037784116	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038033742	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038033742	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2731	1716038033742	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038037751	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716038037751	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2724	1716038037751	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038046789	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038051785	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038051785	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2713	1716038051785	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038053811	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038057801	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038057801	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2738	1716038057801	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038060809	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038060809	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2741	1716038060809	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038063834	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038065842	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038069831	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.8	1716038069831	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2742	1716038069831	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038072857	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038076869	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038078874	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038082882	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038090885	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716038090885	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2672	1716038090885	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038103934	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038111935	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037746001	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037746001	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2628000000000004	1716037746001	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037748005	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.6	1716037748005	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2628000000000004	1716037748005	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037751011	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037751011	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2615	1716037751011	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037752014	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037752014	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2616	1716037752014	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037754038	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037758046	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037760056	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037763043	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037763043	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2641	1716037763043	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037765048	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037765048	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2641	1716037765048	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037767052	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037767052	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2636	1716037767052	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037768076	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037769111	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037771088	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037773087	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037774092	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037781117	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037791115	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037791115	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2661	1716037791115	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038033761	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038037768	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038048797	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038053790	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	12.899999999999999	1716038053790	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2713	1716038053790	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038056799	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716038056799	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2733000000000003	1716038056799	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038059831	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038060829	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038064818	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716038064818	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2739000000000003	1716038064818	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038067848	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038069854	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038076849	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038076849	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2752	1716038076849	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038078853	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038078853	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2739000000000003	1716038078853	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038079874	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038089881	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038089881	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2721	1716038089881	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038090903	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038107924	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038107924	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2725999999999997	1716038107924	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038111953	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037747003	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037747003	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2628000000000004	1716037747003	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037749007	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037749007	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2615	1716037749007	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037753038	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037755052	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037756045	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037759056	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037772066	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037772066	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2601	1716037772066	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037776101	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037783124	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037785100	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037785100	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2659000000000002	1716037785100	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037786102	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716037786102	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2659000000000002	1716037786102	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037788107	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	12.6	1716037788107	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2659000000000002	1716037788107	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037790112	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037790112	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2661	1716037790112	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037792117	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037792117	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2661	1716037792117	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038034745	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.9	1716038034745	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2731	1716038034745	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038035747	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038035747	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2731	1716038035747	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038042763	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038042763	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2719	1716038042763	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038052805	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038061812	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.1	1716038061812	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2741	1716038061812	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038062814	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038062814	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2741	1716038062814	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038080858	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038080858	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2739000000000003	1716038080858	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038081860	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.8	1716038081860	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2731999999999997	1716038081860	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038083883	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038084887	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038085891	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038092909	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038095920	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038097918	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038101910	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716038101910	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2697	1716038101910	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038106922	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038106922	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2725999999999997	1716038106922	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037747029	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037749025	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037755022	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.6	1716037755022	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2632	1716037755022	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037756025	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037756025	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2632	1716037756025	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037759033	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037759033	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.263	1716037759033	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716037771063	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037771063	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2603	1716037771063	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037772091	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037783095	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037783095	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2636	1716037783095	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037784098	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037784098	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2659000000000002	1716037784098	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037785119	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037787122	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037788128	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037790139	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037792137	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038034764	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038035765	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038042780	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038054812	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038061830	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038072839	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.4	1716038072839	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2743	1716038072839	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038080879	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038081880	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038084867	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.4	1716038084867	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2729	1716038084867	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038085870	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.7	1716038085870	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2729	1716038085870	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038087876	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038087876	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2721	1716038087876	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038095896	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038095896	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2704	1716038095896	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038097900	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038097900	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2714000000000003	1716038097900	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038098903	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038098903	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2714000000000003	1716038098903	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038103915	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038103915	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2725	1716038103915	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038106941	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038115966	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038118975	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038122985	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038123989	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038124989	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038141012	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037750009	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037750009	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2615	1716037750009	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037752043	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037757027	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037757027	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.263	1716037757027	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037770060	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037770060	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2603	1716037770060	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037778083	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8	1716037778083	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2624	1716037778083	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037779085	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.700000000000001	1716037779085	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2624	1716037779085	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037780088	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.1	1716037780088	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2624	1716037780088	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037782092	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.699999999999999	1716037782092	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2636	1716037782092	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037791144	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038036749	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038036749	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2724	1716038036749	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038038753	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716038038753	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2724	1716038038753	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038040759	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038040759	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2716999999999996	1716038040759	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038041761	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038041761	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2716999999999996	1716038041761	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038043765	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038043765	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2719	1716038043765	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038047774	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038047774	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2721	1716038047774	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038049780	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038049780	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2705	1716038049780	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038050782	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.8	1716038050782	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2705	1716038050782	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038051805	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038056820	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038058804	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.1	1716038058804	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2738	1716038058804	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038059806	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.4	1716038059806	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2738	1716038059806	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038066823	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.8	1716038066823	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2739000000000003	1716038066823	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038070833	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038070833	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2742	1716038070833	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038073841	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038073841	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2743	1716038073841	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037750031	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037753016	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037753016	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2616	1716037753016	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037757056	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037776075	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037776075	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2604	1716037776075	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037778110	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037779104	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037780108	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037782110	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038036767	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038038773	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038040782	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038041782	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038043869	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038047795	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038049801	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038050801	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038052787	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038052787	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2713	1716038052787	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038057820	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038058824	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038065821	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.100000000000001	1716038065821	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2739000000000003	1716038065821	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038066841	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038070849	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038073860	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038074864	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038075871	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038077875	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038087893	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038089902	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038091908	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038093891	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038093891	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2704	1716038093891	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038094894	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038094894	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2704	1716038094894	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038098927	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038100908	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038100908	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2697	1716038100908	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038101929	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038102929	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038105940	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038108948	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038109953	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038121962	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.500000000000001	1716038121962	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2734	1716038121962	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038125972	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038125972	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2719	1716038125972	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038127977	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.4	1716038127977	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.271	1716038127977	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038128979	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038128979	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.271	1716038128979	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038129981	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037761038	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716037761038	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2628000000000004	1716037761038	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037762041	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.199999999999999	1716037762041	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2628000000000004	1716037762041	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037764065	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037766075	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037775073	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.799999999999999	1716037775073	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2604	1716037775073	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037777080	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716037777080	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2604	1716037777080	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037786127	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037789110	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716037789110	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2659000000000002	1716037789110	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716037793120	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.5	1716037793120	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2649	1716037793120	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038039756	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038039756	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2716999999999996	1716038039756	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038044767	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038044767	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2719	1716038044767	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	109	1716038045770	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038045770	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2721	1716038045770	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038046772	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038046772	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2721	1716038046772	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038054793	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038054793	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2733000000000003	1716038054793	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038055822	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038063816	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716038063816	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2739000000000003	1716038063816	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038067826	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.1	1716038067826	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2739000000000003	1716038067826	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038068849	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038071855	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038083865	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038083865	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2731999999999997	1716038083865	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038086890	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038096899	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038096899	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2714000000000003	1716038096899	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038099923	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038104937	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038110933	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038110933	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2723	1716038110933	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038112937	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	6.9	1716038112937	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2721	1716038112937	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038131989	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.1	1716038131989	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2721	1716038131989	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038132991	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037761061	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716037764046	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.799999999999999	1716037764046	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2641	1716037764046	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716037766050	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716037766050	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2636	1716037766050	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037767078	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037775101	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037777105	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716037787104	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.3	1716037787104	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2659000000000002	1716037787104	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037789132	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716037793149	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038039776	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038044786	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038045790	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038048778	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	11.100000000000001	1716038048778	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2705	1716038048778	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038055797	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038055797	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2733000000000003	1716038055797	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038062831	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038064842	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038068829	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038068829	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2739000000000003	1716038068829	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038071835	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038071835	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2742	1716038071835	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038079855	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038079855	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2739000000000003	1716038079855	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038086873	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7	1716038086873	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2729	1716038086873	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038088900	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038096916	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038104917	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038104917	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2725	1716038104917	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038107944	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038110952	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038114941	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.2	1716038114941	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2727	1716038114941	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038132006	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038133012	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038134995	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.2	1716038134995	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2741	1716038134995	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038148030	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.2	1716038148030	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038148030	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038149032	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.3	1716038149032	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038149032	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038152039	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038152039	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2786	1716038152039	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038159085	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038168079	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.6	1716038213192	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2783	1716038213192	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038214196	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.3	1716038214196	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2783	1716038214196	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038215198	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716038215198	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2783	1716038215198	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038216201	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.3	1716038216201	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038216201	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038216221	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038217204	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.000000000000001	1716038217204	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038217204	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038217226	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038218230	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038219210	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716038219210	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2782	1716038219210	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038220212	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.6	1716038220212	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2782	1716038220212	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038221214	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.2	1716038221214	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2782	1716038221214	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	100	1716038222217	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.6	1716038222217	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038222217	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038222242	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038224246	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038225226	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038225226	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2778	1716038225226	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038226228	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.000000000000001	1716038226228	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2778	1716038226228	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038226248	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038228233	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.2	1716038228233	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2794	1716038228233	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038229236	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038229236	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2794	1716038229236	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038230238	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.000000000000001	1716038230238	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2794	1716038230238	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038230256	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038231241	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.6	1716038231241	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038231241	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038231268	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038234249	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.100000000000001	1716038234249	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2773000000000003	1716038234249	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038234277	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038235252	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038235252	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2773000000000003	1716038235252	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038235272	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038236254	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038236254	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2773000000000003	1716038236254	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038238260	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038213216	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038214225	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038215220	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038218207	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038218207	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038218207	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038219241	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038220227	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038221241	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038223220	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.3	1716038223220	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038223220	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038223238	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038224222	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038224222	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038224222	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038225244	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038227231	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.6	1716038227231	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2778	1716038227231	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038227252	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038228258	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038229260	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038232243	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.2	1716038232243	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038232243	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038232267	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038233245	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038233245	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2777	1716038233245	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038233273	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038236271	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038237258	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.5	1716038237258	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2771	1716038237258	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038237278	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038238260	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2771	1716038238260	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038238287	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038239262	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038239262	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2771	1716038239262	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038239288	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038240265	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.300000000000001	1716038240265	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2794	1716038240265	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038240284	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038241267	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.000000000000001	1716038241267	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2794	1716038241267	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038241294	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038242269	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.899999999999999	1716038242269	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2794	1716038242269	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038242296	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038243273	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038243273	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2803	1716038243273	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038243299	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038244274	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038244274	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2803	1716038244274	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038244302	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038245277	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.9	1716038245277	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2803	1716038245277	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038247281	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.400000000000001	1716038247281	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2746999999999997	1716038247281	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038259309	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038259309	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2781	1716038259309	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038262317	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.2	1716038262317	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2781	1716038262317	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038268360	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038269357	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038272366	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038245296	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038250309	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038259340	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038264322	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	12.7	1716038264322	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2821	1716038264322	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038269338	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.3	1716038269338	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2824	1716038269338	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038270340	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.8	1716038270340	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2796999999999996	1716038270340	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038246279	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.2	1716038246279	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2746999999999997	1716038246279	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038249287	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.3	1716038249287	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2771999999999997	1716038249287	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038252318	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038257325	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038263319	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.6	1716038263319	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2781	1716038263319	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038265327	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038265327	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2821	1716038265327	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038266329	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038266329	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2821	1716038266329	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038268334	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038268334	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2824	1716038268334	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038271369	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038273348	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038273348	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2811	1716038273348	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038246308	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038252293	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038252293	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2778	1716038252293	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038257305	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038257305	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2763	1716038257305	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038262342	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038263349	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038265350	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038266355	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038271343	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.000000000000001	1716038271343	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2796999999999996	1716038271343	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038272345	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.2	1716038272345	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2796999999999996	1716038272345	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038247306	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038249316	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038251290	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.1	1716038251290	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2771999999999997	1716038251290	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038254298	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038254298	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2778	1716038254298	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038258333	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038261314	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.300000000000001	1716038261314	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2781	1716038261314	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038264350	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038267353	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038248284	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.1000000000000005	1716038248284	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2746999999999997	1716038248284	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038253318	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038255300	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038255300	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2763	1716038255300	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038256302	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.5	1716038256302	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2763	1716038256302	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038260312	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.3	1716038260312	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2781	1716038260312	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038248303	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038250288	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.2	1716038250288	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2771999999999997	1716038250288	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038251315	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038258307	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038258307	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2781	1716038258307	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038260331	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038261343	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038267332	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.4	1716038267332	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2824	1716038267332	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038273374	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038253295	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.6	1716038253295	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2778	1716038253295	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038254316	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038255319	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038256320	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038270357	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038274350	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.8	1716038274350	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2811	1716038274350	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038274391	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038275353	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.1	1716038275353	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2811	1716038275353	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038275371	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	106	1716038276354	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038276354	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2807	1716038276354	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038276371	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	103	1716038277357	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.000000000000001	1716038277357	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2807	1716038277357	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038277378	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038278359	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.4	1716038278359	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2807	1716038278359	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038278378	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038279362	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	12.8	1716038279362	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2803	1716038279362	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038279389	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038280364	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	9.8	1716038280364	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2803	1716038280364	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038280386	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	104	1716038281367	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038281367	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2803	1716038281367	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038281386	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038282370	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.2	1716038282370	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2811	1716038282370	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038282392	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038283373	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038283373	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2811	1716038283373	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038283400	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038284375	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	8.2	1716038284375	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2811	1716038284375	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038284393	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038285378	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	12.899999999999999	1716038285378	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2798000000000003	1716038285378	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038285398	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	101	1716038286380	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	5.300000000000001	1716038286380	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2798000000000003	1716038286380	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038286400	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038287382	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10	1716038287382	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2798000000000003	1716038287382	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038287401	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	102	1716038288385	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	7.2	1716038288385	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2807	1716038288385	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038289409	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Swap Memory GB	0.0156	1716038288401	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - CPU Utilization	105	1716038289387	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Utilization	10.2	1716038289387	c35fda81caaf4bb8ae1acddfedafb171	0	f
TOP - Memory Usage GB	2.2807	1716038289387	c35fda81caaf4bb8ae1acddfedafb171	0	f
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
letter	0	92d6aa8e877d4078bc780f673be7abfe
workload	0	92d6aa8e877d4078bc780f673be7abfe
listeners	smi+top+dcgmi	92d6aa8e877d4078bc780f673be7abfe
params	'"-"'	92d6aa8e877d4078bc780f673be7abfe
file	cifar10.py	92d6aa8e877d4078bc780f673be7abfe
workload_listener	''	92d6aa8e877d4078bc780f673be7abfe
letter	0	c35fda81caaf4bb8ae1acddfedafb171
workload	0	c35fda81caaf4bb8ae1acddfedafb171
listeners	smi+top+dcgmi	c35fda81caaf4bb8ae1acddfedafb171
params	'"-"'	c35fda81caaf4bb8ae1acddfedafb171
file	cifar10.py	c35fda81caaf4bb8ae1acddfedafb171
workload_listener	''	c35fda81caaf4bb8ae1acddfedafb171
model	cifar10.py	c35fda81caaf4bb8ae1acddfedafb171
manual	False	c35fda81caaf4bb8ae1acddfedafb171
max_epoch	5	c35fda81caaf4bb8ae1acddfedafb171
max_time	172800	c35fda81caaf4bb8ae1acddfedafb171
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
92d6aa8e877d4078bc780f673be7abfe	illustrious-kit-857	UNKNOWN			daga	FAILED	1716037285793	1716037355133		active	s3://mlflow-storage/0/92d6aa8e877d4078bc780f673be7abfe/artifacts	0	\N
c35fda81caaf4bb8ae1acddfedafb171	(0 0) whimsical-slug-942	UNKNOWN			daga	FINISHED	1716037435558	1716038290622		active	s3://mlflow-storage/0/c35fda81caaf4bb8ae1acddfedafb171/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	92d6aa8e877d4078bc780f673be7abfe
mlflow.source.name	file:///home/daga/radt#examples/pytorch	92d6aa8e877d4078bc780f673be7abfe
mlflow.source.type	PROJECT	92d6aa8e877d4078bc780f673be7abfe
mlflow.project.entryPoint	main	92d6aa8e877d4078bc780f673be7abfe
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	92d6aa8e877d4078bc780f673be7abfe
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	92d6aa8e877d4078bc780f673be7abfe
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	92d6aa8e877d4078bc780f673be7abfe
mlflow.runName	illustrious-kit-857	92d6aa8e877d4078bc780f673be7abfe
mlflow.project.env	conda	92d6aa8e877d4078bc780f673be7abfe
mlflow.project.backend	local	92d6aa8e877d4078bc780f673be7abfe
mlflow.user	daga	c35fda81caaf4bb8ae1acddfedafb171
mlflow.source.name	file:///home/daga/radt#examples/pytorch	c35fda81caaf4bb8ae1acddfedafb171
mlflow.source.type	PROJECT	c35fda81caaf4bb8ae1acddfedafb171
mlflow.project.entryPoint	main	c35fda81caaf4bb8ae1acddfedafb171
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	c35fda81caaf4bb8ae1acddfedafb171
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	c35fda81caaf4bb8ae1acddfedafb171
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	c35fda81caaf4bb8ae1acddfedafb171
mlflow.project.env	conda	c35fda81caaf4bb8ae1acddfedafb171
mlflow.project.backend	local	c35fda81caaf4bb8ae1acddfedafb171
mlflow.runName	(0 0) whimsical-slug-942	c35fda81caaf4bb8ae1acddfedafb171
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

