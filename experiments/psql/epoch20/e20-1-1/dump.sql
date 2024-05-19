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
0	Default	s3://mlflow-storage/0	active	1716035339493	1716035339493
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
SMI - Power Draw	14.51	1716035607039	0	f	1749113eaede46f5856e625ba2f92dc4
SMI - Timestamp	1716035607.024	1716035607039	0	f	1749113eaede46f5856e625ba2f92dc4
SMI - GPU Util	0	1716035607039	0	f	1749113eaede46f5856e625ba2f92dc4
SMI - Mem Util	0	1716035607039	0	f	1749113eaede46f5856e625ba2f92dc4
SMI - Mem Used	0	1716035607039	0	f	1749113eaede46f5856e625ba2f92dc4
SMI - Performance State	0	1716035607039	0	f	1749113eaede46f5856e625ba2f92dc4
TOP - CPU Utilization	103	1716036101097	0	f	1749113eaede46f5856e625ba2f92dc4
TOP - Memory Usage GB	2.3566	1716036101097	0	f	1749113eaede46f5856e625ba2f92dc4
TOP - Memory Utilization	7.3	1716036101097	0	f	1749113eaede46f5856e625ba2f92dc4
TOP - Swap Memory GB	0	1716036101111	0	f	1749113eaede46f5856e625ba2f92dc4
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.51	1716035607039	1749113eaede46f5856e625ba2f92dc4	0	f
SMI - Timestamp	1716035607.024	1716035607039	1749113eaede46f5856e625ba2f92dc4	0	f
SMI - GPU Util	0	1716035607039	1749113eaede46f5856e625ba2f92dc4	0	f
SMI - Mem Util	0	1716035607039	1749113eaede46f5856e625ba2f92dc4	0	f
SMI - Mem Used	0	1716035607039	1749113eaede46f5856e625ba2f92dc4	0	f
SMI - Performance State	0	1716035607039	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	0	1716035607101	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	0	1716035607101	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.6157000000000001	1716035607101	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035607120	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	153.39999999999998	1716035608103	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.5	1716035608103	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.6157000000000001	1716035608103	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035608122	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716035609105	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5	1716035609105	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.6157000000000001	1716035609105	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035609119	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716035610107	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035610107	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8456	1716035610107	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035610121	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716035611110	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035611110	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8456	1716035611110	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035611135	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	105	1716035612112	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035612112	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8456	1716035612112	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035612127	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	104	1716035613113	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5	1716035613113	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8467	1716035613113	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035613126	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716035614115	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035614115	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8467	1716035614115	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035614563	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	106	1716035615117	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035615117	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8467	1716035615117	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035615131	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	145	1716035616119	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.7	1716035616119	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8778	1716035616119	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035616134	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	105	1716035617121	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.2	1716035617121	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8778	1716035617121	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035617138	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	105	1716035618123	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.300000000000001	1716035618123	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8778	1716035618123	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035618136	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716035619125	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035619125	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.878	1716035619125	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035619141	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	106	1716035620127	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035620127	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.878	1716035620127	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035620141	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	105	1716035621129	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5	1716035621129	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.878	1716035621129	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035621141	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035629158	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035630160	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035930748	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.9	1716035930748	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3365	1716035930748	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035936760	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035936760	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3371	1716035936760	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035937762	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035937762	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035937762	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035939766	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035939766	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035939766	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035940767	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035940767	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396999999999997	1716035940767	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035948783	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.8	1716035948783	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3356999999999997	1716035948783	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035955797	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035955797	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3415	1716035955797	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035956799	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035956799	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3415	1716035956799	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035958805	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035958805	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3413000000000004	1716035958805	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035959807	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035959807	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3413000000000004	1716035959807	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035961813	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035961813	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3407	1716035961813	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035965821	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.9	1716035965821	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396	1716035965821	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035974853	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035976858	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035981872	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035982874	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035987879	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716035622130	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.300000000000001	1716035622130	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8782	1716035622130	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716035623132	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035623132	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8782	1716035623132	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716035624134	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.6	1716035624134	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8782	1716035624134	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	104	1716035625136	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5	1716035625136	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8787	1716035625136	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035930765	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035936772	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035937776	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035939782	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035946779	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7	1716035946779	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3356999999999997	1716035946779	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035948798	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035955809	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035956821	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035958820	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035959821	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035961828	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035974838	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035974838	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3386	1716035974838	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035976842	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035976842	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3409	1716035976842	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035981854	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035981854	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.339	1716035981854	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035982856	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	10.2	1716035982856	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3377	1716035982856	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035987866	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035987866	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.34	1716035987866	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035622143	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035623145	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035624149	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035625150	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035931750	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035931750	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3356999999999997	1716035931750	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035932773	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035933770	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035938777	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035942771	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035942771	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396999999999997	1716035942771	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035945777	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035945777	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3354	1716035945777	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035949785	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035949785	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3389	1716035949785	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035950787	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035950787	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3389	1716035950787	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035957815	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035960825	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035962836	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035967825	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716035967825	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3350999999999997	1716035967825	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035968844	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035970846	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035978861	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035979865	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035985876	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	105	1716035626138	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.6	1716035626138	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8787	1716035626138	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716035628143	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035628143	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.1812	1716035628143	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035931769	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035934770	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035943773	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.6	1716035943773	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3354	1716035943773	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035944775	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7	1716035944775	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3354	1716035944775	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035950808	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035953793	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	11.3	1716035953793	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3388	1716035953793	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035954795	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.9	1716035954795	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3388	1716035954795	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035964819	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035964819	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396	1716035964819	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035966844	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035969829	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035969829	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3350999999999997	1716035969829	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035972835	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.2	1716035972835	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.339	1716035972835	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035973837	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035973837	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3386	1716035973837	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035977844	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035977844	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3409	1716035977844	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035984860	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035984860	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3377	1716035984860	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035626153	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035628155	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035932752	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035932752	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3356999999999997	1716035932752	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035933754	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035933754	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3356999999999997	1716035933754	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035938763	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035938763	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035938763	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035940781	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035942786	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035945799	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035949799	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035957801	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035957801	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3415	1716035957801	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035960810	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035960810	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3413000000000004	1716035960810	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035962815	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035962815	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3407	1716035962815	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035966823	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035966823	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396	1716035966823	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035967842	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035970831	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7	1716035970831	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.339	1716035970831	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035978848	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035978848	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3409	1716035978848	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035979850	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.6	1716035979850	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.339	1716035979850	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035985862	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.9	1716035985862	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.34	1716035985862	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716035627140	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.2	1716035627140	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	1.8787	1716035627140	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035934756	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035934756	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3371	1716035934756	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035941793	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035943787	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035944790	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035951804	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035953806	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035954809	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035964834	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035968827	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035968827	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3350999999999997	1716035968827	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035969844	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035972848	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035973851	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035980852	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.2	1716035980852	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.339	1716035980852	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035984876	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035627155	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035935758	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.2	1716035935758	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3371	1716035935758	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035941769	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035941769	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396999999999997	1716035941769	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035947781	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035947781	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3356999999999997	1716035947781	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035951789	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035951789	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3389	1716035951789	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035952812	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035963832	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035971833	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035971833	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.339	1716035971833	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035975840	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035975840	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3386	1716035975840	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035977862	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035983858	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035983858	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3377	1716035983858	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035986864	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035986864	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.34	1716035986864	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035988870	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.9	1716035988870	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3363	1716035988870	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035989871	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035989871	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3363	1716035989871	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	99	1716035629145	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035629145	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.1812	1716035629145	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716035630147	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035630147	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.1812	1716035630147	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716035631149	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035631149	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4054	1716035631149	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035631162	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716035632151	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035632151	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4054	1716035632151	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035632164	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716035633153	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5	1716035633153	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4054	1716035633153	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035633167	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716035634155	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.7	1716035634155	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4079	1716035634155	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035634168	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	104	1716035635157	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035635157	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4079	1716035635157	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035635171	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716035636159	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035636159	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4079	1716035636159	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035636175	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716035637161	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035637161	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4075	1716035637161	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035637176	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716035638163	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5	1716035638163	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4075	1716035638163	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035638178	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716035639165	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035639165	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4075	1716035639165	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035639180	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	104	1716035640167	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035640167	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4113	1716035640167	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035640184	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716035641169	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.7	1716035641169	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4113	1716035641169	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035641191	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716035642171	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.300000000000001	1716035642171	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4113	1716035642171	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035642190	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716035643173	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.2	1716035643173	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4112	1716035643173	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035643188	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716035644175	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.8999999999999995	1716035644175	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4112	1716035644175	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035644197	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716035645177	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.7	1716035645177	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4112	1716035645177	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716035647181	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.300000000000001	1716035647181	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.413	1716035647181	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035660205	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.8	1716035660205	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3204000000000002	1716035660205	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035662209	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035662209	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3236	1716035662209	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035665215	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035665215	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3245999999999998	1716035665215	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035669240	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035677237	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.6	1716035677237	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3275	1716035677237	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035678256	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035935776	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035946802	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035947803	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035952791	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	1.7	1716035952791	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3388	1716035952791	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035963817	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035963817	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3407	1716035963817	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035965841	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035971847	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035975854	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035980870	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035983871	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035986879	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035988883	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035989887	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035645192	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035647194	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035660218	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035662222	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035665228	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035671241	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035677253	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035681264	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035990874	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.9	1716035990874	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3363	1716035990874	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035991876	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035991876	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3373000000000004	1716035991876	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035992892	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035993893	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036000910	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036002912	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716036011916	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716036011916	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3406	1716036011916	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036012918	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716036012918	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3414	1716036012918	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036013920	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6	1716036013920	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3414	1716036013920	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036015937	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036018951	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036030967	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716036040973	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716036040973	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3436999999999997	1716036040973	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036043978	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716036043978	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3444000000000003	1716036043978	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716035646179	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	10.1	1716035646179	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.413	1716035646179	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716035649185	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.300000000000001	1716035649185	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4116999999999997	1716035649185	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035657200	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.300000000000001	1716035657200	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3226	1716035657200	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035658202	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035658202	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3204000000000002	1716035658202	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035661207	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.199999999999999	1716035661207	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3236	1716035661207	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035663211	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.8	1716035663211	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3236	1716035663211	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035666217	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035666217	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3245999999999998	1716035666217	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035667219	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035667219	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3245999999999998	1716035667219	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035671226	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.300000000000001	1716035671226	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.326	1716035671226	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035673243	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035675248	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035681245	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035681245	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3293000000000004	1716035681245	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035684251	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035684251	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3289	1716035684251	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035686255	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035686255	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3287	1716035686255	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035689261	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035689261	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301999999999996	1716035689261	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035990891	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035992877	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.9	1716035992877	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3373000000000004	1716035992877	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	0	1716035993879	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	0	1716035993879	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3373000000000004	1716035993879	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036000895	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.7	1716036000895	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396999999999997	1716036000895	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036002898	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036002898	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396999999999997	1716036002898	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036008927	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036011932	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036012934	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036015924	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.7	1716036015924	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3407	1716036015924	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036018931	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716036018931	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3404000000000003	1716036018931	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036030953	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035646196	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035649201	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035657215	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035659218	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035661221	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035663226	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035666231	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035667233	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	0	1716035673230	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	0	1716035673230	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3274	1716035673230	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035675234	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035675234	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3274	1716035675234	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035676235	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035676235	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3275	1716035676235	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035683265	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035684269	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035688259	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.1	1716035688259	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301999999999996	1716035688259	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035991891	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035995900	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035996900	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036001915	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036007907	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716036007907	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396999999999997	1716036007907	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716036009911	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716036009911	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3406	1716036009911	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716036010914	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	10.299999999999999	1716036010914	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3406	1716036010914	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036014922	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.9	1716036014922	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3414	1716036014922	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036016925	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716036016925	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3407	1716036016925	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716036019933	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716036019933	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3404000000000003	1716036019933	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036023940	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716036023940	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3408	1716036023940	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036026945	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716036026945	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3413000000000004	1716036026945	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036027947	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.2	1716036027947	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3414	1716036027947	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036035963	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716036035963	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3409	1716036035963	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036036965	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716036036965	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3408	1716036036965	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036039991	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036045002	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036047005	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036050005	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716035648183	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035648183	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.413	1716035648183	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716035650186	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5	1716035650186	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4116999999999997	1716035650186	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716035651188	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035651188	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.4116999999999997	1716035651188	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	38	1716035652190	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5	1716035652190	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3193	1716035652190	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035653192	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035653192	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3193	1716035653192	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035654194	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035654194	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3193	1716035654194	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035655210	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035664228	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035668233	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035672228	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035672228	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.326	1716035672228	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035676250	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035679258	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035685253	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.199999999999999	1716035685253	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3287	1716035685253	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035690263	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035690263	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301999999999996	1716035690263	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035994883	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.9	1716035994883	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3403	1716035994883	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035997888	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035997888	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3394	1716035997888	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035998890	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035998890	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3394	1716035998890	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036003916	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036013934	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036020956	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036021953	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036022956	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036025959	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036031977	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036032979	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036034975	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036038991	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036041996	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036048011	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035648198	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035650201	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035651203	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035652205	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035653207	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035655196	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035655196	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3226	1716035655196	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035664213	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035664213	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3245999999999998	1716035664213	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035668220	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035668220	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3245999999999998	1716035668220	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035669222	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035669222	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3245999999999998	1716035669222	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035672243	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035679241	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035679241	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3293000000000004	1716035679241	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035682265	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035685265	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035690275	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035994896	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035997903	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035998905	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036006905	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716036006905	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396999999999997	1716036006905	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036020934	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.9	1716036020934	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3404000000000003	1716036020934	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716036021936	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716036021936	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3408	1716036021936	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036022939	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7	1716036022939	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3408	1716036022939	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	0	1716036025944	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	0	1716036025944	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3413000000000004	1716036025944	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716036031955	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716036031955	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3406	1716036031955	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036032957	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716036032957	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3406	1716036032957	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036034961	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.2	1716036034961	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3409	1716036034961	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716036038969	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716036038969	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3408	1716036038969	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036041975	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036041975	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3436999999999997	1716036041975	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036047986	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.4	1716036047986	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3436	1716036047986	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036048989	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716036048989	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3427	1716036048989	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035654209	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035656213	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035659204	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035659204	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3204000000000002	1716035659204	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035670238	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035674249	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035680243	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.5	1716035680243	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3293000000000004	1716035680243	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035682247	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035682247	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3289	1716035682247	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035686272	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035687274	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035689284	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035995885	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035995885	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3403	1716035995885	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035996886	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035996886	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3403	1716035996886	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035999910	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716036003900	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716036003900	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3414	1716036003900	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036008909	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7	1716036008909	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396999999999997	1716036008909	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036009929	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036010929	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036014937	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036016940	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036019958	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036023961	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036026959	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036027967	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036035979	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036039971	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716036039971	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3436999999999997	1716036039971	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036044980	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716036044980	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3444000000000003	1716036044980	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036046984	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716036046984	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3436	1716036046984	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036049990	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.2	1716036049990	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3427	1716036049990	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035656198	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035656198	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3226	1716035656198	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035658218	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035670224	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035670224	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.326	1716035670224	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035674232	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035674232	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3274	1716035674232	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035678239	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035678239	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3275	1716035678239	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035680258	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035683249	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.6	1716035683249	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3289	1716035683249	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035687257	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035687257	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3287	1716035687257	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035688274	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035691265	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.199999999999999	1716035691265	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3306999999999998	1716035691265	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035691284	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035692267	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035692267	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3306999999999998	1716035692267	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035692282	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035693269	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035693269	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3306999999999998	1716035693269	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035693286	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035694271	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.199999999999999	1716035694271	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301999999999996	1716035694271	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035694286	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035695274	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035695274	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301999999999996	1716035695274	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035695289	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035696276	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035696276	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301999999999996	1716035696276	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035696294	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035697278	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035697278	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3295	1716035697278	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035697296	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035698280	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035698280	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3295	1716035698280	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035698293	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035699282	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035699282	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3295	1716035699282	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035699296	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035700284	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035700284	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3266999999999998	1716035700284	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035700296	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035701286	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035701286	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3266999999999998	1716035701286	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035701299	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035714309	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035714309	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3282	1716035714309	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035715310	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035715310	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3291999999999997	1716035715310	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035716329	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035719333	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035720335	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035721339	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035726333	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035726333	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3298	1716035726333	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035728338	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035728338	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3298	1716035728338	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035732367	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035733362	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035735370	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035740363	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	1.6	1716035740363	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3310999999999997	1716035740363	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035745373	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035745373	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3303000000000003	1716035745373	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035749381	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.299999999999999	1716035749381	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301	1716035749381	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035999892	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035999892	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3394	1716035999892	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716036004902	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036004902	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3414	1716036004902	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036005904	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.699999999999999	1716036005904	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3414	1716036005904	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036006921	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716036017927	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716036017927	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3407	1716036017927	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036024942	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.2	1716036024942	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3413000000000004	1716036024942	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036028949	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716036028949	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3414	1716036028949	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036029951	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716036029951	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3414	1716036029951	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036033959	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.2	1716036033959	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3409	1716036033959	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036037967	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716036037967	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3408	1716036037967	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716036042977	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716036042977	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3444000000000003	1716036042977	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716036045982	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.6	1716036045982	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3436	1716036045982	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036049008	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035702288	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.199999999999999	1716035702288	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3266999999999998	1716035702288	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035708299	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035708299	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3306	1716035708299	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035710303	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035710303	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3313	1716035710303	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035725331	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035725331	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3298	1716035725331	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035729341	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035729341	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3298	1716035729341	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035730343	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035730343	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3319	1716035730343	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035734368	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	5	1716035741365	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035741365	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3310999999999997	1716035741365	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035742367	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035742367	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3324000000000003	1716035742367	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035744371	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035744371	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3324000000000003	1716035744371	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035745387	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035749397	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716036001896	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716036001896	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396999999999997	1716036001896	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036004917	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036005920	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036007924	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036017940	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036024964	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036028970	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036029965	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036033979	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036037988	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036042995	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036045996	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035702303	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035708315	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035710318	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035727356	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035729362	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035734351	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035734351	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3334	1716035734351	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035736373	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035741387	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035742389	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035744385	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035747398	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716036030953	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3406	1716036030953	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036036978	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036040986	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036043994	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035703290	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035703290	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301999999999996	1716035703290	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035704291	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035704291	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301999999999996	1716035704291	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035706308	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035707314	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035709316	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035711323	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035712322	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035713325	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035717330	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035723328	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.300000000000001	1716035723328	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3308	1716035723328	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035724350	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035727335	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035727335	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3298	1716035727335	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035737357	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035737357	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3298	1716035737357	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035738359	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.6	1716035738359	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3298	1716035738359	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035739361	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035739361	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3310999999999997	1716035739361	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035743384	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035747377	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.6	1716035747377	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3303000000000003	1716035747377	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	9	1716036050992	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.9	1716036050992	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3427	1716036050992	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036053018	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036056014	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716036059009	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716036059009	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3519	1716036059009	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036066038	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036070048	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036072057	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036082080	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036089093	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716036093080	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716036093080	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3549	1716036093080	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036097103	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036099106	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035703304	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035706295	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.300000000000001	1716035706295	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3306	1716035706295	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035707297	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035707297	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3306	1716035707297	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035709301	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035709301	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3313	1716035709301	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035711305	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035711305	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3313	1716035711305	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035712306	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035712306	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3282	1716035712306	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035713308	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035713308	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3282	1716035713308	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035717315	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035717315	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3291999999999997	1716035717315	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035722341	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035724330	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.7	1716035724330	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3298	1716035724330	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035725345	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035730356	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035737380	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035738373	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035739384	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035746399	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036051007	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036052009	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036054019	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036060026	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036069030	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036069030	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3534	1716036069030	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036073038	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036073038	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3545	1716036073038	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	100	1716036076044	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716036076044	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3543000000000003	1716036076044	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716036077046	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036077046	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3543000000000003	1716036077046	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036079066	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036084082	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036085076	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036092099	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036101111	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035704307	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035714324	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035715324	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035719320	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035719320	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301	1716035719320	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035720322	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035720322	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301	1716035720322	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035721324	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035721324	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3308	1716035721324	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035722326	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035722326	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3308	1716035722326	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035726356	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035728355	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035733349	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035733349	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3334	1716035733349	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035735353	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035735353	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3334	1716035735353	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035736355	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035736355	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3298	1716035736355	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035740379	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035746375	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035746375	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3303000000000003	1716035746375	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716036051994	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.3	1716036051994	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3531999999999997	1716036051994	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	100	1716036053998	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716036053998	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3531999999999997	1716036053998	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	104	1716036060011	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	13	1716036060011	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3519	1716036060011	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716036066023	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6	1716036066023	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3518000000000003	1716036066023	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036069052	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036073060	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036076058	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036077060	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716036084060	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716036084060	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.353	1716036084060	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716036085062	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7	1716036085062	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.353	1716036085062	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036092078	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036092078	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3543000000000003	1716036092078	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036097088	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6	1716036097088	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3563	1716036097088	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035705293	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035705293	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301999999999996	1716035705293	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035716314	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035716314	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3291999999999997	1716035716314	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035718331	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035731345	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035731345	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3319	1716035731345	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	5	1716035732347	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035732347	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3319	1716035732347	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035748379	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.7	1716035748379	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301	1716035748379	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035750383	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035750383	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301	1716035750383	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	106	1716036052996	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	10.099999999999998	1716036052996	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3531999999999997	1716036052996	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716036056002	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716036056002	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3486	1716036056002	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036058029	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036059030	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716036070032	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716036070032	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3534	1716036070032	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036072036	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	11.599999999999998	1716036072036	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3545	1716036072036	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	104	1716036080052	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036080052	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3499	1716036080052	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036089071	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036089071	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.353	1716036089071	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036090094	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036093101	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036099092	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.399999999999999	1716036099092	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3566	1716036099092	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036100109	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035705307	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035718317	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6	1716035718317	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3301	1716035718317	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035723344	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035731363	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035743369	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035743369	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3324000000000003	1716035743369	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035748393	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035750408	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035751385	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.6	1716035751385	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3329	1716035751385	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035751408	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035752387	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035752387	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3329	1716035752387	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035752411	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035753389	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.6	1716035753389	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3329	1716035753389	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035753404	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035754391	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716035754391	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3318000000000003	1716035754391	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035754416	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	5	1716035755393	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035755393	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3318000000000003	1716035755393	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035755407	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035756395	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035756395	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3318000000000003	1716035756395	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035756412	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035757397	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035757397	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.333	1716035757397	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035757412	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035758399	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716035758399	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.333	1716035758399	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035758414	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035759401	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.6	1716035759401	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.333	1716035759401	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035759424	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035760403	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035760403	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3337	1716035760403	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035760423	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035761405	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.199999999999999	1716035761405	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3337	1716035761405	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035761424	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035762408	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	10.2	1716035762408	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3337	1716035762408	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035762429	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035763410	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.7	1716035763410	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.333	1716035763410	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035763434	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035764412	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.6	1716035764412	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.333	1716035764412	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035765416	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.7	1716035765416	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.333	1716035765416	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035766443	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035767434	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035773432	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035773432	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3346999999999998	1716035773432	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035774448	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035777456	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035778457	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035780468	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035783451	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.6	1716035783451	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.334	1716035783451	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035788475	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035797499	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035806497	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035806497	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3346999999999998	1716035806497	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035808501	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035808501	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3313	1716035808501	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036055000	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.3	1716036055000	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3486	1716036055000	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716036057004	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7	1716036057004	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3486	1716036057004	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716036058006	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716036058006	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3519	1716036058006	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036068050	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036074062	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	104	1716036083058	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036083058	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3516	1716036083058	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716036091076	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716036091076	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3543000000000003	1716036091076	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036094082	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.3	1716036094082	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3549	1716036094082	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036101097	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.3	1716036101097	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3566	1716036101097	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035764434	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035766418	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035766418	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3352	1716035766418	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035767420	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.6	1716035767420	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3352	1716035767420	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035769441	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035773446	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035777440	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035777440	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3294	1716035777440	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035778442	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035778442	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3312	1716035778442	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035780445	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.7	1716035780445	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3312	1716035780445	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035781470	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035788461	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035788461	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3348	1716035788461	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035789486	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035805507	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035806511	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036055015	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036057027	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716036064019	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6	1716036064019	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.35	1716036064019	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716036074040	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716036074040	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3545	1716036074040	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	99	1716036079050	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716036079050	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3499	1716036079050	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036083078	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036091090	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036094097	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035765453	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035774434	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035774434	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3346999999999998	1716035774434	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035775452	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035776452	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035784453	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035784453	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3341999999999996	1716035784453	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035785455	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035785455	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3341999999999996	1716035785455	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035787459	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035787459	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3348	1716035787459	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035793471	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035793471	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035793471	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035795474	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035795474	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035795474	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035797478	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.1999999999999997	1716035797478	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035797478	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035810522	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716036061013	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716036061013	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3509	1716036061013	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716036062016	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.3	1716036062016	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3509	1716036062016	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	104	1716036063017	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036063017	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.35	1716036063017	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036064032	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036065034	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036067048	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716036071034	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.3	1716036071034	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3534	1716036071034	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036075042	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	9.799999999999999	1716036075042	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3543000000000003	1716036075042	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036078048	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716036078048	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3499	1716036078048	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036080075	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036081076	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	100	1716036086064	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716036086064	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.353	1716036086064	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036087066	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.3	1716036087066	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.353	1716036087066	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036088069	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6	1716036088069	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.353	1716036088069	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716036090074	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6	1716036090074	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3543000000000003	1716036090074	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036095099	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036096099	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036098104	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035768422	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035768422	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3352	1716035768422	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035769424	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035769424	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3359	1716035769424	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035772448	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035779457	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035782449	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035782449	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.334	1716035782449	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035786479	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035791467	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.8	1716035791467	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3362	1716035791467	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035794472	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035794472	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035794472	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035796476	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035796476	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035796476	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035798479	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035798479	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035798479	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035800483	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035800483	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3364000000000003	1716035800483	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035801500	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035802505	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035803506	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035804510	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035808513	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036061028	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036062037	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036063036	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036065021	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	10.2	1716036065021	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.35	1716036065021	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716036067026	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036067026	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3518000000000003	1716036067026	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036068028	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.399999999999999	1716036068028	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3518000000000003	1716036068028	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036071048	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036075057	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036078063	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	104	1716036081054	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	8.1	1716036081054	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3516	1716036081054	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	102	1716036082056	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	13	1716036082056	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3516	1716036082056	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036086081	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036087081	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716036088090	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716036095084	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716036095084	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3549	1716036095084	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036096086	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7	1716036096086	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3563	1716036096086	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	103	1716036098090	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036098090	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035768446	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035770426	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035770426	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3359	1716035770426	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035779444	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035779444	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3312	1716035779444	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035781447	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035781447	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.334	1716035781447	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035786457	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035786457	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3341999999999996	1716035786457	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035790486	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035791481	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035794488	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035796499	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035798499	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035800498	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035802489	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.699999999999999	1716035802489	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3335	1716035802489	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035803491	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035803491	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3335	1716035803491	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035804493	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035804493	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3335	1716035804493	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035805495	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035805495	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3346999999999998	1716035805495	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3563	1716036098090	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	101	1716036100094	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716036100094	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3566	1716036100094	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035770447	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035771452	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035787474	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035792469	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	1.6	1716035792469	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3362	1716035792469	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035799481	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035799481	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3364000000000003	1716035799481	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035801485	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035801485	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3364000000000003	1716035801485	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035807515	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035809520	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035771428	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.7	1716035771428	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3359	1716035771428	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035782468	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035789463	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035789463	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3348	1716035789463	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035792482	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035799498	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035807499	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035807499	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3346999999999998	1716035807499	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035809503	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035809503	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3313	1716035809503	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035772430	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035772430	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3346999999999998	1716035772430	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035775436	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035775436	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3294	1716035775436	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035776438	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035776438	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3294	1716035776438	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035783467	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035784470	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035785472	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035790465	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035790465	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3362	1716035790465	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035793484	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035795495	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035810505	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.300000000000001	1716035810505	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3313	1716035810505	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035811507	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035811507	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3333000000000004	1716035811507	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035811522	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035812509	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035812509	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3333000000000004	1716035812509	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035812523	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035813511	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035813511	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3333000000000004	1716035813511	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035813525	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035814513	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035814513	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3350999999999997	1716035814513	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035814525	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035815516	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035815516	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3350999999999997	1716035815516	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035815529	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035816518	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035816518	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3350999999999997	1716035816518	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035816533	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035817520	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035817520	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.337	1716035817520	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035817534	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035818521	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035818521	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.337	1716035818521	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035818534	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035819523	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035819523	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.337	1716035819523	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035819538	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035820526	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035820526	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3388	1716035820526	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035820545	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035821528	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.199999999999999	1716035821528	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3388	1716035821528	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035821542	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035822530	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716035822530	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3388	1716035822530	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035826537	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716035826537	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3358000000000003	1716035826537	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035832549	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035832549	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3371999999999997	1716035832549	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035833551	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035833551	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3371999999999997	1716035833551	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035834553	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035834553	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3371999999999997	1716035834553	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035837559	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035837559	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3379000000000003	1716035837559	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035840565	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7	1716035840565	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.338	1716035840565	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035842581	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035843584	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035847593	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035853591	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035853591	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3358000000000003	1716035853591	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035858600	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035858600	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3364000000000003	1716035858600	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035860604	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035860604	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3365	1716035860604	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035861622	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035862625	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035866632	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035868637	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035822545	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035828541	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035828541	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3358000000000003	1716035828541	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035832565	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035833564	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035834566	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035837576	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035842569	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716035842569	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396	1716035842569	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035843571	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035843571	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396	1716035843571	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035847579	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035847579	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3398000000000003	1716035847579	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035851601	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035853606	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035858616	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035860618	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035862608	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035862608	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3355	1716035862608	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035866617	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035866617	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3343000000000003	1716035866617	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035868620	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035868620	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3346999999999998	1716035868620	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035823531	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035823531	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3395	1716035823531	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035825553	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035827556	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035835568	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035841582	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035845589	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035849600	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035852604	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035854605	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035855610	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035856610	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035867634	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035823545	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035827539	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035827539	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3358000000000003	1716035827539	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035835555	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035835555	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3379000000000003	1716035835555	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035841567	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035841567	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3396	1716035841567	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035845575	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035845575	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3394	1716035845575	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035849583	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035849583	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3398000000000003	1716035849583	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035852589	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035852589	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3305	1716035852589	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035854592	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035854592	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3358000000000003	1716035854592	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035855595	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035855595	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3358000000000003	1716035855595	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035856597	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035856597	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3364000000000003	1716035856597	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035867619	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035867619	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3343000000000003	1716035867619	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035869622	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035869622	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3346999999999998	1716035869622	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035824533	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035824533	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3395	1716035824533	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035828558	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035830561	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035831561	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035838576	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035859602	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035859602	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3365	1716035859602	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035863610	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035863610	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3355	1716035863610	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035865629	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035824548	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035830545	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716035830545	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3379000000000003	1716035830545	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035831547	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035831547	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3379000000000003	1716035831547	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035838561	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035838561	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.338	1716035838561	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035840581	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035859618	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035863626	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035869637	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035825535	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035825535	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3395	1716035825535	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035829543	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035829543	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3379000000000003	1716035829543	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035836557	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035836557	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3379000000000003	1716035836557	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035839563	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035839563	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.338	1716035839563	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035844573	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6	1716035844573	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3394	1716035844573	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035846577	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035846577	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3394	1716035846577	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035848581	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035848581	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3398000000000003	1716035848581	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035850585	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035850585	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3305	1716035850585	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035851587	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035851587	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3305	1716035851587	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035857615	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035864613	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035864613	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3355	1716035864613	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035865615	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035865615	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3343000000000003	1716035865615	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035826552	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035829560	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035836570	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035839581	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035844587	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035846593	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035848596	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035850600	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035857599	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035857599	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3364000000000003	1716035857599	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035861606	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035861606	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3365	1716035861606	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035864628	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035870625	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035870625	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3346999999999998	1716035870625	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035870651	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035871627	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035871627	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3323	1716035871627	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035871642	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035872629	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.300000000000001	1716035872629	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3323	1716035872629	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035872646	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	5	1716035873631	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	10.2	1716035873631	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3323	1716035873631	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035873659	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035874633	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035874633	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3316999999999997	1716035874633	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035874650	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035875635	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035875635	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3316999999999997	1716035875635	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035875652	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035876638	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035876638	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3316999999999997	1716035876638	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035876666	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035877641	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035877641	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3352	1716035877641	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035877658	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035878643	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035878643	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3352	1716035878643	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035878657	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035879647	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035879647	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3352	1716035879647	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035879665	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035880649	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035880649	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3353	1716035880649	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035880740	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035881650	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035881650	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3353	1716035881650	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035881664	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	10	1716035882652	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035882652	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3353	1716035882652	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035892673	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035892673	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3358000000000003	1716035892673	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035893689	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035902693	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035902693	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3379000000000003	1716035902693	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035904697	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035904697	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3373000000000004	1716035904697	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035909707	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035909707	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3390999999999997	1716035909707	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035912734	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035916720	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035916720	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3369	1716035916720	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035921729	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.7	1716035921729	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3321	1716035921729	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035922752	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035923750	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035882666	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035893675	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035893675	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3358000000000003	1716035893675	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035901711	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035902716	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035907724	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035912713	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.9	1716035912713	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3379000000000003	1716035912713	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035915739	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035916744	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035921750	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035923733	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.9	1716035923733	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3336	1716035923733	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035883654	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035883654	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3335	1716035883654	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035885677	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035888682	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035889692	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035894693	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035897696	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035899700	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035905721	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035910709	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.199999999999999	1716035910709	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3379000000000003	1716035910709	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035917722	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7	1716035917722	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3369	1716035917722	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035919740	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035928744	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.3	1716035928744	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3365	1716035928744	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035883667	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035886660	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035886660	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3343000000000003	1716035886660	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035887662	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.6	1716035887662	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3343000000000003	1716035887662	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035890684	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035891686	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035895694	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035896695	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035900690	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.6	1716035900690	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.335	1716035900690	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035904714	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035906722	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035908717	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035911734	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035913727	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035920727	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035920727	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3321	1716035920727	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035924758	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035884656	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035884656	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3335	1716035884656	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035892690	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035903695	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035903695	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3379000000000003	1716035903695	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035905699	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035905699	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3373000000000004	1716035905699	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035914716	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.2	1716035914716	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035914716	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035918724	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.5	1716035918724	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3369	1716035918724	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035919725	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.9	1716035919725	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3321	1716035919725	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035925738	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.2	1716035925738	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035925738	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035926740	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6	1716035926740	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035926740	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035927762	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035929768	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035884672	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035886674	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035890669	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035890669	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3352	1716035890669	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035891671	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035891671	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3352	1716035891671	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035895679	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.1	1716035895679	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3388	1716035895679	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035896681	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	3.2	1716035896681	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3388	1716035896681	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035898707	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035900704	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035906701	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035906701	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3373000000000004	1716035906701	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035908705	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035908705	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3390999999999997	1716035908705	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035911711	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.1	1716035911711	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3379000000000003	1716035911711	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035913714	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035913714	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035913714	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035915718	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035915718	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035915718	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035920740	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035926758	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035885658	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.6	1716035885658	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3335	1716035885658	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035888664	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035888664	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3343000000000003	1716035888664	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035889667	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7.199999999999999	1716035889667	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3352	1716035889667	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035894677	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6.9	1716035894677	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3358000000000003	1716035894677	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035897683	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.4	1716035897683	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3388	1716035897683	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035899688	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035899688	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.335	1716035899688	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035901692	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.800000000000001	1716035901692	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3379000000000003	1716035901692	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035909720	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035910731	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035917743	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035924735	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	7	1716035924735	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3336	1716035924735	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035928758	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035887677	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	3	1716035898686	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	5.3	1716035898686	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.335	1716035898686	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035903711	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035907703	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	6	1716035907703	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3390999999999997	1716035907703	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035914730	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035918737	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	1	1716035922731	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035922731	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3336	1716035922731	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Swap Memory GB	0	1716035925761	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	4	1716035927742	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	4.5	1716035927742	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3368	1716035927742	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - CPU Utilization	2	1716035929746	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Utilization	2.8	1716035929746	1749113eaede46f5856e625ba2f92dc4	0	f
TOP - Memory Usage GB	2.3365	1716035929746	1749113eaede46f5856e625ba2f92dc4	0	f
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
letter	0	b9ef3836efaa4b52b5054e5cbeded934
workload	0	b9ef3836efaa4b52b5054e5cbeded934
listeners	smi+top+dcgmi	b9ef3836efaa4b52b5054e5cbeded934
params	'"-"'	b9ef3836efaa4b52b5054e5cbeded934
file	cifar10.py	b9ef3836efaa4b52b5054e5cbeded934
workload_listener	''	b9ef3836efaa4b52b5054e5cbeded934
letter	0	1749113eaede46f5856e625ba2f92dc4
workload	0	1749113eaede46f5856e625ba2f92dc4
listeners	smi+top+dcgmi	1749113eaede46f5856e625ba2f92dc4
params	'"-"'	1749113eaede46f5856e625ba2f92dc4
file	cifar10.py	1749113eaede46f5856e625ba2f92dc4
workload_listener	''	1749113eaede46f5856e625ba2f92dc4
model	cifar10.py	1749113eaede46f5856e625ba2f92dc4
manual	False	1749113eaede46f5856e625ba2f92dc4
max_epoch	5	1749113eaede46f5856e625ba2f92dc4
max_time	172800	1749113eaede46f5856e625ba2f92dc4
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
b9ef3836efaa4b52b5054e5cbeded934	resilient-goose-550	UNKNOWN			daga	FAILED	1716035479894	1716035527422		active	s3://mlflow-storage/0/b9ef3836efaa4b52b5054e5cbeded934/artifacts	0	\N
1749113eaede46f5856e625ba2f92dc4	(0 0) dashing-duck-187	UNKNOWN			daga	FINISHED	1716035600467	1716036102336		active	s3://mlflow-storage/0/1749113eaede46f5856e625ba2f92dc4/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	b9ef3836efaa4b52b5054e5cbeded934
mlflow.source.name	file:///home/daga/radt#examples/pytorch	b9ef3836efaa4b52b5054e5cbeded934
mlflow.source.type	PROJECT	b9ef3836efaa4b52b5054e5cbeded934
mlflow.project.entryPoint	main	b9ef3836efaa4b52b5054e5cbeded934
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	b9ef3836efaa4b52b5054e5cbeded934
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	b9ef3836efaa4b52b5054e5cbeded934
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	b9ef3836efaa4b52b5054e5cbeded934
mlflow.runName	resilient-goose-550	b9ef3836efaa4b52b5054e5cbeded934
mlflow.project.env	conda	b9ef3836efaa4b52b5054e5cbeded934
mlflow.project.backend	local	b9ef3836efaa4b52b5054e5cbeded934
mlflow.user	daga	1749113eaede46f5856e625ba2f92dc4
mlflow.source.name	file:///home/daga/radt#examples/pytorch	1749113eaede46f5856e625ba2f92dc4
mlflow.source.type	PROJECT	1749113eaede46f5856e625ba2f92dc4
mlflow.project.entryPoint	main	1749113eaede46f5856e625ba2f92dc4
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	1749113eaede46f5856e625ba2f92dc4
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	1749113eaede46f5856e625ba2f92dc4
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	1749113eaede46f5856e625ba2f92dc4
mlflow.project.env	conda	1749113eaede46f5856e625ba2f92dc4
mlflow.project.backend	local	1749113eaede46f5856e625ba2f92dc4
mlflow.runName	(0 0) dashing-duck-187	1749113eaede46f5856e625ba2f92dc4
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

