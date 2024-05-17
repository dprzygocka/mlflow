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
0	Default	s3://mlflow-storage/0	active	1715608640441	1715608640441
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
SMI - Power Draw	14.68	1715608828557	0	f	eea214e99e6044f19adf470b752e50d5
SMI - Timestamp	1715608828.537	1715608828557	0	f	eea214e99e6044f19adf470b752e50d5
SMI - GPU Util	0	1715608828557	0	f	eea214e99e6044f19adf470b752e50d5
SMI - Mem Util	0	1715608828557	0	f	eea214e99e6044f19adf470b752e50d5
SMI - Mem Used	0	1715608828557	0	f	eea214e99e6044f19adf470b752e50d5
SMI - Performance State	3	1715608828557	0	f	eea214e99e6044f19adf470b752e50d5
TOP - CPU Utilization	101	1715609609471	0	f	eea214e99e6044f19adf470b752e50d5
TOP - Memory Usage GB	2.5428	1715609609471	0	f	eea214e99e6044f19adf470b752e50d5
TOP - Memory Utilization	5.6	1715609609471	0	f	eea214e99e6044f19adf470b752e50d5
TOP - Swap Memory GB	0.0482	1715609609497	0	f	eea214e99e6044f19adf470b752e50d5
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
TOP - CPU Utilization	0	1715608828354	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	0	1715608828354	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	1.8437000000000001	1715608828354	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0258	1715608828398	eea214e99e6044f19adf470b752e50d5	0	f
SMI - Power Draw	14.68	1715608828557	eea214e99e6044f19adf470b752e50d5	0	f
SMI - Timestamp	1715608828.537	1715608828557	eea214e99e6044f19adf470b752e50d5	0	f
SMI - GPU Util	0	1715608828557	eea214e99e6044f19adf470b752e50d5	0	f
SMI - Mem Util	0	1715608828557	eea214e99e6044f19adf470b752e50d5	0	f
SMI - Mem Used	0	1715608828557	eea214e99e6044f19adf470b752e50d5	0	f
SMI - Performance State	3	1715608828557	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	166.7	1715608829356	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.7	1715608829356	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	1.8437000000000001	1715608829356	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0258	1715608829402	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	183	1715608830359	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	15.100000000000001	1715608830359	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	1.8437000000000001	1715608830359	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0258	1715608830377	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608831361	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.2	1715608831361	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0825	1715608831361	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0304	1715608831394	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608832364	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.800000000000001	1715608832364	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0825	1715608832364	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0304	1715608832390	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608833367	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.2	1715608833367	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0825	1715608833367	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0304	1715608833387	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608834370	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.800000000000001	1715608834370	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0813	1715608834370	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0304	1715608834400	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608835374	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.2	1715608835374	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0813	1715608835374	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0304	1715608835405	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608836377	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.5	1715608836377	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0813	1715608836377	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0304	1715608836401	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	107	1715608837380	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608837380	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0803000000000003	1715608837380	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0304	1715608837403	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608838382	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.2	1715608838382	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0803000000000003	1715608838382	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0304	1715608838402	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715608839385	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.800000000000001	1715608839385	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0803000000000003	1715608839385	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0304	1715608839405	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715608840388	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.800000000000001	1715608840388	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0799000000000003	1715608840388	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608840410	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608841390	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.2	1715608841390	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0799000000000003	1715608841390	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608841410	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	108	1715608842392	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.6	1715608842392	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0799000000000003	1715608842392	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608842418	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608845428	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608846427	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715608849409	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.800000000000001	1715608849409	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0803000000000003	1715608849409	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	108	1715608851414	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.300000000000001	1715608851414	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0803000000000003	1715608851414	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608852417	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5	1715608852417	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0799000000000003	1715608852417	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715608853420	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608853420	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0799000000000003	1715608853420	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608857449	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608858451	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608859456	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608861443	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608861443	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5885	1715608861443	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715608862447	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.2	1715608862447	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5885	1715608862447	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608865454	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.800000000000001	1715608865454	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5926	1715608865454	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608867459	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608867459	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5938000000000003	1715608867459	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609169269	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609169269	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5258000000000003	1715609169269	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609170274	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609170274	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5258000000000003	1715609170274	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609178298	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609178298	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5275	1715609178298	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609180303	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609180303	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5286999999999997	1715609180303	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609181305	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609181305	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5286999999999997	1715609181305	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609187323	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609187323	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5285	1715609187323	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609188325	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609188325	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5285	1715609188325	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609197349	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8.100000000000001	1715609197349	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5040999999999998	1715609197349	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609201360	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609201360	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5265	1715609201360	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609207379	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609207379	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5255	1715609207379	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609208383	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609208383	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5255	1715609208383	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609212393	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715608843394	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.6	1715608843394	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0791	1715608843394	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715608847405	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608847405	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0788	1715608847405	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608860462	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0381	1715608863471	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608864478	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609169294	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609170299	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609178317	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609180323	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609181327	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609187341	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609188351	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609197368	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609201387	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609207401	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609208407	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609212411	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609215429	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609218433	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609223443	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5366	1715609410923	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609411925	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609411925	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.537	1715609411925	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609413931	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	12.299999999999999	1715609413931	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.537	1715609413931	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609414953	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609419951	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8.2	1715609419951	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5358	1715609419951	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609422976	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609426998	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609432005	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609436017	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609440037	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609442010	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609442010	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5365	1715609442010	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609444015	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609444015	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5365	1715609444015	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609455043	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609455043	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5375	1715609455043	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609456048	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.3	1715609456048	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5391	1715609456048	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609462062	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609462062	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.536	1715609462062	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609465087	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609466105	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609467105	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609543315	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609544322	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609550310	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609550310	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5381	1715609550310	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609552316	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609552316	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608843419	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608847432	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608863450	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608863450	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5885	1715608863450	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608864452	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608864452	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5926	1715608864452	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609171277	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609171277	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5286	1715609171277	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609172280	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609172280	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5286	1715609172280	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609173283	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609173283	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5286	1715609173283	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609185316	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609185316	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5296999999999996	1715609185316	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609191361	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609192358	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609193364	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609194370	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609198378	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609206403	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609209410	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609211391	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609211391	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5255	1715609211391	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609214399	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609214399	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5236	1715609214399	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609216406	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609216406	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5256	1715609216406	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609219413	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609219413	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5285	1715609219413	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609226458	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5334	1715609425967	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609427973	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609427973	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5361	1715609427973	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609429978	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609429978	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5345999999999997	1715609429978	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609439003	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609439003	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5383	1715609439003	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715609443013	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.7	1715609443013	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5365	1715609443013	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609446020	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609446020	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5370999999999997	1715609446020	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609447023	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609447023	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5401	1715609447023	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609450032	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609450032	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5393000000000003	1715609450032	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609458053	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609458053	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608844397	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.7	1715608844397	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0791	1715608844397	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715608848407	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608848407	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0788	1715608848407	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608850438	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608854449	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608855452	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608856451	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608866456	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.2	1715608866456	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5926	1715608866456	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609171305	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609172306	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609173302	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609191333	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609191333	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5298000000000003	1715609191333	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609192336	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609192336	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5273000000000003	1715609192336	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609193339	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609193339	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5273000000000003	1715609193339	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609194341	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609194341	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5273000000000003	1715609194341	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609198352	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609198352	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5245	1715609198352	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609206376	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609206376	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5254000000000003	1715609206376	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609209385	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609209385	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5255	1715609209385	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609210413	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609211418	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609214416	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609216430	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609226432	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609226432	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5301	1715609226432	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609438024	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609445017	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609445017	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5370999999999997	1715609445017	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609448026	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609448026	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5401	1715609448026	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609449029	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609449029	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5401	1715609449029	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609451034	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609451034	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5393000000000003	1715609451034	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609454040	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609454040	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5375	1715609454040	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609461060	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609461060	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5385999999999997	1715609461060	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609463066	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608844422	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715608850412	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715608850412	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0803000000000003	1715608850412	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715608854423	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608854423	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0799000000000003	1715608854423	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	109	1715608855426	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.5	1715608855426	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0788	1715608855426	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715608856428	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.6	1715608856428	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0788	1715608856428	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608857431	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.6	1715608857431	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0788	1715608857431	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608866483	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609174285	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609174285	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5279000000000003	1715609174285	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609175290	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609175290	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5279000000000003	1715609175290	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609176292	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609176292	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5279000000000003	1715609176292	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609177295	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.500000000000001	1715609177295	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5275	1715609177295	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609179300	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609179300	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5275	1715609179300	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609183310	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	10.1	1715609183310	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5296999999999996	1715609183310	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609184313	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609184313	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5296999999999996	1715609184313	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609186320	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609186320	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5285	1715609186320	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609189328	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609189328	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5298000000000003	1715609189328	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609190330	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609190330	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5298000000000003	1715609190330	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609195344	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609195344	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5040999999999998	1715609195344	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609196377	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609204371	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609204371	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5254000000000003	1715609204371	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609213396	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609213396	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5236	1715609213396	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609221418	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609221418	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5285	1715609221418	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609222420	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609222420	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5293	1715609222420	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609224453	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715608845400	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.800000000000001	1715608845400	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0791	1715608845400	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715608846402	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.6	1715608846402	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.0788	1715608846402	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608848433	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608849436	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608851439	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608852447	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.030899999999999997	1715608853449	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608858434	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5	1715608858434	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.3815	1715608858434	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608859437	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715608859437	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.3815	1715608859437	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608860440	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608860440	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.3815	1715608860440	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0381	1715608861471	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0381	1715608862465	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608865476	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608867478	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608868462	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.2	1715608868462	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5938000000000003	1715608868462	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608868485	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608869464	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608869464	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5938000000000003	1715608869464	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608869485	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608870468	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.2	1715608870468	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5959	1715608870468	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608870487	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608871470	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.800000000000001	1715608871470	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5959	1715608871470	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608871491	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608872473	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.800000000000001	1715608872473	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5959	1715608872473	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608872494	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608873475	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.800000000000001	1715608873475	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5954	1715608873475	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608873493	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608874478	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.6	1715608874478	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5954	1715608874478	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608874503	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608875481	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.2	1715608875481	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5954	1715608875481	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608875507	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608876484	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608876484	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5966	1715608876484	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608876506	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608877486	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.6	1715608877486	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5966	1715608877486	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608877504	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608878488	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5	1715608878488	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5966	1715608878488	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608880493	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608880493	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5974	1715608880493	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608885506	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608885506	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5973	1715608885506	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715608887511	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715608887511	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5973	1715608887511	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608889537	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608892553	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608895533	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608895533	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.6	1715608895533	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608898568	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608922607	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608922607	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5006	1715608922607	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608926619	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.300000000000001	1715608926619	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5014000000000003	1715608926619	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609174305	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609175310	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609176312	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609177313	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609179316	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609183336	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609184342	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609186346	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609189356	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609190360	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609196347	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609196347	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5040999999999998	1715609196347	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609200357	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609200357	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5245	1715609200357	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609204397	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609213424	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609221443	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609222448	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609225428	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609225428	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5301	1715609225428	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5391	1715609458053	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609459056	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609459056	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5385999999999997	1715609459056	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609460058	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609460058	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5385999999999997	1715609460058	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609462078	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609545297	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609545297	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5353000000000003	1715609545297	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609547324	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609548324	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609551338	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609556345	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609560336	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609560336	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608878508	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608880516	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608885525	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608887538	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608892525	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608892525	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5973	1715608892525	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608894556	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608898543	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608898543	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4996	1715608898543	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608901550	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608901550	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4984	1715608901550	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608922631	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609182308	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609182308	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5286999999999997	1715609182308	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609185332	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609199355	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609199355	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5245	1715609199355	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609200386	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609202383	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609203401	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609205400	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609217408	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609217408	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5256	1715609217408	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609219434	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609220442	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715609227435	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609227435	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5301	1715609227435	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609228437	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.499999999999998	1715609228437	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5286	1715609228437	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609460080	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609468105	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5366	1715609552316	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609554321	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609554321	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5366	1715609554321	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609555323	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609555323	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5382	1715609555323	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609559333	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609559333	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5385	1715609559333	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609562341	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609562341	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.539	1715609562341	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609564373	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609570394	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609571391	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609573372	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609573372	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5364	1715609573372	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609575377	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609575377	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5364	1715609575377	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609576379	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609576379	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5412	1715609576379	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608879491	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.800000000000001	1715608879491	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5974	1715608879491	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715608888514	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608888514	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5973	1715608888514	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608895552	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608896555	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608897567	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608899571	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608900573	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608902570	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608903575	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608904579	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608911578	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608911578	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5003	1715608911578	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608913583	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715608913583	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5000999999999998	1715608913583	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608916591	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608916591	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5005	1715608916591	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608919600	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608919600	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5004	1715608919600	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608921605	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.299999999999999	1715608921605	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5006	1715608921605	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608923609	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608923609	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5006	1715608923609	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609182329	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609195382	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609199382	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609202365	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609202365	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5265	1715609202365	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609203368	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609203368	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5265	1715609203368	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609205374	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609205374	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5254000000000003	1715609205374	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609210388	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609210388	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5255	1715609210388	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609217431	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609220415	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609220415	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5285	1715609220415	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609224425	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609224425	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5293	1715609224425	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609227463	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609228465	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609463066	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.536	1715609463066	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609468079	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609468079	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5382	1715609468079	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609557348	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609560362	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609563344	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608879513	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608891523	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715608891523	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5973	1715608891523	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608896536	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715608896536	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.6	1715608896536	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608897540	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.4	1715608897540	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4996	1715608897540	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608899546	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715608899546	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4996	1715608899546	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608900548	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715608900548	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4984	1715608900548	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608902553	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715608902553	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4984	1715608902553	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608903556	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715608903556	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5004	1715608903556	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608904559	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608904559	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5004	1715608904559	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608910602	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608911595	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608913611	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608916607	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608919626	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608921630	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608923635	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609212393	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5255	1715609212393	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609215403	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609215403	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5236	1715609215403	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609218410	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609218410	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5256	1715609218410	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609223423	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609223423	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5293	1715609223423	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609466073	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609466073	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5387	1715609466073	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609467076	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609467076	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5387	1715609467076	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5385	1715609560336	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609562359	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609563369	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609565375	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609566381	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609572370	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.7	1715609572370	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.54	1715609572370	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609574375	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609574375	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5364	1715609574375	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609576409	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609577408	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609578386	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5412	1715609578386	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608881496	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608881496	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5974	1715608881496	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608884504	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608884504	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5967	1715608884504	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608888536	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608893527	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715608893527	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5973	1715608893527	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608894530	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715608894530	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.6	1715608894530	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608906565	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.299999999999999	1715608906565	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5000999999999998	1715608906565	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608908570	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715608908570	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5000999999999998	1715608908570	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608909573	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608909573	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5003	1715608909573	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608910576	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608910576	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5003	1715608910576	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608912602	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608918623	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608924642	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608925645	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608927622	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608927622	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5024	1715608927622	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609225458	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609469081	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.7	1715609469081	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5382	1715609469081	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609478104	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609478104	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5405	1715609478104	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609479107	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609479107	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5405	1715609479107	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609481112	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609481112	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5397	1715609481112	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609522229	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609522229	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5389	1715609522229	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609523234	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609523234	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5389	1715609523234	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609526243	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609526243	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.539	1715609526243	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609528249	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.3	1715609528249	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5393000000000003	1715609528249	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609532260	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609532260	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5401	1715609532260	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609533263	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609533263	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5401	1715609533263	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609537273	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608881516	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608884523	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608891547	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608893546	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608901579	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608906590	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608908599	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608909603	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608912580	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715608912580	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5000999999999998	1715608912580	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715608918598	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715608918598	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5004	1715608918598	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608924614	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715608924614	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5014000000000003	1715608924614	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608925617	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715608925617	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5014000000000003	1715608925617	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608926645	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608927651	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609229439	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609229439	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5286	1715609229439	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609230469	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609233469	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609236457	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.7	1715609236457	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5249	1715609236457	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609238465	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609238465	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5282	1715609238465	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609241472	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609241472	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5299	1715609241472	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609243477	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609243477	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5302	1715609243477	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609248507	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609265561	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609272552	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.7	1715609272552	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311999999999997	1715609272552	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609273581	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609274584	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609275585	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609277591	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609469105	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609478126	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609479124	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609481138	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609522256	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609523252	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609526269	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609528281	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609532293	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609533280	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609537293	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609553336	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609558330	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609558330	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5385	1715609558330	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609561364	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609567375	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608882499	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715608882499	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5967	1715608882499	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608883501	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608883501	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5967	1715608883501	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608886509	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608886509	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5973	1715608886509	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715608889517	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.4	1715608889517	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5973	1715608889517	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608890546	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608905589	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608907584	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608914610	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608915613	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608917618	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608920632	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609229468	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609240470	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609240470	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5299	1715609240470	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609250497	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609250497	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305	1715609250497	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609251500	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715609251500	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305	1715609251500	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609253523	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609258550	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609259546	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609263560	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609267558	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609278588	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609285588	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.800000000000001	1715609285588	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5322	1715609285588	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	99	1715609286591	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609286591	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5322	1715609286591	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609470083	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	12.3	1715609470083	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5382	1715609470083	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609471086	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609471086	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.537	1715609471086	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609482115	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609482115	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5397	1715609482115	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609487148	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609490166	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609493177	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609495174	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609498189	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609499196	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609500196	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609502191	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609505201	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609506208	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609507213	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609508205	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609512200	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609512200	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.539	1715609512200	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608882518	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608883523	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608886532	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608890520	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715608890520	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5973	1715608890520	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608905562	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715608905562	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5004	1715608905562	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608907567	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608907567	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5000999999999998	1715608907567	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608914585	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608914585	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5000999999999998	1715608914585	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608915588	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715608915588	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5005	1715608915588	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608917593	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608917593	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5005	1715608917593	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608920603	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715608920603	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5004	1715608920603	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608928625	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715608928625	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5024	1715608928625	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608928644	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608929628	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608929628	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5024	1715608929628	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608929657	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715608930631	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715608930631	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5027	1715608930631	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608930658	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608931633	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608931633	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5027	1715608931633	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608931659	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608932636	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608932636	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5027	1715608932636	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608932656	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608933638	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608933638	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4974000000000003	1715608933638	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608933656	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608934641	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.299999999999999	1715608934641	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4974000000000003	1715608934641	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608934662	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608935643	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608935643	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4974000000000003	1715608935643	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608935664	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608936646	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715608936646	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5002	1715608936646	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608936669	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608937651	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608937651	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5002	1715608937651	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608937672	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608938653	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608938653	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5002	1715608938653	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608940659	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608940659	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5004	1715608940659	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608941661	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608941661	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5004	1715608941661	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608946704	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608947704	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608953715	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608954728	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608956702	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608956702	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5017	1715608956702	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608960715	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608960715	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5025	1715608960715	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608961718	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608961718	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5025	1715608961718	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608965756	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608968736	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608968736	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5059	1715608968736	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608970740	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608970740	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5064	1715608970740	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608976757	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715608976757	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5040999999999998	1715608976757	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608981770	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715608981770	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5038	1715608981770	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608982793	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608983803	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608984804	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609230442	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609230442	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5286	1715609230442	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609233449	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609233449	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5293	1715609233449	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609234452	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609234452	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5249	1715609234452	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609236478	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609238483	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609241498	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609243502	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609265535	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609265535	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5304	1715609265535	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609270574	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609273555	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609273555	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5275	1715609273555	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609274557	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	10.4	1715609274557	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5275	1715609274557	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609275560	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.500000000000001	1715609275560	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5275	1715609275560	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608938672	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608940681	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608946677	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.4	1715608946677	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4999000000000002	1715608946677	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608947679	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608947679	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4999000000000002	1715608947679	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608953695	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608953695	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5009	1715608953695	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608954697	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608954697	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5017	1715608954697	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608955733	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608956727	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608960739	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608965728	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608965728	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5046999999999997	1715608965728	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608967751	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608968762	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608970767	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608979793	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608982773	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715608982773	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5038	1715608982773	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715608983776	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715608983776	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5038	1715608983776	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608984778	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608984778	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5035	1715608984778	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609231445	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609231445	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5293	1715609231445	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609232447	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609232447	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5293	1715609232447	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609247487	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.5	1715609247487	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5301	1715609247487	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609248490	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609248490	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5301	1715609248490	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609254536	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609255539	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609256540	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609257537	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609261554	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609262547	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609264558	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609266566	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609268570	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609269569	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609271574	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609276563	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609276563	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5296	1715609276563	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609279570	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609279570	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5283	1715609279570	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609281602	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609284585	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608939656	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715608939656	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5004	1715608939656	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608941679	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608951689	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715608951689	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5009	1715608951689	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715608957706	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715608957706	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5038	1715608957706	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608961737	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608963750	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608964750	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608969766	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608972771	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608978788	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608981797	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608987810	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609231471	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609232473	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609247515	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609254508	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609254508	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311	1715609254508	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609255510	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609255510	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311	1715609255510	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609256512	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609256512	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311	1715609256512	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609257515	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609257515	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311	1715609257515	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609261526	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609261526	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311	1715609261526	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609262529	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609262529	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311	1715609262529	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609264532	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609264532	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5304	1715609264532	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609266538	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609266538	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5304	1715609266538	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609268542	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609268542	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5317	1715609268542	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609269545	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609269545	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5317	1715609269545	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609271550	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609271550	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311999999999997	1715609271550	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609272570	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609276591	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609281576	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609281576	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5283	1715609281576	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609283599	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609284608	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609287611	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609470109	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609471113	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608939674	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608944689	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608951714	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608957725	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715608963723	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	11.9	1715608963723	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5046999999999997	1715608963723	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608964726	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608964726	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5046999999999997	1715608964726	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715608967733	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608967733	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5059	1715608967733	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608972747	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608972747	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5019	1715608972747	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608978762	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.5	1715608978762	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5031	1715608978762	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608979765	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715608979765	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5031	1715608979765	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608987785	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608987785	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.504	1715608987785	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609234469	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609235482	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609237486	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609242474	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609242474	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5299	1715609242474	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609244479	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609244479	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5302	1715609244479	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609245482	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609245482	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5302	1715609245482	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609246485	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609246485	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5301	1715609246485	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609249495	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609249495	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305	1715609249495	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609252503	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609252503	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311	1715609252503	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609253505	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609253505	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311	1715609253505	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609260550	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609280573	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609280573	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5283	1715609280573	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609282579	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609282579	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5303	1715609282579	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609283582	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609283582	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5303	1715609283582	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609472089	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609472089	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.537	1715609472089	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609475096	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609475096	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608942664	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608942664	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4996	1715608942664	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608944670	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715608944670	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4996	1715608944670	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608949714	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608971743	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.700000000000001	1715608971743	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5064	1715608971743	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608974752	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608974752	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5019	1715608974752	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608977759	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608977759	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5040999999999998	1715608977759	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608980796	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609235454	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609235454	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5249	1715609235454	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609237460	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609237460	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5282	1715609237460	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609239467	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609239467	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5282	1715609239467	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609242500	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609244500	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609245508	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609246511	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609249520	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609252533	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609260524	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609260524	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5307	1715609260524	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609270547	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609270547	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311999999999997	1715609270547	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609280601	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609282604	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609472106	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609475116	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609476124	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609484249	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609485154	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609486154	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609489136	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.799999999999999	1715609489136	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5384	1715609489136	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609496156	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609496156	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5396	1715609496156	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609497159	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609497159	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5396	1715609497159	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609503174	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609503174	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5364	1715609503174	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609511215	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609516236	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609518235	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609519246	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609529252	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609529252	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608942680	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608949684	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608949684	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5017	1715608949684	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608955699	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.9	1715608955699	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5017	1715608955699	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608971773	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608974777	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608980768	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608980768	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5031	1715608980768	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609239493	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609240497	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609250524	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609251524	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609258517	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609258517	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5307	1715609258517	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609259520	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609259520	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5307	1715609259520	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609263530	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609263530	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311	1715609263530	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609267540	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609267540	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5317	1715609267540	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609278567	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609278567	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5296	1715609278567	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609279595	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609285618	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609286621	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609473092	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.799999999999999	1715609473092	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.537	1715609473092	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609474094	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609474094	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5389	1715609474094	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609477102	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609477102	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5405	1715609477102	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609480110	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609480110	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5397	1715609480110	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609483120	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609483120	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5385	1715609483120	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609487131	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609487131	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5393000000000003	1715609487131	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609491142	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609491142	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5384	1715609491142	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609492145	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609492145	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5398	1715609492145	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609494151	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609494151	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5398	1715609494151	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609501169	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609501169	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5364	1715609501169	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608943667	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	12.000000000000002	1715608943667	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4996	1715608943667	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608945672	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608945672	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.4999000000000002	1715608945672	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608948681	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608948681	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5017	1715608948681	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608950686	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608950686	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5017	1715608950686	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608952691	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715608952691	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5009	1715608952691	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608958709	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715608958709	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5038	1715608958709	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608959712	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608959712	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5038	1715608959712	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608962721	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608962721	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5025	1715608962721	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608966731	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608966731	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5059	1715608966731	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608969738	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715608969738	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5064	1715608969738	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608973776	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608975781	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608977776	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608985809	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608986809	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609277564	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609277564	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5296	1715609277564	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609473118	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609474126	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609477119	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609480136	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609483148	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609488133	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609488133	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5393000000000003	1715609488133	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609491168	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609492161	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609494176	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609501194	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609504176	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609504176	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5351999999999997	1715609504176	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609509190	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609509190	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5341	1715609509190	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609510220	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609514230	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609524264	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609540303	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609541313	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609542314	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609546327	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609549326	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608943687	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608945693	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608948704	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608950716	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608952718	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608958741	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608959738	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608962740	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608966756	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608973750	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715608973750	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5019	1715608973750	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608975754	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608975754	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5040999999999998	1715608975754	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608976778	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608985780	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608985780	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5035	1715608985780	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608986782	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608986782	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5035	1715608986782	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608988787	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608988787	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.504	1715608988787	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608988814	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715608989789	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608989789	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.504	1715608989789	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608989816	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715608990791	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715608990791	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5040999999999998	1715608990791	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608990816	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608991794	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715608991794	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5040999999999998	1715608991794	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608991817	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608992796	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608992796	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5040999999999998	1715608992796	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608992813	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608993799	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715608993799	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5051	1715608993799	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608993822	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715608994800	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715608994800	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5051	1715608994800	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608994822	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608995805	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608995805	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5051	1715608995805	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608995824	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715608996807	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715608996807	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5064	1715608996807	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608996834	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715608997810	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715608997810	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5064	1715608997810	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608997827	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715608998812	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715608998812	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5064	1715608998812	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609003824	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609003824	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5042	1715609003824	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609010864	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609018863	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609018863	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5086999999999997	1715609018863	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609020894	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609021898	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609024905	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609026910	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609027904	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609039920	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609039920	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5122	1715609039920	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609046938	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.8	1715609046938	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5103	1715609046938	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609284585	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5303	1715609284585	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609287593	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609287593	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5322	1715609287593	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5389	1715609475096	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609476099	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609476099	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5389	1715609476099	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609484123	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609484123	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5385	1715609484123	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609485125	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609485125	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5385	1715609485125	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	113	1715609486128	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609486128	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5393000000000003	1715609486128	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609488152	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609489161	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609496173	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609497184	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609510194	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609510194	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.539	1715609510194	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609516211	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609516211	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5405	1715609516211	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609518217	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609518217	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5405	1715609518217	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609519220	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609519220	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5399000000000003	1715609519220	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609521258	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609529280	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609531257	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609531257	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5401	1715609531257	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609538275	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8.2	1715609538275	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5370999999999997	1715609538275	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609540283	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609540283	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5376999999999996	1715609540283	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608998828	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609010844	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715609010844	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5080999999999998	1715609010844	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609012868	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609020869	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715609020869	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5091	1715609020869	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609021871	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609021871	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5091	1715609021871	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609024879	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715609024879	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5111	1715609024879	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715609026883	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715609026883	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5116	1715609026883	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609027886	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609027886	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5116	1715609027886	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609034905	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609034905	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5135	1715609034905	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609039947	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609046965	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609288595	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609288595	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5299	1715609288595	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609296616	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609296616	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305	1715609296616	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609297620	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609297620	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5301	1715609297620	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	112	1715609303635	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609303635	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5325	1715609303635	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609304637	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609304637	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5325	1715609304637	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609305639	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609305639	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5325	1715609305639	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609307644	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609307644	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5317	1715609307644	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609315691	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609325716	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609332739	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609333740	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609336722	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609336722	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5314	1715609336722	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609338728	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609338728	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5314	1715609338728	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609339730	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609339730	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5323	1715609339730	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609340733	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609340733	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5323	1715609340733	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609482145	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609490140	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715608999815	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715608999815	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5067	1715608999815	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609001820	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715609001820	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5067	1715609001820	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609004850	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609005858	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609008838	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.4	1715609008838	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5080999999999998	1715609008838	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609009841	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609009841	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5080999999999998	1715609009841	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609011846	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715609011846	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5101999999999998	1715609011846	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609013871	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609015883	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609017887	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609022900	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609030926	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609031926	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609045936	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609045936	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5103	1715609045936	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609047940	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715609047940	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5128000000000004	1715609047940	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609288616	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609296636	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609297641	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609303660	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609304662	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609305663	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609315665	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609315665	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5314	1715609315665	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609325690	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609325690	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305999999999997	1715609325690	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609331731	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609333712	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609333712	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5299	1715609333712	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609335719	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.7	1715609335719	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5299	1715609335719	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609336749	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609338753	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609339759	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609340762	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	10.299999999999999	1715609490140	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5384	1715609490140	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609493148	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609493148	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5398	1715609493148	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609495154	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609495154	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5396	1715609495154	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609498162	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609498162	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5354	1715609498162	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609499164	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715608999832	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609001844	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609005830	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609005830	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.507	1715609005830	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715609006833	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	11.999999999999998	1715609006833	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.507	1715609006833	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609008866	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609009870	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609011874	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609015856	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715609015856	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5086999999999997	1715609015856	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609017861	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715609017861	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5086999999999997	1715609017861	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609022873	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609022873	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5091	1715609022873	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609030893	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609030893	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5122	1715609030893	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609031895	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609031895	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5122	1715609031895	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609044958	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609045963	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609047967	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609289598	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609289598	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5299	1715609289598	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609290600	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609290600	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5299	1715609290600	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609294610	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609294610	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305	1715609294610	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715609302632	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.5	1715609302632	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5319000000000003	1715609302632	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609306642	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609306642	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5317	1715609306642	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609311655	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609311655	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5302	1715609311655	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609312657	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609312657	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5303	1715609312657	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609313660	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609313660	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5303	1715609313660	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609314663	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609314663	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5303	1715609314663	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609321680	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609321680	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305999999999997	1715609321680	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609323685	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609323685	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305999999999997	1715609323685	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609328722	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609330733	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609000817	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609000817	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5067	1715609000817	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609003842	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609006867	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609007855	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609016859	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.9	1715609016859	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5086999999999997	1715609016859	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609018890	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609023904	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609025897	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609033900	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715609033900	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5135	1715609033900	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609034932	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609037939	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609038947	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609042951	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609043950	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609289624	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609290626	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609294626	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609302663	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609307660	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609311681	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609312678	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609313689	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609314690	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609321710	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609328697	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609328697	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5326999999999997	1715609328697	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609330702	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609330702	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.531	1715609330702	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609331706	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609331706	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.531	1715609331706	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609334717	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609334717	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5299	1715609334717	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609335747	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609344744	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609344744	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5318	1715609344744	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609345747	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609345747	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5322	1715609345747	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.7	1715609499164	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5354	1715609499164	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609500166	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609500166	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5354	1715609500166	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609502171	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609502171	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5364	1715609502171	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609505179	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8.2	1715609505179	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5351999999999997	1715609505179	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609506182	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.799999999999999	1715609506182	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5351999999999997	1715609506182	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609507185	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609000845	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609004827	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609004827	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5042	1715609004827	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609007835	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715609007835	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.507	1715609007835	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609012848	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609012848	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5101999999999998	1715609012848	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609016891	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609023876	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715609023876	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5111	1715609023876	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609025881	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609025881	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5111	1715609025881	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609032898	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715609032898	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5135	1715609032898	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609033918	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609037915	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609037915	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5126	1715609037915	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609038918	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609038918	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5122	1715609038918	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609042928	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609042928	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5163	1715609042928	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609043931	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715609043931	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5163	1715609043931	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609044934	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609044934	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5103	1715609044934	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609291602	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8.1	1715609291602	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305999999999997	1715609291602	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609293608	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.7	1715609293608	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305999999999997	1715609293608	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609295634	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609298644	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609299651	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609300652	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609308672	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609309675	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609316693	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609318672	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609318672	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5298000000000003	1715609318672	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609319675	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.5	1715609319675	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5298000000000003	1715609319675	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609320678	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609320678	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5298000000000003	1715609320678	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609322702	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609326718	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609341735	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609341735	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5323	1715609341735	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715609342738	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609002822	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609002822	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5042	1715609002822	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609013851	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715609013851	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5101999999999998	1715609013851	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609014882	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609019893	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609028915	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609029921	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609035908	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609035908	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5126	1715609035908	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609036913	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	10.600000000000001	1715609036913	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5126	1715609036913	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609040923	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715609040923	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5122	1715609040923	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609041926	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609041926	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5163	1715609041926	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609291630	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609295613	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.800000000000001	1715609295613	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305	1715609295613	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609298622	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609298622	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5301	1715609298622	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609299626	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609299626	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5301	1715609299626	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609300628	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609300628	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5319000000000003	1715609300628	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609308647	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609308647	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5317	1715609308647	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609309650	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609309650	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5302	1715609309650	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609316667	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609316667	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5314	1715609316667	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609317669	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609317669	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5314	1715609317669	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609318699	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609319702	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609320702	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609326693	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609326693	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305999999999997	1715609326693	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609327695	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609327695	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5326999999999997	1715609327695	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609341768	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609343740	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8.100000000000001	1715609343740	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5318	1715609343740	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609346750	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609346750	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5322	1715609346750	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609347752	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609002848	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609014854	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715609014854	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5086999999999997	1715609014854	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609019866	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715609019866	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5086999999999997	1715609019866	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609028889	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609028889	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5116	1715609028889	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609029891	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609029891	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5122	1715609029891	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609032925	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609035938	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609036942	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609040951	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609041953	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609048942	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.700000000000001	1715609048942	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5128000000000004	1715609048942	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609048969	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609049945	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715609049945	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5128000000000004	1715609049945	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609049965	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609050950	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715609050950	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5156	1715609050950	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609050966	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609051952	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.5	1715609051952	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5156	1715609051952	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609051979	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609052954	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609052954	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5156	1715609052954	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609052972	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609053957	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715609053957	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5166999999999997	1715609053957	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609053976	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609054960	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609054960	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5166999999999997	1715609054960	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609054977	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609055962	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609055962	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5166999999999997	1715609055962	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609055989	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609056964	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715609056964	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5161	1715609056964	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609056993	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609057967	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609057967	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5161	1715609057967	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609057986	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609058969	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609058969	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5161	1715609058969	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609058994	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609059972	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715609059972	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5162	1715609059972	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609061976	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609061976	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5162	1715609061976	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609063982	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609063982	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5154	1715609063982	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609064984	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715609064984	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5154	1715609064984	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609065987	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715609065987	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5153000000000003	1715609065987	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609067991	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609067991	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5153000000000003	1715609067991	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609071019	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609074034	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609077037	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609083037	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715609083037	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5179	1715609083037	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	100	1715609084039	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609084039	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.512	1715609084039	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609090058	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715609090058	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5135	1715609090058	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609091091	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609094094	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609097079	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715609097079	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5194	1715609097079	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609101090	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609101090	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5179	1715609101090	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609102092	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.5	1715609102092	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5178000000000003	1715609102092	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609103095	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715609103095	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5178000000000003	1715609103095	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609108130	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609292605	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609292605	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305999999999997	1715609292605	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609293628	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609301658	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609310653	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609310653	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5302	1715609310653	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609317697	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609323712	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609324705	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609329699	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.5	1715609329699	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5326999999999997	1715609329699	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609337725	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609337725	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5314	1715609337725	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609347769	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609503196	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609504200	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609509215	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609059992	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609062005	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609064000	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609065010	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609066016	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609068009	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609074009	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715609074009	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5169	1715609074009	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609077019	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609077019	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5183	1715609077019	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609082053	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609083062	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609084061	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609091061	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715609091061	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5135	1715609091061	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609094071	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609094071	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.517	1715609094071	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609096076	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609096076	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5194	1715609096076	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609100087	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609100087	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5179	1715609100087	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609101118	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609102176	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609103111	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609292630	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609301630	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609301630	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5319000000000003	1715609301630	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609306658	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609310679	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609322683	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609322683	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305999999999997	1715609322683	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609324687	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.499999999999998	1715609324687	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305999999999997	1715609324687	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609327717	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609329726	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609337744	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609507185	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5341	1715609507185	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609508187	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609508187	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5341	1715609508187	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609511197	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609511197	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.539	1715609511197	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609512226	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609513223	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609515233	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609517238	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609520251	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609525239	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609525239	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.539	1715609525239	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609527246	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609527246	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.539	1715609527246	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609060974	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715609060974	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5162	1715609060974	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609062979	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715609062979	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5154	1715609062979	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609066989	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609066989	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5153000000000003	1715609066989	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609069996	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609069996	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5159000000000002	1715609069996	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609070999	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715609070999	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5159000000000002	1715609070999	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609080053	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609088052	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.8	1715609088052	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5162	1715609088052	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609089055	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609089055	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5162	1715609089055	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609090076	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609093093	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609332709	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609332709	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.531	1715609332709	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609334744	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609342755	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609344771	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609345775	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609513204	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609513204	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5389	1715609513204	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609515209	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609515209	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5389	1715609515209	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609517215	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609517215	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5405	1715609517215	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609520224	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609520224	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5399000000000003	1715609520224	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609521227	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609521227	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5399000000000003	1715609521227	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609525265	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609527271	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609534282	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609535294	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609536289	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609539296	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609547302	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609547302	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5372	1715609547302	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609548304	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609548304	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5372	1715609548304	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609551313	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609551313	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5381	1715609551313	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609556326	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609556326	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5382	1715609556326	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609061001	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609063003	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609067018	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609070023	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609080028	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609080028	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5171	1715609080028	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609086045	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609086045	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.512	1715609086045	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609088072	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609089085	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609093068	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609093068	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.517	1715609093068	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609096107	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.5	1715609342738	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5318	1715609342738	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609343770	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609346777	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609514206	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609514206	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5389	1715609514206	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609524237	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609524237	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5389	1715609524237	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609530272	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609541285	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609541285	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5376999999999996	1715609541285	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609542288	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	12.5	1715609542288	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5376999999999996	1715609542288	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609546299	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609546299	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5372	1715609546299	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609549307	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609549307	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5381	1715609549307	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609561339	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609561339	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.539	1715609561339	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609563344	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.539	1715609563344	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609565349	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609565349	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5415	1715609565349	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609566351	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609566351	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5415	1715609566351	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609567354	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609567354	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5405	1715609567354	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609568356	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609568356	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5405	1715609568356	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609568374	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609569379	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609572392	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609574404	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609577383	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.3	1715609577383	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5412	1715609577383	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609578386	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609068993	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715609068993	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5159000000000002	1715609068993	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609072002	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715609072002	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5169	1715609072002	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609073007	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715609073007	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5169	1715609073007	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609075012	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715609075012	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5183	1715609075012	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609079025	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.5	1715609079025	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5171	1715609079025	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609081031	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609081031	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5179	1715609081031	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609087049	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609087049	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5162	1715609087049	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609095073	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.699999999999999	1715609095073	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.517	1715609095073	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609097106	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609098101	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609099110	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	109	1715609104098	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609104098	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5178000000000003	1715609104098	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609105100	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.700000000000001	1715609105100	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5183	1715609105100	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609106103	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.000000000000001	1715609106103	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5183	1715609106103	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609107129	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609347752	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5322	1715609347752	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5393000000000003	1715609529252	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609530255	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609530255	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5393000000000003	1715609530255	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609531283	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609538294	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609543290	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609543290	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5353000000000003	1715609543290	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609544294	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609544294	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5353000000000003	1715609544294	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609545321	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609550336	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609552347	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609554338	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609555356	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609559359	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609564346	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8.2	1715609564346	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5415	1715609564346	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609569360	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.9	1715609569360	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5405	1715609569360	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609570365	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609069021	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609072028	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609073031	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609075032	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609079051	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609081057	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609087080	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609095100	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609098082	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715609098082	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5194	1715609098082	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609099084	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	10.3	1715609099084	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5179	1715609099084	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609100106	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609104123	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609105118	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609107105	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.000000000000001	1715609107105	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5183	1715609107105	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609348755	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609348755	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5286	1715609348755	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609362792	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8.1	1715609362792	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.531	1715609362792	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609364800	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609364800	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5315	1715609364800	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609367807	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609367807	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5326999999999997	1715609367807	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609368810	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609368810	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5326999999999997	1715609368810	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609372820	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609372820	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5357	1715609372820	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609373823	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609373823	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5357	1715609373823	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609391871	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609391871	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5345	1715609391871	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609392873	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609392873	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5345	1715609392873	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609398892	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609398892	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5324	1715609398892	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609399894	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609399894	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5332	1715609399894	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609421958	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609421958	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5365	1715609421958	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609422960	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609422960	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5365	1715609422960	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609423983	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609424987	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609431000	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609433006	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609434013	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609076014	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.9	1715609076014	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5183	1715609076014	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609078022	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609078022	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5171	1715609078022	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609082034	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.1	1715609082034	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5179	1715609082034	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609085066	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609092064	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.3	1715609092064	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5135	1715609092064	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609106128	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609348780	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609362818	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609364821	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609367827	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609368836	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609372840	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609373843	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609391895	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609392902	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609398914	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609399922	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609421988	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609423963	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609423963	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5334	1715609423963	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	99	1715609424965	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715609424965	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5334	1715609424965	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609430981	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609430981	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5345999999999997	1715609430981	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609432986	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.4	1715609432986	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5345	1715609432986	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609433988	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609433988	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5345	1715609433988	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609437999	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609437999	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5375	1715609437999	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609441027	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609445037	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609448048	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609449059	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609451062	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609454070	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609461086	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609463087	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609534265	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609534265	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5388	1715609534265	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609535268	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.9	1715609535268	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5388	1715609535268	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609536271	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609536271	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5388	1715609536271	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609539278	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609539278	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5370999999999997	1715609539278	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609076041	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609078047	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609085042	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.300000000000001	1715609085042	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.512	1715609085042	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609086071	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609092079	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609108109	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8.100000000000001	1715609108109	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5194	1715609108109	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609109113	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609109113	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5194	1715609109113	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609109140	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609110115	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609110115	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5194	1715609110115	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609110142	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609111118	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609111118	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5179	1715609111118	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609111143	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609112120	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609112120	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5179	1715609112120	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609112143	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609113123	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.7	1715609113123	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5179	1715609113123	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609113140	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609114125	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609114125	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.517	1715609114125	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609114146	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609115127	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8.100000000000001	1715609115127	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.517	1715609115127	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609115147	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609116132	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.5	1715609116132	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.517	1715609116132	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609116154	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609117134	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609117134	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5183	1715609117134	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609117152	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609118137	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609118137	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5183	1715609118137	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609118156	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609119139	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609119139	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5183	1715609119139	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609119169	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609120142	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609120142	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5162	1715609120142	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609120167	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609121145	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.499999999999998	1715609121145	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5162	1715609121145	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609121170	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609122147	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609122147	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5162	1715609122147	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609126156	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609126156	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5214000000000003	1715609126156	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609127158	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609127158	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5214000000000003	1715609127158	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609128177	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609130191	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609131195	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609132192	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609135208	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609136212	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609137209	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609143204	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609143204	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5225	1715609143204	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609147213	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609147213	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5233000000000003	1715609147213	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609158243	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609158243	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5231999999999997	1715609158243	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609159271	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609162278	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609168287	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609349758	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	12.2	1715609349758	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5286	1715609349758	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609353769	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609353769	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305	1715609353769	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609354771	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609354771	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5316	1715609354771	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609356798	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609360787	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609360787	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.531	1715609360787	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609361789	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.799999999999999	1715609361789	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.531	1715609361789	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609363797	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609363797	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5315	1715609363797	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609366805	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609366805	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5326999999999997	1715609366805	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609369832	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609370836	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609371838	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609379838	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609379838	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5366	1715609379838	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609380840	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609380840	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5366	1715609380840	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609384850	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609384850	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311	1715609384850	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609387859	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609387859	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.533	1715609387859	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609394881	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609122172	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609126182	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609127186	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609130166	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.499999999999998	1715609130166	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.524	1715609130166	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609131168	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609131168	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.524	1715609131168	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609132173	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609132173	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5238	1715609132173	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609135183	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.7	1715609135183	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5231999999999997	1715609135183	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609136186	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609136186	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5231999999999997	1715609136186	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609137188	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609137188	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5231999999999997	1715609137188	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609142228	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609143227	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609147234	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609158259	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609162253	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609162253	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5255	1715609162253	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609168267	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609168267	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5258000000000003	1715609168267	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609349787	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609353789	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609354790	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609359806	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609360817	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609361807	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609363822	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609369812	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.3	1715609369812	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5366	1715609369812	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609370815	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.3	1715609370815	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5366	1715609370815	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609371817	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609371817	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5366	1715609371817	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609378854	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609379865	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609380867	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609384869	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609387883	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609394899	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609395910	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609396907	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609403931	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609406939	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609407942	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609412952	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609415960	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609418947	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609418947	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5358	1715609418947	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609425967	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609425967	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609123149	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609123149	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5193000000000003	1715609123149	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609129163	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609129163	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.524	1715609129163	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609134181	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609134181	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5238	1715609134181	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609138190	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609138190	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5218000000000003	1715609138190	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609141198	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609141198	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5225	1715609141198	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609149219	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609149219	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5233000000000003	1715609149219	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609150221	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609150221	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5254000000000003	1715609150221	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609151223	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609151223	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5254000000000003	1715609151223	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609152228	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609152228	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5254000000000003	1715609152228	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609160248	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609160248	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5233000000000003	1715609160248	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609163275	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609350761	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609350761	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5286	1715609350761	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609351763	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609351763	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305	1715609351763	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609352766	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609352766	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5305	1715609352766	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	106	1715609355774	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.7	1715609355774	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5316	1715609355774	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609356776	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609356776	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5316	1715609356776	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609358802	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609366830	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609374847	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	110	1715609381842	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609381842	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5361	1715609381842	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609385879	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609389865	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609389865	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.533	1715609389865	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609390869	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609390869	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5345	1715609390869	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609393876	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609393876	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5357	1715609393876	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609400897	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609400897	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609123180	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609129194	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609134200	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609138214	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609141225	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609149245	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609150249	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609151249	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609152257	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609160279	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609350789	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609351788	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609352794	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609355794	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609358782	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	12.399999999999999	1715609358782	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5317	1715609358782	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609359784	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609359784	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5317	1715609359784	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609374825	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.3	1715609374825	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5357	1715609374825	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609375828	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609375828	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5376999999999996	1715609375828	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609381869	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609386856	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609386856	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311	1715609386856	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609389890	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609390894	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609393902	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609400922	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609401923	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609402929	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609408937	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609409940	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609416941	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609416941	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5365	1715609416941	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609420953	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609420953	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5365	1715609420953	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609428976	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609428976	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5361	1715609428976	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609430002	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609436996	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.799999999999999	1715609436996	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5375	1715609436996	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609452036	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609452036	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5393000000000003	1715609452036	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609453039	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.3	1715609453039	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5375	1715609453039	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609457051	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609457051	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5391	1715609457051	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609464068	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8.2	1715609464068	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.536	1715609464068	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609537273	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609124151	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609124151	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5193000000000003	1715609124151	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609125154	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609125154	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5193000000000003	1715609125154	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609128161	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609128161	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5214000000000003	1715609128161	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609139218	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609140222	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609144206	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609144206	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5224	1715609144206	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609145208	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	12.2	1715609145208	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5224	1715609145208	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609148216	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609148216	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5233000000000003	1715609148216	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609155235	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609155235	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.522	1715609155235	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609159245	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609159245	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5233000000000003	1715609159245	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609166262	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609166262	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5256999999999996	1715609166262	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609167264	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609167264	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5256999999999996	1715609167264	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609357778	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609357778	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5317	1715609357778	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609365802	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.6000000000000005	1715609365802	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5315	1715609365802	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609375850	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609376855	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609377860	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609382845	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609382845	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5361	1715609382845	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609383848	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609383848	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5361	1715609383848	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609385853	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609385853	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5311	1715609385853	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609388863	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609388863	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.533	1715609388863	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609397889	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609397889	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5324	1715609397889	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609404908	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609404908	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5343	1715609404908	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609405911	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609405911	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5334	1715609405911	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609410923	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609410923	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609124177	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609125178	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609139193	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.199999999999999	1715609139193	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5218000000000003	1715609139193	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609140195	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609140195	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5218000000000003	1715609140195	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609142201	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.4	1715609142201	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5225	1715609142201	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609144229	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609145237	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609148235	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609155260	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609163255	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609163255	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5255	1715609163255	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609166277	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609167293	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609357800	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609365823	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609376830	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609376830	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5376999999999996	1715609376830	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609377833	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	10.600000000000001	1715609377833	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5376999999999996	1715609377833	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609378835	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609378835	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5366	1715609378835	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609382870	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609383874	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609386883	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609388888	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609397916	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609404925	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609405934	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609410943	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609411953	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609413956	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609417961	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609419975	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609426970	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609426970	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5361	1715609426970	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609431983	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.799999999999999	1715609431983	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5345999999999997	1715609431983	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609435994	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609435994	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5375	1715609435994	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609440005	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609440005	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5383	1715609440005	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609441007	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609441007	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5383	1715609441007	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609442037	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609444043	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609455069	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609456066	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609465070	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609465070	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5387	1715609465070	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609133176	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.799999999999999	1715609133176	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5238	1715609133176	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609146211	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609146211	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5224	1715609146211	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609153231	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609153231	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.522	1715609153231	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609154233	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609154233	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.522	1715609154233	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609156238	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.1000000000000005	1715609156238	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5231999999999997	1715609156238	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609157240	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609157240	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5231999999999997	1715609157240	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609161251	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.499999999999998	1715609161251	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5233000000000003	1715609161251	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609164258	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	6.8999999999999995	1715609164258	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5255	1715609164258	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609165260	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.8	1715609165260	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5256999999999996	1715609165260	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609394881	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5357	1715609394881	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609395883	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609395883	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5357	1715609395883	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609396886	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609396886	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5324	1715609396886	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609403905	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609403905	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5343	1715609403905	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609406913	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609406913	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5334	1715609406913	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609407916	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609407916	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5334	1715609407916	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609412929	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609412929	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.537	1715609412929	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609415939	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609415939	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5365	1715609415939	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609417944	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609417944	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5358	1715609417944	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609418967	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609425997	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609427992	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609435010	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609439027	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609443030	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609446047	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609447046	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609450049	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609458073	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609459083	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609133195	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609146239	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609153259	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609154262	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609156265	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609157265	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609161270	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609164286	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609165286	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5332	1715609400897	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609401900	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609401900	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5332	1715609401900	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	115.9	1715609402902	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609402902	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5343	1715609402902	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609408918	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609408918	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5366	1715609408918	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609409921	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609409921	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5366	1715609409921	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609414935	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609414935	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5365	1715609414935	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609416963	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609420981	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609429002	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609434991	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.7	1715609434991	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5345	1715609434991	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609437022	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609452062	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609453063	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609457076	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609464085	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5370999999999997	1715609537273	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609553318	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609553318	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5366	1715609553318	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609557328	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609557328	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5382	1715609557328	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609558359	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.799999999999999	1715609570365	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.54	1715609570365	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609571367	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609571367	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.54	1715609571367	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609573402	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609575410	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609578405	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609579389	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609579389	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5425	1715609579389	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609579418	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609580393	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609580393	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5425	1715609580393	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609580422	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609581395	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609581395	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5425	1715609581395	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609581425	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609582397	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609582397	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5419	1715609582397	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609583400	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609583400	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5419	1715609583400	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609584403	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609584403	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5419	1715609584403	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609589415	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8	1715609589415	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5416	1715609589415	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609590418	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609590418	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5416	1715609590418	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609595434	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609595434	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5425	1715609595434	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609597440	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609597440	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5416	1715609597440	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609598442	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609598442	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5416	1715609598442	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609601450	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609601450	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5419	1715609601450	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609602452	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609602452	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5419	1715609602452	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609603455	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609603455	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5416999999999996	1715609603455	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609604483	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609605493	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609606488	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609607493	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609608486	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609582421	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609583418	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609589444	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609590443	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609597469	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609599444	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609599444	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5416	1715609599444	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609600448	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	8.2	1715609600448	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5419	1715609600448	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609601481	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609602472	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609584428	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609585437	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609591420	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609591420	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5437	1715609591420	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609592423	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609592423	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5437	1715609592423	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609593428	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609593428	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5437	1715609593428	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609596437	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609596437	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5425	1715609596437	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609598458	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609609471	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609609471	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5428	1715609609471	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609585405	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.2	1715609585405	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5427	1715609585405	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609591441	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609592452	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609593447	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609596463	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609603483	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609609497	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609586408	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.6	1715609586408	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5427	1715609586408	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	101	1715609587410	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.3	1715609587410	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5427	1715609587410	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	105	1715609588413	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609588413	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5416	1715609588413	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609594430	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.5	1715609594430	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5425	1715609594430	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609599470	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609586433	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609587429	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609588441	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609594454	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609595458	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Swap Memory GB	0.0482	1715609600476	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609604457	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7	1715609604457	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5416999999999996	1715609604457	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	102	1715609605460	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	9.899999999999999	1715609605460	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5416999999999996	1715609605460	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609606463	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	5.6	1715609606463	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5419	1715609606463	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	104	1715609607466	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609607466	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5419	1715609607466	eea214e99e6044f19adf470b752e50d5	0	f
TOP - CPU Utilization	103	1715609608468	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Utilization	7.3	1715609608468	eea214e99e6044f19adf470b752e50d5	0	f
TOP - Memory Usage GB	2.5419	1715609608468	eea214e99e6044f19adf470b752e50d5	0	f
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
letter	0	eea214e99e6044f19adf470b752e50d5
workload	0	eea214e99e6044f19adf470b752e50d5
listeners	smi+top+dcgmi	eea214e99e6044f19adf470b752e50d5
params	'"-"'	eea214e99e6044f19adf470b752e50d5
file	cifar10.py	eea214e99e6044f19adf470b752e50d5
workload_listener	''	eea214e99e6044f19adf470b752e50d5
model	cifar10.py	eea214e99e6044f19adf470b752e50d5
manual	False	eea214e99e6044f19adf470b752e50d5
max_epoch	5	eea214e99e6044f19adf470b752e50d5
max_time	172800	eea214e99e6044f19adf470b752e50d5
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
eea214e99e6044f19adf470b752e50d5	(0 0) glamorous-mare-492	UNKNOWN			daga	FINISHED	1715608815934	1715609611362		active	s3://mlflow-storage/0/eea214e99e6044f19adf470b752e50d5/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	eea214e99e6044f19adf470b752e50d5
mlflow.source.name	file:///home/daga/radt#examples/pytorch	eea214e99e6044f19adf470b752e50d5
mlflow.source.type	PROJECT	eea214e99e6044f19adf470b752e50d5
mlflow.project.entryPoint	main	eea214e99e6044f19adf470b752e50d5
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	eea214e99e6044f19adf470b752e50d5
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	eea214e99e6044f19adf470b752e50d5
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	eea214e99e6044f19adf470b752e50d5
mlflow.project.env	conda	eea214e99e6044f19adf470b752e50d5
mlflow.project.backend	local	eea214e99e6044f19adf470b752e50d5
mlflow.runName	(0 0) glamorous-mare-492	eea214e99e6044f19adf470b752e50d5
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

