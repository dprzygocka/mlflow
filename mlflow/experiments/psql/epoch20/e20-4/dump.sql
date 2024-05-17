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
0	Default	s3://mlflow-storage/0	active	1715614514974	1715614514974
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
SMI - Power Draw	14.84	1715614721167	0	f	6126b20453ad41dead6c37986e10f63b
SMI - Timestamp	1715614721.153	1715614721167	0	f	6126b20453ad41dead6c37986e10f63b
SMI - GPU Util	0	1715614721167	0	f	6126b20453ad41dead6c37986e10f63b
SMI - Mem Util	0	1715614721167	0	f	6126b20453ad41dead6c37986e10f63b
SMI - Mem Used	0	1715614721167	0	f	6126b20453ad41dead6c37986e10f63b
SMI - Performance State	0	1715614721167	0	f	6126b20453ad41dead6c37986e10f63b
TOP - CPU Utilization	103	1715615570117	0	f	6126b20453ad41dead6c37986e10f63b
TOP - Memory Usage GB	2.654	1715615570117	0	f	6126b20453ad41dead6c37986e10f63b
TOP - Memory Utilization	9.799999999999999	1715615570117	0	f	6126b20453ad41dead6c37986e10f63b
TOP - Swap Memory GB	0.0613	1715615570132	0	f	6126b20453ad41dead6c37986e10f63b
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
SMI - Power Draw	14.84	1715614721167	6126b20453ad41dead6c37986e10f63b	0	f
SMI - Timestamp	1715614721.153	1715614721167	6126b20453ad41dead6c37986e10f63b	0	f
SMI - GPU Util	0	1715614721167	6126b20453ad41dead6c37986e10f63b	0	f
SMI - Mem Util	0	1715614721167	6126b20453ad41dead6c37986e10f63b	0	f
SMI - Mem Used	0	1715614721167	6126b20453ad41dead6c37986e10f63b	0	f
SMI - Performance State	0	1715614721167	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	0	1715614721227	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	0	1715614721227	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	1.9935999999999998	1715614721227	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614721243	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	181.3	1715614722230	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7	1715614722230	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	1.9935999999999998	1715614722230	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614722256	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614723232	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614723232	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	1.9935999999999998	1715614723232	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614723250	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614724234	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614724234	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1855	1715614724234	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614724248	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614725236	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614725236	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1855	1715614725236	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614725254	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614726239	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614726239	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1855	1715614726239	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614726253	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614727241	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614727241	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1856999999999998	1715614727241	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614727261	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614728243	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614728243	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1856999999999998	1715614728243	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614728256	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614729245	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614729245	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1856999999999998	1715614729245	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614729258	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614730248	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614730248	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1856	1715614730248	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614730270	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614731250	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614731250	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1856	1715614731250	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614731275	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614732252	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.3	1715614732252	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1856	1715614732252	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614732281	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614733255	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.5	1715614733255	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1873	1715614733255	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614733270	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614734257	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614734257	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1873	1715614734257	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614734273	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715614735260	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614735260	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1873	1715614735260	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614735274	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614736275	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614745286	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614745286	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1887	1715614745286	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615045994	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615045994	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615045994	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615046997	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.5	1715615046997	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615046997	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615047999	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615047999	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615047999	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615050004	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615050004	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715615050004	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615051006	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615051006	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715615051006	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615052008	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615052008	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715615052008	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	98	1715615053011	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615053011	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715615053011	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	105	1715615054014	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615054014	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715615054014	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615065039	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615065039	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1958	1715615065039	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615069049	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715615069049	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615069049	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615070051	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615070051	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615070051	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615071054	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615071054	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615071054	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615075063	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615075063	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1943	1715615075063	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615076065	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615076065	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1943	1715615076065	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615077067	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615077067	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1943	1715615077067	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615078070	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8	1715615078070	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1942	1715615078070	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615079072	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615079072	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1942	1715615079072	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615080074	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615080074	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1942	1715615080074	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615081077	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615081077	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1939	1715615081077	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615082079	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615082079	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614736262	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614736262	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1877	1715614736262	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614740288	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614745299	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615046007	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615047009	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615048012	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615050025	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615051027	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615052022	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615053032	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615054029	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615065053	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615069063	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615070065	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615071068	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615075076	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615076080	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615077080	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615078083	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615079093	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615080095	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615081098	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615082092	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615083102	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615084097	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615085100	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615086109	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615087103	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615092115	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615095128	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615097133	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615100134	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6348000000000003	1715615258466	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	105	1715615261472	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	10.2	1715615261472	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6351	1715615261472	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615262474	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615262474	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6351	1715615262474	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615263477	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615263477	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6351	1715615263477	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615264479	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615264479	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6355	1715615264479	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615265481	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615265481	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6355	1715615265481	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615267485	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615267485	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6367	1715615267485	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615268487	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615268487	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6367	1715615268487	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615269489	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615269489	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6367	1715615269489	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615270491	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615270491	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6365	1715615270491	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615271494	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615271494	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6365	1715615271494	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614737264	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614737264	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1877	1715614737264	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614740272	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614740272	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1883000000000004	1715614740272	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614741288	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614742297	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615049002	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615049002	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715615049002	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615058023	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715615058023	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615058023	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615059025	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615059025	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615059025	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615060027	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615060027	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1957	1715615060027	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615061030	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615061030	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1957	1715615061030	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615062032	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615062032	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1957	1715615062032	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615088093	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615088093	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1924	1715615088093	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615089095	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615089095	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1924	1715615089095	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615090097	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615090097	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1921	1715615090097	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615091099	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615091099	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1921	1715615091099	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615093104	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615093104	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1921	1715615093104	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615094106	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615094106	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1921	1715615094106	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615101122	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615101122	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1933000000000002	1715615101122	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615102124	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615102124	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1932	1715615102124	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615103126	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.6	1715615103126	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1932	1715615103126	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615274501	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8	1715615274501	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.635	1715615274501	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615275504	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.4	1715615275504	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.635	1715615275504	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615277508	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615277508	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6342	1715615277508	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615281531	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615282539	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614737286	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614741275	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614741275	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1883000000000004	1715614741275	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614742277	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8	1715614742277	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1887	1715614742277	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615049019	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615058037	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615059047	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615060049	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615061044	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615062046	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615088105	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615089117	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615090117	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615091113	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615093125	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615094120	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615101139	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615102145	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615103147	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615275525	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615277521	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615282519	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8	1715615282519	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6363000000000003	1715615282519	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615284523	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615284523	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6363000000000003	1715615284523	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615299568	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615302583	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615308587	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615312602	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615314607	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615340638	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	2.7	1715615340638	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6370999999999998	1715615340638	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615341653	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615442869	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615445879	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615450864	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615450864	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6464000000000003	1715615450864	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615452868	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615452868	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6464000000000003	1715615452868	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615456876	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615456876	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6491	1715615456876	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615457878	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615457878	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6491	1715615457878	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615458880	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615458880	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6491	1715615458880	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615459882	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615459882	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6475999999999997	1715615459882	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615461886	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615461886	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6475999999999997	1715615461886	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615466896	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615466896	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6471	1715615466896	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614738267	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614738267	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1877	1715614738267	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715614739269	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614739269	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1883000000000004	1715614739269	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615055016	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615055016	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615055016	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615056018	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615056018	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615056018	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615057021	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615057021	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615057021	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615063034	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615063034	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1958	1715615063034	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615064037	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615064037	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1958	1715615064037	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615066041	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715615066041	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1952	1715615066041	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615067044	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615067044	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1952	1715615067044	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615068046	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.8	1715615068046	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1952	1715615068046	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615072056	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615072056	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615072056	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615096111	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8999999999999995	1715615096111	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1921	1715615096111	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615098115	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	2.6	1715615098115	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1921	1715615098115	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615099117	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615099117	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1933000000000002	1715615099117	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615284544	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615302560	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615302560	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6355999999999997	1715615302560	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615308572	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615308572	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6351	1715615308572	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615312580	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615312580	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6374	1715615312580	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615314584	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615314584	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6374	1715615314584	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615317590	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615317590	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6358	1715615317590	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615340658	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6471	1715615447858	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615451866	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615451866	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6464000000000003	1715615451866	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615453870	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614738286	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614739290	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615055031	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615056032	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615057033	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615063054	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615064051	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615066062	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615067057	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615068068	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615072071	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615096124	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615098136	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615099139	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6344000000000003	1715615311578	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615316589	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.9	1715615316589	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6358	1715615316589	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615319608	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615322621	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615323624	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615324620	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615331640	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615337631	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.7	1715615337631	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6359	1715615337631	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615338648	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3999999999999995	1715615453870	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6481999999999997	1715615453870	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615463890	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615463890	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6461	1715615463890	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615466910	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615474912	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615474912	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6475	1715615474912	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615475915	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615475915	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6475	1715615475915	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615476917	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615476917	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6475	1715615476917	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615478920	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3999999999999995	1715615478920	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6479	1715615478920	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615479922	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615479922	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6479	1715615479922	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615481925	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615481925	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.649	1715615481925	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615484931	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.899999999999999	1715615484931	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6466999999999996	1715615484931	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615486935	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3999999999999995	1715615486935	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.649	1715615486935	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	106.9	1715615488940	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3999999999999995	1715615488940	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.649	1715615488940	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615489942	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615489942	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6505	1715615489942	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615490944	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614743280	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614743280	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1887	1715614743280	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614744283	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614744283	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1887	1715614744283	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615073058	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615073058	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615073058	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615074060	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615074060	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615074060	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615104129	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615104129	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1932	1715615104129	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615105131	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615105131	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1931	1715615105131	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615322601	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615322601	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.637	1715615322601	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615323603	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615323603	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.637	1715615323603	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615324605	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615324605	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.638	1715615324605	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615331619	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615331619	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6378000000000004	1715615331619	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615335648	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615337653	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6461	1715615462888	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615464892	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615464892	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6461	1715615464892	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615467899	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615467899	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6471	1715615467899	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615469902	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615469902	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6492	1715615469902	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615470925	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615472929	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615474930	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615477919	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6479	1715615477919	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615478935	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615479945	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615481938	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615487937	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615487937	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.649	1715615487937	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615495954	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.2	1715615495954	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.651	1715615495954	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615495977	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615496958	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.2	1715615496958	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.651	1715615496958	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615496979	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615497960	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615497960	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.651	1715615497960	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614743301	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614744304	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614746288	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614746288	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1887	1715614746288	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614746309	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614747290	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614747290	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1887	1715614747290	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614747305	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	105	1715614748293	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.8	1715614748293	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1893000000000002	1715614748293	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614748307	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614749295	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614749295	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1893000000000002	1715614749295	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614749308	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614750297	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614750297	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1893000000000002	1715614750297	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614750319	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614751300	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614751300	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1891	1715614751300	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614751313	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614752303	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.3	1715614752303	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1891	1715614752303	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614752324	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614753306	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614753306	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1891	1715614753306	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614753320	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614754308	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614754308	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1881999999999997	1715614754308	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614754322	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614755310	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614755310	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1881999999999997	1715614755310	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614755323	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614756312	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.5	1715614756312	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1881999999999997	1715614756312	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614756327	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614757314	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614757314	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.188	1715614757314	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614757329	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614758317	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614758317	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.188	1715614758317	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614758331	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614759319	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614759319	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.188	1715614759319	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614759334	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614760322	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614760322	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1891	1715614760322	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614760337	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614761324	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614761324	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1891	1715614761324	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614762326	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614762326	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1891	1715614762326	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715614764330	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614764330	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1883000000000004	1715614764330	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614765334	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614765334	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1883000000000004	1715614765334	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614773353	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614773353	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1881	1715614773353	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614774356	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614774356	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1881	1715614774356	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614779367	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614779367	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1884	1715614779367	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614780371	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614780371	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1884	1715614780371	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614781373	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614781373	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1885	1715614781373	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614786385	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614786385	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1885	1715614786385	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614787387	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614787387	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1885	1715614787387	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614790394	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614790394	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1887	1715614790394	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615073072	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615074075	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615104149	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615105144	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615327611	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.4	1715615327611	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6397	1715615327611	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615329615	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615329615	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6397	1715615329615	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615330617	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.800000000000001	1715615330617	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6378000000000004	1715615330617	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615333623	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8	1715615333623	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6375	1715615333623	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615336629	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615336629	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6359	1715615336629	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615343644	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.1	1715615343644	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6395999999999997	1715615343644	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615344646	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615344646	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6395999999999997	1715615344646	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615467922	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615469924	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615472908	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615472908	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6499	1715615472908	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614761339	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614762340	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614764345	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614765348	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614773368	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614774371	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614779387	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614780392	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614781387	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614786406	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614787409	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614790415	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1939	1715615082079	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615083081	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615083081	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1939	1715615083081	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615084084	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.6	1715615084084	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1933000000000002	1715615084084	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615085086	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615085086	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1933000000000002	1715615085086	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615086088	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615086088	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1933000000000002	1715615086088	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615087090	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.9	1715615087090	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1924	1715615087090	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615092102	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615092102	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1921	1715615092102	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615095108	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615095108	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1921	1715615095108	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615097113	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615097113	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1921	1715615097113	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615100120	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615100120	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1933000000000002	1715615100120	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6370999999999998	1715615341640	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615342663	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615345662	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615468900	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3999999999999995	1715615468900	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6492	1715615468900	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615480923	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615480923	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.649	1715615480923	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615482927	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615482927	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.649	1715615482927	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615483929	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615483929	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6466999999999996	1715615483929	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615485933	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615485933	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6466999999999996	1715615485933	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615487958	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3999999999999995	1715615490944	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6505	1715615490944	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615491960	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615492949	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3999999999999995	1715615492949	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614763328	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614763328	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1883000000000004	1715614763328	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614775358	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614775358	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1883000000000004	1715614775358	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614777363	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614777363	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1883000000000004	1715614777363	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614800417	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614800417	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1892	1715614800417	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614802423	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614802423	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1891	1715614802423	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614803425	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614803425	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1891	1715614803425	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615106133	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615106133	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1931	1715615106133	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615107136	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615107136	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1931	1715615107136	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615108138	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615108138	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1939	1715615108138	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615109140	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615109140	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1939	1715615109140	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615111144	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615111144	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1943	1715615111144	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615112147	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615112147	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1943	1715615112147	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615115153	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615115153	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715615115153	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615116155	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.5	1715615116155	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715615116155	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615117158	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615117158	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715615117158	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615118160	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615118160	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715615118160	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615119162	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615119162	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715615119162	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615120164	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615120164	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1938	1715615120164	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615121166	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615121166	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1938	1715615121166	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615122169	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.3	1715615122169	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1938	1715615122169	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	108	1715615124174	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615124174	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1943	1715615124174	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615127180	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614763343	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614775371	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614777383	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614800431	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614802445	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614803447	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615106145	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615107149	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615108158	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615109152	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615111158	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615112160	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615115176	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615116177	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615117179	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615118180	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615119175	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615120185	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615121187	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615122243	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615124194	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615127200	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615134218	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615135220	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615138220	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615145244	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615146251	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615147242	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615149253	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615154258	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615158274	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615163262	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615163262	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7191	1715615163262	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615164281	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615345648	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.799999999999999	1715615345648	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6386	1715615345648	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615468918	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615475929	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615476930	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615484947	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615486951	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615488953	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615489962	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615490965	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6509	1715615492949	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615492963	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615497981	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615499966	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.2	1715615499966	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6496	1715615499966	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615500968	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.2	1715615500968	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6496	1715615500968	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615500990	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615501972	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615501972	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6495	1715615501972	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615502974	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615502974	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6495	1715615502974	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615502995	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615503975	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615503975	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614766336	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614766336	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1881	1715614766336	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614767338	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614767338	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1881	1715614767338	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614768340	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.300000000000001	1715614768340	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1881	1715614768340	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614769343	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614769343	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1879	1715614769343	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614770346	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614770346	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1879	1715614770346	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614771348	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614771348	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1879	1715614771348	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614772350	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715614772350	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1881	1715614772350	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614776360	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614776360	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1883000000000004	1715614776360	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614778365	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614778365	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1884	1715614778365	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614782375	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614782375	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1885	1715614782375	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614783377	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614783377	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1885	1715614783377	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614784380	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.5	1715614784380	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1885	1715614784380	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614785382	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614785382	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1885	1715614785382	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614789392	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614789392	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1885	1715614789392	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614791396	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614791396	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1887	1715614791396	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614792399	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614792399	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1887	1715614792399	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614793401	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614793401	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1889000000000003	1715614793401	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614794403	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614794403	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1889000000000003	1715614794403	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614801420	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614801420	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1892	1715614801420	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615110142	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615110142	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1939	1715615110142	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615131191	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615131191	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715615131191	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615133195	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614766349	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614767350	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614768361	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614769365	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614770360	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614771361	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614772372	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614776373	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614778386	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614782397	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614783389	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614784400	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614785396	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614789413	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614791408	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614792420	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614793421	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614794423	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614801437	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615110156	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615131216	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615133216	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615137227	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615140228	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615141229	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615161258	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615161258	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.719	1715615161258	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615346650	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615346650	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6386	1715615346650	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615347652	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.7	1715615347652	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6386	1715615347652	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615349656	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615349656	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6376999999999997	1715615349656	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615351660	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615351660	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6382	1715615351660	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615355668	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615355668	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6393	1715615355668	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615357687	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615360694	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615363701	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615368696	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8	1715615368696	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6426999999999996	1715615368696	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615370700	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.1	1715615370700	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6419	1715615370700	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615375710	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615375710	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6441	1715615375710	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615377736	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615379718	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.4	1715615379718	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6376	1715615379718	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615383726	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615383726	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6398	1715615383726	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615389754	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615391743	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615391743	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614788390	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.7	1715614788390	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1885	1715614788390	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614795406	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614795406	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1889000000000003	1715614795406	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614796408	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614796408	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1886	1715614796408	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614797411	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614797411	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1886	1715614797411	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614798412	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614798412	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1886	1715614798412	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614799415	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614799415	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1892	1715614799415	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614804427	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614804427	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1891	1715614804427	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614805430	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614805430	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1893000000000002	1715614805430	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615113149	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615113149	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1943	1715615113149	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615114151	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615114151	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715615114151	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615125176	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615125176	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1943	1715615125176	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615126178	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615126178	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715615126178	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615128183	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615128183	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715615128183	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615130188	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615130188	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715615130188	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615132193	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	10.8	1715615132193	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715615132193	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615136202	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615136202	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1940999999999997	1715615136202	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615139209	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615139209	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946999999999997	1715615139209	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615142216	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615142216	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.196	1715615142216	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615143219	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615143219	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.196	1715615143219	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615148251	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615150234	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.9	1715615150234	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7134	1715615150234	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615152238	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615152238	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7134	1715615152238	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614788412	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614795426	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614796421	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614797432	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614798434	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614799436	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614804449	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614805450	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614806432	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614806432	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1893000000000002	1715614806432	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614806454	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614807434	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614807434	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1893000000000002	1715614807434	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614807455	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614808437	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614808437	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1896	1715614808437	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614808457	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614809439	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8	1715614809439	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1896	1715614809439	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614809461	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	105	1715614810441	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614810441	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1896	1715614810441	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614810462	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614811445	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614811445	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1896999999999998	1715614811445	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614811460	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614812447	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614812447	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1896999999999998	1715614812447	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614812468	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715614813449	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614813449	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1896999999999998	1715614813449	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614813472	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	105	1715614814451	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614814451	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1896999999999998	1715614814451	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614814472	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614815454	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614815454	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1896999999999998	1715614815454	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614815467	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614816456	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614816456	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1896999999999998	1715614816456	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614816477	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614817458	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614817458	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1899	1715614817458	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614817479	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614818460	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614818460	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1899	1715614818460	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614818480	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614819463	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614819463	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1899	1715614819463	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614819484	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614820465	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614820465	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1902	1715614820465	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614821468	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614821468	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1902	1715614821468	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614824475	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614824475	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1899	1715614824475	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614825477	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614825477	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1899	1715614825477	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	99	1715614826480	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614826480	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1899	1715614826480	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614828485	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614828485	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1899	1715614828485	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614829488	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9	1715614829488	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1900999999999997	1715614829488	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	99	1715614830490	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614830490	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1900999999999997	1715614830490	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	105	1715614831492	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614831492	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1900999999999997	1715614831492	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614832495	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614832495	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.19	1715614832495	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614833498	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614833498	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.19	1715614833498	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715614834500	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614834500	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.19	1715614834500	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614837506	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614837506	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1899	1715614837506	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614842519	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614842519	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1904	1715614842519	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614843522	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614843522	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1904	1715614843522	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614844524	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614844524	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1903	1715614844524	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614849536	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.300000000000001	1715614849536	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1902	1715614849536	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614850539	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614850539	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1904	1715614850539	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614851541	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.300000000000001	1715614851541	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1904	1715614851541	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614856553	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614856553	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1905	1715614856553	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614857555	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614857555	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1905	1715614857555	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614858557	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614820486	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614821490	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614824496	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614825498	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614826502	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614828507	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614829508	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614830510	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614831521	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614832511	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614833516	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614834514	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614837527	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614842541	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614843543	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614844544	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614849550	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614850560	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614851557	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614856575	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614857576	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614858577	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614862579	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615113169	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615114172	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615125197	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615126192	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615128204	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615130204	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615132206	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615136222	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615139223	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615142228	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615143233	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615149232	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615149232	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.71	1715615149232	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615150249	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615153240	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615153240	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7174	1715615153240	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615157250	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615157250	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7193	1715615157250	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615159275	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615162274	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615165280	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615346664	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615347674	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615349670	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615351680	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615355683	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615360679	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.799999999999999	1715615360679	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6375	1715615360679	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615363686	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615363686	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6401	1715615363686	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615367711	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615368712	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615370714	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615375731	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615378716	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.4	1715615378716	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6376	1715615378716	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614822471	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614822471	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1902	1715614822471	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614823473	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.9	1715614823473	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1899	1715614823473	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614835502	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614835502	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1899	1715614835502	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614836504	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614836504	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1899	1715614836504	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614838509	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614838509	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1904	1715614838509	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614839512	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.300000000000001	1715614839512	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1904	1715614839512	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614840515	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.5	1715614840515	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1904	1715614840515	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614841517	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614841517	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1904	1715614841517	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614859560	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614859560	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1902	1715614859560	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614860562	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614860562	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1902	1715614860562	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614861564	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614861564	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1902	1715614861564	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614865573	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.9	1715614865573	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1900999999999997	1715614865573	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615123171	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615123171	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1943	1715615123171	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615129186	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615129186	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715615129186	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615144235	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615151254	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615155246	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615155246	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7174	1715615155246	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615156248	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615156248	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7193	1715615156248	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615157263	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615163278	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615348654	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615348654	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6376999999999997	1715615348654	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615350658	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615350658	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6376999999999997	1715615350658	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615352662	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.4	1715615352662	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6382	1715615352662	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615353664	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615353664	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6382	1715615353664	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614822492	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614823485	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614835525	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614836526	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614838530	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614839533	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614840536	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614841538	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614859582	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614860583	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614861585	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615123193	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615129203	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615151236	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.6	1715615151236	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7134	1715615151236	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615152260	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615155260	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615156260	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615160256	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615160256	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.719	1715615160256	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615348676	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615350679	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615352687	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615353688	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615358674	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615358674	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6375	1715615358674	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615359677	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8	1715615359677	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6375	1715615359677	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615362684	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615362684	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6375	1715615362684	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615366707	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615372704	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615372704	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6449000000000003	1715615372704	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615376712	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615376712	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6441	1715615376712	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615378740	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615384744	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615395767	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615401764	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615401764	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6414	1715615401764	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615403768	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615403768	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6423	1715615403768	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615409794	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615410803	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615414791	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615414791	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6458000000000004	1715615414791	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615419818	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615420818	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615421819	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615422823	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615431840	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615433853	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615435856	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615438862	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615439921	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614827482	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614827482	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1899	1715614827482	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614845527	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.8	1715614845527	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1903	1715614845527	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614846529	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715614846529	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1903	1715614846529	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614847531	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614847531	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1902	1715614847531	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614852544	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614852544	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1904	1715614852544	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614853546	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614853546	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1905	1715614853546	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614854549	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614854549	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1905	1715614854549	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614863569	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.9	1715614863569	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1902	1715614863569	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.9	1715615127180	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715615127180	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615134198	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615134198	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715615134198	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615135200	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615135200	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1940999999999997	1715615135200	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615138207	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615138207	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946999999999997	1715615138207	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615145224	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615145224	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6967	1715615145224	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615146226	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615146226	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6967	1715615146226	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615147228	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8	1715615147228	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.71	1715615147228	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615148230	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615148230	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.71	1715615148230	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615154243	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.5	1715615154243	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7174	1715615154243	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615158252	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615158252	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7193	1715615158252	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615160270	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615164265	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715615164265	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7191	1715615164265	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615354666	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.4	1715615354666	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6393	1715615354666	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615358688	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615359693	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615362699	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615367694	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614827503	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614845548	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614846550	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614847552	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614852565	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614853560	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614854568	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614863591	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615133195	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715615133195	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615137204	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615137204	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1940999999999997	1715615137204	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615140211	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615140211	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946999999999997	1715615140211	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615141214	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615141214	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.196	1715615141214	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615144221	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715615144221	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6967	1715615144221	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615161281	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615354684	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615356686	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615361695	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615373706	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615373706	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6449000000000003	1715615373706	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615374708	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615374708	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6449000000000003	1715615374708	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615377714	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615377714	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6441	1715615377714	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615382747	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615387749	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615388752	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615396767	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615408779	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3999999999999995	1715615408779	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6453	1715615408779	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615409781	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.5	1715615409781	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6453	1715615409781	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615414807	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615417810	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615424825	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615427832	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615428833	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615430842	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615434846	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615437852	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615444870	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615449879	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615455889	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615460905	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615465916	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615470904	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.7	1715615470904	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6492	1715615470904	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615473910	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.2	1715615473910	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6499	1715615473910	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615477919	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614848534	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614848534	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1902	1715614848534	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614855551	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614855551	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1905	1715614855551	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614864571	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614864571	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1902	1715614864571	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615153263	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	108	1715615159254	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.800000000000001	1715615159254	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.719	1715615159254	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615162260	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9	1715615162260	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7191	1715615162260	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615165267	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615165267	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7180999999999997	1715615165267	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615356670	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.7	1715615356670	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6393	1715615356670	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615361680	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615361680	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6375	1715615361680	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615366692	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615366692	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6426999999999996	1715615366692	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615373728	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615374729	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615382724	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615382724	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6398	1715615382724	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615387735	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615387735	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6433	1715615387735	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	106	1715615388737	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.699999999999999	1715615388737	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6433	1715615388737	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615396754	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3999999999999995	1715615396754	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6446	1715615396754	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615397770	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615408801	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615412787	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615412787	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6462	1715615412787	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615417797	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615417797	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6452	1715615417797	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615424812	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615424812	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6426999999999996	1715615424812	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615427818	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615427818	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6421	1715615427818	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615428820	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615428820	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6421	1715615428820	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615430824	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615430824	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6464000000000003	1715615430824	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615434832	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615434832	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614848554	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614855572	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614864593	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615166270	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615166270	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7180999999999997	1715615166270	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615167289	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615168290	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615172297	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615177308	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615186334	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615192339	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615194345	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615201365	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615209384	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615217393	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615224416	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615225411	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615357672	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615357672	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6375	1715615357672	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615364702	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615365707	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615369714	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615371715	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615380741	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615381739	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615385731	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615385731	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6413	1715615385731	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615386733	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615386733	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6413	1715615386733	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615390741	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615390741	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6412	1715615390741	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615393748	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615393748	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6413	1715615393748	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615394750	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.1	1715615394750	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6413	1715615394750	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615398773	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615406802	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615416807	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615429822	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.799999999999999	1715615429822	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6464000000000003	1715615429822	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615431826	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615431826	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6464000000000003	1715615431826	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615432841	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615447881	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615451880	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615453890	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615463916	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615471906	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615471906	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6499	1715615471906	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615473931	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615477932	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615493950	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.1	1715615493950	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6509	1715615493950	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615493971	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614858557	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1905	1715614858557	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614862566	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614862566	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1902	1715614862566	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614865594	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614866576	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614866576	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1900999999999997	1715614866576	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614866590	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614867578	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614867578	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1900999999999997	1715614867578	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614867599	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614868580	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614868580	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1906999999999996	1715614868580	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614868594	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614869583	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614869583	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1906999999999996	1715614869583	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614869604	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614870585	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614870585	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1906999999999996	1715614870585	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614870606	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614871587	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614871587	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1905	1715614871587	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614871601	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614872590	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614872590	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1905	1715614872590	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614872604	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614873592	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614873592	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1905	1715614873592	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614873606	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614874594	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614874594	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1905	1715614874594	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614874608	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614875596	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614875596	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1905	1715614875596	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614875611	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614876599	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614876599	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1905	1715614876599	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614876612	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614877601	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614877601	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.191	1715614877601	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614877616	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614878603	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	2.6	1715614878603	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.191	1715614878603	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614878619	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614879606	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614879606	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.191	1715614879606	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614879626	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614880608	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614880608	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1911	1715614880608	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614881610	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9	1715614881610	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1911	1715614881610	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	99	1715614885620	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	2.6	1715614885620	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1908000000000003	1715614885620	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614891635	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614891635	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1928	1715614891635	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614895645	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614895645	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1942	1715614895645	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	105	1715614911682	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614911682	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1942	1715614911682	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615166284	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615178311	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615181316	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615183306	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9	1715615183306	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6245	1715615183306	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615184308	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	2.6	1715615184308	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6245	1715615184308	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615185310	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615185310	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6245	1715615185310	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615188316	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615188316	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6241	1715615188316	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615190320	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.300000000000001	1715615190320	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6218000000000004	1715615190320	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615195330	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615195330	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6268000000000002	1715615195330	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615202346	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615202346	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.63	1715615202346	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615208360	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615208360	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6296	1715615208360	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615210364	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615210364	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6231999999999998	1715615210364	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615213371	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615213371	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6281	1715615213371	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615214394	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615215396	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615364688	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615364688	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6401	1715615364688	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615365690	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615365690	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6401	1715615365690	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615369698	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.799999999999999	1715615369698	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6419	1715615369698	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615371702	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615371702	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6419	1715615371702	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615380720	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614880630	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614881631	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614885641	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614891649	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614895666	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614911703	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615167272	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615167272	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.7180999999999997	1715615167272	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615168274	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.5	1715615168274	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.621	1715615168274	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615172283	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615172283	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6215	1715615172283	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615177293	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615177293	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.625	1715615177293	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615186312	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615186312	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6241	1715615186312	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615192325	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615192325	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.626	1715615192325	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615194329	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615194329	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.626	1715615194329	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615201344	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615201344	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.63	1715615201344	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615209362	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8	1715615209362	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6296	1715615209362	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615217379	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615217379	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.634	1715615217379	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615224395	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615224395	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6319	1715615224395	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615225398	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615225398	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6336	1715615225398	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615367694	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6426999999999996	1715615367694	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615372724	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615376735	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615384728	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615384728	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6413	1715615384728	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615395752	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615395752	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6413	1715615395752	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615397756	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615397756	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6446	1715615397756	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615401786	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615407777	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615407777	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6439	1715615407777	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615410783	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.1	1715615410783	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6453	1715615410783	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615413789	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615413789	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614882613	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.5	1715614882613	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1911	1715614882613	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614884618	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614884618	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1908000000000003	1715614884618	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614886622	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614886622	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1906999999999996	1715614886622	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614887625	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614887625	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1906999999999996	1715614887625	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614888628	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614888628	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1906999999999996	1715614888628	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614893640	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614893640	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.195	1715614893640	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614894643	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614894643	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.195	1715614894643	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614896647	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614896647	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1942	1715614896647	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614897650	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	10.3	1715614897650	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1942	1715614897650	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614898652	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.3	1715614898652	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614898652	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614902661	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614902661	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614902661	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614903663	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614903663	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614903663	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614904666	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614904666	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614904666	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614907673	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614907673	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614907673	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614912684	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614912684	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1942	1715614912684	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614913686	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	10.2	1715614913686	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614913686	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614914688	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614914688	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614914688	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715614915691	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614915691	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614915691	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614916694	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614916694	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1942	1715614916694	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614917697	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614917697	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1942	1715614917697	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614919701	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9	1715614919701	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715614919701	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614920704	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614882634	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614884639	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614886644	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614887639	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614888641	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614893661	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614894663	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614896667	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614897664	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614898665	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614902682	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614903684	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614904687	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614907695	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614912704	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614913707	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614914700	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614915711	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614916715	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614917709	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614919720	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614920718	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614921718	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614922731	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614923733	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614924733	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615169276	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615169276	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.621	1715615169276	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615170278	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715615170278	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.621	1715615170278	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615171281	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.9	1715615171281	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6215	1715615171281	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615175289	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615175289	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.625	1715615175289	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615176291	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615176291	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.625	1715615176291	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615179297	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715615179297	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.625	1715615179297	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615182304	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615182304	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6231	1715615182304	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615189333	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615193341	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615197355	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615198352	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615199361	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615203369	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615204364	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615205366	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615207356	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615207356	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6296	1715615207356	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615211367	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615211367	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6231999999999998	1715615211367	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615213394	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615216392	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615218403	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615220411	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614883615	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614883615	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1908000000000003	1715614883615	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715614889630	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614889630	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1928	1715614889630	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614890632	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614890632	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1928	1715614890632	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614892637	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614892637	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.195	1715614892637	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614899654	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614899654	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614899654	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614900657	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614900657	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614900657	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614901659	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614901659	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614901659	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614905668	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614905668	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614905668	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715614906671	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614906671	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614906671	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614908675	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614908675	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614908675	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614909677	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614909677	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1944	1715614909677	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614910679	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8	1715614910679	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1942	1715614910679	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614918699	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614918699	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1942	1715614918699	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615169291	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615170292	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615171302	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615175302	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615176306	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615179310	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615189319	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615189319	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6218000000000004	1715615189319	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615193327	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615193327	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.626	1715615193327	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615197334	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615197334	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6268000000000002	1715615197334	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615198338	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615198338	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6284	1715615198338	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615199340	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615199340	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6284	1715615199340	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615203348	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	10.2	1715615203348	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.63	1715615203348	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615204350	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614883629	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614889645	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614890647	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614892650	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614899670	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614900671	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614901672	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614905689	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614906684	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614908696	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614909698	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614910699	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614918721	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615173285	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615173285	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6215	1715615173285	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615174287	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715615174287	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.625	1715615174287	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615180300	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615180300	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6231	1715615180300	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615187314	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615187314	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6241	1715615187314	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615191322	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615191322	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6218000000000004	1715615191322	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615196332	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615196332	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6268000000000002	1715615196332	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615200342	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615200342	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6284	1715615200342	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615206354	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615206354	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6287	1715615206354	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615212393	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615219404	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615223414	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615379731	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615389739	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615389739	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6433	1715615389739	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615390757	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615391756	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615398758	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615398758	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6446	1715615398758	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615399773	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615400783	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615402781	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615404770	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615404770	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6423	1715615404770	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615405772	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.2	1715615405772	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6439	1715615405772	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615407797	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615411802	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615413803	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615415808	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615418813	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615423824	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615426830	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614920704	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715614920704	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614921706	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614921706	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715614921706	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614922708	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614922708	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1940999999999997	1715614922708	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614923710	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715614923710	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1940999999999997	1715614923710	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614924713	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614924713	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1940999999999997	1715614924713	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614925715	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614925715	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715614925715	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614925728	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614926717	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614926717	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715614926717	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614926738	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715614927720	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614927720	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.194	1715614927720	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614927740	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614928722	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614928722	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1939	1715614928722	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614928744	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614929724	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614929724	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1939	1715614929724	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614929737	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614930727	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614930727	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1939	1715614930727	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614930747	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614931729	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614931729	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936999999999998	1715614931729	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614931748	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614932731	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614932731	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936999999999998	1715614932731	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614932754	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614933734	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614933734	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936999999999998	1715614933734	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614933748	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614934736	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614934736	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1933000000000002	1715614934736	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614934749	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614935739	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614935739	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1933000000000002	1715614935739	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614935752	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715614936741	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614936741	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1933000000000002	1715614936741	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614936753	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614937743	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.3	1715614937743	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1931	1715614937743	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614942756	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614942756	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1935	1715614942756	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614943758	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	10.2	1715614943758	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1935	1715614943758	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715614944760	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614944760	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1935	1715614944760	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614946765	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.9	1715614946765	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1932	1715614946765	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614947767	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614947767	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1932	1715614947767	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614948770	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614948770	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1932	1715614948770	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614949771	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614949771	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1932	1715614949771	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614951776	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614951776	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1932	1715614951776	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614952779	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614952779	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1927	1715614952779	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614953781	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614953781	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1927	1715614953781	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614957791	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614957791	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1924	1715614957791	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614958793	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614958793	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614958793	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614960798	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614960798	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614960798	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614961800	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614961800	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614961800	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614965809	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614965809	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1935	1715614965809	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614966812	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	10.2	1715614966812	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1935	1715614966812	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615173306	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615174302	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615180315	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615187328	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615191337	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615196353	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615200356	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615212369	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615212369	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6231999999999998	1715615212369	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615219383	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615219383	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6321	1715615219383	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615223393	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615223393	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614937759	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614942778	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614943772	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614944773	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614946786	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614947781	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614948790	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614949791	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614951790	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614952799	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614953801	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614957811	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614958813	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614960818	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614961813	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614965829	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614966836	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615178295	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615178295	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.625	1715615178295	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615181302	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.3	1715615181302	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6231	1715615181302	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615182319	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615183320	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615184321	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615185324	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615188335	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615190333	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615195343	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615202362	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615208382	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615210387	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	106	1715615214373	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	11.999999999999998	1715615214373	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6281	1715615214373	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615215375	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615215375	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6281	1715615215375	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.1	1715615380720	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6376	1715615380720	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615381723	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615381723	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6398	1715615381723	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615383748	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615385747	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615386747	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615392759	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615393769	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615394764	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615406774	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.2	1715615406774	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6439	1715615406774	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615416795	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.799999999999999	1715615416795	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6458000000000004	1715615416795	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615425814	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.1	1715615425814	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6426999999999996	1715615425814	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615429836	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615432828	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615432828	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6456	1715615432828	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615447858	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.1	1715615447858	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614938745	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614938745	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1931	1715614938745	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614950774	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614950774	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1932	1715614950774	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614967814	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614967814	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1938	1715614967814	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614968817	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614968817	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1938	1715614968817	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614969819	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614969819	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1938	1715614969819	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614970822	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9	1715614970822	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614970822	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614971825	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614971825	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614971825	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614972827	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614972827	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614972827	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614973829	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614973829	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614973829	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614976836	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614976836	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614976836	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614977838	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614977838	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614977838	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614978841	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614978841	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614978841	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614979844	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.9	1715614979844	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715614979844	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614984855	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715614984855	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715614984855	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615204350	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6287	1715615204350	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615205352	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615205352	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6287	1715615205352	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615206370	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615207371	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615211387	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615216377	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615216377	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.634	1715615216377	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615218381	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615218381	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.634	1715615218381	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615220387	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615220387	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6321	1715615220387	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615221389	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615221389	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6321	1715615221389	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615222391	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615222391	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614938758	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614950794	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614967835	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614968838	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614969833	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614970835	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614971846	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614972847	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614973851	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614976857	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614977859	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614978863	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614979865	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614984876	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615221415	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615222406	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6412	1715615391743	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615392745	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.2	1715615392745	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6412	1715615392745	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615399760	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.1	1715615399760	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6414	1715615399760	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	105	1715615400762	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.799999999999999	1715615400762	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6414	1715615400762	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615402766	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615402766	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6423	1715615402766	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615403790	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615404791	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615405794	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615411785	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.799999999999999	1715615411785	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6462	1715615411785	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615412807	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615415793	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615415793	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6458000000000004	1715615415793	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615418799	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3999999999999995	1715615418799	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6452	1715615418799	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615423809	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615423809	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6426999999999996	1715615423809	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615426816	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615426816	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6421	1715615426816	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615436836	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615436836	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6455	1715615436836	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615440844	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615440844	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6452	1715615440844	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	109	1715615441846	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.1	1715615441846	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6434	1715615441846	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615443850	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615443850	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6434	1715615443850	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615446870	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615448874	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615454887	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615462909	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615464913	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614939748	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614939748	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1931	1715614939748	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715614940751	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614940751	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1935	1715614940751	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614941753	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614941753	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1935	1715614941753	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614954784	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614954784	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1927	1715614954784	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614974831	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614974831	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614974831	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715614975834	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614975834	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614975834	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614981848	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614981848	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715614981848	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6319	1715615222391	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6462	1715615413789	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615419801	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.1	1715615419801	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6452	1715615419801	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615420803	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615420803	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6426	1715615420803	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615421805	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615421805	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6426	1715615421805	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615422807	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615422807	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6426	1715615422807	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615425832	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615433830	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3999999999999995	1715615433830	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6456	1715615433830	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615435834	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615435834	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6455	1715615435834	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615438840	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615438840	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6452	1715615438840	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615439842	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615439842	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6452	1715615439842	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615442848	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615442848	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6434	1715615442848	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615445854	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615445854	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6463	1715615445854	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615446856	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615446856	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6463	1715615446856	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615450890	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615452889	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615456891	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615457893	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615458898	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615459904	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615461902	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614939769	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614940764	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614941774	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614954804	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614974853	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614975854	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614981868	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6319	1715615223393	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6456	1715615434832	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615437838	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615437838	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6455	1715615437838	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615444852	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615444852	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6463	1715615444852	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615449862	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615449862	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6471	1715615449862	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615455874	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615455874	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6481999999999997	1715615455874	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615460884	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615460884	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6475999999999997	1715615460884	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615465894	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615465894	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6471	1715615465894	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615471922	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615480944	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615482948	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615483950	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615485956	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615491946	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615491946	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6505	1715615491946	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615494952	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615494952	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6509	1715615494952	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615494965	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615498962	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615498962	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6496	1715615498962	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615498983	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615499980	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615501988	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6495	1715615503975	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615503991	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615504978	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615504978	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6486	1715615504978	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615504992	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	99	1715615505980	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615505980	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6486	1715615505980	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615505996	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	105	1715615506982	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.899999999999999	1715615506982	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6486	1715615506982	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615506995	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615507984	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8	1715615507984	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6508000000000003	1715615507984	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615508006	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615508986	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615509004	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614945763	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614945763	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1935	1715614945763	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614955786	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614955786	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1924	1715614955786	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614956789	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715614956789	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1924	1715614956789	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614959795	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614959795	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614959795	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614962802	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614962802	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614962802	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614963804	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614963804	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1936	1715614963804	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614964807	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614964807	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1935	1715614964807	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614980846	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614980846	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715614980846	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715614982851	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614982851	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715614982851	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614983853	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614983853	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715614983853	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615226400	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615226400	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6336	1715615226400	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615229406	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715615229406	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6319	1715615229406	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615233413	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615233413	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6284	1715615233413	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615236420	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.9	1715615236420	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6296	1715615236420	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615238438	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615240448	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615241451	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615246462	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615248466	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615249467	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615250468	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615251471	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615253476	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615257485	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615258479	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615261488	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615262496	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615263497	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615264492	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615265494	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615267505	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615268508	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615269513	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615270512	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615271516	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615274523	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614945783	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614955800	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614956810	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614959807	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614962816	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614963826	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614964829	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614980867	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614982872	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614983874	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614985858	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614985858	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.196	1715614985858	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614985871	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614986860	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614986860	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.196	1715614986860	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614986875	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614987862	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614987862	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.196	1715614987862	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614987883	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614988865	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614988865	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1957	1715614988865	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614988880	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614989867	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614989867	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1957	1715614989867	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614989881	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614990870	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614990870	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1957	1715614990870	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614990890	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614991872	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715614991872	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1957	1715614991872	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614991892	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614992874	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614992874	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1957	1715614992874	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614992896	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614993876	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715614993876	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1957	1715614993876	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614993890	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614994880	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715614994880	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715614994880	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614994932	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715614995882	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614995882	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715614995882	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614995897	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	106	1715614996884	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.199999999999999	1715614996884	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715614996884	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614996899	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614997887	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715614997887	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715614997887	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614997900	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715614998889	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715614998889	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715614998889	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615001896	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615001896	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946999999999997	1715615001896	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615002898	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615002898	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946999999999997	1715615002898	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615008912	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715615008912	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946	1715615008912	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615009914	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615009914	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615009914	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615010916	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615010916	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615010916	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615011918	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615011918	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615011918	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615016929	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615016929	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1952	1715615016929	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615017932	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615017932	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1952	1715615017932	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615022943	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615022943	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615022943	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615037977	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615037977	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615037977	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615226423	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615229427	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615233434	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615236436	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615240428	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.9	1715615240428	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6326	1715615240428	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615241430	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615241430	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6326	1715615241430	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615246440	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615246440	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6348000000000003	1715615246440	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615248444	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615248444	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6348000000000003	1715615248444	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615249446	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615249446	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6348000000000003	1715615249446	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615250449	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.800000000000001	1715615250449	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6348000000000003	1715615250449	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615251451	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6	1715615251451	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6348000000000003	1715615251451	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615253455	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615253455	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6346999999999996	1715615253455	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615257464	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715615257464	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.633	1715615257464	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615258466	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615258466	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614998910	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615001908	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615002919	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615008927	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615009926	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615010937	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615011939	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615016942	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615017953	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615022964	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615037996	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615227402	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715615227402	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6336	1715615227402	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615228404	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615228404	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6319	1715615228404	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615232412	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615232412	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6284	1715615232412	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615234416	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615234416	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6296	1715615234416	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615235418	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615235418	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6296	1715615235418	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615247442	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.7	1715615247442	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6348000000000003	1715615247442	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615254457	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615254457	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6346999999999996	1715615254457	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615255460	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615255460	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.633	1715615255460	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615256480	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615266497	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615278531	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615287530	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.4	1715615287530	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6384000000000003	1715615287530	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615291538	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6	1715615291538	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6384000000000003	1715615291538	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615292540	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615292540	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6384000000000003	1715615292540	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615295546	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615295546	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6378000000000004	1715615295546	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615296548	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615296548	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6378000000000004	1715615296548	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615300556	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.4	1715615300556	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6355999999999997	1715615300556	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615303562	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615303562	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6369000000000002	1715615303562	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615306568	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615306568	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6351	1715615306568	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615311578	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.4	1715615311578	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715614999891	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715614999891	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715614999891	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615000893	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615000893	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946999999999997	1715615000893	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615027954	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615027954	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615027954	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615033968	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615033968	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715615033968	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615034970	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615034970	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715615034970	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615035973	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615035973	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1948000000000003	1715615035973	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615038979	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.5	1715615038979	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615038979	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615039981	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615039981	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.195	1715615039981	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615040984	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615040984	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.195	1715615040984	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615041986	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615041986	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.195	1715615041986	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615042988	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615042988	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1940999999999997	1715615042988	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615043990	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615043990	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1940999999999997	1715615043990	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615045007	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615227423	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615228417	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615232428	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615234430	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615235432	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615247459	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615254479	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615255481	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615266483	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615266483	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6355	1715615266483	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615278510	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615278510	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6342	1715615278510	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615280536	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615287550	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615291561	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615292553	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615295560	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615296562	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615300576	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615303584	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615306582	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615311592	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615319595	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.7	1715615319595	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6354	1715615319595	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715614999912	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615000914	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615027975	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615033990	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615034991	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615035993	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615038994	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615040002	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615041005	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615041999	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615043008	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615044011	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615230408	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615230408	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6319	1715615230408	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615231410	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615231410	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6284	1715615231410	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615238424	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615238424	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6304000000000003	1715615238424	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615239448	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615242453	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615243448	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615244456	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615276520	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615283521	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615283521	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6363000000000003	1715615283521	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615286528	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615286528	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6384000000000003	1715615286528	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615288532	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8	1715615288532	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6366	1715615288532	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615290536	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615290536	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6366	1715615290536	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615293542	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615293542	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6384000000000003	1715615293542	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615294544	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615294544	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6378000000000004	1715615294544	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615299554	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615299554	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6354	1715615299554	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615301571	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615305580	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615307587	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615313606	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615315607	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615318613	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615321612	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615326622	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615328626	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615332642	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615334640	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615338634	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615338634	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6359	1715615338634	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615339656	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615342642	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615342642	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6395999999999997	1715615342642	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615003901	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.300000000000001	1715615003901	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946999999999997	1715615003901	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615004903	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615004903	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946999999999997	1715615004903	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615007909	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615007909	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946	1715615007909	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615012920	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615012920	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1952	1715615012920	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615013923	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615013923	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1952	1715615013923	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615014925	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.6	1715615014925	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1952	1715615014925	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615015927	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615015927	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1952	1715615015927	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615018934	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615018934	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.195	1715615018934	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615019936	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615019936	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.195	1715615019936	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615020939	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615020939	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.195	1715615020939	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615021941	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7	1715615021941	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615021941	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615023945	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615023945	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615023945	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615024947	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615024947	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.195	1715615024947	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615025950	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615025950	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.195	1715615025950	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615026952	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615026952	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.195	1715615026952	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615028956	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615028956	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615028956	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615029959	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.5	1715615029959	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615029959	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615030961	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615030961	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946999999999997	1715615030961	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615031964	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615031964	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946999999999997	1715615031964	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615032966	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615032966	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946999999999997	1715615032966	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615230430	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615231431	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615239426	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615239426	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615003915	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615004918	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615007931	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615012941	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615013944	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615014946	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615015948	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615018955	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615019956	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615020959	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615021954	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615023967	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615024967	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615025970	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615026965	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615028977	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615029972	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615030982	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615031977	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615032986	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615237422	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.2	1715615237422	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6304000000000003	1715615237422	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615245438	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.6	1715615245438	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6336	1715615245438	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615252453	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615252453	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6346999999999996	1715615252453	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615256461	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.5	1715615256461	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.633	1715615256461	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615259489	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615260491	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615272518	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615273518	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615279533	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615285525	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615285525	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6384000000000003	1715615285525	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615289534	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615289534	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6366	1715615289534	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615297550	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615297550	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6354	1715615297550	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615298552	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615298552	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6354	1715615298552	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615304564	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.9	1715615304564	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6369000000000002	1715615304564	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615309574	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615309574	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6344000000000003	1715615309574	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615310576	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615310576	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6344000000000003	1715615310576	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615317612	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615320597	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.1	1715615320597	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6354	1715615320597	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615325607	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615325607	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.638	1715615325607	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615005905	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615005905	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946999999999997	1715615005905	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615006907	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9	1715615006907	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1946	1715615006907	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615036975	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615036975	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1949	1715615036975	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615044992	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615044992	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.1940999999999997	1715615044992	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615237435	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615245459	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615252476	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615259468	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.6000000000000005	1715615259468	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6348000000000003	1715615259468	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615260470	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615260470	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6348000000000003	1715615260470	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615272497	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615272497	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6365	1715615272497	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615273499	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.7	1715615273499	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.635	1715615273499	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615279513	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615279513	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6355	1715615279513	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615281517	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.4	1715615281517	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6355	1715615281517	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615285542	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615289547	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615297567	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615298566	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615304579	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615309590	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615310597	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615318592	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615318592	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6354	1715615318592	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615320619	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615325621	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615327632	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615329636	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615330630	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615333645	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615336644	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615343666	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615344669	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615436849	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615440865	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615441859	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615443869	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615448860	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615448860	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6471	1715615448860	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615454872	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615454872	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6481999999999997	1715615454872	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615462888	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615462888	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615005927	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615006921	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.061	1715615036990	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6304000000000003	1715615239426	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615242432	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	4.9	1715615242432	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6326	1715615242432	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615243434	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.5	1715615243434	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6336	1715615243434	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615244436	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615244436	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6336	1715615244436	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615276506	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5	1715615276506	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6342	1715615276506	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615280515	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615280515	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6355	1715615280515	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615283543	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615286552	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615288545	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615290557	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615293563	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615294558	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615301558	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.4	1715615301558	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6355999999999997	1715615301558	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615305566	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615305566	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6369000000000002	1715615305566	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615307570	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615307570	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6351	1715615307570	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615313582	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615313582	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6374	1715615313582	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615315586	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615315586	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6358	1715615315586	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615316610	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615321599	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615321599	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.637	1715615321599	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615326609	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.6	1715615326609	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.638	1715615326609	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615328613	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3999999999999995	1715615328613	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6397	1715615328613	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615332621	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.4	1715615332621	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6378000000000004	1715615332621	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615334625	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615334625	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6375	1715615334625	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615335627	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.7	1715615335627	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6375	1715615335627	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615339636	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3	1715615339636	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6370999999999998	1715615339636	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615341640	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615341640	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615508986	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6508000000000003	1715615508986	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615511992	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.699999999999999	1715615511992	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6523000000000003	1715615511992	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615513996	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615513996	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6501	1715615513996	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615514998	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.1	1715615514998	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6501	1715615514998	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615517002	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615517002	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6523000000000003	1715615517002	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615526022	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7	1715615526022	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6527	1715615526022	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615529051	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615530045	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615533059	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615536059	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615541077	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615545078	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615547084	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615552078	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.6000000000000005	1715615552078	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6533	1715615552078	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615554082	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615554082	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6533	1715615554082	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615556086	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615556086	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6543	1715615556086	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615557088	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7	1715615557088	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6543	1715615557088	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615558090	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615558090	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6539	1715615558090	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615567111	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.9	1715615567111	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6529000000000003	1715615567111	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615568135	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615569136	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615570132	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615509988	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.1	1715615509988	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6508000000000003	1715615509988	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615510990	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8	1715615510990	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6523000000000003	1715615510990	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615512994	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.3999999999999995	1715615512994	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6523000000000003	1715615512994	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615519008	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615519008	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6523000000000003	1715615519008	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615520024	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615522028	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615528027	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.6000000000000005	1715615528027	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6481	1715615528027	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615534041	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.9	1715615534041	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6515999999999997	1715615534041	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615535043	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615535043	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6515999999999997	1715615535043	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615540054	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.3	1715615540054	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6524	1715615540054	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615543061	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615543061	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6521999999999997	1715615543061	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615548071	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.6000000000000005	1715615548071	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6508000000000003	1715615548071	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615549073	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615549073	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6501	1715615549073	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615561096	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	10.5	1715615561096	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6504000000000003	1715615561096	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615564103	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.3	1715615564103	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6512	1715615564103	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615566107	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615566107	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6512	1715615566107	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615568113	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615568113	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6529000000000003	1715615568113	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615510001	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615511011	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615516014	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615519030	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615522014	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7	1715615522014	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6502	1715615522014	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615525020	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.9	1715615525020	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6527	1715615525020	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615528042	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615534063	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615535056	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615540067	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615543086	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615548093	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615549093	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615561118	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615564124	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615566128	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615512012	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615514017	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615515012	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615517018	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615529029	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.9	1715615529029	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6481	1715615529029	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615530033	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615530033	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6481	1715615530033	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615533039	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.9	1715615533039	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6494	1715615533039	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615536045	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615536045	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6515999999999997	1715615536045	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615541056	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.6000000000000005	1715615541056	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6524	1715615541056	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615545065	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615545065	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6521999999999997	1715615545065	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615547069	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.1	1715615547069	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6508000000000003	1715615547069	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615551076	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.1	1715615551076	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6501	1715615551076	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615552092	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615554104	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615556108	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615557110	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615558115	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615567125	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615569115	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.299999999999999	1715615569115	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6529000000000003	1715615569115	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615570117	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.799999999999999	1715615570117	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.654	1715615570117	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615513010	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615520010	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.6000000000000005	1715615520010	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6502	1715615520010	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615521026	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615524032	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615531049	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615538067	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615542081	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615555084	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.9	1715615555084	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6543	1715615555084	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615560094	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615560094	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6539	1715615560094	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615562098	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.3	1715615562098	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6504000000000003	1715615562098	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615516000	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	9.7	1715615516000	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6501	1715615516000	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	104	1715615523016	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	8.2	1715615523016	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6513	1715615523016	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615526037	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615527039	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615532037	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615532037	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6494	1715615532037	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615537048	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615537048	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6519	1715615537048	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615539052	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.6000000000000005	1715615539052	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6519	1715615539052	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615544063	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.3	1715615544063	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6521999999999997	1715615544063	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615546067	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.9	1715615546067	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6508000000000003	1715615546067	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	100	1715615550075	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615550075	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6501	1715615550075	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615553080	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.6	1715615553080	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6533	1715615553080	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615559092	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	6.8999999999999995	1715615559092	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6539	1715615559092	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	101	1715615563100	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615563100	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6504000000000003	1715615563100	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615565105	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.6000000000000005	1715615565105	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6512	1715615565105	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615518004	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.6000000000000005	1715615518004	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6523000000000003	1715615518004	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615521012	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615521012	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6502	1715615521012	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615524018	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.5	1715615524018	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6513	1715615524018	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615525034	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615538050	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	7.6	1715615538050	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6519	1715615538050	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615542058	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.8	1715615542058	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6524	1715615542058	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615551098	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615555097	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615560107	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615562113	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615518018	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615523031	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	103	1715615527025	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	10.5	1715615527025	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6527	1715615527025	6126b20453ad41dead6c37986e10f63b	0	f
TOP - CPU Utilization	102	1715615531035	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Utilization	5.199999999999999	1715615531035	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Memory Usage GB	2.6494	1715615531035	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615532050	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615537061	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615539069	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615544083	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615546082	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615550091	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615553101	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615559113	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615563114	6126b20453ad41dead6c37986e10f63b	0	f
TOP - Swap Memory GB	0.0613	1715615565120	6126b20453ad41dead6c37986e10f63b	0	f
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
letter	0	98ced106ac5c496abab81b92b10e2d5e
workload	0	98ced106ac5c496abab81b92b10e2d5e
listeners	smi+top+dcgmi	98ced106ac5c496abab81b92b10e2d5e
params	'"-"'	98ced106ac5c496abab81b92b10e2d5e
file	cifar10.py	98ced106ac5c496abab81b92b10e2d5e
workload_listener	''	98ced106ac5c496abab81b92b10e2d5e
letter	0	6126b20453ad41dead6c37986e10f63b
workload	0	6126b20453ad41dead6c37986e10f63b
listeners	smi+top+dcgmi	6126b20453ad41dead6c37986e10f63b
params	'"-"'	6126b20453ad41dead6c37986e10f63b
file	cifar10.py	6126b20453ad41dead6c37986e10f63b
workload_listener	''	6126b20453ad41dead6c37986e10f63b
model	cifar10.py	6126b20453ad41dead6c37986e10f63b
manual	False	6126b20453ad41dead6c37986e10f63b
max_epoch	5	6126b20453ad41dead6c37986e10f63b
max_time	172800	6126b20453ad41dead6c37986e10f63b
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
98ced106ac5c496abab81b92b10e2d5e	salty-ram-919	UNKNOWN			daga	FAILED	1715614465324	1715614570492		active	s3://mlflow-storage/0/98ced106ac5c496abab81b92b10e2d5e/artifacts	0	\N
6126b20453ad41dead6c37986e10f63b	(0 0) abrasive-dolphin-529	UNKNOWN			daga	FINISHED	1715614714160	1715615570838		active	s3://mlflow-storage/0/6126b20453ad41dead6c37986e10f63b/artifacts	0	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow_user
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	daga	98ced106ac5c496abab81b92b10e2d5e
mlflow.source.name	file:///home/daga/radt#examples/pytorch	98ced106ac5c496abab81b92b10e2d5e
mlflow.source.type	PROJECT	98ced106ac5c496abab81b92b10e2d5e
mlflow.project.entryPoint	main	98ced106ac5c496abab81b92b10e2d5e
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	98ced106ac5c496abab81b92b10e2d5e
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	98ced106ac5c496abab81b92b10e2d5e
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	98ced106ac5c496abab81b92b10e2d5e
mlflow.runName	salty-ram-919	98ced106ac5c496abab81b92b10e2d5e
mlflow.project.env	conda	98ced106ac5c496abab81b92b10e2d5e
mlflow.project.backend	local	98ced106ac5c496abab81b92b10e2d5e
mlflow.user	daga	6126b20453ad41dead6c37986e10f63b
mlflow.source.name	file:///home/daga/radt#examples/pytorch	6126b20453ad41dead6c37986e10f63b
mlflow.source.type	PROJECT	6126b20453ad41dead6c37986e10f63b
mlflow.project.entryPoint	main	6126b20453ad41dead6c37986e10f63b
mlflow.source.git.commit	7d2e33f2e8153fce7cd5f872f07ee41424602571	6126b20453ad41dead6c37986e10f63b
mlflow.source.git.repoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	6126b20453ad41dead6c37986e10f63b
mlflow.gitRepoURL	https://github.com/Resource-Aware-Data-systems-RAD/radt.git	6126b20453ad41dead6c37986e10f63b
mlflow.project.env	conda	6126b20453ad41dead6c37986e10f63b
mlflow.project.backend	local	6126b20453ad41dead6c37986e10f63b
mlflow.runName	(0 0) abrasive-dolphin-529	6126b20453ad41dead6c37986e10f63b
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

